open Graphics
open GameElements
open Player
open InputProcessing

let default_color = 0xCD853F
let button_width = 93
let button_height = 50
let screen_width = 1000
let screen_height = 600

(******************************IMAGES*****************************************)

(* Changes white to transparency *)
let make_transp img =
  let replace = Array.map (fun col -> if col = white then transp else col) in
  Array.map (fun arr -> replace arr) img

(* Loads image from files to color array array *)
let get_img img =
  Images.load img [] |> Graphic_image.array_of_image |> make_transp

(* Opens graph so we can preload some images *)
let _ = open_graph "";
        set_window_title "Mini Transport Tycoon - by Dan, Jon, Max, and Pat"

(* 8Bit live wallpaper by Nysis*)
let start_screen = get_img "images/start.png" |> make_image
let title_screen = get_img "images/title.png" |> make_image
(* pixel art game cars collection by shutterstock *)
let car_img = get_img "images/car.png" |> make_image
let truck_img = get_img "images/truck.png" |> make_image
(* Buttons *)
let newgame = get_img "images/newgame.png" |> make_image
let loadgame = get_img "images/loadgame.png" |> make_image
let help = get_img "images/help.png" |> make_image
let exit = get_img "images/exit.png" |> make_image
let settings = get_img "images/settings.png" |> make_image
let easy = get_img "images/easy.png" |> make_image
let medium = get_img "images/medium.png" |> make_image
let hard = get_img "images/hard.png" |> make_image
let brutal = get_img "images/brutal.png" |> make_image
(* In game buttons *)
let save = get_img "images/savebutt.png" |> make_image
let pause = get_img "images/pausebutt.png" |> make_image
let buycar = get_img "images/carbutt.png" |> make_image
let buytruck = get_img "images/truckbutt.png" |> make_image
let buyroad = get_img "images/buyroad.png" |> make_image
let sellroad = get_img "images/sellroad.png" |> make_image
let addcargo = get_img "images/addcargo.png" |> make_image
let moveauto = get_img "images/moveauto.png" |> make_image
let sellauto = get_img "images/sellauto.png" |> make_image
let confirm = get_img "images/confirm.png" |> make_image
let cancel = get_img "images/cancel.png" |> make_image
(* Resources *)
let tech = get_img "images/elect.png" |> make_image
let fruit = get_img "images/fruit.png" |> make_image
let oil = get_img "images/oil.png" |> make_image
let drugs = get_img "images/drugs.png" |> make_image
let wood = get_img "images/lumber.png" |> make_image
(* Small Resources *)
let tech_s = get_img "images/elect_s.png" |> make_image
let fruit_s = get_img "images/fruit_s.png" |> make_image
let oil_s = get_img "images/oil_s.png" |> make_image
let drugs_s = get_img "images/drugs_s.png" |> make_image
let wood_s = get_img "images/lumber_s.png" |> make_image
(* No Resources *)
let notech = get_img "images/notech.png" |> make_image
let nofruit = get_img "images/nofruit.png" |> make_image
let nooil = get_img "images/nooil.png" |> make_image
let nodrugs = get_img "images/nodrugs.png" |> make_image
let nowood = get_img "images/nolumber.png" |> make_image
(* Other *)
let house = get_img "images/house.png" |> make_image
let bg = get_img "images/bg.png" |> make_image
let gameover = get_img "images/gameover.png" |> make_image
(* Handmade font *)
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
let e = get_img "font/E.png" |> make_image
let p = get_img "font/P.png" |> make_image
let s = get_img "font/S.png" |> make_image
let n = get_img "font/N.png" |> make_image
let i = get_img "font/I.png" |> make_image
let r = get_img "font/R.png" |> make_image
let w = get_img "font/W.png" |> make_image
let dot = get_img "font/dot.png" |> make_image
let colon = get_img "font/colon.png" |> make_image
let dollar = get_img "font/dollar.png" |> make_image

(******************************HELPER FUNCTIONS********************************)

(* For converting strings into pictures *)
let img_of_str str =
  match str with
  | "E" -> e
  | "I" -> i
  | "N" -> n
  | "P" -> p
  | "R" -> r
  | "S" -> s
  | "W" -> w
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

(* Resource to String, so resource types can be printed *)
let rtos r =
  match r with
  | Lumber -> "Wood"
  | Iron -> "Drugs"
  | Oil -> "Oil"
  | Electronics -> "Tech"
  | Produce -> "Fruit"

(* Converts a string into a list of 1 character strings *)
let rec chr_lst str =
  match str with
  | "" ->[]
  | ch ->(String.sub ch 0 1)::(chr_lst (String.sub ch 1 ((String.length ch)-1)))

(* Draw a string by printing a one char string list *)
let rec draw_chars chars x y =
  let width = 16 in
  match chars with
  | [] -> ()
  | " "::t -> draw_chars t (x+width) y
  | h::t -> draw_image (img_of_str h) x y;
            draw_chars t (x+width) y

(* Converta string to a char list and then prints it *)
let draw_str str x y =
  draw_chars (chr_lst str) x y

(* Custom round for pixels *)
let round flt =
  int_of_float (flt +. 0.5)

(* For trucating to 2 digits *)
let two_dec flt =
  float_of_int (round (flt *. 100.)) /. 100.

(* For displaying dollar amounts up to 1 cent *)
let string_of_float flt =
  let str = string_of_float flt in
  if String.index str '.' = (String.length str - 1) then str ^ "00" else
  if String.index str '.' = (String.length str - 2) then str ^ "0" else
  str

(* Used instead of pattern matching for conciseness *)
let get_some opt =
  match opt with
  | Some v -> v
  | _ -> failwith "Always check None before using get_some"

(* Pretty colors *)
let purple = 0xAA00AA
let green = 0x228B22
let orange = 0xFFA500

(* Match players to pretty colors, some are predefined in graphics *)
let player_color pid =
  match pid with
  | -1 -> default_color
  | 0 -> red
  | 1 -> yellow
  | 2 -> blue
  | 3 -> white
  | 4 -> purple
  | _ -> black

(******************************GRAPHICS****************************************)

(* Draws the title screen, now with buttons! *)
let draw_start () =
  resize_window 500 500;
  let y = 100 in
  let x = 100 in
  let offset = button_width/2 in
  draw_image bg 0 0;
  draw_image title_screen 0 0;
  draw_image newgame x y;
  draw_image loadgame (x+button_width) y;
  draw_image help (x+2*button_width) y;
  draw_image settings (x+offset) (y-button_height);
  draw_image exit (x+button_width+offset) (y-button_height)

(* Get clicks for title screen *)
let rec title_click () =
  draw_start ();
  let status = wait_next_event [Button_down] in
  let b_x = 100 in
  let b_y = 100 in
  let offset = button_width/2 in
  let x = status.mouse_x in
  let y = status.mouse_y in
  if (y < b_y+button_height && y > b_y) then (
    if x < b_x+button_width && x > b_x then 1 else
    if x < b_x+2*button_width && x > b_x+button_width then 2 else
    if x < b_x+3*button_width && x > b_x+button_width then 3 else
    title_click () )
  else if (y < b_y && y > b_y-button_height) then (
    if x < b_x+button_width+offset && x > b_x+offset then 4 else
    if x < b_x+2*button_width+offset && x > b_x+button_width+offset then 5 else
    title_click () )
  else title_click ()

(* Draws difficulty options and returns them on mouse click *)
let rec settings () =
  let y = 70 in
  let x = 200 in
  let spacing = button_height+button_height in
  draw_image bg 0 0;
  draw_image brutal x y;
  draw_image hard x (y+spacing);
  draw_image medium x (y+2*spacing);
  draw_image easy x (y+3*spacing);
  let status = wait_next_event [Button_down] in
  let sx, sy = status.mouse_x, status.mouse_y in
  if (sx < x+button_width && sx > x) then (
    if sy < y+button_height && sy > y
      then (print_endline "Brutal mode selected.\n"; Player.Brutal) else
    if sy < y+spacing+button_height && sy > y+spacing
      then (print_endline "Hard mode selected.\n"; Player.Hard) else
    if sy < y+2*spacing+button_height && sy> y+2*spacing
      then (print_endline "Medium mode selected.\n"; Player.Medium) else
    if sy < y+3*spacing+button_height && sy > y+3*spacing
      then (print_endline "Easy mode selected.\n"; Player.Easy) else
    settings () )
  else settings ()


(* Draws a line from one point to another *)
let draw_line ?(color=default_color) ?(width=16) (x1,y1) (x2,y2) =
  set_color color;
  set_line_width width;
  moveto x1 y1;
  lineto x2 y2

(* Iterates over edges and vertexes of our map and draws it *)
let draw_ograph grph : unit =
  let label = Map.V.label in
  Map.iter_edges_e
    (fun (v1, e, v2) ->
      let pos1 = ( (round (label v1).l_x),
                   (round (label v1).l_y) ) in
      let pos2 = ( (round (label v2).l_x),
                   (round (label v2).l_y) ) in
      draw_line pos1 pos2;
      let pid = e.c_owner_id in
      if pid < 0 then ()
      else draw_line ~color:(player_color pid) ~width:8 pos1 pos2
     )  grph;

  Map.iter_vertex
    (fun v -> let (x,y) = ((Map.V.label v).l_x,
                          (Map.V.label v).l_y) in
     draw_image house
       ((round x - 30)) ((round y - 30))) grph

(* Draws a vehicle at its location, now with cargo icons and color labels! *)
let draw_vehicle (v:vehicle) : unit =
  let pic = (match v.v_t with
            | Car -> car_img
            | Truck -> truck_img) in
  let x = round ((v.x -. 30.0)) in
  let y = (round ((v.y -. 15.0) )) in
  Graphics.draw_image pic x y;
  set_color black;
  fill_circle x y 10;
  set_color (player_color v.v_owner_id);
  fill_circle x y 8;
  if v.cargo = None then () else (
    let img = match (get_some v.cargo).t with
              | Electronics -> tech_s
              | Oil -> oil_s
              | Iron -> drugs_s
              | Lumber -> wood_s
              | Produce -> fruit_s in
    draw_image img (x-10) (y+20) )

(* Draws all vehicle in list, player 0 on top *)
let rec draw_vehicles (vs:vehicle list) : unit =
  List.iter draw_vehicle (List.filter (fun v -> v.v_owner_id <> 0) vs);
  List.iter draw_vehicle (List.filter (fun v -> v.v_owner_id = 0) vs)

(* Draws a player's color and their score *)
let draw_score (p:Player.player) : unit =
  let x = 780 in
  let y = (550-p.p_id*30) in
  set_color black;
  fill_circle (x-10) (y+10) 10;
  set_color (player_color p.p_id);
  fill_circle (x-10) (y+10) 8;
  draw_str ("P"^string_of_int p.p_id^":$"^
            string_of_float(two_dec p.money)) x y

(* Draws all scores *)
let draw_scores (ps:Player.player list) : unit =
  List.iter draw_score ps

(* Constants for button drawing and clicking *)
let spacing = 50
let start_height = 550

(* Draws all of the in game buttons *)
let draw_buttons () =
  draw_image save 0 start_height;
  draw_image pause 0 (start_height-spacing);
  draw_image buycar 0 (start_height-2*spacing);
  draw_image buytruck 0 (start_height-3*spacing);
  draw_image buyroad 0 (start_height-4*spacing);
  draw_image moveauto 0 (start_height-5*spacing);
  draw_image addcargo 0 (start_height-6*spacing);
  draw_image sellauto 0 (start_height-7*spacing);
  draw_image sellroad 0 (start_height-8*spacing);
  draw_image confirm 0 (start_height-10*spacing);
  draw_image cancel 0 (start_height-11*spacing)

(* Draws the product info associated with each vertex *)
let draw_info_box x y v =
  let box_height = 100 in
  set_color black; fill_rect (x-2) (y-2) 154 (box_height+4);
  set_color white; fill_rect x y 150 box_height;
  let loc = Map.V.label v in
  set_color black;
  (* set_text_size 20; (* Damn you OCaml *)*)
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

(* Draws an info box when mouse is hovering near a location *)
let draw_hover grph =
  let stat = wait_next_event [Poll;Button_down;Button_up] in
  let x = stat.mouse_x in
  let y = stat.mouse_y in
  let close_enough = 30 in
  let labl = Map.V.label in
  Map.iter_vertex
    (fun v -> let (x1,y1) = (labl v).l_x, (labl v).l_y in
              if (abs (x - round x1) < close_enough)
              && (abs (y - round y1) < close_enough)
                             then draw_info_box x y v else ()) grph

(* Draws the whole game to be played, Engine will call this each loop *)
let draw_game_state (gs:game_state) : unit =
  draw_image bg 0 0;
  draw_scores gs.players;
  draw_ograph gs.graph;
  draw_vehicles gs.vehicles;
  draw_buttons ();
  draw_hover gs.graph

(* Checks to see if the cancel button was pressed *)
let is_cancelled (x,y) =
  (y < start_height+button_height-11*spacing && y > start_height-11*spacing) ||
  (y < start_height+button_height && y > start_height-1*spacing)

(* Complete the game to see this in action, displays winner ans game over *)
let rec fin p_win gs wait =
   let color = (player_color p_win) in
    draw_image truck_img ((Random.int (screen_width+50))-50)
                         ((Random.int (screen_height+50))-50);
    draw_image car_img ((Random.int (screen_width+50))-50)
                       ((Random.int (screen_height+50))-50);
   draw_image house ((Random.int (screen_width+50))-50)
                       ((Random.int (screen_height+50))-50);
    set_color black;
    fill_rect (screen_width/4-5) (screen_height/2-55) 470 160;
    set_color color;
    fill_rect (screen_width/4) (screen_height/2-50) 460 150;
    draw_image gameover (screen_width/4) (screen_height/2);
    draw_str ("WINNER IS: P" ^ (string_of_int p_win))
       (screen_width/4+120) (screen_height/2 - 30);
    set_color black;
    fill_rect 745 405 230 180;
    set_color color;
    fill_rect 750 410 220 170;
    draw_scores gs.players;
    let wait = if wait > 0.003 then wait/.1.2 else wait in
    Unix.sleepf wait;
    draw_image exit 0 (start_height-11*spacing);
    let stat = wait_next_event [Poll;Button_down] in
    let pos = (stat.mouse_x, stat.mouse_y) in
    if (button_down () && is_cancelled pos)
    then failwith "exit" else fin p_win gs wait

(* Engine calls this if it detects someone has won, draws end game screen *)
let draw_winner p_win gs =
  draw_ograph gs.graph;
  draw_vehicles gs.vehicles;
  fin p_win gs 1.

(******************************INPUT FROM GRAPHICS*****************************)

(* Checks to see if the confirmed button was pressed *)
let is_confirmed (x,y) =
  y < start_height+button_height-10*spacing && y > start_height-10*spacing

(* Won't let you do anything else until you hit confirm or cancel *)
let rec wait_confirm () =
  let stat = wait_next_event [Button_down] in
  let pos = (stat.mouse_x, stat.mouse_y) in
  if is_cancelled pos || is_confirmed pos
  then is_confirmed pos else wait_confirm ()

(* Finds a (new) location of the graph near a mouse click, or given position *)
let rec get_loc_near ?(l_id = (-1)) ?(click = true) ?(pos = (0,0)) grph =
  let (x,y) = if click then let stat = wait_next_event [Button_down] in
                            (stat.mouse_x, stat.mouse_y)
              else pos in
  let loc = ref None in
  let close_enough = 30 in
  let labl = Map.V.label in
  Map.iter_vertex
    (fun v -> let (x1,y1) = (labl v).l_x, (labl v).l_y in
              if (abs (x - round x1) < close_enough)
              && (abs (y - round y1) < close_enough)
                                  then loc := Some v else () ) grph;
  match !loc with
  | Some v when (labl v).l_id <> l_id -> Some v
  | _ -> if is_cancelled (x,y) then None else
         get_loc_near ~l_id:l_id grph

(* Get's a human's car near a location *)
let rec get_auto_near gs =
  let stat = wait_next_event [Button_down] in
  let (x,y) = (stat.mouse_x, stat.mouse_y) in
  let auto = ref None in
  let close_enough = 30 in
  List.iter
    (fun v -> let (x1,y1) = round v.x, round v.y in
              if (abs (x - x1) < close_enough)
              && (abs (y - y1) < close_enough)
              && v.v_owner_id = 0
                                  then auto := Some v else () ) gs.vehicles;
  match !auto with
  | Some v -> Some v
  | None -> if is_cancelled (x,y) then None else
            get_auto_near gs

(* Selects two different locations using get_loc_near *)
let get_start_end grph =
  print_endline "Select a start location.";
  let start_loc = get_loc_near grph in
  if start_loc = None then (None, None) else
  (print_endline "Select an end location.";
  let end_loc =
    get_loc_near ~l_id:(Map.V.label (get_some start_loc)).l_id grph in
  (start_loc, end_loc))

(* Displays cargo options at a location and then lets you click one *)
let rec pick_cargo loc =
  let res_start = start_height-6*spacing in
  let res_space = 56 in
  let resource_list = List.map (fun prod -> prod.resource) loc.produces in
  if List.exists ((=) Electronics) resource_list
    then draw_image tech button_width res_start
    else draw_image notech button_width res_start;
  if List.exists ((=) Oil) resource_list
    then draw_image oil (button_width+res_space) res_start
    else draw_image nooil (button_width+res_space) res_start;
  if List.exists ((=) Produce) resource_list
    then draw_image fruit (button_width+2*res_space) res_start
    else draw_image nofruit (button_width+2*res_space) res_start;
  if List.exists ((=) Lumber) resource_list
    then draw_image wood (button_width+3*res_space) res_start
    else draw_image nowood (button_width+3*res_space) res_start;
  if List.exists ((=) Iron) resource_list
    then draw_image drugs (button_width+4*res_space) res_start
    else draw_image nodrugs (button_width+4*res_space) res_start;
  let stat = wait_next_event [Button_down] in
  let (x,y) = stat.mouse_x, stat.mouse_y in
  if is_cancelled (x,y) then None else
  if y > res_start+button_height || y < res_start
    then pick_cargo loc else
  let cargo =
  if x > button_width && x < button_width+res_space
    then Some Electronics else
  if x > button_width+res_space && x < button_width+2*res_space
    then Some Oil else
  if x > button_width+2*res_space && x < button_width+3*res_space
    then Some Produce else
  if x > button_width+3*res_space && x < button_width+4*res_space
    then Some Lumber else
  if x > button_width+4*res_space && x < button_width+5*res_space
    then Some Iron
  else
    pick_cargo loc in
  if cargo = None then None else
  if List.exists ((=) (get_some cargo)) resource_list
  then cargo else pick_cargo loc

(* For quitting, also saves *)
let quit gs =
  print_endline "Saving game to data/save.json";
  DataProcessing.save_file gs "data/save.json";
  EndGame

(* Returns true iff pause button is clicked *)
let is_pause (x,y) =
  y < start_height+button_height-spacing && y > start_height-spacing

(* Waits until something other than pause is clicked *)
let rec wait_pause () =
  let stat = wait_next_event [Button_down] in
  let pos = (stat.mouse_x, stat.mouse_y) in
  if is_pause pos then wait_pause () else ()

(* Pauses the game until you click something other than pause *)
let rec pause () =
  print_endline "Game Paused. Click anywhere to continue";
  wait_pause ();
  print_endline "Game Unpaused.\n";
  Pause

(* Buys a car at a location *)
let buy_car gs player_id =
  print_endline ("Select a start location." ^ "\nThe car will cost $"
    ^ (string_of_float car_price));
  match get_loc_near gs.graph with
  | None -> (print_endline "Cancelled\n"; Nothing)
  | Some loc ->
  InputProcessing.init_vehicle player_id Car loc.l_id gs.graph

(* Buys a truck at a location, very different than buying a car *)
let buy_truck (gs:game_state) player_id =
  print_endline ("Select a start location." ^ "\nThe truck will cost $"
    ^ (string_of_float truck_price));
  match get_loc_near gs.graph with
  | None -> (print_endline "Cancelled\n"; Nothing)
  | Some loc ->
  InputProcessing.init_vehicle player_id Truck loc.l_id gs.graph

(* Buys a road between two locations, waits for confirmation *)
let buy_road gs player_id =
  let (start_loc, end_loc) = get_start_end gs.graph in
  if start_loc = None || end_loc = None
  then (print_endline "Cancelled\n"; Nothing) else (
  let cost = calculate_buy_road_cost
             (get_some start_loc) (get_some end_loc) gs.graph in
  print_endline ("The road will cost $" ^ (string_of_float (two_dec cost))
                   ^ "\n\nConfirm to buy.\n");
  let confirmed = wait_confirm () in
  if (not confirmed) then (print_endline "Cancelled\n"; Nothing) else
  InputProcessing.buy_road player_id
      (get_some start_loc) (get_some end_loc) gs.graph)

(* Sells an owned road between two locations, waits for confirmation *)
let sell_road gs player_id =
  print_endline "Pick two endpoints of the road to sell.";
  let (start_loc, end_loc) = get_start_end gs.graph in
  if start_loc = None || end_loc = None
  then (print_endline "Cancelled\n"; Nothing)
  else (
  let cost = calculate_sell_road_cost (get_some start_loc) (get_some end_loc) in
    print_endline ("You will earn $" ^ (string_of_float (two_dec cost))
                   ^ "\n\nConfirm to sell.\n");
  let confirmed = wait_confirm () in
  if not confirmed then (print_endline "Cancelled\n"; Nothing) else
  InputProcessing.sell_road player_id
    (get_some start_loc) (get_some end_loc) gs.graph)

(* Lets you choose a vehicle to add cargo to *)
let add_cargo gs player_id =
  print_endline "Choose vehicle to add cargo to.";
  match get_auto_near gs with
  | None -> (print_endline "Cancelled\n"; Nothing)
  | Some auto when auto.status = Driving ->
    (print_endline "Vehicle must be stopped at a location.\n"; Nothing)
  | Some auto ->
  print_endline "Choose cargo to go in that vehicle.";
  let loc=get_loc_near ~click:false ~pos:(round auto.x,round auto.y) gs.graph in
  if loc = None then Nothing
  else (
    let cargo = pick_cargo (get_some loc) in
    if cargo = None then Nothing else
    InputProcessing.buy_vehicle_cargo player_id auto (get_some cargo) gs
  )

(* Moves selected auto to clicked location, if possible *)
let move_auto gs player_id =
  print_endline "Pick a vehicle to move.";
  let auto_opt = get_auto_near gs in
  if auto_opt = None then (print_endline "Cancelled"; Nothing)
  else (
    let auto = get_some auto_opt in
    print_endline "Choose destination.";
    let loc_opt = get_loc_near gs.graph in
    if loc_opt = None then (print_endline "Cancelled\n"; Nothing)
    else (
      let dest = get_some loc_opt in
      let l = match auto.v_loc with
      | None -> failwith "vehicle has no location"
      | Some loc -> get_loc loc gs.graph in
      InputProcessing.set_vehicle_dest player_id auto l dest gs
    ))

(* Sells a clicked vehicle *)
let sell_auto gs player_id =
  print_endline "Pick a vehicle to sell for\n\tCar: $60.00 \n\tTruck:$120.00";
  match get_auto_near gs with
  | None -> (print_endline "Cancelled\n"; Nothing)
  | Some auto -> InputProcessing.sell_vehicle player_id auto

(* Matches mouse clicks to buttons, engine uses it for getting inputs *)
let click_buttons gs player_id =
  let status = wait_next_event [Poll;Button_up;Button_down] in
  let x = status.mouse_x in
  let y = status.mouse_y in
  if not (button_down () && x < button_width && x > 0) then Nothing
  else if x > screen_width || x < 0 then pause ()
  else (
    if y < start_height+button_height
       && y > start_height then quit gs else
    if y < start_height+button_height-spacing
       && y > start_height-spacing then pause () else
    if y < start_height+button_height-2*spacing
      && y > start_height-2*spacing then buy_car gs player_id else
    if y < start_height+button_height-3*spacing
       && y > start_height-3*spacing then buy_truck gs player_id else
    if y < start_height+button_height-4*spacing
       && y > start_height-4*spacing then buy_road gs player_id else
    if y < start_height+button_height-5*spacing
       && y > start_height-5*spacing then move_auto gs player_id else
    if y < start_height+button_height-6*spacing
       && y > start_height-6*spacing then add_cargo gs player_id else
    if y < start_height+button_height-7*spacing
       && y > start_height-7*spacing then sell_auto gs player_id else
    if y < start_height+button_height-8*spacing
       && y > start_height-8*spacing then sell_road gs player_id
    (*Cancel and Confirm don't do anything by themselves *)
    else Nothing
  )

