open Mirage

let main =
  foreign
    ~packages:[ package ~min:"6.0.1" "mirage-kv" ]
    "Unikernel.Main"
    (qubesdb @-> kv_ro @-> job)

(* Any other value returns: Blkfront.connect test: unable to match 'test' to any available devices [ 51712; 51728; 51744 ] *)
let block = block_of_xenstore_id "51712"
let fs = tar_kv_ro block

let () = register "unikernel" [ main $ default_qubesdb $ fs ]
