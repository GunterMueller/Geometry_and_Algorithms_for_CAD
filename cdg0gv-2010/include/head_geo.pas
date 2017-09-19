{***************************}
{***  H E A D _ G E O    ***}
{***************************}

(*procedure GeoInit;*)
procedure graph_on(mode : integer);
procedure draw_area(width,height,x0,y0,sfac : real);
procedure draw_end;
procedure graph_off;
procedure new_color(color: integer);
procedure new_linewidth(factor :real);
procedure linec2d(x1,y1,x2,y2 : real; style : integer);
procedure line2d(p1,p2 : vt2d; style : integer);
procedure pointc2d(x,y : real; style : integer);
procedure point2d(p : vt2d; style: integer);
procedure curve2d(var p: vts2d; n1,n2,style : integer);
procedure curve2d_vis(var p: vts2d; n1,n2,style: integer; visible: b_array );
procedure arrowc2d(x1,y1,x2,y2 : real; style : integer);
procedure arrow2d(p1,p2 : vt2d; style : integer);
procedure read_integer_file(file_name: string; n_dat: integer;
                                           var int_var: i_array);
