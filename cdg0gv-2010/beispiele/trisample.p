program trisample;
uses geograph,hiddenl;

type  funct2d = function(x,y: real) : real;   
      funct2d2d = procedure(x,y: real; var gx,gy: real);
      funct3d = function(p: vt3d) : real;   
      funct3d3d = procedure(p: vt3d; var g: vt3d);
      funct2d3d = procedure(u,v: real; var p: vt3d);
      funct1d3d = procedure(u: real; var p: vt3d);
      psurface_tangents = procedure(u,v: real; var su,sv: vt3d); 
      implicit3d = procedure(p: vt3d; var fvalue: real; var gradf: vt3d);

{var   f_gradf: implicit3d;}
{--------------------------}
{for triangulation:}
const tnfmax=15000; tnemax=30000; tnpmax=15000; 
      tfrnpmax= 500;  {max. number of points in a front}  
      tnfrmax=20;     {max. number of additional fronts.}
{--------------------------}
var   i,k,ipro,ianf,n1,n2,ik,ne0       		: integer;
      u1,u2,v1,v2,du,dv,u,v			: real;
      oriented_faces				: boolean;
      x1,y1,r1,x2,y2,r2,x3,y3,r3,dw,r_tor,a_tor	: real;
      p1					: vt3d;
{****************}
{$i triang_proc.p}   
{****************}
{************************************************************}

procedure f_gradf_c1(p: vt3d; var f: real; var gradf: vt3d); 
{1. cylinder}
begin
  with p do 
  begin
    f:= sqr(x-x1)+sqr(y-y1) -r1*r1;  
    gradf.x:= 2*(x-x1);   
    gradf.y:= 2*(y-y1);   
    gradf.z:= 0;	 
  end;
end;   
{******}

procedure f_gradf_c2(p: vt3d; var f: real; var gradf: vt3d); 
{2. cylinder}
begin
  with p do 
  begin
    f:= sqr(x-x2)+sqr(y-y2) -r2*r2;
    gradf.x:= 2*(x-x2);   
    gradf.y:= 2*(y-y2);   
    gradf.z:= 0;	 
  end;
end;   
{******}
procedure f_gradf_sph4(p: vt3d; var f: real; var gradf: vt3d);  
begin
  with p do 
       begin
       f:= x*x*x*x+y*y*y*y+z*z*z*z - 16;
       gradf.x:= 4*x*x*x;
       gradf.y:= 4*y*y*y;
       gradf.z:= 4*z*z*z;
       end; 
end;   
{******}
procedure f_gradf_tor(p: vt3d; var f: real; var gradf: vt3d); 
{torus }
var c1,c2: real;
begin
  c1:= sqr(r_tor);
  with p do 
      begin
      c2:= x*x+y*y +z*z + c1 - sqr(a_tor);
      f:= c2*c2 - 4*c1*(x*x+y*y);
      gradf.x:= 4*x*c2 - 8*c1*x;
      gradf.y:= 4*y*c2 - 8*c1*y;
      gradf.z:= 4*z*c2;
      end;
end;   
{******}
{*************************************************************}
begin {main program}
   graph_on(0);
   repeat
     writeln('*********************************************');
     writeln(' *** Triangulation of implicit surfaces  *** ');   
     writeln('*********************************************'); 
     writeln;
     writeln('  example: 3 cylinders and a quartic sphere  ');  
     writeln('*********************************************');  
     writeln;
{------------------------------------}      
{for hiddenline:}
      for i:= 1 to nemax do
	  with edge[i] do begin color:=black; linew:=1; end;
{------------------------------------}      
{for triangulation:}
     cuttype:=0; {box}
     {cuttype=1: cylinder, needs xcut,ycut,rcut_square (see proc. cut...)} 
     {cuttype=2: sphere, needs xcut,ycut,zcut,rcut_square (   "         )} 
     for i:= 1 to tnpmax do tpoint[i].full:= false;     
     tnp:= 0;   tnf:= 0;    tnfr:= 0;
      np:=0;    nf:= 0;      ne:= 0;  ne0:= 0;

     writeln('Number of triangles ?');  readln(n_triang);
     writeln;

{------------------------------------------------------------------------}

{1. cylinder: with start hexagon}
     f_gradf:= f_gradf_c1;
     x1:= -2; y1:= -5;	 r1:= 2; 
     put3d(0,-3,1, p1);   
     tstepl:= 0.4; 
     xmin:= -10;  xmax:= 10;         
     ymin:= -10;  ymax:= 10;
     zmin:= -2;   zmax:= 5;
     tnp:= 0;        tnf:= 0;    tnfr:= 0; 
     start_triangulation(p1,f_gradf); 

{triangulation: }
     nearpointtest:= true;
     triangulation(nearpointtest);

     writeln('tfrontnp: ',tfrontnp,' fullcount: ',fullcount,' tnf: ',
             tnf,' n_triang: ',n_triang);
     writeln;
     writeln('tnp: ',tnp,'   tnf: ',tnf);  
     writeln;

{tri --> hiddenl.:}
     for i:= 1 to tnp do p[np+i]:= tpoint[i].p;
     for i:= 1 to tnf do 
         with face[nf+i] do 
              begin 
              npf:= 3; 
              with tface[i] do 
	      begin fp[1]:= np+p1; fp[2]:= np+p2; fp[3]:= np+p3;  end;
	      end; 
     np:=np+tnp;  nf:= nf+tnf;
     aux_polyhedron;   
     writeln('np: ',np);  writeln('nf: ',nf); writeln('ne: ',ne); 
     for i:= ne0+1 to ne do
	  with edge[i] do begin color:=black; linew:=1; end;
      ne0:= ne;
{--------------------------------}

{2. cylinder: with start POLYGON (circle)}
     for i:= 1 to tnpmax do tpoint[i].full:= false;     
     tnp:= 0;        tnf:= 0;    tnfr:= 0;
     x2:= -5;  y2:=0;  r2:= 2;
     f_gradf:= f_gradf_c2;   
     xmin:= -10;  xmax:= 10;         
     ymin:= -10;  ymax:= 10;
     zmin:= -10;  zmax:= 10;
     tfrontnp:= 30; tnp:= tfrontnp;  dw:= pi2/tfrontnp;   tstepl:= r2*pi2/tfrontnp;
	for i:= 1 to tfrontnp do   {front polygon: circle on the top} 
         begin
         with tpoint[i] do 
              begin
              put3d(x2+r2*cos((i-1)*dw),y2+r2*sin((i-1)*dw),5, p1); 
              surface_point_normal_tangentvts(p1,f_gradf, p,nv,tv1,tv2);
              full:= false; achange:= true;
              end;  { with }
         tfrontpt[i]:= i;
         end;  { for }  
     dw:= -dw;    
	for i:= 1 to tfrontnp do    {bounding polygon: circle on the bottom}
         begin
         with tpoint[tnp+i] do 
              begin
              put3d(x2+r2*cos((i-1)*dw),y2+r2*sin((i-1)*dw),-2, p1); 
              surface_point_normal_tangentvts(p1,f_gradf, p,nv,tv1,tv2);
              full:= false; achange:= true;
              end;  { with }
         tfr[1,i]:= tnp+i ;
         end;  { for }
     tfr[1,0]:= tfrontnp;   tnp:= tnp+tnp;    
     tnfr:= 1;

{triangulation:}
     nearpointtest:= true;
     triangulation(nearpointtest);

     writeln('tfrontnp: ',tfrontnp,' fullcount: ',fullcount,' tnf: ',
             tnf,' n_triang: ',n_triang);
	writeln;
	writeln('tnp: ',tnp,'   tnf: ',tnf);  
	writeln;

{tri --> hiddenl.:}
       for i:= 1 to tnp do p[np+i]:= tpoint[i].p;
       for i:= 1 to tnf do 
           with face[nf+i] do 
                begin 
                npf:= 3; 
                with tface[i] do 
                     begin fp[1]:= np+p1; fp[2]:= np+p2; fp[3]:= np+p3;  end; 
                end; 
	np:=np+tnp;  nf:= nf+tnf;
       aux_polyhedron;   
       writeln('np: ',np);  writeln('nf: ',nf); writeln('ne: ',ne); 
     for i:= ne0+1 to ne do
	  with edge[i] do begin color:=red; linew:=3; end;
      ne0:= ne;
{-------------------------------------------------------}

{3. quartic sphere x^4+y^4+z^4-16=0: with start hexagon}
     for i:= 1 to tnpmax do tpoint[i].full:= false;     
     tnp:= 0;        tnf:= 0;    tnfr:= 0;
     f_gradf:= f_gradf_sph4;   
     put3d(0,0,1, p1);
     tstepl:= 0.3;                  
     xmin:= -3;  xmax:= 3;         
     ymin:= -3;  ymax:= 3;
     zmin:= -3;  zmax:= 3;
     tnp:= 0;        tnf:= 0;    tnfr:= 0; 
     start_triangulation(p1,f_gradf); 

{triangulation: }
     nearpointtest:= true;
     triangulation(nearpointtest);

     writeln('tfrontnp: ',tfrontnp,' fullcount: ',fullcount,' tnf: ',
             tnf,' n_triang: ',n_triang);
     writeln;
     writeln('tnp: ',tnp,'   tnf: ',tnf);  
     writeln;

{tri --> hiddenl.:}
     for i:= 1 to tnp do p[np+i]:= tpoint[i].p;
     for i:= 1 to tnf do 
         with face[nf+i] do 
              begin 
              npf:= 3; 
              with tface[i] do 
	      begin fp[1]:= np+p1; fp[2]:= np+p2; fp[3]:= np+p3;  end;
	      end; 
     np:=np+tnp;  nf:= nf+tnf;
     aux_polyhedron;   
     writeln('np: ',np);  writeln('nf: ',nf); writeln('ne: ',ne); 
     for i:= ne0+1 to ne do
	  with edge[i] do begin color:=blue; linew:=1; end;
      ne0:= ne;

{--------------------------------}
      
{4.torus: with start hexagon}
     for i:= 1 to tnpmax do tpoint[i].full:= false;     
     tnp:= 0;        tnf:= 0;    tnfr:= 0;
     f_gradf:= f_gradf_tor; r_tor:= 8.5; a_tor:= 1;   
{     cuttype:= 1; xcut:= 0;  ycut:= 0; rcut_square:= sqr(r_tor);}
     put3d(0,6,0, p1);
     tstepl:= 0.45;                  
     xmin:= -10;  xmax:= 10;         
     ymin:= -10;  ymax:= 10;
     zmin:= -3;  zmax:= 3;
     start_triangulation(p1,f_gradf); 

{triangulation: }
     nearpointtest:= true;
     triangulation(nearpointtest);

     writeln('tfrontnp: ',tfrontnp,' fullcount: ',fullcount,' tnf: ',
             tnf,' n_triang: ',n_triang);
     writeln;
     writeln('tnp: ',tnp,'   tnf: ',tnf);  
     writeln;

{tri --> hiddenl.:}
     for i:= 1 to tnp do p[np+i]:= tpoint[i].p;
     for i:= 1 to tnf do 
         with face[nf+i] do 
              begin 
              npf:= 3; 
              with tface[i] do 
	      begin fp[1]:= np+p1; fp[2]:= np+p2; fp[3]:= np+p3;  end;
	      end; 
     np:=np+tnp;  nf:= nf+tnf;
     aux_polyhedron;   
     writeln('np: ',np);  writeln('nf: ',nf); writeln('ne: ',ne); 
     for i:= ne0+1 to ne do
	  with edge[i] do begin color:=green; linew:=1; end;
      ne0:= ne;

{--------------------------------}
      
{5. cylinder: with QUADRANGLES}
     x3:= -2; y3:= 5; r3:= 2;
     n1:= 40;    n2:= 10;
     u1:= 0;     u2:= pi2;
     v1:=-2;     v2:= 5;
     du:= (u2-u1)/n1;     dv:= (v2-v1)/(n2-1);
     v:= v1;
     for k:= 1 to n2 do
         begin
         u:= u1;
         for i:= 1 to n1 do
             begin
             ik:=i + (k-1)*n1;
             put3d(x3+r3*cos(u),y3+r3*sin(u),v,  p[np+ik]);
             u:= u+du;
             end;
         v:= v+dv;
         end;
     aux_cylinder(n1,n2,np,ne,nf);
     for i:= ne0+1 to ne do
	  with edge[i] do begin color:=cyan; linew:=1; end;
      ne0:= ne;
	
{--------------------------------------------------------------------}
     repeat
     init_centralparallel_projection(2);

{ for drawing : }
     draw_area(250,250,120,120,10); 

{hiddenline:}
     oriented_faces:= false;   is_permitted:= true;    newstyles:= true;
     cp_lines_before_convex_faces(oriented_faces,is_permitted,newstyles);
  
     draw_end;        writeln ;
 
     writeln('Another projection?  (yes: 1, no: 0)');
     readln(ipro);
     until ipro=0;

   writeln('Run again ?  (yes: 1, no: 0)');
   readln(ianf);
   until ianf=0;

   graph_off;
 end.









