open OUnit2

let string_of_list f xs =
  "[" ^ (String.concat "; " (List.map f xs)) ^ "]" 
let string_of_int_list = string_of_list string_of_int
