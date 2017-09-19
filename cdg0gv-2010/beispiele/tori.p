{***  Projektion zweier Tori mit UP cp_lines_before_convex_faces  ***}
{********************************************************************}
program tori_h;
uses geograph,dos;
 const {Achtung: es muss  array_size>=nfmax  sein  !!!}
       nfmax= 20000;  nemax=40000;    nsegmax=10;  npfmax=4;

 
 type  vts2d_pol  = array[0..npfmax] of vt2d;
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
 var   face : array[1..nfmax] of face_dat;
       edge : array[1..nemax] of edge_dat;
       p : vts3d;     p0 : vt3d;   pdist : r_array;   error : boolean;
       n1,n2,np,nf,ne,i,j,k,ik,iachs,inz,ianf,i2tor : integer;
       r1,r2,xf,yf,x1,y1,x2,y2,dw,cdw,sdw : real;
     {$i include/proc_zpo.pas}

{****************}
begin {Hauptprogramm}
   graph_on(0);
   repeat
     writeln(' ***  2 Tori  *** ');    writeln;
{     writeln(' n2 (>2 Unterteilungen des grossen Kreises) ? ');  readln(n2);
     writeln(' n1 (>2 Unterteilungen des kleinen Kreises) ? ');  readln(n1);
     writeln(' 2 Tori ? (ja=1) oder 1 Torus ? ');             readln(i2tor);}
      n1:= 20; n2:= 20;  i2tor:= 1;
      r1:= 50;  r2:= 15;
{ Koordinaten der Punkte 1...n1 (kleiner Kreis): }
     dw:= pi2/n1;   cdw:= cos(dw);    sdw:= sin(dw);
     put3d(r1+r2,0,0, p[1]);   put3d(r1,0,0, p0);
     for i:= 2 to n1 do rotp0y(cdw,-sdw,p0, p[i-1], p[i]);
{ Koordinaten der restlichen Punkte des 1. Torus: }
     dw:= pi2/n2;   cdw:= cos(dw);    sdw:= sin(dw);
     for k:= 2 to n2 do
         for i:= 1 to n1 do
             begin
             ik:= i + (k-1)*n1;
             rotorz(cdw,sdw,p[ik-n1], p[ik]);
             end;
     np:= n1*n2;
     aux_torus(n1,n2,0,0,0);
{ 2. Torus:}
    if i2tor=1 then
       begin
       for i:= 1 to np do put3d(p[i].x-r1, -p[i].z, p[i].y,  p[np+i]);
       aux_torus(n1,n2,np,ne,nf);
       end;
     writeln(' np:',np);     writeln(' nf:',nf);     writeln(' ne:',ne);

     repeat
       init_centralparallel_projection(2);
      { writeln(' Koordinaten-Achsen ? (Ja = 1)');         readln(iachs);}
{ Zeichnen : }
	draw_area(200,200,80,90,1);
    {   if iachs=1 then begin  cp_axes(20);  point2d(null2d,0);  end; }

       cp_lines_before_convex_faces(true,false,false);    {Hiddenline-Algorithmus}

       draw_end ;        writeln ;
	writeln(' Noch eine Projektion ? ( Ja = 1 )');     readln(inz);
     until inz=0;
   writeln('Noch einmal mit ANDEREN  n1, n2 ?  (ja: 1)'); readln(ianf);
   until ianf=0;
   graph_off;
 end.





