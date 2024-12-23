type node_dest = { left : string; right : string }

let directions lines = List.hd lines |> String.to_seq |> List.of_seq

let process_nodes_to_dict lines =
  let nodes = match lines with [] -> [] | _ :: t -> t in
  let node_map = Hashtbl.create (List.length nodes) in
  let source s = String.sub s 0 3 in
  let left_dst s = String.sub s 7 3 in
  let right_dst s = String.sub s 12 3 in
  List.iter
    (fun line ->
      Hashtbl.add node_map (source line)
        { left = left_dst line; right = right_dst line })
    nodes;
  node_map

let rec gcd a b = if b = 0 then a else gcd b (a mod b)
let lcm a b = a * b / gcd a b

let get_sum node_map directions =
  let starting_nodes =
    Hashtbl.fold
      (fun k _v acc -> if k.[2] = 'A' then k :: acc else acc)
      node_map []
  in

  let get_next_direction = function
    | h :: t -> (h, t)
    | [] -> (
        match directions with
        | h :: t -> (h, t)
        | _ -> failwith "impossible next dir")
  in

  let rec get_next_node curr_node dir =
    let dst = Hashtbl.find node_map curr_node in
    match dir with
    | 'L' -> dst.left
    | 'R' -> dst.right
    | _ -> failwith "Impossible dir"
  in

  let rec travel_until_z node count cut_directions =
    if node.[2] = 'Z' then count
    else
      let h, t = get_next_direction cut_directions in
      let next_node = get_next_node node h in
      travel_until_z next_node (count + 1) t
  in

  List.map (fun node -> travel_until_z node 0 directions) starting_nodes
  |> List.fold_left (fun acc x -> lcm acc x) 1

let read_lines file =
  In_channel.with_open_text file In_channel.input_all
  |> String.split_on_char '\n'
  |> List.filter (fun line -> line <> "")

let () =
  let lines = read_lines "input.txt" in
  let map = process_nodes_to_dict lines in
  let dirs = directions lines in
  let sum = get_sum map dirs in
  Printf.printf "%d\n" sum
