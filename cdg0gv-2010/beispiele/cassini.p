program cassini;
{mit Methode des "steilsten Weges"}
uses linux,geograph;
type  
      funct2d = function(x,y: real) : real;    { fuer implicit_curvepts }
      funct2d2d = procedure(x,y: real; var gx,gy: real);

var   startpt,endpt,start_tangentvt: vt2d;
      tangent_stepl,curvept_delta : real;
      n2max,n2 : integer;
      f: funct2d;
      gradf: funct2d2d;
      p : vts2d;

 var   a,c,scalefac,x0,y0 : real;
       p0,p1,p2 : vt2d;
       inz,i,ipld : integer;
{******}

procedure implicit_curvepts(startpt,endpt,start_tangentvt: vt2d;
                             tangent_stepl,curvept_delta : real;
                                                   n2max : integer;
                                                        f: funct2d;
                                                    gradf: funct2d2d;
                                                   var n2: integer;
                                                   var p : vts2d);
{berechnet Punkte p[0],...,p[n2] einer impliziten Kurve f(x,y)=0 mit der
 Methode des "steilsten Weges".
 startpt=Startpunkt, endpt=Endpunkt,
 tangent_stepl= Schrittweite in Tangentenrichtung,
 curvept_delta= Genauigkeitsschranke zur Berechnung von Kurvenpunkten,
 n2max= maximales n2, n2max muss kleiner als array_size sein !.}
 var i : integer;    tv,dv,ps,curve_endpt : vt2d;
     g,ghn,gx,gy,fac,test,stepl,delta,cc : real;
{****}
procedure newton_step(xi,yi : real; var xi1,yi1 :real);
 var  fi,gxi,gyi,t,cc : real;
 begin
   fi:= f(xi,yi);            gradf(xi,yi, gxi,gyi);
   cc:= sqr(gxi) + sqr(gyi);
   if cc>0 then t:= -fi/cc else begin t:= 0; pointc2d(xi,yi,0); end;
   xi1:= xi + t*gxi;  yi1:= yi + t*gyi;
 end;
{***}
procedure curve_point(p0 : vt2d; var pc : vt2d);
{Sucht einen Punkt der Kurve entlang des steilsten Weges}
 var xi,yi,xi1,yi1,delta : real;
 begin
   xi:= p0.x;  yi:= p0.y;
   repeat                                      {pointc2d(xi,yi,10);}
     newton_step(xi,yi,xi1,yi1);
     delta:= abs(xi-xi1) + abs(yi-yi1);
     xi:= xi1;  yi:= yi1;
   until delta < curvept_delta;
   put2d(xi1,yi1, pc);
 end;   { curve_point }
{*********}
 begin {implicitcurve}      {Mit while-Schleife, n2 ist "var"}
   curve_point(startpt, p[0]);       curve_point(endpt, curve_endpt);
   stepl:= tangent_stepl;            delta:= stepl;
   tv:= start_tangentvt;             fac:= stepl/length2d(tv);
   lcomb2vt2d(1,p[0], fac,tv, ps);   curve_point(ps,p[1]);
   i:=1;   test:= 0;
   while (delta>0.7*stepl) and (i<n2max) do
       begin
       diff2d(p[i],p[i-1], dv);
       gradf(p[i].x,p[i].y, gx,gy);   put2d(-gy,gx, tv);
       cc:= length2d(tv);
       if cc>0 then
          begin
          fac:= stepl/cc;
          test:= scalarp2d(tv,dv);       if test<0 then fac:= -fac;
          lcomb2vt2d(1,p[i], fac,tv, ps);
          end
          else lcomb2vt2d(2,p[i],1,p[i-1], ps);
       i:= i+1;
       curve_point(ps,p[i]);
       delta:= distance2d(p[i],curve_endpt);
       end;  { while }
   if i<n2max then begin n2:= i+1; p[n2]:= curve_endpt; end
              else n2:= i;
  end; {implicit_curvepts}
{***************}

function fcass(x,y : real) : real;
 begin
   fcass:= sqr(x*x+y*y) - 2*c*c*(x*x-y*y) - (a*a*a*a-c*c*c*c) ;
 end;
{*****}
procedure gradfcass(x,y : real; var gx,gy: real);
 begin
   gx:= 4*x*(x*x+y*y) - 4*c*c*x;
   gy:= 4*y*(x*x+y*y) + 4*c*c*y;
 end;
{*****}

{***********************}
 begin {Hauptprogramm}
   writeln('pld-Datei ? (ja:1, nein:0)');                 readln(ipld);
   graph_on(ipld);
   writeln('**************************************************');
   writeln('            Implizite Kurven mit ');
   writeln(        'Methode des steilsten Weges');
   writeln('**************************************************');
   repeat
     writeln(' CASSINIsche Kurve (Bronstein S.141):');
     writeln('(x*x+y*y)**2 -2*c*c*(x*x-y*y) - (a**4-c**4) = 0 ');
     writeln('Fuer a=c ergibt sich eine LEMNISKATE');
     writeln('  a ?  (>0) ,  c (0.5 ... 2) ?');          readln(a,c);
{     writeln('Anfangspunkt (x0,y0) ? (nicht (0,0) !)');  readln(x0,y0);}
     x0:= 1; y0:= 1; 
     put2d(x0,y0, p0);     scalefac:= 30;
{Zeichenflaeche :  }
     draw_area(180,140,90,65,scalefac);
     put2d(-2,0, p1);  put2d(2,0, p2);     arrow2d(p1,p2,2);
     put2d(0,-1, p1);  put2d(0,1, p2);     arrow2d(p1,p2,2);

     put2d(x0,y0,startpt); new_color(red); point2d(startpt,0); new_color(default);
     endpt:= startpt;  put2d(0,1,start_tangentvt);
     tangent_stepl:= 0.05;  curvept_delta:= eps6;  n2max:= 300;
     f:= fcass;  gradf:= gradfcass;
     implicit_curvepts(startpt,endpt,start_tangentvt,
                             tangent_stepl,curvept_delta,
                             n2max,f,gradf,n2,p);
writeln('Anzahl der Punkte: ',n2);
     curve2d(p,0,n2,0);
     if c>a then
        begin
        for i:= 0 to n2 do p[i].x:= -p[i].x;  curve2d(p,0,n2,0);
        end;
     draw_end;          writeln;
     writeln(' Noch eine Zeichnung ? (nein: 0) ');     read(inz);
   until inz=0;
   graph_off;
 end.















