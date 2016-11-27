open Graphics
open GameElements
open Player

let default_color = 0xCD853F
let scale =  ref 2 (* No longer supported *)

let make_transp img =
  let replace = Array.map (fun col -> if col = white then transp else col) in
  Array.map (fun arr -> replace arr) img

let get_img img =
  Images.load img [] |> Graphic_image.array_of_image |> make_transp

let _ = open_graph " 380x380"
(* 8Bit live wallpaper by Nysis*)
let start_screen = get_img "images/start.png" |> make_image
(* pixel art game cars collection by shutterstock *)
let car_img = get_img "images/car.png" |> make_image
let truck_img = get_img "images/truck.png" |> make_image
let save = get_img "images/savebutt.png" |> make_image
let pause = get_img "images/pausebutt.png" |> make_image
let buycar = get_img "images/carbutt.png" |> make_image
let buytruck = get_img "images/truckbutt.png" |> make_image
let buyroad = get_img "images/buyroad.png" |> make_image
let house = get_img "images/house.png" |> make_image
let bg = get_img "images/bg.png" |> make_image
let n1 = get_img "font/1.png" |> make_image
let n2 = get_img "font/2.png" |> make_image
let n3 = get_img "font/3.png" |> make_image
let n4 = get_img "font/4.png" |> make_image
let n5 = get_img "font/5.png" |> make_image
let n6 = get_img "font/6.png" |> make_image
let n7 = get_img "font/7.png" |> make_image
let n8 = get_img "font/8.png" |> make_image
let n9 = get_img "font/9.png" |> make_image
let n0 = get_img "font/0.png" |> make_image
let p = get_img "font/P.png" |> make_image
let dot = get_img "font/dot.png" |> make_image
let colon = get_img "font/colon.png" |> make_image
let dollar = get_img "font/dollar.png" |> make_image

let img_of_str str =
  match str with
  | "P" -> p
  | "1" -> n1
  | "2" -> n2
  | "3" -> n3
  | "4" -> n4
  | "5" -> n5
  | "6" -> n6
  | "7" -> n7
  | "8" -> n8
  | "9" -> n9
  | "0" -> n0
  | "." -> dot
  | ":" -> colon
  | "$" -> dollar
  | _ -> dot

let rec chr_lst str =
  match str with
  | "" ->[]
  | ch ->(String.sub ch 0 1)::(chr_lst (String.sub ch 1 ((String.length ch)-1)))

let rec draw_chars chars x y =
  let width = 16 in
  match chars with
  | [] -> ()
  | " "::t -> draw_chars t (x+width) y
  | h::t -> draw_image (img_of_str h) x y;
            draw_chars t (x+width) y

let draw_str str x y =
  draw_chars (chr_lst str) x y

let draw_start () =
  draw_image start_screen 0 0

let round flt =
  int_of_float (flt +. 0.5)

let two_dec flt =
  float_of_int (round (flt *. 100.)) /. 100.

let string_of_float flt =
  let str = string_of_float flt in
  if String.index str '.' = (String.length str - 1) then str ^ "00" else
  if String.index str '.' = (String.length str - 2) then str ^ "0" else
  str

let open_screen size =
  scale := (int_of_string size);
  resize_window (500* !scale) (300* !scale)

let draw_line ?(color=default_color) ?(width=8) (x1,y1) (x2,y2) =
  set_color color;
  set_line_width (!scale * width);
  moveto x1 y1;
  lineto x2 y2

let draw_ograph grph : unit =
  GameElements.Map.iter_edges
    (fun v1 v2 -> draw_line
      ((round ((GameElements.Map.V.label v1).l_x) / 2 * !scale),
      (round ((GameElements.Map.V.label v1).l_y)/ 2 * !scale))
      ((round ((GameElements.Map.V.label v2).l_x)/ 2 * !scale),
      (round ((GameElements.Map.V.label v2).l_y)/ 2 * !scale))
     )  grph;

  GameElements.Map.iter_vertex
    (fun v -> let (x,y) = ((GameElements.Map.V.label v).l_x,
                          (GameElements.Map.V.label v).l_y) in
     draw_image house
       ((round x - 30)/ 2 * !scale) ((round y - 30)/ 2 * !scale)) grph

let draw_vehicle (v:GameElements.vehicle) : unit =
  let pic = (match v.v_t with
            | GameElements.Car -> car_img
            | GameElements.Truck -> truck_img) in
  let x = round ((v.x -. 30.0) /. 2. *. (float_of_int !scale)) in
  let y = (round ((v.y -. 15.0) /. 2. *. (float_of_int !scale))) in
  Graphics.draw_image pic x y

let rec draw_vehicles (vs:GameElements.vehicle list) : unit =
  match vs with
  | v::t -> draw_vehicles t; draw_vehicle v
  | [] -> ()

let draw_player_info (p:Player.player) : unit =
  draw_str ("P"^string_of_int p.p_id^":$"^
            string_of_float(two_dec p.money)) 800 (550-p.p_id*30)
  (*  moveto (p.p_id) (10*p.p_id);
   draw_string ("Player " ^ (string_of_int p.p_id) ^
                ": $" ^(string_of_float p.money)) *)

let rec draw_players (ps:Player.player list) : unit =
  match ps with
  | p::t -> draw_players t; draw_player_info p
  | [] -> ()

let spacing = 25 * !scale
let start_height = 250 * !scale

let draw_buttons () =
  draw_image save 0 start_height;
  draw_image pause 0 (start_height-spacing);
  draw_image buycar 0 (start_height-2*spacing);
  draw_image buytruck 0 (start_height-3*spacing);
  draw_image buyroad 0 (start_height-4*spacing)

open GameElements
let rtos r =
  match r with
  | Lumber -> "Lumber"
  | Iron -> "Iron"
  | Oil -> "Oil"
  | Electronics -> "Electronics"
  | Produce -> "Produce"

let draw_info_box x y v =
  let box_height = 100 in
  (set_color white; fill_rect x y 150 box_height);
  let loc = GameElements.Map.V.label v in
  set_color black;
  (* set_font "-misc-dejavu sans mono-bold-r-normal--256-0-0-0-m-0-iso8859-1";*)
  moveto (x+10) (y+ box_height - 20);
  draw_string "Accepts:";
  rmoveto (-(fst (text_size "Accepts:"))) 0;
  List.iter (fun acc ->
    rmoveto 0 (-12);
    let str = (rtos acc.resource ^": $"^ string_of_float (two_dec acc.price)) in
    draw_string str;
    rmoveto (-fst (text_size str)) 0;
    ) loc.accepts;

  rmoveto 0 (-20);
  draw_string "Produces:";
  rmoveto (-(fst (text_size "Produces:"))) 0;
  List.iter (fun prod ->
    rmoveto 0 (-12);
    let str = string_of_int prod.current ^ " " ^ rtos prod.resource ^
              ": $" ^ string_of_float (two_dec prod.price) in
    draw_string str;
    rmoveto (-fst (text_size str)) 0;
    ) loc.produces


let rec get_loc_near grph =
  let stat = wait_next_event [Button_down] in
  let (x,y) = (stat.mouse_x, stat.mouse_y) in
  let loc = ref None in
  let close_enough = 30 in
  let labl = GameElements.Map.V.label in
  GameElements.Map.iter_vertex
    (fun v -> let (x1,y1) = (labl v).l_x, (labl v).l_y in
              if (abs (x*2/ !scale - round x1) < close_enough)
              && (abs (y*2/ !scale - round y1) < close_enough)
                                  then loc := Some v else () ) grph;
  match !loc with
  | Some v -> v
  | None -> (* print_endline "Not a valid location"; *) get_loc_near grph

let draw_hover grph =
  let stat = wait_next_event [Poll] in
  let x = stat.mouse_x in
  let y = stat.mouse_y in
  let close_enough = 30 in
  let labl = GameElements.Map.V.label in
  GameElements.Map.iter_vertex
    (fun v -> let (x1,y1) = (labl v).l_x, (labl v).l_y in
              if (abs (x*2/ !scale - round x1) < close_enough)
              && (abs (y*2/ !scale - round y1) < close_enough)
                             then draw_info_box x y v else ()) grph

let button_width = 93
let button_height = 50

let quit gs =
  print_endline "Game saved in ???.json";
  (* SAVE; *)
  close_graph ()

let rec pause () =
  let _ = wait_next_event [Button_down] in
  print_endline "Game Paused. Click anywhere to continue"

let get_start_end grph =
  print_endline "Select a start location.";
  let start_loc = get_loc_near grph in
  print_endline "Select an end location.";
  let end_loc = get_loc_near grph in
  (start_loc, end_loc)

let buy_car (gs:GameElements.game_state) =
  print_endline "Select a start location.";
  let loc = get_loc_near gs.graph in
  print_endline "Car bought.\n"

let buy_truck (gs:GameElements.game_state) =
  print_endline "Select a start location.";
  let loc = get_loc_near gs.graph in
  print_endline "Truck bought.\n"

let buy_road (gs:GameElements.game_state) =
  let (start_loc, end_loc) = get_start_end gs.graph in
  print_endline "Road bought.\n"

let click_buttons (gs:GameElements.game_state) =
  let stat = wait_next_event [Poll] in
  let x = stat.mouse_x in
  let y = stat.mouse_y in
  if not (button_down () && x < button_width) then ()
  else (
    if y < start_height+button_height
       && y > start_height then quit gs else
    if y < start_height+button_height-spacing
       && y > start_height-spacing then pause () else
    if y < start_height+button_height-2*spacing
      && y > start_height-2*spacing then buy_car gs else
    if y < start_height+button_height-3*spacing
       && y > start_height-3*spacing then buy_truck gs else
    if y < start_height+button_height-4*spacing
       && y > start_height-4*spacing then buy_road gs
    else ()
  )

let draw_game_state (gs:GameElements.game_state) : unit =
  (* clear_graph (); *)
  draw_image bg 0 0;
  draw_players gs.players;
  draw_ograph gs.graph;
  draw_vehicles gs.vehicles;
  draw_buttons ();
  draw_hover gs.graph;
  click_buttons gs