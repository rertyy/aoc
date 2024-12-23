let hash str =
  String.fold_left (fun acc c -> (acc + Char.code c) * 17 mod 256) 0 str

let solve file =
  In_channel.with_open_text file In_channel.input_all
  |> String.split_on_char ','
  |> List.map (fun x -> String.trim x)
  |> List.map hash |> List.fold_left ( + ) 0

let () = solve "input.txt" |> print_int
