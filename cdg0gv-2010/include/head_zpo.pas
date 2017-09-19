{*****************}
{***  HEAD_ZPO ***}
{*****************}

procedure aux_polyhedron;
procedure cp_vts3d_vts2d_spez(var p: vts3d; n1,n2: integer;
                              var pp: vts2d; var pdist: r_array);
procedure aux_quadrangle(n1,n2,np0,ne0,nf0: integer);
procedure aux_quadrangle_triang(n1,n2: integer;
                                show_triangles: boolean);
procedure aux_cylinder(n1,n2,np0,ne0,nf0: integer);
procedure aux_torus(n1,n2,np0,ne0,nf0: integer);
procedure is_line_convex_polygon(p1,p2 : vt2d; p_pol : vts2d_pol; np : integer;
                                           var t1,t2 : real; var ind : integer);
procedure intmint(a,b,c,d: real; var e1,f1,e2,f2: real; var ind: integer);
procedure cp_lines_before_convex_faces(oriented_faces,is_permitted,newstyles : boolean);
procedure is_interv_interv(var a,b,c,d,aa,bb : real; var inters: boolean);
procedure box3d_of_pts(var p : vts3d_pol; np: integer; var box : box3d_dat);
function is_two_boxes3d(var box1,box2 : box3d_dat) : boolean;
procedure is_line_conv_pol_in_plane3d(var pl,rl: vt3d; var pp : vts3d_pol;
                                      npp : integer;
                                      var t1,t2 : real; var inters : boolean);
procedure is_n1gon_n2gon3d(var pp1,pp2: vts3d_pol; np1,np2: integer;
                           var  ps1,ps2 : vt3d; var intersection : boolean);
procedure boxes_of_faces;
procedure is_face_face(i,k: integer;  var ps1,ps2 : vt3d;
                                      var intersection: boolean);
