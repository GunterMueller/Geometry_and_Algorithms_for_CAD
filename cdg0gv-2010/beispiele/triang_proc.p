
(*

{***************************************************}
{*********  P R O C E D U R E S  ON VECTORS  *******}
{***************************************************}

const array_size = 20000; 
      pi= 3.14159265358;       pi2= 6.2831853;       pih= 1.5707963;
      eps8=0.00000001;

type  vt3d    = record  x: real;  y: real;  z: real; end;
      vts3d   = array[0..array_size] of vt3d;
{***************************************************}

function max(a,b : real) : real;
 begin   if a>=b then  max:= a   else   max:= b;   end; {max}
{*************}
function min(a,b : real) : real;
 begin   if a<=b then  min:= a   else   min:= b;   end; {min}
{*************}

procedure put3d(x,y,z : real; var v: vt3d);
 begin   v.x:= x;  v.y:= y;  v.z:= z;   end;
{*************}

procedure get3d(v : vt3d; var x,y,z: real);
 begin  x:= v.x;  y:= v.y;  z:= v.z;  end;
{*************}

procedure scale3d(r : real; v: vt3d; var vs: vt3d);
 begin   vs.x:= r*v.x;  vs.y:= r*v.y;  vs.z:= r*v.z;  end;
{*************}

procedure sum3d(v1,v2 : vt3d; var vs : vt3d);
 begin vs.x:= v1.x + v2.x;  vs.y:= v1.y + v2.y;  vs.z:= v1.z + v2.z; end;
{*************}

procedure diff3d(v1,v2 : vt3d; var vs : vt3d);
 begin vs.x:= v1.x - v2.x;  vs.y:= v1.y - v2.y;  vs.z:= v1.z - v2.z; end;
{*************}

procedure lcomb2vt3d(r1: real; v1: vt3d; r2: real; v2: vt3d; var vlc : vt3d);
 begin
 vlc.x:= r1*v1.x + r2*v2.x; vlc.y:= r1*v1.y + r2*v2.y; vlc.z:= r1*v1.z + r2*v2.z;
 end;
{*************}

procedure lcomb3vt3d(r1: real; v1: vt3d; r2: real; v2: vt3d;
                                          r3: real; v3: vt3d; var vlc : vt3d);
 begin
   vlc.x:= r1*v1.x + r2*v2.x + r3*v3.x;
   vlc.y:= r1*v1.y + r2*v2.y + r3*v3.y;
   vlc.z:= r1*v1.z + r2*v2.z + r3*v3.z;
 end;
{*************}

function abs3d(v : vt3d) : real;
 begin  abs3d:= abs(v.x) + abs(v.y) + abs(v.z);  end;
{*************}
function length3d(v : vt3d) : real;
 begin  length3d:= sqrt( sqr(v.x) + sqr(v.y) + sqr(v.z));  end;
{*************}
procedure normalize3d(var p: vt3d);
var c : real;
begin c:= 1/length3d(p); p.x:= c*p.x; p.y:= c*p.y; p.z:= c*p.z  end;
{************}
function scalarp3d(p1,p2 : vt3d) : real;
 begin  scalarp3d:= p1.x*p2.x + p1.y*p2.y + p1.z*p2.z;  end;
{*************}
function distance3d(p,q : vt3d): real;
begin  distance3d:= sqrt( sqr(p.x-q.x) + sqr(p.y-q.y) + sqr(p.z-q.z) );  end;
{*************}
function distance3d_square(p,q : vt3d) : real;
begin distance3d_square:= sqr(p.x-q.x) + sqr(p.y-q.y) + sqr(p.z-q.z);  end;
{**************}

procedure vectorp(v1,v2 : vt3d; var vp : vt3d);
{vectorproduct of v1,v2}
 begin
   vp.x:=  v1.y*v2.z - v1.z*v2.y ;
   vp.y:= -v1.x*v2.z + v2.x*v1.z ;
   vp.z:=  v1.x*v2.y - v2.x*v1.y ;
 end; {vectorp}
{*************}

function determ3d(v1,v2,v3: vt3d) : real;
{determinant of 3 vectors.}
 begin
   determ3d:= v1.x*v2.y*v3.z + v1.y*v2.z*v3.x + v1.z*v2.x*v3.y
            - v1.z*v2.y*v3.x - v1.x*v2.z*v3.y - v1.y*v2.x*v3.z;
 end; {determ3d}
{*************}

procedure rotorz(cos_rota,sin_rota : real; p : vt3d; var pr: vt3d);
 begin
   pr.x:= p.x*cos_rota - p.y*sin_rota;
   pr.y:= p.x*sin_rota + p.y*cos_rota;    pr.z:= p.z;
 end; {rotorz}
{*************}

function polar_angle(x,y : real) : real;
 {determines the polar angle of point (x,y)}
 var w : real;
 begin
   if (x=0) and (y=0) then   w:= 0
     else
      begin
        if abs(y)<=abs(x) then
           begin
             w:= arctan(y/x);
             if x<0 then  w:=pi+w
                else  if (y<0) and( w<>0) then  w:= pi2+w;
           end
          else
           begin
             w:= pih-arctan(x/y);
             if y<0 then w:= pi+w;
           end; {if}
      end;  {if}
    polar_angle:= w;
 end;  { polar_angle }
{******************}

procedure newcoordinates3d(p,b0,b1,b2,b3: vt3d; var pnew: vt3d);
{determines the coordinates of p for the basis b1,b2,b3 with origin b0.}
var det : real;   p0: vt3d;
begin
  diff3d(p,b0, p0);              det:= determ3d(b1,b2,b3);
  pnew.x:= determ3d(p0,b2,b3)/det;
  pnew.y:= determ3d(b1,p0,b3)/det;
  pnew.z:= determ3d(b1,b2,p0)/det;
end;  { newcoordinates3d }  
{************}

*)

{*******************************************************************************}

{**********************************************}
{********** T R I A N G U L A T I O N : *******}     
{**********************************************}

(*
{for triangulation:}
const tnfmax=10000; tnemax=20000; tnpmax=10000; 
      tfrnpmax= 500;  {max. number of points in a front}  
      tnfrmax=20;     {max. number of further fronts.}*)

type
(*      implicit3d = procedure(p: vt3d; var fvalue: real; var gradf: vt3d);*)

      tface_dat = record
                  p1,p2,p3: integer;        {points of a triangle}
                  end;
      tpoint_dat= record
                  p,nv,tv1,tv2 : vt3d;      {coordinates, normal,tangentvectors}
		     full,achange: boolean; {full=true: point surrounded by triang.} 
		     angle: real;           {achange=true: angle was changed}
                  end;
var
      tface : array[1..tnfmax] of tface_dat;
      tpoint: array[1..tnpmax] of tpoint_dat;           
      tfrontpt: array[1..tfrnpmax] of integer; {points in actual front polygon}  
      tfrontnp: integer;     {number of front points} 
      tfr : array[0..tnfrmax,0..tfrnpmax] of integer;   {further fronts} 
      tfrbox : array[0..tnfrmax,1..6] of real; 
      tnp,tne,tnf,tnfr : integer;  {number of points, edges, triangles, fronts}
      tstepl,tstepl_square,xmin,xmax,ymin,ymax,zmin,zmax,minangle : real;
      n_triang,fullcount,frontnumber: integer;
      f_gradf : implicit3d;
      actual_ip : integer;
      nearpointtest : boolean;
      cuttype : integer;
      xcut,ycut,zcut,rcut,rcut_square: real;
{*****************************************}
procedure quader(xmin,xmax,ymin,ymax,zmin,zmax: real);
var p1,p2,p3,p4,p5,p6,p7,p8: vt3d;
begin
  put3d(xmin,ymin,zmin, p1);
  put3d(xmax,ymin,zmin, p2);
  put3d(xmax,ymax,zmin, p3);
  put3d(xmin,ymax,zmin, p4);
  put3d(xmin,ymin,zmax, p5);
  put3d(xmax,ymin,zmax, p6);
  put3d(xmax,ymax,zmax, p7);
  put3d(xmin,ymax,zmax, p8);
  cp_line(p1,p2,0);  cp_line(p2,p3,0);  cp_line(p3,p4,0);  cp_line(p4,p1,0);
  cp_line(p5,p6,0);  cp_line(p6,p7,0);  cp_line(p7,p8,0);  cp_line(p8,p5,0);
  cp_line(p1,p5,0);  cp_line(p2,p6,0);  cp_line(p3,p7,0);  cp_line(p4,p8,0);
end;  
{***************************************************************************}


procedure insert_point(ip_new,i_new: integer);
{inserts point ip_new as i_new-th front point}
var i : integer;
begin
  for i:= tfrontnp+1 downto i_new do tfrontpt[i+1]:=  tfrontpt[i];
  tfrontpt[i_new]:= ip_new; 
  tfrontnp:= tfrontnp+1;
end;
{******} 
procedure delete_point(i_del: integer);
{deletes i_del-th front point}
var i : integer;
begin
  tfrontnp:= tfrontnp-1;
  for i:= i_del to tfrontnp+1 do tfrontpt[i]:=  tfrontpt[i+1];
end;
{******} 

function  point_ok_box(p: vt3d): boolean;
{point p in bounding box ?}
begin
   with p do
      if ((x<=xmax) and (x>=xmin) and 
	  (y<=ymax) and (y>=ymin) and 
	  (z<=zmax) and (z>=zmin)) then point_ok_box:= true
	                           else point_ok_box:= false;
end;
{*****}
procedure cut_seg_box(p0,p: vt3d; var pc: vt3d);
{cuts new edge p0-p at bounding box -> p0-pc}
var dv: vt3d; x0,y0,z0,t: real;
begin
   diff3d(p,p0, dv);  t:= 1;  get3d(p0, x0,y0,z0);
   with dv do
          begin 
	     if x>0 then t:= min(t,(xmax-x0)/x) else t:= min(t,(xmin-x0)/x);
	     if y>0 then t:= min(t,(ymax-y0)/y) else t:= min(t,(ymin-y0)/y); 
	     if z>0 then t:= min(t,(zmax-z0)/z) else t:= min(t,(zmin-z0)/z);
	  end; 
 lcomb2vt3d(1,p0,t,dv, pc); 
end;
{******}     

function point_ok_cyl(p: vt3d): boolean;
{point p in bounding box ?}
begin
   with p do
	if (z<=zmax) and (z>=zmin) and (sqr(x-xcut)+sqr(y-ycut)< rcut_square)
	   then point_ok_cyl:= true
	   else point_ok_cyl:= false;
end;
{*****}
procedure cut_seg_cyl(p0,p: vt3d; var pc: vt3d);
{cuts new edge p0-p at bounding cylinder -> p0-pc}
var dv: vt3d; t,x0,y0,z0,a,b,d2: real;
begin
   diff3d(p,p0, dv);  t:= 1;  get3d(p0, x0,y0,z0);
   with dv do
          begin 
	  if z>0 then t:= min(t,(zmax-z0)/z) else t:= min(t,(zmin-z0)/z);
          d2:=x*x+y*y;
          if d2>0 then
             begin
             x0:= p0.x-xcut;  y0:=p0.y-ycut;   
             a:= (x0*x+y0*y)/d2;  b:= (x0*x0+y0*y0-rcut_square)/d2;
             t:= min(t,-a+sqrt(a*a-b)); 
             end;
	  end; 
   lcomb2vt3d(1,p0,t,dv, pc); 
end;
{******}  
function point_ok_sph(p: vt3d): boolean;
{point p in bounding sphere ?}
begin
   with p do
	if (sqr(x-xcut)+sqr(y-ycut)+sqr(z-zcut)< rcut_square)
	   then point_ok_sph:= true
	   else point_ok_sph:= false;
end;
{*****}
procedure cut_seg_sph(p0,p: vt3d; var pc: vt3d);
{cuts new edge p0-p at bounding sphere -> p0-pc}
var dv: vt3d; t,x0,y0,z0,a,b,d2: real;
begin
   diff3d(p,p0, dv);  t:= 1;  get3d(p0, x0,y0,z0);
   with dv do
          begin 
          d2:=x*x+y*y+z*z;
          if d2>0 then
             begin
	     x0:= p0.x-xcut;  y0:=p0.y-ycut; z0:= p0.z-zcut;
             a:= (x0*x+y0*y+z0*z)/d2;
	     b:= (x0*x0+y0*y0+z0*z0-rcut_square)/d2;
             t:= min(t,-a+sqrt(a*a-b)); 
             end;
	  end; 
   lcomb2vt3d(1,p0,t,dv, pc); 
end;
{******}  

function point_ok(p: vt3d): boolean;
{point p in bounding box or cylinder}
begin
  if cuttype=1 then
     point_ok:= point_ok_cyl(p)
  else if cuttype=2 then point_ok:= point_ok_sph(p)
                    else point_ok:= point_ok_box(p);
end;
{*****}
procedure cut_seg(p0,p: vt3d; var pc: vt3d);
{cuts new edge p0-p at bounding box or cylinder -> p0-pc}
begin
  if cuttype=1 then cut_seg_cyl(p0,p, pc)
  else if cuttype=2 then cut_seg_sph(p0,p, pc)
                    else cut_seg_box(p0,p, pc);
end;
{******}  

procedure surface_point_normal_tangentvts(p_start : vt3d;
                                          f_gradf : implicit3d;  
                                  var p,nv,tv1,tv2: vt3d);
{***}
procedure surface_point(p0 : vt3d; var p_surface,nv : vt3d);
{seeks surface point along the steepest way}
 var delta,fi : real;   p_i,p_i1,dv,gradfi : vt3d;  
{**}
procedure newton_step(p_i : vt3d; var p_i1 : vt3d);
 var  t,cc : real;  
 begin
   f_gradf(p_i, fi,gradfi);
   cc:= scalarp3d(gradfi,gradfi);
    if cc>1E-15{eps8} then t:= -fi/cc
    else
    begin t:= 0; writeln(cc,' WARNING tri (surface_point...): newton');
       new_color(lightred);  cp_point(p_i, 1); new_color(default); end;
   lcomb2vt3d(1,p_i, t,gradfi, p_i1);
 end;
{**}
 begin {surface_point}
   p_i:= p0;      
   repeat
     newton_step(p_i, p_i1);     diff3d(p_i1,p_i, dv);
     delta:= abs3d(dv);
     p_i:= p_i1;
   until delta < eps8;
   p_surface:= p_i1; nv:= gradfi;  
 end;   { surface_point }
{***}
begin
  surface_point(p_start, p,nv);
  normalize3d(nv);
  with nv do if (abs(x)>0.5) or (abs(y)>0.5) then put3d(y,-x,0, tv1)
                                             else put3d(-z,0,x, tv1);
  normalize3d(tv1);  vectorp(nv,tv1, tv2);  {nv,tv1,tv2: ON-base} 
end;  {surface_point_normal_tangentvts}
{****}

procedure start_triangulation(p_start: vt3d; f_gradf: implicit3d);
{calculates from p_start the first surface point p[1] and the first six triangles}
var p0,p1,nv0,tv10,tv20 : vt3d;    i,tnp0 : integer;   dw,cw,sw : real;
begin
  tnp:= tnp+1; 
  surface_point_normal_tangentvts(p_start,f_gradf,p0,nv0,tv10,tv20);
  if not point_ok(p0) then
  begin writeln('!!! First point not in bounding box or cylinder !!!');
	n_triang:= 0;  exit;
     end; 
  with tpoint[tnp] do 
  begin p:= p0;  nv:= nv0;  tv1:= tv10;  tv2:= tv20;  end;
  tnp0:= tnp;
  for i:= 0 to 5 do
      begin
      dw:= pi/3; cw:= cos(i*dw);  sw:= sin(i*dw);
      lcomb3vt3d(1,p0,tstepl*cw,tv10,tstepl*sw,tv20, p1);
      tnp:= tnp +1;  tfrontpt[i+1]:= tnp;  
      with tpoint[tnp] do
           begin 
           surface_point_normal_tangentvts(p1,f_gradf, p,nv,tv1,tv2);
           achange:= true;
           end;
      end;   { for }
  tfrontnp:= 6;   tpoint[1].full:= true;
  for i:= 1 to 6 do   {triangles}
      begin
      tnf:= tnf+1;                 
      with tface[tnf] do begin p1:= tnp0; p2:= tnp0+i; p3:= tnp0+i+1; end;
      end; 
  tface[tnf].p3:= tnp0+1;       
end;  
{********}  
procedure new_triangle(q1,q2,q3: integer);
begin
  tnf:= tnf+1;
  with tface[tnf] do begin p1:= q1; p2:= q2; p3:= q3; end;
end;   
{****}
function reduce(n: integer): integer;
begin
  reduce:= n;
  if n<1        then reduce:= n+tfrontnp;
  if n>tfrontnp then reduce:= n-tfrontnp;
end;
{****}

procedure make_angle(ipf: integer);
{calculates the front angle at ipf-th front point}
var pn1,pn2,pn11,pn22 : vt3d;    ip,ip1,ip2 : integer;    w1,w2: real; 
begin
  ip:=  tfrontpt[ipf];    
  with tpoint[ip] do
       if (full or (not achange) ) then exit
          else
           begin
	   ip1:= tfrontpt[reduce(ipf-1)];  
           ip2:= tfrontpt[reduce(ipf+1)];  
           pn1:= tpoint[ip1].p;  newcoordinates3d(pn1,p,tv1,tv2,nv, pn11);  
           pn2:= tpoint[ip2].p;  newcoordinates3d(pn2,p,tv1,tv2,nv, pn22); 
           w1:= polar_angle(pn11.x,pn11.y);    
           w2:= polar_angle(pn22.x,pn22.y);     if w2<w1 then w2:= w2+pi2;
           angle:= w2-w1;   achange:= false;
           end;
end;  
{****}

function fangle(ipf: integer): real;
{calculates the front angle at ipf-th front point}
var pn1,pn2,pn11,pn22 : vt3d;    ip,ip1,ip2 : integer;    w1,w2: real; 
begin
  ip:=  tfrontpt[ipf];    
  with tpoint[ip] do
       begin
       ip1:= tfrontpt[reduce(ipf-1)]; 
       ip2:= tfrontpt[reduce(ipf+1)];  
       pn1:= tpoint[ip1].p;  newcoordinates3d(pn1,p,tv1,tv2,nv, pn11);  
       pn2:= tpoint[ip2].p;  newcoordinates3d(pn2,p,tv1,tv2,nv, pn22); 
       w1:= polar_angle(pn11.x,pn11.y);    
       w2:= polar_angle(pn22.x,pn22.y);     if w2<w1 then w2:= w2+pi2;
       fangle:= w2-w1; 
       end;
end;  
{****}

function outside(ip0,ip1,iptest: integer): boolean;
{is point p[iptest] in not triangulated region at point p[ip0] ?}
var pn1,pn11,ptest,ptestt: vt3d;  w1,wtest: real; 
begin
  with tpoint[ip0] do
       begin
       pn1:= tpoint[ip1].p;       newcoordinates3d(pn1,p,tv1,tv2,nv, pn11);  
       ptest:= tpoint[iptest].p;  newcoordinates3d(ptest,p,tv1,tv2,nv, ptestt); 
       w1:= polar_angle(pn11.x,pn11.y);    
       wtest:= polar_angle(ptestt.x,ptestt.y);     
       if wtest<w1 then wtest:= wtest+pi2;
       if wtest<w1+angle then outside:= true else outside:= false; 
       end;
end;   
{********}  

procedure test_criticalpt(ipf: integer; var ipf_nearp: integer);
{seeks another front point near to ipf-th front point}
label 10;
var i,k,ip,ip1,ip2,ip11,ip22,ip111,ip222,ipi,nn: integer;    p0: vt3d;
begin
  ip:= tfrontpt[ipf];                ipf_nearp:= -1;    
  with tpoint[ip] do if full then exit else p0:= p; 
  if ipf<3 then nn:= tfrontnp-3+ipf else nn:= tfrontnp;
  {tests only front points i>ipf+3 ! important for divide_front}     
  for i:= ipf+3 to nn do
      begin               {ipi not neighbor or neighbor of neighbors} 
      ipi:= tfrontpt[i];     
      with tpoint[ipi] do 
           if not full then 
              if abs(p0.x-p.x)<tstepl then
                 if abs(p0.y-p.y)<tstepl then
                    if abs(p0.z-p.z)<tstepl then    
                       if distance3d_square(p0,p) < tstepl_square then 
                          begin 
                          if not outside(ip,tfrontpt[reduce(ipf-1)],ipi) 
                                                               then goto 10;
        		  if scalarp3d(tpoint[ip].nv,tpoint[ipi].nv)<0
			                                       then goto 10;
                          ipf_nearp:= i;   exit; 
                          end; { if }
10:   end;  { for }          
end;  { test_criticalpt }
{*********}

procedure find_pair_of_nearpts(var ipf,ipf_nearp,frontnumber: integer);
{seeks a nearpoint to a front point}
label 10;
var i1,i2,i,k,j,l,ip,ipj,inp,tfrontnpi: integer;   p0: vt3d; 
begin
  ipf:= 0;  ipf_nearp:= -1;  frontnumber:= 0;
  for i:= 1 to tfrontnp  do 
        begin 
        test_criticalpt(i,inp);  
        if inp>0 then 
           begin ipf:= i; ipf_nearp:= inp; frontnumber:= 0; exit; end;  
        end;
  for i:= 1 to tnfr do
      begin
      tfrontnpi:= tfr[i,0];       
      for k:= 1 to tfrontnp do
          begin
          ip:=  tfrontpt[k];  
          with tpoint[ip] do if full then goto 10 else p0:= p;   
          for j:= 1 to tfrontnpi do
              begin 
              ipj:= tfr[i,j];     
              with tpoint[ipj] do 
                   if abs(p0.x-p.x)<tstepl then
                      if abs(p0.y-p.y)<tstepl then
                         if abs(p0.z-p.z)<tstepl then 
                            if distance3d_square(p0,p) < tstepl_square then 
                               if outside(ip,tfrontpt[reduce(k-1)],ipj) then 
                                   begin
                                   frontnumber:= i;  ipf:= k;  ipf_nearp:= j;       
                                   exit; 
                                   end;
              end;  { for j }                 
10:	  end;  { for k }
      end;   { for i }                
end;                    
{**************}

function minanglept: integer;
{determines the front point with minimal front angle.}
var  i,imin: integer; min: real;
begin
  min:= 10; 
  for i:= 1 to tfrontnp do with tpoint[tfrontpt[i]] do
      if ((not full) and (angle<min)) 
         then begin min:= angle; imin:= i; end;
  if min<10 then begin minanglept:= imin; minangle:= min; end 
            else minanglept:= -1;      
end;
{****}

procedure complete_point(ipf: integer; f_gradf: implicit3d);
{determines for ipf-th front point the missing triangles}
var p0,nv0,tv10,tv20,pn1,pn2,pn0,p_start,pc_start,pn11,pn22 : vt3d;    
    i,ip,ip1,ip2,ipf1,ipf2,ne_rest : integer;      dw,cdw,sdw: real; 
begin
  if tfrontnp<=3 then exit;
  ip:= tfrontpt[ipf];
  actual_ip:= ip;   {global var. for start parameters of footpoint algorithms}
  with tpoint[ip] do
       begin 
       if full then exit;
       ipf1:= reduce(ipf-1);  ipf2:= reduce(ipf+1);
       ip1:= tfrontpt[ipf1];  ip2:= tfrontpt[ipf2];  
       pn1:= tpoint[ip1].p;  newcoordinates3d(pn1,p,tv1,tv2,nv, pn11);  
       pn11.z:=0; normalize3d(pn11);  scale3d(tstepl,pn11, pn11);
       pn2:= tpoint[ip2].p;  newcoordinates3d(pn2,p,tv1,tv2,nv, pn22); 
       if achange then angle:=fangle(ipf);
       ne_rest:= trunc(angle*3/pi);
       dw:= angle/(ne_rest+1);   
       if (dw<0.8) and (ne_rest>0) 
          then begin ne_rest:= ne_rest-1;  dw:= angle/(ne_rest+1); end;
       if (ne_rest=0) and (dw>0.8) and (distance3d(pn1,pn2)>1.25*tstepl) then 
           begin ne_rest:= 1;  dw:= dw/2; end;       
       p0:= p; nv0:= nv; tv10:= tv1; tv20:= tv2; 
       end;  
  if ((distance3d_square(p0,pn1)<0.2*tstepl_square) or    
      (distance3d_square(p0,pn2)<0.2*tstepl_square))  then ne_rest:=0;  
  if ne_rest=0 
     then new_triangle(ip1,ip2,ip)
     else   
     for i:= 1 to ne_rest do
         begin
         cdw:= cos(dw);  sdw:= sin(dw);
         rotorz(cdw,sdw,pn11, pn11);
         lcomb3vt3d(1,p0,pn11.x,tv10,pn11.y,tv20, p_start);
         tnp:= tnp +1;  
	 if point_ok(p_start)
	    then begin tpoint[tnp].full:= false; pc_start:=p_start; end
            else begin tpoint[tnp].full:= true; cut_seg(p0,p_start, pc_start); end;
         with tpoint[tnp] do
              begin                           
              surface_point_normal_tangentvts(pc_start,f_gradf, p,nv,tv1,tv2);
	      if scalarp3d(nv,tpoint[ip].nv)<0 then  {change if necessary (SING.)}
                                  begin scale3d(-1,nv,nv); change3d(tv1,tv2); end;
	      achange:= true;
              end;
         if i=1 then new_triangle(ip1,tnp,ip); 
         if i=ne_rest then new_triangle(tnp,ip2,ip) 
                      else new_triangle(tnp,tnp+1,ip);
         end;   { for }
  delete_point(ipf);      
  for i:= 0 to ne_rest-1 do insert_point(tnp-i,ipf);
  tpoint[ip1].achange:= true;  tpoint[ip2].achange:= true;
end;  
{********}  

procedure divide_front(ipf1,ipf2: integer);
var i,nn: integer;   fa1,fa2: real;  
begin 
  tnfr:= tnfr+1;
  with tpoint[tfrontpt[ipf1]] do achange:= true; 
  with tpoint[tfrontpt[ipf2]] do achange:= true; 
  for i:= 0 to ipf2-ipf1 do tfr[tnfr,i+1]:= tfrontpt[ipf1+i];    
  for i:=1 to tfrontnp-ipf2+1 do tfrontpt[ipf1+i]:= tfrontpt[ipf2+i-1];
  tfrontnp:= tfrontnp-(ipf2-ipf1-1);
  tfr[tnfr,0]:=  ipf2-ipf1+1;
  fa1:= fangle(ipf1); fa2:= fangle(ipf1+1);  
  if fa1<fa2 then begin nn:= tfrontnp; 
                        complete_point(ipf1  ,f_gradf);  
                        complete_point(ipf1+tfrontnp-nn+1  ,f_gradf); end
             else begin complete_point(ipf1+1,f_gradf); 
                        complete_point(ipf1  ,f_gradf); end;
end; 
{***********}

procedure unite_front(ipf1,ipf2,frontnumber: integer);
{unites the actual front polygon with a further front (frontnumber)}
var i,ipf,tfrontnpi,nn: integer;   fa1,fa2: real;
begin
  tfrontnpi:=  tfr[frontnumber,0];
  for i:= 1 to tfrontnpi do 
      begin
      ipf:= ipf2+i-1;
      if ipf>tfrontnpi then ipf:= ipf-tfrontnpi; 
      insert_point(tfr[frontnumber,ipf],ipf1+i);
      end;
  insert_point(tfrontpt[ipf1+1],ipf1+tfrontnpi+1);
  insert_point(tfrontpt[ipf1],ipf1+tfrontnpi+2);
  for i:= 0 to tfr[tnfr,0] do tfr[frontnumber,i]:= tfr[tnfr,i];
  tnfr:= tnfr-1;
  with tpoint[tfrontpt[ipf1]] do 
       begin achange:= true; full:= false; end;
  with tpoint[tfrontpt[ipf1+1]] do 
       begin achange:= true; full:= false; end;
  fa1:= fangle(ipf1); fa2:= fangle(ipf1+1);  
  if fa1<fa2 then begin nn:= tfrontnp; 
                        complete_point(ipf1  ,f_gradf);  
                        complete_point(ipf1+tfrontnp-nn+1  ,f_gradf); end
             else begin complete_point(ipf1+1,f_gradf); 
                        complete_point(ipf1  ,f_gradf); end;
end;  { unite_front }    
{*******}

procedure triangulation(nearpointtest : boolean);
var i,k,ipi1,ipi2,ipf,ipf1,ipf2,delay: integer;
begin       
{Box-Tests:}
  for i:= 1 to tfrontnp do
      if not point_ok(tpoint[tfrontpt[i]].p) then
          begin writeln('!!! STARTING front points NOT in bounding BOX !!!');
          quader(xmin,xmax,ymin,ymax,zmin,zmax);
	     new_linewidth(10); cp_point(tpoint[tfrontpt[i]].p,0); new_linewidth(1); 
          n_triang:= 0;  exit;
          end;
  for k:= 1 to tnfr do 
  for i:= 1 to tfr[k,0] do 
      if not point_ok( tpoint[tfr[k,i]].p) then
          begin writeln('!!! BOUNDARY points NOT in bounding BOX !!!');
          quader(xmin,xmax,ymin,ymax,zmin,zmax);
	  new_linewidth(10); cp_point(tpoint[tfr[k,i]].p,0); new_linewidth(1);
          n_triang:= 0;  exit;
          end; 
  writeln('**********************************'); 
   if nearpointtest then writeln('triang.: nearpoint test is ON !');
   if cuttype=1 then writeln('triang.: bounded by CYLINDER ')
       else if cuttype=2 then writeln('triang.: bounded by SPHERE ')
                         else writeln('triang.: bounded by a BOX');
  writeln('**********************************'); 
  tstepl_square:= tstepl*tstepl; fullcount:= 0;
  while (tnfr>=0) and (tnf<n_triang) and (fullcount<tfrontnp) do
        begin 
	   fullcount:= 0;  delay:= 0;   minangle:= 0;
        while (tnf<n_triang) and (fullcount<tfrontnp) and (tfrontnp>3)  do   
	      begin             
	      if ((not nearpointtest) or (tfrontnp<10) or (minangle<1.5))
                   then delay:= 1;
              if delay=0 then find_pair_of_nearpts(ipf1,ipf2,frontnumber)
		         else begin delay:= delay-1; ipf2:= -1; end;		   
              if ipf2>0 then
                   begin
                   ipi1:= tfrontpt[ipf1];
                   if frontnumber=0 then  ipi2:= tfrontpt[ipf2]
                                    else  ipi2:= tfr[frontnumber,ipf2];
                   delay:= 0;
		   writeln('triangles: ',tnf,'  NEARPOINTS detected: ',ipi1,' +++ ',ipi2);
                   if frontnumber=0 then divide_front(ipf1,ipf2); 
                   if frontnumber>0 then unite_front(ipf1,ipf2,frontnumber);
                   end;
             for i:= 1 to tfrontnp do make_angle(i); 
             ipf:= minanglept;   
             if ipf>0 then complete_point(ipf,f_gradf);
             for i:= 1 to tfrontnp do make_angle(i); 
	     ipf:= minanglept; {renews minangle for "if ....(minangle<..)" above !!}
             fullcount:= 0;      
             for i:= 1 to tfrontnp do  
                 with tpoint[tfrontpt[i]] do if full then fullcount:= fullcount+1;
             end;  { while }
             
        if tfrontnp=3 then 
           begin
           new_triangle(tfrontpt[1],tfrontpt[2],tfrontpt[3]);
           tfrontnp:= 0;
           end;
        if ((tfrontnp=0) or (fullcount=tfrontnp)) and (tnfr>0) then 
           begin
           tfrontnp:= tfr[tnfr,0];  
           for i:=1 to tfrontnp do 
               begin
               tfrontpt[i]:= tfr[tnfr,i];
               with tpoint[tfrontpt[i]] do achange:= true;
               end;
           tnfr:= tnfr-1;   fullcount:=0;   writeln('tnfr: ',tnfr);   
           end;
	end;  { while }
  writeln('*****************************************************'); 
  writeln('triang.: total number of triangels: ', tnf);  
  writeln('triang.: remaining front points: ', tfrontnp);  
  writeln('triang.: remaining fronts: ', tnfr);  
  writeln('*****************************************************'); 
   if tnf>tnfmax then writeln('triang. warning: tnfmax to small !!!');
   if tnp>tnpmax then writeln('triang. warning: tnpmax to small !!!');
   if tfrontnp>tfrnpmax  then writeln('triang. warning: tfrnpmax to small !!!');
   if tnfr>tnfrmax  then writeln('triang. warning: tnfrmax to small !!!');
end;   { triangulation }
{*************************************************************}

