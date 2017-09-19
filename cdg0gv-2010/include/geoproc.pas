{##############################}
{ geoproc.pas for FREE-PASCAL }
{##############################}

const
  GeoPLDcommand    : Boolean = false; 
  GeoPLDinteraktiv : Boolean = false;
  GeoBild          : Boolean = true;
  GeoMono          : Boolean = false;

var
  GeoPLDFilename  : string;
  GeoEpsFilename  : string;                             

{*****************************************************}
{*** A: For Generation of a PLD-file ***}
{*****************************************************}
{ i include/geoinit.pas}
{$i pld.pas}
{$i postscr.pas}

{***********************************************************************}
   {***  B: for the generation of an EPS-file of the drawing and ....***}
{***********************************************************************}

procedure graph_on(mode : integer);
begin
  null2d.x:= 0;  null2d.y:= 0;
  null3d.x:= 0;  null3d.y:= 0;   null3d.z:= 0;
(*   if GeoBild then
   begin
      GeoEpsFilename:= 'geodummy.eps';
      ps_graph_on(GeoEpsFilename, true);
   end; *)
  GeoPLDinteraktiv := (mode <> 0);
  plot_it := GeoPLDinteraktiv or GeoPLDcommand;
  if plot_it then  plot_init;
end; { graph_on }
{*************}

procedure draw_area(width,height,x0,y0,sfac : real);
{.... and opens geodummy.eps}
begin
  if plot_it then  plot_area(width, height);
  scalefactor:= sfac;
  origin2d.x:=x0; origin2d.y:=y0;
  if scalefactor<>1 then writeln('scalefactor is:',scalefactor:3:2);
  if GeoBild then
     begin
      GeoEpsFilename:= 'geodummy.eps';
      ps_graph_on(GeoEpsFilename, true);
      ps_draw_area(width,height,x0,y0, true);                   
     end;	
 end; { draw_area}
{*************}

procedure draw_end;
{closes the eps-file and displays it}
var s :  longint;
begin
 if plot_it then plot_end;
 if GeoBild then
    begin
       ps_draw_end;
       writeln('###: show drawing (with gv):');
       writeln('###: (continue after quitting gv)');
       s:=fpsystem('gv geodummy.eps');
{       writeln('shell beendet mit: ',s);}
    end;
end; { draw_end }
{*************}

procedure graph_off;
begin
  if GeoBild then
     begin
	ps_graph_off;
     end;
end; {graph_off}
{**************}

procedure new_color(color: integer);
begin
  if not GeoMono then 
  begin
    if plot_it then plot_new_color(color);
    if color = default then color := black;
    if GeoBild then
       begin
	  ps_new_color(color);                         
       end;
  end;
end;  { new_color }
{**************}

procedure new_linewidth(factor: real);
const
   default = 3.0;
begin
   if plot_it then plot_new_linewidth(factor);
   if GeoBild then
      begin
	 ps_new_linewidth(factor);          
      end;
end;

procedure linec2d(x1,y1,x2,y2 : real; style : integer);
{draws the line (x1,y1)(x2,y2)}
begin
  x1 := x1*scalefactor;
  x2 := x2*scalefactor;
  y1 := y1*scalefactor;
  y2 := y2*scalefactor;
  if style > 3 then style := 0;
  if plot_it then plot_linec2d(x1,y1, x2,y2,style);
  if GeoBild then
     begin
	ps_linec2d(x1,y1,x2,y2, style);                  
     end;
end; {linec2d}
{*************}

procedure line2d(p1,p2 : vt2d; style : integer);
begin
  linec2d(p1.x,p1.y,p2.x,p2.y,style);
end; {line2d}
{*************}

procedure pointc2d(x,y : real; style : integer);
{draws a point}
begin
  x:= x*scalefactor;
  y:= y*scalefactor;
  if plot_it  then plot_pointc2d(x,y,style);
  if GeoBild then
     begin
	ps_pointc2d(x,y,style);
     end;
end; { pointc2d }
{*************}

procedure point2d(p : vt2d; style: integer);
begin
  pointc2d(p.x,p.y,style);
end;  {point2d}
{**************}

procedure curve2d(var p: vts2d; n1,n2,style : integer);
{draws the polyline (x(n1),y(n1))... (x(n2),y(n2))}
var
  i  : integer;
  pp : vts2d;
begin
    for i:= n1 to n2 do 
    begin
      pp[i].x := p[i].x * scalefactor;
      pp[i].y := p[i].y * scalefactor;
    end;
    if style > 3 then style := 0;
    if plot_it then plot_curve2d(pp,n1,n2,style);
    if GeoBild then
       begin
	  ps_curve2d(pp,n1,n2,style);
       end;
end; {curve2d}
{*************}

procedure curve2d_vis(var p: vts2d; n1,n2,style: integer; visible: b_array );
{neighbored "visible" points are connected.
 if style=10: "invisible" lines are dashed. }
 var i,i1 : integer;
     vis : boolean;
 begin

   i1 := n1;
   i := i1;
   vis := visible[i1];
   
   repeat
     i := i+1;
     if (i>n2) or (vis <> visible[i]) then 
     begin
        if vis then curve2d(p,i1,i-1,style)
        else if style=10 then curve2d(p,i1,i-1,1);
        i1 := i;
        vis := visible[i];
     end;  
   until i>n2;

 end; { curve2d_vis }
{*************}

procedure arrowc2d(x1,y1,x2,y2 : real; style : integer);
{draws an arrow}
 var x21,y21,x3,y3,x4,y4,d,sl,sb,sld,sbd : real;
 begin
   x21:= x2-x1;   y21:= y2-y1;
   d:= sqrt(x21*x21+y21*y21);
   sl:= 3/scalefactor;  {Laenge der Spitze}
   sb:= 1/scalefactor; {Breite ..}
   if d>=sl then   {Pfeilspitze}
              begin
                sld:= sl/d;  sbd:= sb/d;
                x3:= x2-sld*x21-sbd*y21 ;   y3:= y2-sld*y21+sbd*x21 ;
                x4:= x2-sld*x21+sbd*y21 ;   y4:= y2-sld*y21-sbd*x21 ;
                linec2d(x2,y2,x3,y3,0)  ;   linec2d(x2,y2,x4,y4,0)  ;
              end;
   linec2d(x1,y1,x2,y2,style);
 end; { arrowc2d }
{**************}

procedure arrow2d(p1,p2 : vt2d; style : integer);
 begin
   arrowc2d(p1.x,p1.y,p2.x,p2.y,style);
 end; { arrow2d }
{**********************************************************************}

procedure read_integer_file(file_name: string; n_dat: integer;
                                           var int_var: i_array);
var  text_var : text;
     i   : integer;
begin
   assign(text_var,file_name);
   reset(text_var);
   for i:= 1 to n_dat do read(text_var, int_var[i]);
   close(text_var);  
end;  { read_integer_file }
{***********}




