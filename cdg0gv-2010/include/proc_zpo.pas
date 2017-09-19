{*****************}
{***  PROC_ZPO ***}
{*****************}

procedure aux_polyhedron;
{ne, nf : Anzahl der Punkte,Kanten,Flaechen
 face[i].npf : Anzahl der Punkte (Kanten) der i-ten Flaeche
 edge.ep1, ep2 : Anfangs- bzw. Endpunkt der k-ten Kante
 face[i].fp[k] : k-ter Punkt der i-ten Flaeche (positiv orientiert!!!)
 face[i].fe[k] : k-te Kante der i-ten Flaeche
 ! Dieses UP berechnet aus nf,face[i].fp und face[i].npf:
 ne, face[i].fe[k], edge[i].ep1 und edge[i].ep2 !.}
 type sedge  = record  p1,p2,nr: integer;  end;
      sedges = array[1..nemax] of sedge;
 var i,k,i1,i2,i_edge : integer;
     new_edge : sedge;
     sorted_edges: sedges;
     new_is_old,error: boolean;
{***}
procedure search_insert_edge(var sorted_edges: sedges; new_edge: sedge;
                             var i_edge: integer; var new_is_old: boolean);
{Prueft, ob new_edge in sorted_edges enthalten ist und fuegt new_edge
 gegebenenfalls ein.}
var found: boolean;  left,right,middle: integer;   i : integer;
{**}
function edge1_smaller_edge2(var edge1,edge2 : sedge) : boolean;
begin
  if (edge1.p1<edge2.p1) or ((edge1.p1=edge2.p1) and (edge1.p2<edge2.p2))
     then  edge1_smaller_edge2:= true  else  edge1_smaller_edge2:= false;
end;  { edge1_smaller_edge2 }
{**}
begin  { search_insert_edge }
  left:= 1;  right:= ne;
  if ne=0 then begin found:= false; middle:= 0; end
     else           { binaeres Suchen }
      repeat
      middle:= (left+right) div 2;
      if edge1_smaller_edge2(new_edge,sorted_edges[middle])
         then  right:= middle-1  else  left:= middle+1;
      with sorted_edges[middle] do if (new_edge.p1=p1) and (new_edge.p2=p2)
                                      then found:=true else found:= false;
      until found or (left>right);
  if found then begin i_edge:= middle; new_is_old:= true; end
     else
      begin
      new_is_old:= false; if left>middle then middle:= middle+1;
      for i:= ne downto middle do sorted_edges[i+1]:= sorted_edges[i];
      sorted_edges[middle]:= new_edge;
      sorted_edges[middle].nr:= ne+1;
      end;  { if }
end;   { search_insert_edge }
{***}
 begin   { aux_polyhedron }
   ne:= 0;
   for i:= 1 to nf do
       with face[i] do
       begin
       i1:= fp[1];
       for k:= 1 to npf do
           begin
           if k<npf then i2:= fp[k+1] else i2:= fp[1];
           new_edge.p1:= i1;  new_edge.p2:= i2;
           with new_edge do if p1>p2 then begin p1:= i2; p2:= i1; end;
           search_insert_edge(sorted_edges,new_edge, i_edge,new_is_old);
           if new_is_old then fe[k]:= sorted_edges[i_edge].nr
              else
               begin
               ne:= ne+1; fe[k]:= ne;
               with edge[ne] do begin  ep1:= i1; ep2:= i2; vis:= true end;
               end;  { if }
           i1:= i2;
           end;  { for k }
       nef:= npf;
       plane_equ(p[fp[1]],p[fp[2]],p[fp[3]], nv,d,error);
       end; { with face }
 end; { aux_lines_before_faces }
{*************}

procedure cp_vts3d_vts2d_spez(var p: vts3d; n1,n2: integer;
                              var pp: vts2d; var pdist: r_array);
{Zentralprojektion (Koordinaten) einer Punktreihe.
 pdist[i]: Distanz des Punktes p[i] von der Bildtafel. }
 var xe,ye,ze,cc : real;   pm : vt3d;   i : integer;
 begin
   for i:= n1 to n2 do
       begin
   diff3d(p[i],mainpt, pm);
   xe:= scalarp3d(pm,e1vt);   { Koordinaten von p bzgl. dem Koord.-System: }
   ye:= scalarp3d(pm,e2vt);   { Nullpunkt = Hauptpunkt                     }
   ze:= scalarp3d(pm,n0vt);   { und Basis e1,e2,n0                         }
   cc:= 1-ze/distance;   pdist[i]:= ze;  { Abstand zur Bildebene }
   if cc>eps6 then begin  pp[i].x:= xe/cc; pp[i].y:= ye/cc; end
              else
              writeln('Punkt liegt in oder hinter der Verschwindungsebene !!');
       end; { for }
 end; { cp_vts3d_vts2d_spez }
{**************}

procedure aux_quadrangle(n1,n2,np0,ne0,nf0: integer);
 var  ne1,i,k : integer;  error : boolean;
{***}
function f(i,k :integer) : integer;  begin f := (k-1)*(n1-1)+i+nf0;  end;
function pt(i,k:integer) : integer;  begin pt:= (k-1)*n1+i+np0; end;
function e1(i,k:integer) : integer;  begin e1:= (k-1)*(n1-1)+i+ne0; end;
function e2(i,k:integer) : integer;  begin e2:= ne1+(i-1)*(n2-1)+k+ne0; end;
{****}
 begin
   ne1:= (n1-1)*n2;
   for k:= 1 to n2 do
       begin
       for i:= 1 to n1 do
           begin
           if (i<n1) and (k<n2) then
           with face[f(i,k)] do
                begin
                fp[1]:= pt(i,k);      fp[2]:= pt(i+1,k);
                fp[3]:= pt(i+1,k+1);  fp[4]:= pt(i,k+1);
                fe[1]:= e1(i,k);      fe[2]:= e2(i+1,k);
                fe[3]:= e1(i,k+1);    fe[4]:= e2(i,k);
                npf:= 4; nef:= 4;
                end;  { with }
           if i<n1 then
           with edge[e1(i,k)] do
                begin  ep1:= pt(i,k);  ep2:= pt(i+1,k);  vis:= true; end;
           if k<n2 then
           with edge[e2(i,k)] do
                begin  ep1:= pt(i,k);  ep2:= pt(i,k+1);  vis:= true; end;
           end;  { for i }
       end;  { for k }
   np:= np0+n1*n2;  ne:= ne0+n1*(n2-1)+(n1-1)*n2;  nf:= nf0+(n1-1)*(n2-1);
   for i:= nf0+1 to nf do
       with face[i] do plane_equ(p[fp[1]],p[fp[2]],p[fp[3]], nv,d,error);
 end;  { aux_quadrangle }
{************}

procedure aux_quadrangle_triang(n1,n2: integer;
                                show_triangles: boolean);
{Berechnet ne,nf und fuer jede Flaeche fp,fe und jede Kante ep1,ep2.}
 var  ne1,i,k : integer;
{***}
function f(i,k,u:integer): integer;  begin f := (k-1)*(n1-1)+i + u*nf;  end;
function pt(i,k:integer) : integer;  begin pt:= (k-1)*n1+i; end;
function e1(i,k:integer) : integer;  begin e1:= (k-1)*(n1-1)+i; end;
function e2(i,k:integer) : integer;  begin e2:= ne1+(i-1)*(n2-1)+k; end;
function e3(i,k:integer) : integer;  begin e3:= ne+(k-1)*(n1-1)+i; end;
{****}
 begin
   ne:= n1*(n2-1)+(n1-1)*n2;  nf:= (n1-1)*(n2-1);
   ne1:= (n1-1)*n2;
   for k:= 1 to n2-1 do
       begin
      for i:= 1 to n1-1 do
          begin
          with face[f(i,k,0)] do
               begin
               fp[1]:= pt(i,k);   fp[2]:= pt(i+1,k);   fp[3]:= pt(i+1,k+1);
               fe[1]:= e1(i,k);   fe[2]:= e2(i+1,k);   fe[3]:= e3(i,k);
               end;  { with }
          with face[f(i,k,1)] do
               begin
               fp[1]:= pt(i,k);   fp[2]:= pt(i+1,k+1);  fp[3]:= pt(i,k+1);
               fe[1]:= e3(i,k);   fe[2]:= e1(i,k+1);    fe[3]:= e2(i,k);
               end;  { with }
          with edge[e1(i,k)] do
               begin  ep1:= pt(i,k);  ep2:= pt(i+1,k); end;
          with edge[e2(i,k)] do
               begin  ep1:= pt(i,k);  ep2:= pt(i,k+1); end;
          with edge[e3(i,k)] do
               begin  ep1:= pt(i,k);  ep2:= pt(i+1,k+1); end;
          end;  { for i }
      end;  { for k }
  for i:= 1 to n1-1 do
      with edge[e1(i,n2)] do begin  ep1:= pt(i,n2); ep2:= pt(i+1,n2);  end;
  for k:= 1 to n2-1 do
      with edge[e2(n1,k)] do begin  ep1:= pt(n1,k); ep2:= pt(n1,k+1);  end;
  if show_triangles then ne:= ne+nf;
  for i:= 1 to ne do edge[i].vis:= true;
  nf:= nf+nf;
  for i:= 1 to nf do
      with face[i] do
           begin
           plane_equ(p[fp[1]],p[fp[2]],p[fp[3]], nv,d,error);
           npf:= 3; nef:= 3;
           end;
 end;  { aux_quadrangle_triang }
{************}

procedure aux_cylinder(n1,n2,np0,ne0,nf0: integer);
var  n12,i,k : integer;   error : boolean;
{***}
function f(i,k :integer) : integer;  begin f := (k-1)*n1+i+nf0; end;
function pt(i,k:integer) : integer;  begin pt:= (k-1)*n1+i+np0; end;
function e1(i,k:integer) : integer;  begin e1:= (k-1)*n1+i+ne0; end;
function e2(i,k:integer) : integer;  begin e2:= n12+(i-1)*(n2-1)+k+ne0; end;
{****}
begin
  n12:= n1*n2;
  for k:= 1 to n2 do
      begin
      for i:= 1 to n1 do
          begin
          with face[f(i,k)] do
               begin
               fp[1]:= pt(i,k);      fp[2]:= pt(i+1,k);
               fp[3]:= pt(i+1,k+1);  fp[4]:= pt(i,k+1);
               fe[1]:= e1(i,k);      fe[2]:= e2(i+1,k);
               fe[3]:= e1(i,k+1);    fe[4]:= e2(i,k);
               npf:= 4; nef:= 4;
               end;  { with }
          with edge[e1(i,k)] do
               begin  ep1:= pt(i,k);  ep2:= pt(i+1,k);  vis:= true;  end;
          if k<n2 then
          with edge[e2(i,k)] do
               begin  ep1:= pt(i,k);  ep2:= pt(i,k+1);  vis:= true;  end;
          end;  { for i }
      end;  { for k }
  for k:= 1 to n2 do    { Korrektur }
      begin
      with face[f(n1,k)] do
           begin
           fp[2]:= pt(1,k);  fp[3]:= pt(1,k+1);
           fe[2]:= e2(1,k);
           end; { with }
      edge[e1(n1,k)].ep2:= pt(1,k);
      end;  { for k }
  np:= np0+n12; ne:= ne0+2*n12-n1;  nf:= nf0+n12-n1;
  for i:= nf0+1 to nf do
      with face[i] do plane_equ(p[fp[1]],p[fp[2]],p[fp[3]], nv,d,error);
end;  { aux_cylinder }
{************}

procedure aux_torus(n1,n2,np0,ne0,nf0: integer);
 var  n12,i,k : integer;
{***}
function f(i,k :integer) : integer;  begin f := (k-1)*n1+i+nf0; end;
function pt(i,k:integer) : integer;  begin pt:= (k-1)*n1+i+np0; end;
function e1(i,k:integer) : integer;  begin e1:= (k-1)*n1+i+ne0; end;
function e2(i,k:integer) : integer;  begin e2:= n12+(i-1)*n2+k+ne0; end;
{****}
 begin
   n12:= n1*n2;
   for k:= 1 to n2 do
       begin
       for i:= 1 to n1 do
           begin
           with face[f(i,k)] do
                begin
                fp[1]:= pt(i,k);      fp[2]:= pt(i+1,k);
                fp[3]:= pt(i+1,k+1);  fp[4]:= pt(i,k+1);
                fe[1]:= e1(i,k);      fe[2]:= e2(i+1,k);
                fe[3]:= e1(i,k+1);    fe[4]:= e2(i,k);
                npf:= 4; nef:= 4;
                end;  { with }
           with edge[e1(i,k)] do
                begin  ep1:= pt(i,k);  ep2:= pt(i+1,k);  vis:= true;  end;
           with edge[e2(i,k)] do
                begin  ep1:= pt(i,k);  ep2:= pt(i,k+1);  vis:= true;  end;
           end;  { for i }
       end;  { for k }
{ Korrektur: }
   for k:= 1 to n2 do
       begin
       with face[f(n1,k)] do
            begin
            fp[2]:= pt(1,k);  fp[3]:= pt(1,k+1);
            fe[2]:= e2(1,k);
            end; { with }
       with edge[e1(n1,k)] do ep2:= pt(1,k);
       end;  { for k }
   for i:= 1 to n1 do
       begin
       with face[f(i,n2)] do
            begin
            fp[3]:= np0+i+1;  fp[4]:= np0+i;
            fe[3]:= ne0+i;
            end;  { with }
       with edge[e2(i,n2)] do ep2:= pt(i,1);
       end;  { for i }
   with face[f(n1,n2)] do
        begin
        fp[3]:= np0+1;  fp[4]:= np0+n1;    fe[3]:= ne0+n1;
        end;
  np:= np0+n12;  ne:= ne0+n12+n12;   nf:= nf0+n12;
  for i:= nf0+1 to nf do
      with face[i] do plane_equ(p[fp[1]],p[fp[2]],p[fp[3]], nv,d,error);
 end;  { aux_torus }
{************}

procedure is_line_convex_polygon(p1,p2 : vt2d; p_pol : vts2d_pol; np : integer;
                                           var t1,t2 : real; var ind : integer);
{Berechnet die Parameter t1,t2 der Schnittpunkte der Strecke p1,p2
 mit dem konvexen Polygon p_pol[0],...p_pol[np].
 ind=0 bzw. 2 : Strecke  innerhalb bzw. ausserhalb, ind=1: sonst.
 vts2d_pol: array[0..npfmax] of vt2d. }
 var x1,y1,x2,y2,x21,y21,s,t,det,xi,yi,xi1,yi1 : real;  i,ns : integer;
 begin
   x1:= p1.x;  y1:= p1.y;  x2:= p2.x;  y2:= p2.y;
   x21:= x2-x1;   y21:= y2-y1;    ns:= 0;
   t1 :=0;  t2:=0;  i:=0;         xi:= p_pol[0].x;  yi:= p_pol[0].y;
   while (ns<2) and (i<np) do
         begin
         xi1:= p_pol[i+1].x;  yi1:= p_pol[i+1].y;
         det:= (xi1-xi)*y21 - x21*(yi1-yi);
         if abs(det)>eps6 then
            begin
            s:= (x21*(yi-y1) - y21*(xi-x1))/det;
            if (-eps7<=s) and (s<=1+eps7) then
               begin
               t:= ((yi-y1)*(xi1-xi)-(xi-x1)*(yi1-yi))/det;
               if ns=0 then
                  begin
                  t1:= t;      ns:= 1;
                  end
                 else  {ns=1}
                  begin
                  t2:= t;   if abs(t2-t1)>eps6 then ns:= 2;
                  end;
               end;  { if }
            end;  { if }
         xi:= xi1;  yi:= yi1;  i:= i+1;
         end; { while }
   ind:= 2;
   if ns=2 then
      begin
      ind:= 1;   {Strecke schneidet wenigstens eine Seite}
      if t2<t1 then  change1d(t1,t2);
      if (t1<=0) and (t2>=1) then ind:= 0;  {Strecke innerh.}
      if (t1>=1) or  (t2<=0) then ind:= 2;  {Strecke ausserh.}
      end;
 end;  { is_line_convex_polygon }
{*************}

procedure intmint(a,b,c,d: real; var e1,f1,e2,f2: real; var ind: integer);
{Berechnet die Intervall-Differenz  [a,b] \ [c,d] .
 ind=0: leer, ind=1: 1 Interv., ind=2: 2 Interv.}
 var aa,bb,cc,dd : real;
 begin
   aa:= min(a,b);   bb:= max(a,b);
   cc:= min(c,d);   dd:= max(c,d);
   e1:= aa;         f1:= bb;        ind:= 1;
   if (cc<=aa) and (dd>=bb)   then  ind:=0
     else
      begin
      if (cc<=aa) and (dd>aa)  then  e1:= dd;
      if (dd>=bb) and (cc<bb)  then  f1:= cc;
      if (cc>aa)  and (dd<bb)  then
         begin
         f1:= cc;  e2:= dd;  f2:= bb;  ind:= 2;
         end;
      end;
 end; { intmint }
{*************}

procedure cp_lines_before_convex_faces(oriented_faces,is_permitted,newstyles : boolean);
{Projiziert und zeichnet Kantenteile VOR (orientierten) ebenen n-Ecken.
 oriented_faces=true: die Flaechen sind orientiert,
 is_permitted=true: Kanten duerfen die Flaechen schneiden.
 Aus dem Hauptprogramm muessen bereitstehen:
 np, ne, nf: Anzahl der Punkte, Kanten, Flaechen,
 p[1],...,p[np] : Punkte,
 face[i].fp[k] (face[i].fe[k]): k-ter Punkt (k-te Kante) in i-ter Flaeche,
 face[i].npf (face[i].nef): Anzahl der Punkte (Kanten) in der i-ten Flaeche,
 edge[i].ep1 (edge[i].ep2): Anfangs-(End-)Punkt der i-ten Kante,
 face[i].nv,face[i].d: Koeffizienten der Ebenengleichung.}
 label 5,10;
 var  t1,t2,tt,dispt,xemin,xemax,yemin,yemax,zemin,d1,d2,dd1,dd2,a,b,
      tt1,tt2,ts,disp1,disp2,dispt1,dispt2,test1,test2 : real;
      i,j,k,l,m,i1,i2,nseg,nseg0,ind : integer;
      p1,p2,pd,pt, pt1,pt2,ps : vt3d;
      pp1,pp2,ppd,qq1,qq2,pps : vt2d;
      pp : vts2d; 
      par1,par2,pa1,pa2,pa3,pa4 : r_array_seg;  {r_array_seg : s. HP    }
      p_pol : vts2d_pol;                        {vts2d_pol   : s. HP    }
      nt : i_array_seg;                         {i_array_seg : s. HP    }
{******}
 begin
    if nf>100 then
    begin
       writeln; writeln('####:  wait !!! (for hiddenline-alg.)  '); writeln;
    end;
    if oriented_faces then
      begin
      for i:= 1 to nf do face[i].vis:= false;
      for i:= 1 to ne do edge[i].vis:= false;
      end;
{ Koordinaten der Bildpunkte: }
   cp_vts3d_vts2d_spez(p,1,np, pp,pdist);
{ Fenster und Normalentest fuer die Flaechen: }
   for i:= 1 to nf do
       begin
       with face[i] do
            begin
            discentre:= scalarp3d(nv,centre) - d;
            if ((discentre>=0) or (not oriented_faces)) then
               begin
               if oriented_faces then
                  begin      { Normalentest: Flaeche ist sichtbar }
                  vis:= true;
                  for k:= 1 to nef do edge[fe[k]].vis:= true;
                  end;
               with box do
                    begin
                    with pp[fp[1]] do   { Anfangswerte }
                         begin xmin:= x; xmax:= x;  ymin:= y;  ymax:= y; end;
                    zmax:= pdist[fp[1]];
                    for k:= 2 to npf do
                        begin
                        with pp[fp[k]] do     { Flaechenfenster }
                             begin
                             xmin:= min(xmin,x);  ymin:= min(ymin,y);
                             xmax:= max(xmax,x);  ymax:= max(ymax,y);
                             end;  { with }
                        zmax:= max(zmax,pdist[fp[k]]);
                        end;  { for k }
                    end;  { with box }
               end;  { if }
            end; { with  face }
       end; { for i }
{ Test und Zeichnen der Kanten(-teile):}
   for i:= 1 to ne do                           { Beginn der KANTENschleife }
       begin
       if not edge[i].vis then goto 10;
       par1[1]:= 0;  par2[1]:= 1;  nseg:= 1;    { : 1 sichtb. Anfangsintervall}
  { Punkte und Fenster der Kante : }
       i1:= edge[i].ep1;  i2:= edge[i].ep2;
       p1:= p[i1];  p2:= p[i2];  pp1:= pp[i1]; pp2:= pp[i2];
       xemax:= max(pp1.x,pp2.x);   yemax:= max(pp1.y,pp2.y);
       xemin:= min(pp1.x,pp2.x);   yemin:= min(pp1.y,pp2.y);
       zemin:= min(pdist[i1],pdist[i2]);
       for j:= 1 to nf do                       { Beginn der FLAECHENschleife }
           with face[j] do
           begin
           if not vis and oriented_faces then goto 5;
  { Fenstertest mit j-ter Flaeche: }
           if (xemax<=box.xmin) or (xemin>=box.xmax)
             or (yemax<=box.ymin) or (yemin>=box.ymax) or (box.zmax<=zemin)
               then   goto 5; { Kante wird nicht von j-ter Flaeche verdeckt }
  { Kante i Kante von j-ter Flaeche ?:}
           for k:= 1 to nef do  if i=fe[k] then goto 5; { naechste Flaeche}
  { Schnitt der Kante mit dem (konvexen) Flaechenpolygon in der Bildtafel: }
           for k:= 1 to npf do p_pol[k]:= pp[fp[k]];  p_pol[0]:= p_pol[npf];
           is_line_convex_polygon(pp1,pp2,p_pol,npf,t1,t2,ind);
           if ind=2 then  goto 5 ;   {Kante nicht verdeckt=> naechste Flaeche }
	   d1:= distance3d(p1,centre);     d2:= distance3d(p2,centre);
	   with pp1 do dd1:=sqrt(x*x+y*y+sqr(distance)); {fuer Testpunkte}
	   with pp2 do dd2:=sqrt(x*x+y*y+sqr(distance)); 
	   a:= d1/dd1;  b:= d2/dd2;
           if not is_permitted then  {Kante darf die Flaeche NICHT durchdr.}
  { Testpunkt und Test, ob Kante vor oder hinter der Flaeche : }
              begin
              tt:= ( max(0,t1) + min(1,t2) )/2;     diff3d(p2,p1, pd);
	      tt:= a*tt/(b+tt*(a-b)); {Korrekt. (Zentralproj. keine lin. Abb.)}
              lcomb2vt3d(1,p1, tt,pd, pt);
              dispt:= scalarp3d(nv,pt) - d;    {Distanz Testpunkt-Ebene}
              if (dispt*discentre>0)  then   goto 5;
                { Kante vor der Ebene => naechste Flaeche }
              end;  { if not is_permitted }
           if is_permitted then  { Kante darf die Flaeche durchdringen }
 { Bestimmung des Teils der Kante, der hinter der Flaeche liegt: }
              begin
              tt1:= max(0,t1);  tt2:= min(1,t2);   diff3d(p2,p1, pd);
	      tt1:= a*tt1/(b+tt1*(a-b));{Korrekt. (Zentralproj. keine lin. Abb.)}
	      tt2:= a*tt2/(b+tt2*(a-b));{                "                      }
              lcomb2vt3d(1,p1,tt1,pd, pt1);      lcomb2vt3d(1,p1,tt2,pd, pt2);
              dispt1:= scalarp3d(nv,pt1) - d;    {Distanz 1.Testpunkt-Ebene}
              dispt2:= scalarp3d(nv,pt2) - d;    {Distanz 2.Testpunkt-Ebene}
              test1:= dispt1*discentre;          test2:= dispt2*discentre;
              if ((test1>=0) and (test2>=0))  then   goto 5;
             { Kante vor der Ebene => naechste Flaeche }
              if dispt1*dispt2<0 then
                 begin
                 disp1:= scalarp3d(nv,p1) - d;   disp2:= scalarp3d(nv,p2) - d;
                 ts:= disp1/(disp1-disp2);
                 lcomb2vt3d(1,p1,ts,pd, ps);  cp_vt3d_vt2d(ps,pps);
                 diff2d(pp2,pp1, ppd); {Zentralproj. ist keine lin. Abb. !!!}
                 ts:= (scalarp2d(pps,ppd)-scalarp2d(pp1,ppd))/scalarp2d(ppd,ppd);
                 if test1<0 then t2:= ts else t1:= ts;
                 end;
              end; { if is_permitted}
              for l:= 1 to nseg do   {weiterhin sichtbare Intervalle:}
                  intmint(par1[l],par2[l],t1,t2,
                                         pa1[l],pa2[l],pa3[l],pa4[l],nt[l]);
              nseg0:= nseg; m:= 0;
              for l:= 1 to nseg0 do          { neue Intervallteilung }
                  begin
                  if nt[l]=0 then  nseg:= nseg-1   { 1 Segment weniger }
                    else
                     begin
                     m:= m+1;
                     par1[m]:= pa1[l];  par2[m]:= pa2[l];
                     if nt[l]=2 then      { 1 Segment mehr }
                        begin
                        m:= m+1;  nseg:= nseg+1;
                        par1[m]:= pa3[l];  par2[m]:= pa4[l];
                        end;
                     end;  { if }
                  end; { for l }
          if nseg<1 then goto 10;
5:        end; { with }
       for k:=1 to nseg do   { Zeichnen der sichtb. Segmente der i-ten Kante}
           begin
           diff2d(pp2,pp1, ppd);
           lcomb2vt2d(1,pp1, par1[k],ppd, qq1);
           lcomb2vt2d(1,pp1, par2[k],ppd, qq2);
	   if newstyles then
	      with edge[i] do begin new_color(color); new_linewidth(linew); end;
           line2d(qq1,qq2,0);
           end;
10:    end; { for i (Kantenschleife) }
 end; { cp_lines_before_convex_faces }
{*************}



procedure is_interv_interv(var a,b,c,d,aa,bb : real; var inters: boolean);
{Berechnet den Schnitt der Intervalle [a,b], [c,d] .}
var a1,a2,b1,b2 : real;
begin
  a1:= min(a,b);    b1:= max(a,b);
  a2:= min(c,d);    b2:= max(c,d);
  aa:= max(a1,a2);  bb:= min(b1,b2);
  if bb<=aa then inters:= false else inters:= true;
end; {is_interv_interv}
{*****}

procedure box3d_of_pts(var p : vts3d_pol; np: integer; var box : box3d_dat);
var   i: integer;
{Bestimmt den zugehoerigen (kleinsten) achsenparallelen Quader.}
begin
  with box do
       begin
       with p[1] do
            begin
            xmin:= x; xmax:= x;   ymin:= y; ymax:= y;  zmin:= z; zmax:= z;
            end;
       for i:= 2 to np do with p[i] do
           begin
           xmin:= min(xmin,x);  xmax:= max(xmax,x);
           ymin:= min(ymin,y);  ymax:= max(ymax,y);
           zmin:= min(zmin,z);  zmax:= max(zmax,z);
           end;  { for }
      end;  { with }
end;  { box3d_of_pts }
{************}
(*
function is_two_boxes3d(var box1,box2 : box3d_dat) : boolean;
{Schnitt zweier achsenparalleler Quader.}
begin
  is_two_boxes3d:= false;
  if (box1.xmax>box2.xmin) then if (box1.xmin<box2.xmax) then
     if (box1.ymax>box2.ymin) then if (box1.ymin<box2.ymax) then
        if (box1.zmax>box2.zmin) then if (box1.zmin<box2.zmax) then
           is_two_boxes3d:= true;
end; {is_two_boxes3d }
*)
{*************}


function is_two_boxes3d(var box1,box2 : box3d_dat) : boolean;
{Schnitt zweier achsenparalleler Quader.}
begin

  if ((box1.xmax>box2.xmin) and (box1.xmin<box2.xmax) and
      (box1.ymax>box2.ymin) and (box1.ymin<box2.ymax) and
      (box1.zmax>box2.zmin) and (box1.zmin<box2.zmax))
     then
       is_two_boxes3d:=true
     else
       is_two_boxes3d:=false;
end;  {is_two_boxes3d }
{*************}

procedure is_line_conv_pol_in_plane3d(var pl,rl: vt3d; var pp : vts3d_pol;
                                      npp : integer;
                                      var t1,t2 : real; var inters : boolean);
{Schnitt eines konv. Polygons mit einer in der Polygonebene liegenden Gerade.}
var pp1,v1,v2,pl2 : vt3d;      qql1,qql2 : vt2d;
    qq : vts2d_pol;    error : boolean;   i,ind : integer;
begin
  pp1:= pp[1];  diff3d(pp[npp],pp1, v2);  diff3d(pp[2],pp1, v1);
  for i:= 3 to npp-1 do
      ptco_plane3d(pp1,v1,v2,pp[i], qq[i].x,qq[i].y,error);
  put2d(0,0, qq[1]);    put2d(1,0, qq[2]);
  put2d(0,1, qq[npp]);  qq[0]:= qq[npp];
  ptco_plane3d(pp1,v1,v2,pl,qql1.x,qql1.y,error);
  sum3d(pl,rl, pl2);
  ptco_plane3d(pp1,v1,v2,pl2, qql2.x,qql2.y,error);
  is_line_convex_polygon(qql1,qql2,qq,npp, t1,t2,ind);
  if t1<>t2 then inters:= true else inters:= false;
end;  { is_line_conv_pol_in_plane3d }
{***********}
procedure is_n1gon_n2gon3d(var pp1,pp2: vts3d_pol; np1,np2: integer;
                           var  ps1,ps2 : vt3d; var intersection : boolean);
{Berechnet die Schnittstrecke zweier ebener konvexer Polygone im Raum, die
 NICHT in einer Ebene liegen.}
var   box1,box2 : box3d_dat;    t1,t2,s1,s2,s,t : real;
      nv1,nv2,ps,rs : vt3d;  d1,d2 : real;
      inters1,inters2,error,inters : boolean;
begin
  intersection:= false;
  box3d_of_pts(pp1,np1, box1);  box3d_of_pts(pp2,np2, box2);
  if is_two_boxes3d(box1,box2) then
     begin
     plane_equ(pp1[1],pp1[2],pp1[3], nv1,d1,error);
     plane_equ(pp2[1],pp2[2],pp2[3], nv2,d2,error);
     is_plane_plane(nv1,d1,nv2,d2, ps,rs, error);
     if not error then
        begin
        is_line_conv_pol_in_plane3d(ps,rs,pp1,np1, t1,t2,inters1);
        is_line_conv_pol_in_plane3d(ps,rs,pp2,np2, s1,s2,inters2);
        if inters1 and inters2 then
           begin
           is_interv_interv(t1,t2,s1,s2, s,t,inters);
           if inters then
              begin
              lcomb2vt3d(1,ps,s,rs, ps1);
              lcomb2vt3d(1,ps,t,rs, ps2);
              intersection:= true;
              end;   { if inters }
           end;  { if inters1,inters2 }
        end;  { if not error }
     end; { if is_boxes }
end;  { is_n1gon_n2gon }
{**************}

procedure boxes_of_faces;
var i,j : integer;  pp : vts3d_pol;
begin
  for i:= 1 to nf do
      with face[i] do
           begin
           for j:= 1 to npf do pp[j]:= p[fp[j]];
           box3d_of_pts(pp,npf, box);
           end;
end;  { boxes_of_faces }
{************}

procedure is_face_face(i,k: integer;  var ps1,ps2 : vt3d;
                                      var intersection: boolean);
{Berechnet die Schnittstrecke zweier nicht in einer Ebene liegenden
 (konvexen) Flaechen eines Polyeders.}
var  t1,t2,s1,s2,s,t : real;      ps,rs : vt3d;  ppf: vts3d_pol;
     error,inters1,inters2,inters : boolean;  j: integer;
begin
  intersection:= false;
  if is_two_boxes3d(face[i].box,face[k].box) then
     begin
     is_plane_plane(face[i].nv,face[i].d,face[k].nv,face[k].d, ps,rs, error);
     if not error then
        begin
        with face[i] do for j:= 1 to npf do ppf[j]:= p[fp[j]];
        is_line_conv_pol_in_plane3d(ps,rs,ppf,face[i].npf, t1,t2,inters1);
        with face[k] do for j:= 1 to npf do ppf[j]:= p[fp[j]];
        is_line_conv_pol_in_plane3d(ps,rs,ppf,face[k].npf, s1,s2,inters2);
        if inters1 and inters2 then
           begin
           is_interv_interv(t1,t2,s1,s2, s,t,inters);
           if inters then
              begin
              lcomb2vt3d(1,ps,s,rs, ps1);
              lcomb2vt3d(1,ps,t,rs, ps2);
              intersection:= true;
              end;   { if inters }
           end;  { if inters1,inters2 }
        end;  { if not error }
     end; { if is_boxes }
end;  { is_face_face }
{**************}
