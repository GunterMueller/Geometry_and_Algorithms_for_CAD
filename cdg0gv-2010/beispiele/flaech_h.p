{********************************************************************}
{***  Projektion einer param. Flaeche mit UP cp_lines_before_convex_faces  ***}
{********************************************************************}
program flaech_h;
uses geograph,hiddenl;
(*  {const type und var in unit hiddenl:}
const {Achtung: es muss  array_size>=nfmax  sein  !!!}
       nfmax= 10000;  nemax=20000;    nsegmax=10;  npfmax=10;

type   vts2d_pol  = array[0..npfmax] of vt2d;
       vts3d_pol  = array[0..npfmax] of vt3d;
       r_array_seg  = array[0..nsegmax] of real;
       i_array_seg  = array[0..nsegmax] of integer;
       box3d_dat = record
                   xmin,xmax,ymin,ymax,zmin,zmax : real;
                   end;
       face_dat = record
                  npf,nef : integer;
                  fp,fe : array[1..npfmax] of integer;
                  vis : boolean;
                  box : box3d_dat;
                  discentre,d : real;
                  nv : vt3d;
                  end;
       edge_dat = record
                  vis : boolean;
                  ep1,ep2,color,linew : integer;
                  end;

var    ne,nf,np: integer;  {Anzahl der Kanten, Facetten,Punkte}
       p    : vts3d;       {Punkte des Polyeders} 
       face : array[1..nfmax] of face_dat;
       edge : array[1..nemax] of edge_dat;
       pdist: r_array;     {pdist[i]: Abstand d. i-ten Punktes von d. Bildeb.} 
       error,oriented_faces,is_permitted,newstyles: boolean;
*)

 var   u,v,du,dv,u1,u2,v1,v2,r1 : real;
       n1,n2,i,k,ik,iachs,inz,ianf,iplot,nf1,ne0 : integer;
       ps1,ps2			: vt3d;     {fuer Schnittkanten der Flaechen}
       inters			: boolean;
{****************}

begin {Hauptprogramm}
   writeln('PLD-Datei ? (ja: 1)');  readln(iplot);
   graph_on(iplot);
   repeat
     writeln('***  Projektion parametrisierter Flaechen         ***');    writeln;
     writeln('***  hier: "Affensattel" und Zylinder             ***');
      ne0:= 0;
{--------------------------------}
{ Affensattel: Typ ist "quadrangle"}
     n1:= 30;    n2:= 30;   {Anzahl der Unterteilungen im Parameterbereich};
     u1:= -0.9;  u2:= 0.9;  {Parametergrenzen}
     v1:= -0.9;  v2:= 0.9;
     du:= (u2-u1)/(n1-1);     dv:= (v2-v1)/(n2-1);
     v:= v1;
     for k:= 1 to n2 do
         begin
         u:= u1;
         for i:= 1 to n1 do
             begin
             ik:=i + (k-1)*n1;
             put3d(u,v,u*u*u-3*u*v*v, p[ik]);    {Parameterdarstellung}
             u:= u+du;
             end;
         v:= v+dv;
         end;
     np:= n1*n2;
{     aux_quadrangle_triang(n1,n2,true);}
    aux_quadrangle(n1,n2,0,0,0); 
     writeln(' np:',np);     writeln(' nf:',nf);     writeln(' ne:',ne);
     nf1:= nf;
     for i:= ne0+1 to ne do
	  with edge[i] do begin color:=cyan; linew:=1; end;
      ne0:= ne;
{--------------------------------}      
{Zylinder 1: x**2 + z**2 -r1**2=0, Typ ist "cylinder"}
     r1:= 0.6;
     n1:= 50;    n2:= 10;
     v1:= -1.5;  v2:= 1;
     u1:= 0;     u2:= pi2;
     du:= (u2-u1)/n1;     dv:= (v2-v1)/(n2-1);
     v:= v1;
     for k:= 1 to n2 do
         begin
         u:= u1;
         for i:= 1 to n1 do
             begin
             ik:=i + (k-1)*n1;
             put3d(r1*cos(u),r1*sin(u),v, p[np+ik]);
             u:= u+du;
             end;
         v:= v+dv;
         end;
     aux_cylinder(n1,n2,np,ne,nf);
     for i:= ne0+1 to ne do
	  with edge[i] do begin color:=blue; linew:=1; end;
      ne0:= ne;
{---------------------------------------------}

{Durchdringung der beiden Flaechen:}
    boxes_of_faces;
    for i:= 1 to nf1 do         { 1.Flaechenschleife }
        begin
        for k:= nf1+1 to nf do  { 2.Flaechenschleife }
            begin
            is_face_face(i,k, ps1,ps2,inters);
            if inters then
               begin
               p[np+1]:= ps1;  p[np+2]:= ps2;
               with edge[ne+1] do 
                    begin ep1:= np+1; ep2:= np+2; vis:= true; end;
               np:= np+2;  ne:= ne+1;
               with face[i] do begin fe[nef+1]:= ne; nef:= nef+1;  end;
               with face[k] do begin fe[nef+1]:= ne; nef:= nef+1;  end;
               end;  { if }
            end;  { for k }
        end;  { for i }
     for i:= ne0+1 to ne do
	  with edge[i] do begin color:=red; linew:=1; end;
      ne0:= ne;
{---------------------------------------------}
      
     repeat
       writeln;
       init_centralparallel_projection(2);
       writeln(' Koordinaten-Achsen ? (Ja = 1)');
       readln(iachs);
{ Zeichnen : }
       draw_area(200,200,100,100,50);
       if iachs=1 then begin  cp_axes(1.8);  point2d(null2d,0);  end;

       oriented_faces:= false;
       is_permitted:= true;
	newstyles:= true;
       cp_lines_before_convex_faces(oriented_faces,is_permitted,newstyles);

       draw_end ;        writeln ;
       writeln(' Noch eine Projektion ? ( Ja = 1 )');
     readln(inz);
     until inz=0;

   writeln('Noch einmal mit ANDEREN  n1, n2 ?  (ja: 1)');
   readln(ianf);
   until ianf=0;
   graph_off;
 end.





