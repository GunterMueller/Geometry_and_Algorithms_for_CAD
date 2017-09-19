program pldv;
uses  Unix {linux};
const
{$i include/geoconst.pas}

type
{$i include/geotype.pas}

var
{$i include/geovar.pas}

const
  AutoScale    : Boolean = false;
  Frame        : Boolean = false;
  Fixed_X_Size : Boolean = false;
  Fixed_Y_Size : Boolean = false;
  Postscript   : Boolean = false;
  eps          : Boolean = false;
  mono	       : Boolean = false;
  RandDefault  : Boolean = true;  
  
var
  breite,hoehe,
  xnullp,ynullp,
  xmin,xmax,
  ymin,ymax,r,
  x_size,y_size,
  faktor,
  Rand,
  x1,y1,x2,y2        : Real;
  anz,
  ind,i,idummy       : Integer;
  C                  : Char;
  PLDFileName,
  PSFileName         : string;
  PLDFILE            : text;
  s                  : String;
  color              : integer;
  Option_Error,
  anfang,newname     : Boolean;
  p                  : vts2d;


{$i include/geoproc.pas}
{$i include/proc_ag.pas}
{i postscr.pas}


procedure remapx(var x:real);
begin
  x := (x/pt_per_mm + xnullp) * faktor + Rand;
end;

procedure remapy(var y:real);
begin
  y := (y/pt_per_mm + ynullp) * faktor + Rand;
end;

{******************}

begin   {main}

  PLDFilename:='';
  PSFilename:='geodummy.eps';
  faktor:=1.0;  
{  Postscript:= true;}
  eps       := true;
  newname   := false;

  { Parser for options }

  for i := 1 to ParamCount do
  begin
    Option_Error := False;
    s := ParamStr(i);
    if length(s) > 0 then
    begin
      Case s[1] of
         '-' : begin
                if length(s) > 1 then
                Case s[2] of
                  'o' : begin
                          s := Copy(s,3,length(s)-2);
        		  PSFileName:=s; newname:= true;
                        end;
                  'p' : begin
		          Postscript:= true;
                          s := Copy(s,3,length(s)-2);
 		          if s='ps' then eps:= false
                        end;
                  'z' : begin
                          s := Copy(s,3,length(s)-2);
                          Val(s,idummy,ind);
                          if ind <> 0 then begin
                            faktor := 1;
                            Option_Error := True;
                          end else faktor := idummy / 100.0;
                        end;
                  'a' : AutoScale := True;
                  'm' : mono := True;
                  'x' : begin
                          Fixed_X_Size := True;
                          Fixed_Y_Size := false;
                          s := Copy(s,3,length(s)-2);
                          Val(s,idummy,ind);
                          if ind <> 0 then begin
                            Fixed_X_size := false;
                            Option_Error := True;
                          end else x_size := idummy *1.0;
                        end;
                  'y' : begin
                          Fixed_Y_Size := True;
                          Fixed_X_Size := false;
                          s := Copy(s,3,length(s)-2);
                          Val(s,idummy,ind);
                          if ind <> 0 then begin
                            Fixed_Y_size := false;
                            Option_Error := True;
                          end else y_size := idummy *1.0;
                        end;
                  'r' : begin
                          RandDefault := False;
                          s := Copy(s,3,length(s)-2);
                          Val(s,idummy,ind);
                          if ind <> 0 then begin
                            RandDefault := True;
                            Option_Error := True;
                          end else Rand := idummy *1.0;
                        end;
                  else Option_Error := True; { nur -  }
                 end;
              end; 
          else PLDFileName:=s;
      end { Case }
    end; {if}

    if Option_Error then
    begin
      Writeln('inadmissible option : ', ParamStr(i) );
      halt;
    end;
  end;  { For }

  if PLDFileName='' then begin
    writeln;
    writeln('PLDV by Andreas Goerg / Erich Hartmann (Version: 10.12.2002)');
    writeln('for PLD-files version >=1.0 ');
    writeln('call: PLDV {PLD-file-name} [-p{ps,eps}] [-o{file}] [-z{%}] [-a]');
    writeln('                                 [-x{width}] [-y{height}] [-r{border}] ');
    writeln(' -p : a ps/eps-file is generated with the same name as the pld-file');
    writeln('      or the name specified in -o.... ');
    writeln(' -z : zoom (per cent) ');
    writeln(' -a : adjust the drawing area ');
    writeln(' -x : drawing scaled to {width} mm ');
    writeln(' -y : drawing scaled to {height} mm ');
    writeln(' -m : (monochrome) ignoring colors');
{    writeln(' -q : keine Grafikausgabe');}      
    writeln(' -r : border width= {border} mm around the drawing'); 
    halt;
  end;  

   if (not newname) and (Postscript) then
   begin
       s:= Copy(pldfilename,1,length(pldfilename)-3);
       if eps then s:= s+'eps' else s:= s+'ps';
       psfilename:= s; 
   end; 

  writeln('PLDV: A Postscript-file ',PSFileName, ' is generated');
    
  assign(PLDFile,PLDFilename);
  reset(PLDFile);

  Readln(PLDFile,s);
  if s <> 'Ver1.0' then 
  begin
    Writeln('This PLD-File is not of version >= Ver 1.0');
    halt;
  end;  
  
  xnullp := 0;
  ynullp := 0;

  if AutoScale or Fixed_X_Size or Fixed_Y_Size then
  begin
    Read(PLDFile,breite,hoehe);
    anfang := True;
    repeat
      Read(PLDFile,C);
      Case C of
      'P' : begin
              Read(PLDFile,x1,y1,ind);
              if anfang then
              begin
                xmax := x1; xmin := xmax;
                ymax := y1; ymin := ymax;
                anfang := false;
              end
              else
              begin
                if x1 > xmax then xmax := x1;
                if x1 < xmin then xmin := x1;
                if y1 > ymax then ymax := y1;
                if y1 < ymin then ymin := y1;
              end;
            end;
      'L' : begin
              Read(PLDFile,x1,y1,x2,y2,ind);
              if anfang then
              begin
                xmax := x1; xmin := xmax;
                ymax := y1; ymin := ymax;
                anfang := false;
              end
              else
              begin
                if x1 > xmax then xmax := x1;
                if x1 < xmin then xmin := x1;
                if y1 > ymax then ymax := y1;
                if y1 < ymin then ymin := y1;
                if x2 > xmax then xmax := x2;
                if x2 < xmin then xmin := x2;
                if y2 > ymax then ymax := y2;
                if y2 < ymin then ymin := y2;
              end;
            end;
      'K' : begin
              Read(PLDFile,anz,ind);
              for i:= 1 to anz do 
              begin
                Read(PLDFile,x1,y1);
                if anfang then
                begin
                  xmax := x1; xmin := xmax;
                  ymax := y1; ymin := ymax;
                  anfang := false;
                end
                else
                begin
                  if x1 > xmax then xmax := x1;
                  if x1 < xmin then xmin := x1;
                  if y1 > ymax then ymax := y1;
                  if y1 < ymin then ymin := y1;
                end;
              end;                      
            end;
    end;
    until (C = '*') or EOF(PLDFile);

    Reset(PLDFile);
    Readln(PLDFile,s);

    Breite := (xmax-xmin)/pt_per_mm;
    Hoehe  := (ymax-ymin)/pt_per_mm;
    xnullp := -xmin/pt_per_mm;
    ynullp := -ymin/pt_per_mm;

    if RandDefault then Rand := 3;

  end
  else
  begin
    if RandDefault then Rand := 0;
  end; 

  if Fixed_Y_Size then  faktor := pt_per_mm*y_size/(ymax-ymin);
  if Fixed_X_Size then  faktor := pt_per_mm*x_size/(xmax-xmin);

   ps_graph_on(PSFilename,eps);
  
  if AutoScale or Fixed_X_size or Fixed_Y_Size then Read(PLDFile,r,r)
                                               else Read(PLDFile,breite,hoehe);
    ps_Draw_Area(breite*faktor+2*Rand,hoehe*faktor+2*Rand,0,0,eps);  

  repeat
    Read(PLDFile,C);
    Case C of
    'P' : begin
            Read(PLDFile,x1,y1,ind); remapx(x1); remapy(y1);
            ps_pointc2d(x1,y1,ind);
          end;
    'L' : begin
            Read(PLDFile,x1,y1,x2,y2,ind); remapx(x1); remapy(y1); remapx(x2); remapy(y2);
            ps_linec2d(x1,y1,x2,y2,ind);
          end;
    'K' : begin
            Read(PLDFile,anz,ind);
            for i:= 1 to anz do 
            begin
              Read(PLDFile,x1,y1); remapx(x1); remapy(y1);
              put2d(x1,y1,p[i-1]);
            end;
            ps_curve2d(p,0,anz-1,ind);
            end;
    'C' : begin
            Read(PLDFile,color);
            if not mono then
            begin
              ps_new_color(color);
            end;
          end;
    'W' : begin
            Read(PLDFile,i);
            ps_new_linewidth(i/10.0);
          end;
    end;
  until (C = '*') or EOF(PLDFile);

  ps_Draw_end;            
  ps_Graph_Off;  

{Show psfile:}
   s:= 'gv '; s:= s+psfilename;  
   writeln('### display: ',s);
   {* shell(s); *}
   fpSystem(s);

end.

