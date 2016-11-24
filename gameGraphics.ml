open Graphics
open GameElements
open Player

let vertex_color = black
let default_color = 0xD3D3D3
let car_color = red
let vertex_size = 5
let car_size = 6
let scale =  ref 2

let get_img img =
  Images.load img [] |> Graphic_image.array_of_image

let car_img = get_img "images/car.png"
let truck_img = get_img "images/truck.png"

let round flt =
  int_of_float (flt +. 0.5)

let open_screen size =
  scale := (int_of_string size);
  let display = string_of_int (400 * !scale) ^ "x" ^ string_of_int (300 * !scale) in
  open_graph (" " ^ display)

let draw_line ?(color=default_color) ?(width=2) (x1,y1) (x2,y2) =
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

  set_color vertex_color;
  GameElements.Map.iter_vertex
    (fun v -> let (x,y) = ((GameElements.Map.V.label v).l_x,
                          (GameElements.Map.V.label v).l_y) in
     fill_circle ((round x)/ 2 * !scale) ((round y)/ 2 * !scale) (!scale * vertex_size)) grph

let draw_vehicle (v:GameElements.vehicle) : unit =
  set_color car_color;
  let pic = (match v.t with
            | GameElements.Car -> car_img
            | GameElements.Truck -> truck_img) in
  let x = (round (v.x *. (float_of_int !scale)/.2.)) in
  let y = (round (v.y *. (float_of_int !scale)/.2.)) in
  let size = (!scale * car_size) in

  Graphics.draw_image (pic |> make_image) x y
  (* fill_rect x y size size *)

let rec draw_vehicles (vs:GameElements.vehicle list) : unit =
  match vs with
  | v::t -> draw_vehicles t; draw_vehicle v
  | [] -> ()

let draw_player_info (p:Player.player) : unit =
   moveto (10*p.p_id) (10*p.p_id);
   draw_string ("Player " ^ (string_of_int p.p_id) ^
                ": $" ^(string_of_int p.money))

let rec draw_players (ps:Player.player list) : unit =
  match ps with
  | p::t -> draw_players t; draw_player_info p
  | [] -> ()

let button_size = 50

let draw_buttons () =
  let spacing = 500 in
  draw_image (get_img "images/car.png" |> make_image) 0 200;
  draw_image (get_img "images/truck.png"|> make_image) 0 (200-spacing);
  draw_image (get_img "images/car.png"|> make_image) 0 (200-2*spacing);
  draw_image (get_img "images/car.png"|> make_image) 0 (200-3*spacing)
(*   moveto (!scale*10) (!scale*110);
  draw_string "Buy Car";
  draw_rect (!scale*0) (!scale*100) (!scale*button_size) (!scale*button_size);
  moveto (!scale*10) (!scale*160);
  draw_string "Buy Truck";
  draw_rect (!scale*0) (!scale*150) (!scale*button_size) (!scale*button_size);
  moveto (!scale*10) (!scale*210);
  draw_string "Pause";
  draw_rect (!scale*0) (!scale*200) (!scale*button_size) (!scale*button_size);
  moveto (!scale*10) (!scale*260);
  draw_string "Save and Quit";
  draw_rect (!scale*0) (!scale*250) (!scale*button_size) (!scale*button_size)
 *)
let draw_game_state gs : unit =
  clear_graph ();
  draw_ograph gs.graph;
  draw_vehicles gs.vehicles;
  draw_players gs.players;
  draw_buttons ()