{*******************************}
{*****  H E A D _ Z P      *****}
{*****  Zentralprojektion  *****}
{*****  OHNE Clipping      *****}
{*******************************}

procedure init_central_projection;
{**************}

procedure init_centralparallel_projection(ind : integer);
{**************}

procedure transf_to_e1e2n0_base(p : vt3d; var pm : vt3d);
{***************}

procedure cp_vt3d_vt2d(p: vt3d; var pp : vt2d);
{**************}

procedure cp_point(p: vt3d; style: integer);
{*************}

procedure cp_line(p1,p2 : vt3d ; style : integer);
{*************}

procedure cp_arrow(p1,p2 : vt3d; style : integer);
{*************}

procedure cp_axes(al : real);
{*************}

procedure cp_vts3d_vts2d(var p: vts3d; n1,n2 : integer; var pp : vts2d);
{*************}

procedure cp_curve(var p: vts3d; n1,n2,style : integer);
{*************}


 procedure cp_curve_vis(var p : vts3d; n1,n2,style : integer; visible: b_array );
{*************}

procedure cp_line_before_plane(p1,p2,nv: vt3d; d : real; side,style: integer);
{**************}

procedure cp_curve_before_plane(var p: vts3d ; n1,n2: integer; nv: vt3d; d: real;
                                                       side,style : integer);
{*************}


