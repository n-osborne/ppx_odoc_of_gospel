type 'a t = { size : int; mutable contents : 'a list }

let empty n = { size = n; contents = [] }
let equal t0 t1 = List.equal ( = ) t0.contents t1.contents

exception TooMuch

let add a t =
  if List.length t.contents >= t.size then raise TooMuch
  else t.contents <- a :: t.contents
