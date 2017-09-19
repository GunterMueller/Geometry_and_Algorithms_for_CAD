{*******************************}
{*****  P R O C _ C P      *****}
{*****  Zentralprojektion  *****}
{*******************************}

procedure init_central_projection;
 begin
   writeln('*** CENTRAL-PROJECTION ***');
   writeln;
   writeln('mainpoint ?');  readln(mainpt.x,mainpt.y,mainpt.z);
   writeln('distance ?');     readln(distance);
   writeln('angles u, v ? (in degree)');  readln(u_angle,v_angle);
   rad_u:= u_angle*pi/180;        rad_v:= v_angle*pi/180;
   sin_u:= sin(rad_u);            cos_u:= cos(rad_u);
   sin_v:= sin(rad_v);            cos_v:= cos(rad_v);
{base e1,e2 and normal n0 of image plane:}
   e1vt.x:= -sin_u;         e1vt.y:= cos_u;          e1vt.z:= 0;
   e2vt.x:= -cos_u*sin_v;   e2vt.y:=-sin_u*sin_v;    e2vt.z:= cos_v;
   n0vt.x:= cos_u*cos_v;    n0vt.y:= sin_u*cos_v;    n0vt.z:= sin_v;
{centre:}
   lcomb2vt3d(1,mainpt, distance,n0vt,  centre);
 end; { init_central_projection }
{**************}

procedure init_centralparallel_projection(ind : integer);
 begin
   if ind=1 then
             begin
             writeln('*** CENTRAL-projection ***');    
             writeln('mainpoint ?');  readln(mainpt.x,mainpt.y,mainpt.z);
             writeln('distance ?');     readln(distance);
             end 
            else
             begin
             writeln('*** PARALLEL-projection ***');
             mainpt:= null3d;   distance:= 1000000000;
             end;
   writeln('angles u, v ? (in degree)');  readln(u_angle,v_angle);
   rad_u:= u_angle*pi/180;        rad_v:= v_angle*pi/180;
   sin_u:= sin(rad_u);            cos_u:= cos(rad_u);
   sin_v:= sin(rad_v);            cos_v:= cos(rad_v);
{base e1,e2 and normal n0 of image plane:}
   e1vt.x:= -sin_u;         e1vt.y:= cos_u;          e1vt.z:= 0;
   e2vt.x:= -cos_u*sin_v;   e2vt.y:=-sin_u*sin_v;    e2vt.z:= cos_v;
   n0vt.x:= cos_u*cos_v;    n0vt.y:= sin_u*cos_v;    n0vt.z:= sin_v;
{centre:}
   lcomb2vt3d(1,mainpt, distance,n0vt,  centre);
 end; { init_centralparallel_projection }
{**************}

procedure transf_to_e1e2n0_base(p : vt3d; var pm : vt3d);
{coordinates in system "mainpoint, e1,e2,n0".}
 var pd : vt3d;
 begin
   diff3d(p,mainpt, pd);
   pm.x:= scalarp3d(pd,e1vt);
   pm.y:= scalarp3d(pd,e2vt);
   pm.z:= scalarp3d(pd,n0vt);
 end;  { transf_to_e1e2n0_base }
{***************}

procedure cp_vt3d_vt2d(p: vt3d; var pp : vt2d);
{central projetion (coordinates) of a point}
 var xe,ye,ze,cc : real;   pm : vt3d;
 begin
   diff3d(p,mainpt, pm);
   xe:= scalarp3d(pm,e1vt);   { coordinates von p in system: }
   ye:= scalarp3d(pm,e2vt);   { origin = mainpoint           }
   ze:= scalarp3d(pm,n0vt);   { and base vectors  e1,e2,n0   }
   cc:= 1-ze/distance;
   if cc>eps6 then begin  pp.x:= xe/cc; pp.y:= ye/cc; end      { projection }
              else
	      writeln('central proj.: point not in front of vanishing plane !!');
 end;  { cp_vt3d_vt2d }
{**************}

procedure cp_point(p: vt3d; style: integer);
 var pp : vt2d;
 begin
   cp_vt3d_vt2d(p,pp);   point2d(pp,style);
 end;  { cp_point }
{**************}

procedure cp_line(p1,p2 : vt3d ; style : integer);
 var pp1,pp2 : vt2d;
 begin
   cp_vt3d_vt2d(p1,pp1);   cp_vt3d_vt2d(p2,pp2);   line2d(pp1,pp2,style);
 end; {cp_line}
{**************}

procedure cp_arrow(p1,p2 : vt3d; style : integer);
 var pp1,pp2: vt2d;
 begin
   cp_vt3d_vt2d(p1,pp1);   cp_vt3d_vt2d(p2,pp2);   arrow2d(pp1,pp2,style);
 end;  { cp_arrow }
{**************}

procedure cp_axes(al : real);
 var p0,p1,p2,p3 : vt3d;
 begin
   put3d(0,0,0,p0);  put3d(al,0,0,p1);
   put3d(0,al,0,p2); put3d(0,0,al,p3);
   cp_arrow(p0,p1, 2);   cp_arrow(p0,p2, 2);   cp_arrow(p0,p3, 2);
 end;  { cp_axes }
{**************}

procedure cp_vts3d_vts2d(var p: vts3d; n1,n2 : integer; var pp : vts2d);
 var i : integer;
 begin
   for i:= n1 to n2 do  cp_vt3d_vt2d(p[i],pp[i]);
 end;  { cp_vts3d_vts2d }
{*************}

procedure cp_curve(var p: vts3d; n1,n2,style : integer);
 var pp : vts2d;
 begin
   cp_vts3d_vts2d(p,n1,n2,pp);   curve2d(pp,n1,n2,style);
 end;  { cp_curve }
{*************}

procedure cp_curve_vis(var p : vts3d; n1,n2,style : integer; visible: b_array );
{connects neighbored visible points.}
 var pp : vts2d;
 begin
   cp_vts3d_vts2d(p,n1,n2,pp);   curve2d_vis(pp,n1,n2,style,visible);
 end;  { cp_curve_vis }
{*************}

procedure cp_line_before_plane(p1,p2,nv: vt3d; d : real; side,style: integer);
{style=0: draws visible part of the line p1p2 (visible:  side*(nv*x - d) >= 0).
 Dash-dots the invisible part if style = 10 .}
var dis1,dis2,t : real;    p3 : vt3d;
 begin
   dis1:= scalarp3d(nv,p1) - d;   dis2:= scalarp3d(nv,p2) - d;
   if side<0 then begin  dis1:= -dis1; dis2:= -dis2;  end;
   if (dis1>=0) and (dis2>=0) then  cp_line(p1,p2,0)
     else
        if (dis1<0) and (dis2<0) then
           begin
           if style=10 then      cp_line(p1,p2,1);
           end
          else
           begin
           t := -dis1/(dis2-dis1);
           lcomb2vt3d(1-t,p1, t,p2, p3);    {Schnittpunkt}
           if dis1>=0    then           {p1 vor der Ebene}
              begin
              cp_line(p1,p3,0);
              if style=10 then cp_line(p3,p2,1);
              end
             else
              begin
              cp_line(p3,p2,0);
              if style=10 then cp_line(p1,p3,1);
              end;
            end;
  end;  { cp_line_before_plane }
{**************}

procedure cp_curve_before_plane(var p: vts3d ; n1,n2: integer; nv: vt3d; d: real;
                                                       side,style : integer);
{see cp_line_before_plane}
 var i : integer;
 begin
   for i:= n1 to n2-1  do
       cp_line_before_plane(p[i],p[i+1],nv,d,side,style);
 end;  { cp_curve_before_plane }
{*************}



