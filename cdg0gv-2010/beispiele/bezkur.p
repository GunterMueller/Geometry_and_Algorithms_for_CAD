program bezkur;
 uses geograph;
 const n_bez=20;
 type  bez_array   = array[0..n_bez] of real; 
       bezpt_array = array[0..n_bez] of vt2d;
 var   p : vts2d;         bx,by,bxnew,bynew : bez_array;
       dt,t : real;       bezpts: bezpt_array;   curvept: vt2d;
       i,j,degree,ipld,np,ivorn,degree1,nelev : integer;
{******}

function bezier_comp(degree: integer; var coeff: bez_array; t: real) : real;
{Berechnet eine Komponente einer Bezier-Kurve.}
{aus FARIN: Curves and surfaces...}
 var i,n_choose_i : integer;    fact,t1,aux : real;
 begin
   t1:= 1-t;  fact:=1;  n_choose_i:= 1;
   aux:= coeff[0]*t1;
   for i:= 1 to degree-1 do
       begin
       fact:= fact*t;
       n_choose_i:= n_choose_i*(degree-i+1) div i;
       aux:= (aux + fact*n_choose_i*coeff[i])*t1;
       end;
   aux:= aux + fact*t*coeff[degree];
   bezier_comp:= aux;
 end;  {bezier_comp}
{*************}

function bezier_comp_decas(degree: integer; var coeff: bez_array; t: real) : real;
{Berechnet eine Komponente einer Bezier-Kurve mit DECASTELJAU_Alg..}
{aus FARIN: Curves and Surfaces, S. 33,34}
 var i,r : integer;    t1 : real;       coeffa: bez_array;
 begin
   t1:= 1-t;  
   coeffa:= coeff;
   for r:= 1 to degree do
       for i:= 0 to degree-r do coeffa[i]:= t1*coeffa[i] + t*coeffa[i+1];
   bezier_comp_decas:= coeffa[0];
 end;  {bezier_comp_decas}
{*************}

procedure degree_elev_comp(degree: integer; var coeff: bez_array; 
                                            var coeffnew: bez_array);
{Berechnet die Koeffizienten f"ur eine Graderh"ohung.}
var i,degree1: integer; 
begin
  degree1:= degree+1;
  coeffnew[0]:= coeff[0];  coeffnew[degree1]:= coeff[degree];
  for i:= 1 to degree do   
      coeffnew[i]:= (i*coeff[i-1] + (degree1-i)*coeff[i])/degree1;
end;  { degree_elev_comp }
{************}

procedure beziercurvept2d_decas(degree: integer; var bezpts: bezpt_array; t: real; 
                                                 var curvept: vt2d); 
{Berechnet und zeichnet einen Punkt einer Bezier-Kurve mit DECASTELJAU_Alg..}
{aus FARIN: Curves and Surfaces, S. 33,34}
 var i,r : integer;    t1 : real;       bezptsa: bezpt_array;
 begin
   t1:= 1-t;  
   bezptsa:= bezpts;
   for r:= 1 to degree do
       for i:= 0 to degree-r do 
        begin
        lcomb2vt2d(t1,bezptsa[i],t,bezptsa[i+1], bezptsa[i]);
        point2d(bezptsa[i],0); 
        if (i>0) and (r<degree) then line2d(bezptsa[i-1],bezptsa[i],0);
        end;
   curvept:= bezptsa[0];
 end;  {beziercurvept2d_decas}
{*************}

{*************}
 begin {Hauptprogramm}
   writeln('pld-Datei ? (ja:1)');               read(ipld);
   graph_on(ipld);
   repeat
     writeln('*** ebene BEZIER-Kurve (mit CASTELJAU oder hornbez) *** ');
     writeln('Welcher Grad ? ');                  readln(degree);
     writeln('Kontroll-Punkte (xi,zi):  ');
     for i:= 0 to degree do
         begin
         write(i,'. Punkt ? ');                   readln(bx[i],by[i]);
         end;
     writeln('Anzahl der Kurven-Punkte:  np ?');  readln(np);
     dt:= 1/np;     t:= 0;
     for i:= 0 to np do
         begin
         p[i].x:= bezier_comp_decas(degree,bx,t);
         p[i].y:= bezier_comp_decas(degree,by,t);
         t:= t+dt;
         end;
     draw_area(180,180,20,20,1.3);
     for i:= 1 to degree do
         begin
         pointc2d(bx[i],by[i],0);
         linec2d(bx[i-1],by[i-1],bx[i],by[i],1);
         end;
     pointc2d(bx[0],by[0],0);
     new_linewidth(2);
     curve2d(p,0,np,0);   
     new_linewidth(1);
     {arrowc2d(0,0,60,0,2);  arrowc2d(0,0,0,60,2);}
(*     
{ Casteljau-Alg. fuer t=...:}
     for i:= 0 to degree do put2d(bx[i],by[i], bezpts[i]);
     t:= 0.6;
     beziercurvept2d_decas(degree,bezpts,t,curvept); 
*)

{Graderhoehung:}
     nelev:= 10;
     for j:= 1 to nelev do
        begin
        degree_elev_comp(degree,bx,bxnew);
        degree_elev_comp(degree,by,bynew);
        degree1:= degree+1;
        if j=nelev then
        for i:= 0 to degree1 do pointc2d(bxnew[i],bynew[i],0);
        if j=nelev then 
        for i:= 0 to degree1-1 do linec2d(bxnew[i],bynew[i],bxnew[i+1],bynew[i+1],0);
        bx:= bxnew;  by:= bynew;  degree:= degree1;
        end;

     draw_end;
     writeln(' von vorn ? (nein: 0) ');          readln(ivorn);
   until ivorn=0;
   graph_off;
 end.










