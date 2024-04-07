It currently fails with:
```
[2024-04-07 18:30:28] Solo5: Xen console: port 0x2, ring @0x00000000FEFFF000
[2024-04-07 18:30:28]             |      ___|
[2024-04-07 18:30:28]   __|  _ \  |  _ \ __ \
[2024-04-07 18:30:28] \__ \ (   | | (   |  ) |
[2024-04-07 18:30:28] ____/\___/ _|\___/____/
[2024-04-07 18:30:28] Solo5: Bindings version v0.8.0
[2024-04-07 18:30:28] Solo5: Memory map: 32 MB addressable:
[2024-04-07 18:30:28] Solo5:   reserved @ (0x0 - 0xfffff)
[2024-04-07 18:30:28] Solo5:       text @ (0x100000 - 0x284fff)
[2024-04-07 18:30:28] Solo5:     rodata @ (0x285000 - 0x2d2fff)
[2024-04-07 18:30:28] Solo5:       data @ (0x2d3000 - 0x401fff)
[2024-04-07 18:30:28] Solo5:       heap >= 0x402000 < stack < 0x2000000
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [qubes.db] connecting to server...
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [qubes.db] connected
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [blkfront] Blkfront.connect 51712: interpreting 51712 as a xen virtual disk bus slot number
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [blkfront] Blkfront.connect 51712 -> 51712
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [blkfront] Blkfront.plug id=51712
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [blkfront] Blkback advertises multi-page ring (size 2 ** 4 pages)
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [blkfront] Negotiated a multi-page ring (size 2 ** 2 pages)
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [blkfront] Blkfront.alloc ring Blkif.51712 header_size = 64; index slot size = 112; number of entries = 128
[2024-04-07 18:30:28] 2024-04-07T16:30:28-00:00: [INFO] [blkfront] Blkfront info: sector_size=512 sectors=20971520 max_indirect_segments=256
[2024-04-07 18:30:28] Fatal error: exception Io_page.Buffer_is_not_page_aligned
[2024-04-07 18:30:28] Raised at Lwt.Miscellaneous.poll in file "duniverse/lwt/src/core/lwt.ml", line 3123, characters 20-29
[2024-04-07 18:30:28] Called from Xen_os__Main.run.aux in file "duniverse/mirage-xen/lib/main.ml", line 37, characters 10-20
[2024-04-07 18:30:28] Called from Dune__exe__Main.run in file "main.ml" (inlined), line 3, characters 12-29
[2024-04-07 18:30:28] Called from Dune__exe__Main in file "main.ml", line 114, characters 5-10
[2024-04-07 18:30:28] Solo5: solo5_exit(2) called
```
