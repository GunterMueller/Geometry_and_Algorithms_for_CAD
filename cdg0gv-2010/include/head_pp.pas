{***********************}
{***  H E A D _ P P  ***}
{***********************}

procedure init_parallel_projection;
procedure pp_vt3d_vt2d(p : vt3d; var pp: vt2d);
procedure pp_point(p: vt3d; style: integer);
procedure pp_line(p1,p2 : vt3d ; style : integer);
procedure pp_arrow(p1,p2 : vt3d; style : integer);
procedure pp_axes(al : real);
procedure pp_vts3d_vts2d(var p: vts3d; n1,n2 : integer; var pp : vts2d);
procedure pp_curve(var p: vts3d; n1,n2,style : integer);
procedure pp_curve_vis(var p : vts3d; n1,n2,style : integer; visible: b_array );
procedure pp_line_before_plane(p1,p2,nv: vt3d; d : real; side,style: integer);
procedure pp_curve_before_plane(var p: vts3d ; n1,n2: integer; nv: vt3d; d: real;
                                                       side,style : integer);

