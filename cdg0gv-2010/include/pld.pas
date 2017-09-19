{pld.pas}

{******************************************************}
{*** A: Procedures for the generation of a PLD-file ***}
{******************************************************}

const
      pt_per_mm : real = 10.0;
      pld_ver   = 'Ver1.0';

var
      plotdatei : text;
      plot_it   : boolean;

procedure plot_init;
 var i : integer;
 begin
   writeln('*************************************************************');
   writeln('** A PLD-file (point-line-description) will be generated ****');
   writeln('*************************************************************');
   writeln;
   writeln;
 end; { plot_init }

{*************}

procedure plot_area(width,height: real);
{ for PLD-file }
 var  datei : string;
 begin
   if GeoPLDinteraktiv then begin
     writeln('name of PLD-file ? (... .pld)');
     readln(datei);
   end;
   if GeoPLDcommand then datei:=GeoPLDFilename;
   assign(plotdatei,datei);
   rewrite(plotdatei);
   writeln(plotdatei,pld_ver);
   Write(plotdatei,width:10:3,' ',height:10:3,' ');
 end; { plot_area }
{*************}

procedure plot_end;
 begin
   Write(plotdatei,'*');
   Close(plotdatei);
 end;
{*************}

procedure plot_linec2d(x1,y1,x2,y2 : real; style : integer);
{draws the line (x1,y1)(x2,y2)}
 var px1,py1,px2,py2 : longint; 
 begin
   px1:=round((x1+origin2d.x)*pt_per_mm); 
   py1:=round((y1+origin2d.y)*pt_per_mm);
   px2:=round((x2+origin2d.x)*pt_per_mm); 
   py2:=round((y2+origin2d.y)*pt_per_mm);
   if style > 3 then style := 0;
   Write(plotdatei,'L ',px1,' ',py1,' ',px2,' ',py2,' ',style,' ');
 end; { plot_linec2d }
{*************}

procedure plot_curve2d(var p: vts2d; n1,n2,style : integer);
{draws the polyline (x(n1),y(n1))... (x(n2),y(n2))}
var
  i : integer;
  px1,py1 : longint;
begin
  if style > 3 then style := 0;
  Write(plotdatei,'K ',n2-n1+1,' ',style,' ');
  for i := n1 to n2 do
  begin
    px1:=round((p[i].x+origin2d.x)*pt_per_mm);    
    py1:=round((p[i].y+origin2d.y)*pt_per_mm);
    Write(plotdatei,px1,' ',py1,' ');
  end;
end; {plot_curve2d}
{*************}

procedure plot_pointc2d(x,y : real; style : integer);
{draws a points}
 var ix,iy : longint;
 begin
   ix:=round((x+origin2d.x)*pt_per_mm);
   iy:=round((y+origin2d.y)*pt_per_mm);
   Write(plotdatei, 'P ',ix,' ',iy,' ',style,' ')
 end; { plot_pointc2d}
{*************}

procedure plot_new_color(color:integer);
begin
   Writeln(plotdatei, 'C',color)
 end; { plot_new_color}
{*************}

procedure plot_new_linewidth(factor : real);
begin
   Writeln(plotdatei, 'W', round(factor*10));
end;
