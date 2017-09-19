{postscr.pas:}

const
   ps_style : Integer = 99;

var
   psfile : text;


procedure ps_set_style(style :integer);
begin
  if (style <> ps_style) then
  begin
    Case style of
          0  : writeln(psfile,'[] 0 setdash');
          1  : writeln(psfile,'[2 1.5] 0 setdash');
          3  : writeln(psfile,'[.2 1.5] 0 setdash');
          2  : writeln(psfile,'[3 1 .2 1] 0 setdash');
    end;
    ps_style := style;
  end;
end;


procedure ps_graph_on(fname:string;eps:boolean);
begin
  assign(psfile,fname);  
  rewrite(psfile);
  if not eps then
  begin
    writeln(psfile, '%!PS-Adobe-2.0 PSF-2.0');
    writeln(psfile, '%%Creator: pldv');
    writeln(psfile, '/Rahmen{newpath');
    writeln(psfile, 'wx neg wy neg moveto ');
    writeln(psfile, '0 hoehe     rlineto  ');
    writeln(psfile, 'breite 0    rlineto  ');
    writeln(psfile, '0 hoehe neg rlineto  ');
    writeln(psfile, 'closepath            ');
    writeln(psfile, '/lw currentlinewidth def ');
    writeln(psfile, '0 setlinewidth           ');
    writeln(psfile, 'stroke                   ');
    writeln(psfile, 'lw setlinewidth          ');
    writeln(psfile, 'wx neg wy neg 5 sub moveto ');
    writeln(psfile, 'titel show             ');
(*    writeln(psfile, '/seite seite 1 add def ');
    writeln(psfile, 'wx 20 sub wy 5 add neg moveto ');
    writeln(psfile, '(Seite ) show  ');
    writeln(psfile, 'seite str cvs  ');*)
    writeln(psfile, 'str show       ');
    writeln(psfile, '}def           ');
    writeln(psfile, '/titel (',fname ,') def');
  end else {EPS}
  begin
    writeln(psfile, '%!PS-Adobe-2.0 EPSF-2.0');
    writeln(psfile, '%%Creator: pldv');
  end;
  ps_style := 99;
end;

procedure ps_graph_off;
begin
end;

procedure ps_draw_end;
begin
    writeln(psfile,'grestore');
    writeln(psfile,'showpage');
    close(psfile);
end;


procedure ps_draw_area(world_width,world_height,x,y:real;eps:boolean);
const
  f=2.8346;
begin
    if eps then begin
      writeln(psfile,'%%BoundingBox: ',
                                trunc(-x*f) ,' ',
                                trunc(-y*f) ,' ',
                                round((-x+world_width)*f),' ',
                                round((-y+world_height)*f) );
       writeln(psfile,'%%EndComments');
    end;
    writeln(psfile, 'gsave          ');
    writeln(psfile, '2.8346 2.8346 scale ');
    if not eps then writeln(psfile, '90 rotate           ');
    writeln(psfile, '0.15 setlinewidth      ');
    writeln(psfile, '1 setlinejoin       ');
    writeln(psfile);
    if not eps then 
    begin
      writeln(psfile, '/Times-Roman findfont 5 scalefont setfont ');
      writeln(psfile, '/seite 0 def ');
      writeln(psfile, '/str 3 string def ');
      writeln(psfile, '/breite ',world_width:8:2,' def' );
      writeln(psfile, '/hoehe ',world_height:8:2,' def' );
      writeln(psfile, '/wx ',x:8:2, ' def');
      writeln(psfile, '/wy ',y:8:2, ' def');
      writeln(psfile,'17 wx add -9 hoehe sub wy add translate');
      writeln(psfile,'Rahmen'); 
    end;
    writeln(psfile);
end;

procedure ps_newpage;
begin
   writeln(psfile,'gsave'); 
   writeln(psfile,'showpage'); 
   writeln(psfile,'grestore');
   writeln(psfile,'Rahmen'); writeln(psfile);
end;

procedure ps_new_color(color:integer);
begin
  if color= default    then color := black;
  if color= black           then writeln(psfile,'0 0 0 setrgbcolor');
  if color= blue            then writeln(psfile,'0 0 .8 setrgbcolor');
  if color= green           then writeln(psfile,'0 .8 0 setrgbcolor');
  if color= cyan            then writeln(psfile,'0 .8 .8 setrgbcolor');
  if color= red             then writeln(psfile,'.8 0 0 setrgbcolor');
  if color= magenta         then writeln(psfile,'.8 0 .8 setrgbcolor');
  if color= brown           then writeln(psfile,'.65 .16 .16 setrgbcolor');
  if color= lightgray       then writeln(psfile,'.8 .8 .8 setrgbcolor');
  if color= darkgray        then writeln(psfile,'.6 .6 .6 setrgbcolor');
  if color= lightblue       then writeln(psfile,'0 0 1 setrgbcolor');
  if color= lightgreen      then writeln(psfile,'0 1 0 setrgbcolor');
  if color= lightcyan       then writeln(psfile,'0 1 1 setrgbcolor');
  if color= lightred        then writeln(psfile,'1 0 0 setrgbcolor');
  if color= lightmagenta    then writeln(psfile,'1 0 1 setrgbcolor');
  if color= yellow     	    then writeln(psfile,'1 1 0 setrgbcolor');
  if color= white           then writeln(psfile,'1 1 1 setrgbcolor');
end;

procedure ps_set_linewidth( width : real);
begin
  writeln(psfile,width:8:2,'  setlinewidth');
end;

procedure ps_new_linewidth(factor : real);
const
   default = 0.15;
begin
   ps_set_linewidth(default*factor);
end;


procedure ps_linec2d( x1,y1,x2,y2: real; style:integer);
begin
   ps_set_style(style);
   writeln(psfile,x1:8:2,' ',y1:8:2,' moveto');
   writeln(psfile,x2:8:2,' ',y2:8:2,'  lineto');
   writeln(psfile,'stroke');
end;

procedure ps_pointc2d(x,y :real; marker:integer);
begin
    writeln(psfile,'/lw currentlinewidth def');
(*    writeln(psfile,'0 setlinewidth');*)
    writeln(psfile,'[] 0 setdash');
    
   (*  if marker > 3 then marker := 3; *)
    Case marker of 
      100 {PIXEL},	
      3 {DOT}     : begin
                      writeln(psfile, 'newpath');
                      writeln(psfile, x:8:2,' ',y:8:2,' .2 0 360 arc');
                      writeln(psfile, 'fill');
                    end;   
      1 {PLUS}    : begin
                      writeln(psfile, 'newpath');
                      writeln(psfile, x:8:2,' ',y+1:8:2,' moveto');
                      writeln(psfile,' 0 -2 rlineto');
                      writeln(psfile,'-1  1 rmoveto');
                      writeln(psfile,' 2  0 rlineto');
                      writeln(psfile,'stroke');
                    end;  
      10 {SMALLPLUS} : begin
(*
                      writeln(psfile, 'newpath');
                      writeln(psfile, x:8:2,' ',y+1:8:2,' moveto');
                      writeln(psfile,' 0 -1 rlineto');
                      writeln(psfile,'-0.5  0.5 rmoveto');
                      writeln(psfile,' 1  0 rlineto');
                      writeln(psfile,'stroke');
*)
                      writeln(psfile, 'newpath');
                      writeln(psfile, x:8:2,' ',y:8:2,' .5 0 360 arc');
                      writeln(psfile, 'fill');
                    end;  
      50 {BIGPIXEL} : begin
                      writeln(psfile, 'newpath');
                      writeln(psfile, x:8:2,' ',y:8:2,' .35 0 360 arc');
                      writeln(psfile, 'fill');
                    end;  
      2 {CROSS}   : begin
                      writeln(psfile, 'newpath');
                      writeln(psfile, x+0.707:8:2,' ',y+0.707:8:2,' moveto');
                      writeln(psfile, '-1.414 -1.414 rlineto');
                      writeln(psfile, '1.414 0 rmoveto');
                      writeln(psfile, '-1.414  1.414 rlineto');
                      writeln(psfile, 'stroke');
                    end;  
      0 {circle}  : begin
                      writeln(psfile, 'newpath');
                      writeln(psfile, x:8:2,' ',y:8:2,' .8 0 360 arc');
                      writeln(psfile, 'stroke');
                    end; 
      end;
    writeln(psfile,'lw setlinewidth');  
    ps_style := 0;
end;

procedure  ps_curve2d(var p:vts2d; n1,n2,style:integer);
var
    i : integer;
begin
    ps_set_style(style);
    writeln(psfile, 'newpath');
    writeln(psfile, p[n1].x:8:2,' ',p[n1].y:8:2,' moveto');
    writeln(psfile, '[');
    for i:=n1+1 to n2 do
        writeln(psfile,' [', p[i].x:8:2,' ',p[i].y:8:2, ']');
    writeln(psfile, ']');
    writeln(psfile,'{aload pop lineto} forall');
    writeln(psfile,'stroke');    
end;


