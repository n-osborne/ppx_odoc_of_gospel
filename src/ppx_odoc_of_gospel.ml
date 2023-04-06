open Ppxlib

let is_gospel attr = attr.attr_name.txt = "gospel"

let is_ocaml_doc attr =
  attr.attr_name.txt = "ocaml.text" || attr.attr_name.txt = "ocaml.doc"

let align_gospel txt = "   " ^ txt

let gospel_txt_of_attributes attr =
  assert (is_gospel attr);
  let rec aux attr =
    if is_gospel attr then
      match attr.attr_payload with
      | PStr
          [
            {
              pstr_desc =
                Pstr_eval
                  ( {
                      pexp_desc = Pexp_constant (Pconst_string (txt, loc, _));
                      _;
                    },
                    attrs );
              _;
            };
          ] ->
          { txt; loc } :: (List.map aux attrs |> List.flatten)
      | _ -> []
    else []
  in
  let rec squash (acc : string loc) = function
    | [] -> failwith "unreachable case in squash"
    | [ { txt; loc } ] ->
        {
          txt = acc.txt ^ "\n" ^ align_gospel txt;
          loc = { acc.loc with loc_end = loc.loc_end };
        }
    | { txt; _ } :: xs ->
        squash { acc with txt = acc.txt ^ align_gospel txt } xs
  in
  match aux attr with
  | [] -> failwith "unreachable case in gospel_txt_of_attributes"
  | [ x ] -> { x with txt = align_gospel x.txt }
  | x :: xs -> squash { x with txt = align_gospel x.txt } xs

let wrap_gospel header txt =
  let header =
    match header with
    | `Declaration -> "Gospel declaration:\n"
    | `Specification -> "Gospel specification:\n"
  in
  Fmt.str "{@gospel[\n%s%s]}" header txt

let attr_label = function
  | `Declaration -> "ocaml.text"
  | `Specification -> "ocaml.doc"

let gospel_declaration = wrap_gospel `Declaration
let gospel_specification = wrap_gospel `Specification

let payload_of_string ~loc txt =
  let open Ast_helper in
  let content : constant = Const.string ~loc txt in
  let expression : expression = Pexp_constant content |> Exp.mk ~loc in
  let structure_item = Str.eval ~loc expression in
  PStr [ structure_item ]

let doc_of_gospel header attr =
  assert (is_gospel attr);
  let attr_name = { txt = attr_label header; loc = attr.attr_loc } in
  let info = gospel_txt_of_attributes attr in
  let txt = wrap_gospel header info.txt in
  let attr_payload = payload_of_string ~loc:info.loc txt in
  let attr_loc = attr.attr_loc in
  { attr_name; attr_payload; attr_loc }

let doc_of_gospel_declaration = doc_of_gospel `Declaration
let doc_of_gospel_specification = doc_of_gospel `Specification

(* The attributes with a gospel tag in a signature are gospel declarations,
   that is gospel functions, gospel predicates and gospel axioms.

   This function takes the contents of these attributes and make a
   documentation attribute with it. The new attribute is added just after the
   gospel one. *)
let rec signature = function
  | [] -> []
  | ({ psig_desc = Psig_attribute a; psig_loc = loc } as x) :: xs
    when is_gospel a ->
      let a' = doc_of_gospel_declaration a in
      x :: { psig_desc = Psig_attribute a'; psig_loc = loc } :: signature xs
  | x :: xs -> x :: signature xs

(* XXX TODO:
    1. get the contents of the gospel specification
    2. merge it in the last documentation attribute if there is some
*)
let attributes attrs = attrs

let merge =
  object
    inherit Ast_traverse.map as super
    method! signature s = super#signature s |> signature
    method! attributes attrs = super#attributes attrs |> attributes
  end

let preprocess_intf = merge#signature
let () = Driver.register_transformation ~preprocess_intf "odoc_of_gospel"
