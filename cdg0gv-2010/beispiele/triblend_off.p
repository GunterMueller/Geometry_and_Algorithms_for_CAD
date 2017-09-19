program triexample;
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
var   i,ipro,ianf    : integer;
      oriented_faces : boolean;
      mue,dw,r_sph   : real;
      p1	     : vt3d;

{****************}
{$i triang_proc.p}   
{****************}

{###################################################################}
{****  auxiliary procs for generating OFFfiles used for GEOMVIEW ***}
{*******************************************************************}

{*****}
var offdatei : text;
{*****}
   
procedure open_offdatei;
{ for OFF-file }
 var  datei : string;
 begin
   writeln('name of OFF-File ? (... .off)');
   readln(datei);
   assign(offdatei,datei);
   rewrite(offdatei);
 end; { open_offdatei }
{*************}

procedure close_offdatei;
 begin
   Close(offdatei);
 end;
{************}

procedure write_nangles_to_offfile;
var i,k : integer;
begin
 open_offdatei;
 writeln(offdatei, 'OFF');
 writeln(offdatei,np,' ',nf,' ',0);
 for i:= 1 to np do with p[i] do
           writeln(offdatei,'   ',x:3:5,' ',y:3:5,' ',z:3:5);
 for i:= 1 to nf do
    with face[i] do
         begin
         write(offdatei,npf,'  ');
         for k:= 1 to npf do write(offdatei,fp[k]-1,' ');
         writeln(offdatei,' ');
	 end;   
 close_offdatei;
end;  { write_nangles_to_offdatei }
{#####################################################################}

procedure f_gradf_blend3cy(p: vt3d; var f: real; var gradf: vt3d); 
{Blending 3 cylinders by parabol. funct. splines}
var c1,c2,c3,fk: real;
begin
  with p do 
      begin
      c1:= y*y+z*z-1;        c2:= x*x+z*z-1;        c3:= x*x+y*y-1;
      fk:= 1+sqr(r_sph) - x*x - y*y - z*z;
      f:= (1-mue)*c1*c2*c3-mue*fk*fk*fk;
      gradf.x:= (1-mue)*2*x*c1*(c3 + c2) + 6*mue*x*fk*fk;
      gradf.y:= (1-mue)*2*y*c2*(c3 + c1) + 6*mue*y*fk*fk;
      gradf.z:= (1-mue)*2*z*c3*(c1 + c2) + 6*mue*z*fk*fk;
      end;
end;   
{******}
{*************************************************************}
begin {main program}
   graph_on(0);
   repeat
     writeln('****************************************************');
     writeln('***     Triangulation of an implicit surface    *** ');   
     writeln('***     (blending of 3 cylinders)               *** ');   
     writeln('****************************************************'); 
     writeln;
     writeln('   and generation of a OFF-file for GEOMVIEW        ');  
     writeln('****************************************************');  
     writeln;

{------------------------------------}      
{for triangulation:}
     cuttype:=0; {box}
     {cuttype=1: cylinder, needs xcut,ycut,rcut_square (see proc. cut...)} 
     {cuttype=2: sphere, needs xcut,ycut,zcut,rcut_square (   "         )} 
     for i:= 1 to tnpmax do tpoint[i].full:= false;     
     tnp:= 0;   tnf:= 0;    tnfr:= 0;
       np:=0;    nf:= 0;      ne:= 0;   

     writeln('Number of triangles ?');  readln(n_triang);
     writeln;

{------------------------------------------------------------------------}

{Tringulation of a blend surface of 3 cylinders with bounding box}
     f_gradf:= f_gradf_blend3cy;   mue:= 0.0003;  r_sph:= 3;  
     put3d(1,1,-1, p1);       
     dw:= pi2/30;   tstepl:= dw;  {radii= 1 !!}
     xmin:= -3;  xmax:= 3;         
     ymin:= -3;  ymax:= 3;
     zmin:= -3;  zmax:= 3;
     tnp:= 0;        tnf:= 0;    tnfr:= 0; 
     start_triangulation(p1,f_gradf);

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

{--------------------------------------------------------------------}
     repeat
     init_centralparallel_projection(2);

{drawing : }
     draw_area(250,250,120,120,25); 

{hiddenline:}
     oriented_faces:= false;
     cp_lines_before_convex_faces(oriented_faces,true,false);
  
     draw_end;        writeln ;
 
     writeln('Another projection?  (yes: 1, no: 0)');
     readln(ipro);
     until ipro=0;

   writeln('Run again ?  (yes: 1, no: 0)');
   readln(ianf);
   until ianf=0;

{generates offfile for GEOMVIEW:}
   write_nangles_to_offfile;

   graph_off;
 end.













