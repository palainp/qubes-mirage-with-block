open Lwt.Infix

module Main (DB : Qubes.S.DB) (KV : Mirage_kv.RO) =
struct
  let log_src = Logs.Src.create "unikernel" ~doc:"unikernel"
  module Log = (val Logs.src_log log_src : Logs.LOG)

  let fail pp e = Lwt.fail_with (Format.asprintf "%a" pp e)
  let fail_read = fail KV.pp_error
  let ( >>+= ) m f = m >>= function Error e -> fail_read e | Ok x -> f x

  let lsdir root path =
    let pathkey = Mirage_kv.Key.v path in
    KV.list root pathkey >>+= fun res ->
    Lwt.return res

  let read_key root pathkey ~offset ~length =
    KV.get_partial root pathkey ~offset ~length >>= function
    | Error e -> Lwt.return (Error e)
    | Ok data -> Lwt.return (Ok data)

  let read root path ~offset ~length =
    let pathkey = Mirage_kv.Key.v path in
    read_key root pathkey ~offset ~length

  let size_key root pathkey =
    KV.size root pathkey >>= function
    | Error `Not_found k -> Log.err (fun f -> f "size: '%s' isn't found" (Mirage_kv.Key.to_string k)); Lwt.return 0
    | Error _ -> Log.err (fun f -> f "connot get size for '%s'" (Mirage_kv.Key.to_string pathkey)); Lwt.return 0
    | Ok s -> Lwt.return (Optint.Int63.to_int s)

  let size root path =
    let pathkey = Mirage_kv.Key.v path in
    size_key root pathkey

  let get_required qubesDB key =
    match Qubes.DB.read qubesDB key with
    | None -> failwith (Printf.sprintf "Required QubesDB key %S not found" key)
    | Some v ->
      Log.info (fun f -> f "QubesDB %S = %S" key v);
      v

  let directory ~handle dir =
    Xen_os.Xs.directory handle dir >|= function
    | [""] -> []      (* XenStore client bug *)
    | items -> items

  let start qubesDB disk =
  (* display keys in qubesDB *)
    let db = Qubes.DB.bindings qubesDB in
    Log.info(fun f -> f "QubeDB = ");
    Qubes.DB.KeyMap.iter (fun k -> (fun _ -> Log.info(fun f -> f "\t%s" k))) db;
  (* the block-devices key is empty, maybe it's hotplug devices (i.e. attached with qubes GUI when running) *)
    let _blkdev = get_required qubesDB "/qubes-block-devices" in

  (* this gives a result for a cmd like: `xenstore-ls /local/domain/X` with X the domain id from `xl list` *)
    Xen_os.Xs.make () >>= fun xs ->
    Xen_os.Xs.immediate xs (fun h ->
      (* available disks: 51712 , 51728 , 51744 , for private, root, and volatile ? *)
      Xen_os.Xs.read h "device/vbd/51712/backend"
    ) >>= fun blk ->
    Log.info(fun f -> f "blk = <%s>" blk);

  (* try to list files in a block device *)
    lsdir disk "/" >>= fun lst ->
    Log.info(fun f -> f "/ contains %d elements" (List.length lst));
    List.iter (fun (k, _) -> Log.info (fun f -> f "\t%s" (Mirage_kv.Key.to_string k))) lst ;

    let filename = "/hello.txt" in
    size disk filename >>= fun s ->
    read disk filename ~offset:(Optint.Int63.of_int 0) ~length:s >>= function
    | Error _ -> Log.info(fun f -> f "Error with /hello.txt") ; Lwt.return_unit
    | Ok data -> Log.info(fun f -> f "<%s> contains <%s>" filename data) ; Lwt.return_unit

end
