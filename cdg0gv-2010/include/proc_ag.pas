{*********************************}
{*********  P R O C _ A G  *******}
{*********************************}

function sign(a : real) : integer;
 begin   if a<0  then  sign:= -1  else  sign:= 1;  end; {sign}
{*************}
function max(a,b : real) : real;
 begin   if a>=b then  max:= a   else   max:= b;   end; {max}
{*************}
function min(a,b : real) : real;
 begin   if a<=b then  min:= a   else   min:= b;   end; {min}
{*************}

procedure put2d(x,y : real; var v: vt2d);
 begin   v.x:= x;  v.y:= y;   end;
{*************}
procedure put3d(x,y,z : real; var v: vt3d);
 begin   v.x:= x;  v.y:= y;  v.z:= z;   end;
{*************}

procedure get3d(v : vt3d; var x,y,z: real);
 begin  x:= v.x;  y:= v.y;  z:= v.z;  end;
{*************}

procedure scale2d(r : real; v: vt2d; var vs: vt2d);
 begin   vs.x:= r*v.x;  vs.y:= r*v.y;  end;
{*************}
procedure scale3d(r : real; v: vt3d; var vs: vt3d);
 begin   vs.x:= r*v.x;  vs.y:= r*v.y;  vs.z:= r*v.z;  end;
{*************}

procedure scaleco2d(r1,r2 : real; v: vt2d; var vs: vt2d);
 begin   vs.x:= r1*v.x;  vs.y:= r2*v.y;  end;
{*************}
procedure scaleco3d(r1,r2,r3 : real; v: vt3d; var vs: vt3d);
 begin   vs.x:= r1*v.x;  vs.y:= r2*v.y;  vs.z:= r3*v.z;  end;
{*************}


procedure sum2d(v1,v2 : vt2d; var vs : vt2d);
 begin  vs.x:= v1.x + v2.x;  vs.y:= v1.y + v2.y; end;
{*************}
procedure sum3d(v1,v2 : vt3d; var vs : vt3d);
 begin vs.x:= v1.x + v2.x;  vs.y:= v1.y + v2.y;  vs.z:= v1.z + v2.z; end;
{*************}

procedure diff2d(v1,v2 : vt2d; var vs : vt2d);
 begin  vs.x:= v1.x - v2.x;   vs.y:= v1.y - v2.y; end;
{*************}
procedure diff3d(v1,v2 : vt3d; var vs : vt3d);
 begin vs.x:= v1.x - v2.x;  vs.y:= v1.y - v2.y;  vs.z:= v1.z - v2.z; end;
{*************}

procedure lcomb2vt2d(r1: real; v1: vt2d; r2: real; v2: vt2d; var vlc : vt2d);
 begin vlc.x:= r1*v1.x + r2*v2.x;  vlc.y:= r1*v1.y + r2*v2.y; end;
{*************}
procedure lcomb2vt3d(r1: real; v1: vt3d; r2: real; v2: vt3d; var vlc : vt3d);
 begin
 vlc.x:= r1*v1.x + r2*v2.x; vlc.y:= r1*v1.y + r2*v2.y; vlc.z:= r1*v1.z + r2*v2.z;
 end;
{*************}

procedure lcomb3vt2d(r1: real; v1: vt2d; r2: real; v2: vt2d;
                                         r3: real; v3: vt2d; var vlc : vt2d);
 begin
   vlc.x:= r1*v1.x + r2*v2.x + r3*v3.x;
   vlc.y:= r1*v1.y + r2*v2.y + r3*v3.y;
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

procedure lcomb4vt3d(r1: real; v1: vt3d; r2: real; v2: vt3d;
                     r3: real; v3: vt3d; r4: real; v4: vt3d; var vlc : vt3d);
 begin
   vlc.x:= r1*v1.x + r2*v2.x + r3*v3.x + r4*v4.x;
   vlc.y:= r1*v1.y + r2*v2.y + r3*v3.y + r4*v4.y;
   vlc.z:= r1*v1.z + r2*v2.z + r3*v3.z + r4*v4.z;
 end;
{*************}

function abs2d(v : vt2d) : real;
 begin  abs2d:= abs(v.x) + abs(v.y);  end;
{*************}
function abs3d(v : vt3d) : real;
 begin  abs3d:= abs(v.x) + abs(v.y) + abs(v.z);  end;
{*************}

function length2d(v : vt2d) : real;
 begin  length2d:= sqrt( sqr(v.x) + sqr(v.y) );  end;
{*************}
function length3d(v : vt3d) : real;
 begin  length3d:= sqrt( sqr(v.x) + sqr(v.y) + sqr(v.z));  end;
{*************}

procedure normalize2d(var p: vt2d);
var c : real;
begin c:= 1/length2d(p); p.x:= c*p.x; p.y:= c*p.y; end;
{************}
procedure normalize3d(var p: vt3d);
var c : real;
begin c:= 1/length3d(p); p.x:= c*p.x; p.y:= c*p.y; p.z:= c*p.z  end;
{************}

function scalarp2d(p1,p2 : vt2d) : real;
 begin  scalarp2d:= p1.x*p2.x + p1.y*p2.y;  end;
{*************}
function scalarp3d(p1,p2 : vt3d) : real;
 begin  scalarp3d:= p1.x*p2.x + p1.y*p2.y + p1.z*p2.z;  end;
{*************}

function distance2d(p,q : vt2d): real;
begin  distance2d:= sqrt( sqr(p.x-q.x) + sqr(p.y-q.y) );  end;
{*************}
function distance3d(p,q : vt3d): real;
begin  distance3d:= sqrt( sqr(p.x-q.x) + sqr(p.y-q.y) + sqr(p.z-q.z) );  end;
{*************}
function distance2d_square(p,q : vt2d) : real;
begin distance2d_square:= sqr(p.x-q.x) + sqr(p.y-q.y);  end;
{**************}
function distance3d_square(p,q : vt3d) : real;
begin distance3d_square:= sqr(p.x-q.x) + sqr(p.y-q.y) + sqr(p.z-q.z);  end;
{**************}

procedure vectorp(v1,v2 : vt3d; var vp : vt3d);
{Berechnet das Kreuzprodukt von (x1,y1,z1) und (x2,y2,z2). }
 begin
   vp.x:=  v1.y*v2.z - v1.z*v2.y ;
   vp.y:= -v1.x*v2.z + v2.x*v1.z ;
   vp.z:=  v1.x*v2.y - v2.x*v1.y ;
 end; {vectorp}
{*************}

function determ3d(v1,v2,v3: vt3d) : real;
{Berechnet die Determinante einer 3x3-Matrix.}
 begin
   determ3d:= v1.x*v2.y*v3.z + v1.y*v2.z*v3.x + v1.z*v2.x*v3.y
            - v1.z*v2.y*v3.x - v1.x*v2.z*v3.y - v1.y*v2.x*v3.z;
 end; {determ3d}
{*************}

procedure rotor2d(cos_rota,sin_rota : real; p : vt2d; var pr: vt2d);
 begin
   pr.x:= p.x*cos_rota - p.y*sin_rota;
   pr.y:= p.x*sin_rota + p.y*cos_rota;
 end; {rotor2d}
{*************}

procedure rotp02d(cos_rota,sin_rota : real; p0,p : vt2d; var pr: vt2d);
 begin
   pr.x:= p0.x + (p.x-p0.x)*cos_rota - (p.y-p0.y)*sin_rota;
   pr.y:= p0.y + (p.x-p0.x)*sin_rota + (p.y-p0.y)*cos_rota;
 end; {rotor2d}
{*************}

procedure rotorz(cos_rota,sin_rota : real; p : vt3d; var pr: vt3d);
 begin
   pr.x:= p.x*cos_rota - p.y*sin_rota;
   pr.y:= p.x*sin_rota + p.y*cos_rota;    pr.z:= p.z;
 end; {rotorz}
{*************}
procedure rotp0z(cos_rota,sin_rota : real; p0,p: vt3d; var pr: vt3d);
 begin
   pr.x:= p0.x + (p.x-p0.x)*cos_rota - (p.y-p0.y)*sin_rota;
   pr.y:= p0.y + (p.x-p0.x)*sin_rota + (p.y-p0.y)*cos_rota;    pr.z:= p.z;
 end; {rotp0z}
{*************}
procedure rotp0x(cos_rota,sin_rota : real; p0,p: vt3d; var pr: vt3d);
{Rotation um eine zur x-Achse parallele Achse durch p0}
 begin
   pr.y:= p0.y + (p.y-p0.y)*cos_rota - (p.z-p0.z)*sin_rota;
   pr.z:= p0.z + (p.y-p0.y)*sin_rota + (p.z-p0.z)*cos_rota;    pr.x:= p.x;
 end; {rotp0x}
{*************}
procedure rotp0y(cos_rota,sin_rota : real; p0,p: vt3d; var pr: vt3d);
{Rotation um eine zur y-Achse parallele Achse durch p0}
 begin
   pr.x:= p0.x + (p.x-p0.x)*cos_rota - (p.z-p0.z)*sin_rota;
   pr.z:= p0.z + (p.x-p0.x)*sin_rota + (p.z-p0.z)*cos_rota;    pr.y:= p.y;
 end; {rotp0y}
{*************}

procedure change1d(var a,b: real);
var aa: real;
begin  aa:= a;  a:= b;  b:= aa;  end;
{*********}
procedure change2d(var v1,v2: vt2d);
var vv: vt2d;
begin  vv:= v1;  v1:= v2;  v2:= vv;  end;
{**********}
procedure change3d(var v1,v2: vt3d);
var vv: vt3d;
begin  vv:= v1;  v1:= v2;  v2:= vv;  end;
{**********}

{polar_angles fuer altes p2c: (SUSE 6.4)}
function polar_angle(x,y : real) : real;
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

procedure equation_degree1(a,b :real; var x : real ; var ns : integer);
 {Gleichung 1.Grades: a*x + b = 0 }
 begin
  if abs(a)=0 {<eps8} then   ns:= -1
                 else   begin x:=-b/a;   ns:= 1;  end;
 end; { equation_degree1 }
{***************}

procedure equation_degree2(a,b,c:real; var x1,x2:real ;var ns:integer);
{Berechnet die REELLEN Loesungen einer Gleichnung 2.Grades: a*x*x+b*x+c = 0.}
 var dis,wu2,xx1 : real;
 begin
   ns:=0;
   if abs(a)=0 {<eps8} then
        equation_degree1(b,c,x1,ns)
      else
        begin
        dis:= b*b-4*a*c;
        if (dis<0) and (dis>-eps6*abs(b)) then  dis:=0;
        if dis<0 then   ns:= 0
                 else
                   begin
                   if abs(dis)<eps8 then
                      begin  ns:= 1;   x1:= -b/(2*a);  x2:= x1; end
                     else
                      begin
                      ns:= 2;                wu2:= sqrt(dis);
                      x1:= (-b+wu2)/(2*a);    x2:= (-b-wu2)/(2*a);
                      end;
                   end; {dis>=0}
        end; {a<>0}
{Umordnen nach Groesse:}
   if ns=2 then  if x2<x1 then  change1d(x1,x2);
 end;  { equation_degree2 }
{*****************}

procedure is_line_line(a1,b1,c1, a2,b2,c2 : real; var xs,ys : real;
                                                  var nis : integer);
 {Schnittpunkt (xs,ys) (ns=1) der Geraden a1*x+b1*y=c1, a2*x+b2*y=c2 .}
 var det : real;
 begin
   det:= a1*b2 - a2*b1;
   if abs(det)<eps8 then    nis:= 0
       else
         begin
         nis:= 1;  xs:= (c1*b2 - c2*b1)/det;   ys:= (a1*c2 - a2*c1)/det;
         end;
 end;   { is_line_line }
{************}

procedure is_unitcircle_line(a,b,c: real; var x1,y1,x2,y2 : real;
                                                  var nis : integer);
 {Schnitt Kreis-Gerade: sqr(x)+sqr(y)=1, a*x+b*y=c,
  Schnittpkte: (x1,y1),(x2,y2).Es ist x1<=x2, nis Anzahl der Schnittpunkte}
 var ab2,wu,dis : real;
 begin
   nis:= 0;   ab2:= a*a + b*b;   dis:= ab2 - c*c;
   if dis>=0 then
      begin
      nis:= 2;
      wu:= sqrt(dis);           if abs(wu)<eps8 then nis:= 1;
      x1:= (a*c-b*wu)/ab2;      y1:= (b*c+a*wu)/ab2;
      x2:= (a*c+b*wu)/ab2;      y2:= (b*c-a*wu)/ab2;
      if x2<x1 then begin  change1d(x1,x2);  change1d(y1,y2);  end;
      end;
 end;   { is_unitcircle_line }
{************}

procedure is_circle_line(xm,ym,r, a,b,c: real; var x1,y1,x2,y2 : real;
                                               var nis : integer);
 {Schnitt Kreis-Gerade: sqr(x-xm)+sqr(y-ym)=r*r, a*x+b*y=c,
  Schnittpkte: (x1,y1),(x2,y2).Es ist x1<=x2, nis Anzahl der Schnittpunkte}
 var ab2,wu,dis,cc : real;
 begin
   nis := 0;
   ab2:= a*a + b*b;   cc:=c - a*xm - b*ym;   dis:= r*r*ab2 - cc*cc;
   if dis>=0 then
      begin
      nis:= 2;
      wu:= sqrt(dis);           if abs(wu)<eps8 then nis:= 1;
      x1:= xm + (a*cc-b*wu)/ab2;   y1:= ym + (b*cc+a*wu)/ab2;
      x2:= xm + (a*cc+b*wu)/ab2;   y2:= ym + (b*cc-a*wu)/ab2;
      if x2<x1 then begin  change1d(x1,x2);  change1d(y1,y2);  end;
      end;
 end;   { is_circle_line }
{************}

procedure is_circle_circle(xm1,ym1,r1,xm2,ym2,r2: real;
                                 var x1,y1,x2,y2: real; var nis: integer);
{Schnitt Kreis-Kreis. Es ist x1<x2. nis = Anzahl der Schnittpunkte }
 var a,b,c : real;
 begin
   a:= 2*(xm2 - xm1);        b:= 2*(ym2 - ym1);
   c:= r1*r1 - sqr(xm1) -sqr(ym1) - r2*r2 + sqr(xm2) + sqr(ym2);
   if (abs(a)+abs(b)<eps8) then   nis:= 0
      else   is_circle_line(xm1,ym1,r1,a,b,c,x1,y1,x2,y2,nis);
 end;   { is_circle_circle }
{************}

function pt_before_plane(p,nv: vt3d; d: real) : boolean;
{...stellt fest, ob der Punkt p "vor" der Ebene  nv*x-d=0 liegt.}
 begin  if (scalarp3d(p,nv)-d) >=0 then pt_before_plane:= true
                                   else pt_before_plane:= false;  end;
{*************}

procedure plane_equ(p1,p2,p3 : vt3d; var nv : vt3d; var d: real;
                                                      var error : boolean);
{Berechnet die Gleichung nv*x=d der Ebene durch die Punkte p1,p2,p3.
 error=true: die Punkte spannen keine Ebene auf.}
 var p21,p31 : vt3d;
 begin
   diff3d(p2,p1,p21);      diff3d(p3,p1,p31);
   vectorp(p21,p31,nv);    d:= scalarp3d(nv,p1);
   if abs3d(nv)<eps8 then error:= true else error:= false;
 end;   { plane_coeff }
{*************}

procedure is_line_plane(p,rv,nv: vt3d; d : real; var pis : vt3d;
                                                 var nis : integer);
{Schnitt Gerade-Ebene. Gerade: Punkt p, Richtung r. Ebene:  nv*x = d .
 nis=0: kein Schnitt ,nis=1: Schnittpunkt, nis=2: Gerade liegt in der Ebene.}
 var t,sp,pd : real;
 begin
   sp:= scalarp3d(nv,rv);   pd:= scalarp3d(nv,p) - d;
   if abs(sp)<eps8 then
        begin  nis:= 0;  if abs(pd)<eps8 then  nis:= 2;  end
       else
        begin
        t:= -pd/sp;   lcomb2vt3d(1,p ,t,rv ,pis);    nis:= 1;
        end;
 end;   { is_line_plane }
{*************}

procedure is_3_planes(nv1: vt3d; d1: real; nv2: vt3d; d2: real;
                      nv3: vt3d; d3: real;
                      var pis : vt3d; var error: boolean);
{Schnitt der Ebenen nv1*x=d1, nv2*x=d2, nv3*x=d3.
 error= true: Schnitt besteht nicht aus einem Punkt.}
 var det,dd1,dd2,dd3 : real;  n12,n23,n31 : vt3d;
 begin
   vectorp(nv1,nv2, n12);  vectorp(nv2,nv3, n23);  vectorp(nv3,nv1, n31);
   det:= scalarp3d(nv1,n23);
   if abs(det)<eps8 then  error:= true
      else
       begin
       dd1:= d1/det;  dd2:= d2/det;  dd3:= d3/det;
       lcomb3vt3d(dd1,n23, dd2,n31, dd3,n12 ,pis);
       end;
 end;   { is_3_planes }
{*************}

procedure is_plane_plane(nv1: vt3d; d1: real; nv2: vt3d; d2: real;
                             var p,rv : vt3d; var error: boolean);
{Schnitt der Ebenen nv1*x=d1, nv2*x=d2. Schnittgerade: x = p +  t*rv .
 error= true: Schnitt besteht nicht aus einem Punkt.}
 var det,c11,c22,c12,s1,s2: real;
 begin
   c11:= scalarp3d(nv1,nv1);     c22:= scalarp3d(nv2,nv2);
   c12:= scalarp3d(nv1,nv2);     det:= c11*c22-sqr(c12);
   if abs(det)=0 {<eps8} then  error:= true
      else
       begin
       s1:= (d1*c22-d2*c12)/det;        s2:= (d2*c11-d1*c12)/det;
       lcomb2vt3d(s1,nv1, s2,nv2, p);   vectorp(nv1,nv2, rv);
       error:= false;
       end;
 end;   { is_plane_plane }
{***********}

procedure ptco_plane3d(p0,v1,v2,p: vt3d; var xi,eta: real; var error: boolean);
 {v1,v2 sind linear unabhaengig, p-p0 linear abhaengig von v1,v2.
 Es werden Zahlen  xi,eta berechnet mit  p = p0 + xi*v1 + eta*v2. }
 var det,s11,s12,s22,s13,s23 : real;   v3 : vt3d;
 begin
   diff3d(p,p0, v3);
   s11:= scalarp3d(v1,v1);   s12:= scalarp3d(v1,v2);   s13:= scalarp3d(v1,v3);
                             s22:= scalarp3d(v2,v2);   s23:= scalarp3d(v2,v3);
   det := s11*s22 - s12*s12;
   if abs(det)=0 {<eps8} then  error:= true
      else
        begin
        error:= false;
        xi := (s13*s22 - s23*s12)/det;
        eta:= (s11*s23 - s13*s12)/det;
        end;
 end;   { ptco_plane3d }
{*****************}


procedure newcoordinates3d(p,b0,b1,b2,b3: vt3d; var pnew: vt3d);
{Berechnet die Koordinaten von p bzgl. der Basis b1,b2,b3 mit Nullpkt. b0.}
var det : real;   p0: vt3d;
begin
  diff3d(p,b0, p0);              det:= determ3d(b1,b2,b3);
  pnew.x:= determ3d(p0,b2,b3)/det;
  pnew.y:= determ3d(b1,p0,b3)/det;
  pnew.z:= determ3d(b1,b2,p0)/det;
end;  { newcoordinates3d }  
{***}
