open Ppxlib

let merge =
  object
    inherit Ast_traverse.map
  end

let preprocess_intf = merge#signature
let () = Driver.register_transformation ~preprocess_intf "odoc_of_gospel"
