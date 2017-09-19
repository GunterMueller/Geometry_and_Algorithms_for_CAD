{******************************}
{***  Regelmaessiges n-Eck  ***}
{******************************}
program n_eck;
uses linux;
const  {$i include/geoconst.pas}
type   {$i include/geotype.pas}
var    {$i include/geovar.pas}
       p : vts2d;
       n,iverb,i,j,inz : integer;
       r,dw,cdw,sdw : real;
     {$i include/geoproc.pas}
     {$i include/proc_ag.pas}
{*******************}
 begin {Hauptprogramm}
   graph_on(0);
   repeat
     writeln('***  n-Eck  ***');
     writeln(' n ?  Radius r des zugehoerigen Kreises ?');
     readln(n,r);
     writeln('Jeden Punkt mit jedem Punkt verbinden ? (Ja = 1)');
     readln(iverb);
{Berechnung der Eckpunkte:}
     put2d(r,0, p[0]);
     dw:= pi2/n;   cdw:= cos(dw);  sdw:= sin(dw);
     for i := 0 to n-1 do  rotor2d(cdw,sdw, p[i], p[i+1]);
     draw_area(2*r+20,2*r+20,r+10,r+10,1);
{Zeichnen:}   new_color(green);
     if iverb=1 then
          for i:= 0 to n-1 do
                for j:= i+1 to n do
                    line2d(p[i],p[j],0)
        else
          curve2d(p,0,n,0);
     draw_end;
    writeln('Noch eine Zeichnung? (ja:1, nein:0)');
    readln(inz);
   until inz=0;
   graph_off;
 end.

