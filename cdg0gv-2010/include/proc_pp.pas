{**********************}
{***  P R O C  P P  ***}
{**********************}

procedure init_parallel_projection;
 begin
   writeln('*** PARALLEL-PROJEKTION ***');
   writeln;
   writeln('Projektionswinkel u, v ? (in Grad)');  readln(u_angle,v_angle);
   rad_u:= u_angle*pi/180  ;  rad_v:= v_angle*pi/180  ;
   sin_u:= sin(rad_u)   ;           cos_u:= cos(rad_u)   ;
   sin_v:= sin(rad_v)   ;           cos_v:= cos(rad_v)   ;
{Normalen-Vektor der Bildebene:}
   n0vt.x:= cos_u*cos_v;    n0vt.y:= sin_u*cos_v;    n0vt.z:= sin_v;
 end; { init_parallel_projection }
{**************}

procedure pp_vt3d_vt2d(p : vt3d; var pp: vt2d);
 {Bildvektor eines Punktes}
 begin
   pp.x:= -p.x*sin_u + p.y*cos_u;
   pp.y:=-(p.x*cos_u + p.y*sin_u)*sin_v + p.z*cos_v;
 end; {pp_vt3d_vt2d}
{*************}

procedure pp_point(p: vt3d; style: integer);
 {... markiert einen projizierten Punkt}
 var pp : vt2d;
 begin
   pp_vt3d_vt2d(p,pp);   point2d(pp,style);
 end; {pp_point}
{*************}

procedure pp_line(p1,p2 : vt3d ; style : integer);
 {projiziert die Strecke p1,p2 }
 var pp1,pp2 : vt2d;
 begin
   pp_vt3d_vt2d(p1,pp1);       pp_vt3d_vt2d(p2,pp2);
   line2d(pp1,pp2,style);
 end; {pp_line}
{*************}

procedure pp_arrow(p1,p2 : vt3d; style : integer);
 {projiziert einen Pfeil}
 var pp1,pp2: vt2d;
 begin
   pp_vt3d_vt2d(p1,pp1);   pp_vt3d_vt2d(p2,pp2);
   arrow2d(pp1,pp2,style);
 end; {pp_axes}
{*************}

procedure pp_axes(al : real);
 {projiziert die Koordinatenachsen, al: Achsenlaenge}
 var p0,p1,p2,p3 : vt3d;
 begin
   put3d(0,0,0,p0);  put3d(al,0,0,p1);
   put3d(0,al,0,p2); put3d(0,0,al,p3);
   pp_arrow(p0,p1, 2);   pp_arrow(p0,p2, 2);
   pp_arrow(p0,p3, 2);
 end; {pp_axes}
{*************}

procedure pp_vts3d_vts2d(var p: vts3d; n1,n2 : integer; var pp : vts2d);
 {Berechnet die Bildvektoren pp einer Punktreihe p.}
 var i : integer;
  begin
    for i:= n1 to n2 do
      begin
        pp[i].x:= - p[i].x*sin_u + p[i].y*cos_u;
        pp[i].y:= -(p[i].x*cos_u + p[i].y*sin_u)*sin_v + p[i].z*cos_v;
      end;
  end; {pp_vts3d_vts2d}
{*************}

procedure pp_curve(var p: vts3d; n1,n2,style : integer);
 {Projiziert das 3d-Polygon p[n1]...p[n2]}
 var pp : vts2d;
 begin
   pp_vts3d_vts2d(p,n1,n2,pp);
   curve2d(pp,n1,n2,style);
 end; {pp_curve}
{*************}

procedure pp_curve_vis(var p : vts3d; n1,n2,style : integer; visible: b_array);
 {projiziert ein 3d-Polygon. Es werden je zwei benachnarte "visible"
 Punkte verbunden. style=10: Rest wird gestrichelt.}
 var pp : vts2d;
 begin
   pp_vts3d_vts2d(p,n1,n2,pp);
   curve2d_vis(pp,n1,n2,style,visible);
 end; {pp_curve_vis}
{*************}

procedure pp_line_before_plane(p1,p2,nv: vt3d; d : real; side,style: integer);
 {Zeichnet ,falls style=0, den Teil der Strecke p1, p2, fr den
 side*(nv*x - d) >= 0 ist und strichelt den Rest, falls style = 10 ist. }
 var dis1,dis2,t : real;    p3 : vt3d;
 begin
   dis1:= scalarp3d(nv,p1) - d;   dis2:= scalarp3d(nv,p2) - d;
   if side<0 then begin  dis1:= -dis1; dis2:= -dis2;  end;
   if (dis1>=0) and (dis2>=0) then  pp_line(p1,p2,0)
     else
        if (dis1<0) and (dis2<0) then
            begin
            if style=10 then      pp_line(p1,p2,1);
            end
          else
            begin
            t := -dis1/(dis2-dis1);
            lcomb2vt3d(1-t,p1, t,p2, p3);    {Schnittpunkt}
            if dis1>=0    then           {p1 vor der Ebene}
               begin
               pp_line(p1,p3,0);
               if style=10 then pp_line(p3,p2,1);
               end
              else
               begin
               pp_line(p3,p2,0);
               if style=10 then pp_line(p1,p3,1);
               end;
            end;
  end; { pp_line_before_plane }
{**************}

procedure pp_curve_before_plane(var p: vts3d ; n1,n2: integer; nv: vt3d;
                                         d: real; side,style : integer);
 {Projiziert eine Kurve (Polygonzug) "vor" der Ebene nv*x = d und strichelt
 den Rest, falls style=10 .}
 var i,k,nis : integer;  nvv,p_i,p_i1,rvt,pis : vt3d;    visi,visi1 : boolean;
     pp : vts3d;   vis : b_array;       dd : real;
 begin
   if side<0 then begin scale3d(-1,nv,nvv);  dd:= -d;  end
             else begin nvv:= nv;  dd:= d; end;
   k:= n1-1;
   for i:= n1 to n2 do
       begin
       p_i:= p[i]; k:= k+1;
       if scalarp3d(p_i,nvv)-dd >= 0 then visi:= true
                                    else visi:= false;
       pp[k]:= p_i;  vis[k]:= visi;
       if (i>n1) and (visi<>visi1) then
             begin
             diff3d(p_i,p_i1, rvt);
             is_line_plane(p_i1,rvt, nvv,dd, pis,nis);
             k:= k+1;  pp[k]:= pis;  vis[k]:= true;
             end;
       p_i1:= p_i;  visi1:= visi;
       end;    { for i }
  pp_curve_vis(pp,n1,k,style,vis);
 end; { pp_curve_before_plane }
{*************}
(*

procedure pp_curve_before_plane(var p: vts3d ; n1,n2: integer; nv: vt3d; d: real;
                                                       side,style : integer);
{Projiziert eine Kurve (Polygonzug) "vor" der Ebene nv*x = d und strichelt
 den Rest, falls style=10 .}
 var i : integer;
 begin
   for i:= n1 to n2-1  do
       pp_line_before_plane(p[i],p[i+1],nv,d,side,style);
 end; { pp_curve_before_plane }
{*************}

procedure pp_curve_before_plane(var p: vts3d ; n1,n2: integer; nv: vt3d;
                                         d: real; side,style : integer);
 {Projiziert eine Kurve (Polygonzug) "vor" der Ebene nv*x = d und strichelt
 den Rest, falls style=10 .}
 var i : integer;  nvv : vt3d;  pp1,pp2 : vt2d;
     vis1,vis2 : boolean;            dd : real;
 begin
   if side<0 then begin scale3d(-1,nv,nvv);  dd:= -d;  end
             else begin nvv:= nv;  dd:= d; end;
   for i:= n1 to n2 do
       begin
       if scalarp3d(p[i],nvv)-dd >= 0 then
          begin
          vis2:=true;    pp_vt3d_vt2d(p[i],pp2);
          end
         else
          begin
          vis2:= false;  if style=10 then pp_vt3d_vt2d(p[i],pp2);
          end;
       if i>n1 then
          begin
          if vis1 and vis2 then line2d(pp1,pp2,style);
          if (style=10) and (not vis1) and (not vis2) then line2d(pp1,pp2,1);
          if (vis1 and not vis2) or (not vis1 and vis2)
             then pp_line_before_plane(p[i-1],p[i],nv,d,side,style);
          end;
       pp1:= pp2;  vis1:= vis2;
       end;
 end; { pp_curve_before_plane }
{*************}

*)
