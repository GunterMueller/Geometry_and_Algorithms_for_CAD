{**********************************************}
{********* H E A D _ A G  *********************}
{*** Prozedur-Koepfe der Datei proc_ag.pas  ***}
{**********************************************}

function sign(a: real) : integer;
function max(a,b : real) : real;
function min(a,b : real) : real;
procedure change1d(var a,b: real);
procedure change2d(var v1,v2: vt2d);
procedure change3d(var v1,v2: vt3d);
procedure put2d(x,y : real; var v: vt2d);
procedure put3d(x,y,z : real; var v: vt3d);
procedure get3d(v : vt3d; var x,y,z: real);
procedure scale2d(r : real; v: vt2d; var vs: vt2d);
procedure scale3d(r : real; v: vt3d; var vs: vt3d);
procedure scaleco2d(r1,r2 : real; v: vt2d; var vs: vt2d);
procedure scaleco3d(r1,r2,r3 : real; v: vt3d; var vs: vt3d);
procedure sum2d(v1,v2 : vt2d; var vs : vt2d);
procedure sum3d(v1,v2 : vt3d; var vs : vt3d);
procedure diff2d(v1,v2 : vt2d; var vs : vt2d);
procedure diff3d(v1,v2 : vt3d; var vs : vt3d);
procedure lcomb2vt2d(r1: real; v1: vt2d; r2: real; v2: vt2d; var vlc : vt2d);
procedure lcomb2vt3d(r1: real; v1: vt3d; r2: real; v2: vt3d; var vlc : vt3d);
procedure lcomb3vt2d(r1: real; v1: vt2d; r2: real; v2: vt2d;
                                         r3: real; v3: vt2d; var vlc : vt2d);
procedure lcomb3vt3d(r1: real; v1: vt3d; r2: real; v2: vt3d;
                                          r3: real; v3: vt3d; var vlc : vt3d);
procedure lcomb4vt3d(r1: real; v1: vt3d; r2: real; v2: vt3d;
                     r3: real; v3: vt3d; r4: real; v4: vt3d; var vlc : vt3d);
function abs2d(v : vt2d) : real;
function abs3d(v : vt3d) : real;
function length2d(v : vt2d) : real;
function length3d(v : vt3d) : real;
function scalarp2d(p1,p2 : vt2d) : real;
function scalarp3d(p1,p2 : vt3d) : real;
procedure normalize2d(var p: vt2d);
procedure normalize3d(var p: vt3d);
function distance2d(p,q : vt2d): real;
function distance3d(p,q : vt3d): real;
function distance2d_square(p,q : vt2d) : real;
function distance3d_square(p,q : vt3d) : real;
procedure vectorp(v1,v2 : vt3d; var vp : vt3d);
function determ3d(v1,v2,v3: vt3d) : real;
procedure rotor2d(cos_rota,sin_rota : real; p : vt2d; var pr: vt2d);
procedure rotp02d(cos_rota,sin_rota : real; p0,p : vt2d; var pr: vt2d);
procedure rotorz(cos_rota,sin_rota : real; p : vt3d; var pr: vt3d);
procedure rotp0z(cos_rota,sin_rota : real; p0,p: vt3d; var pr: vt3d);
procedure rotp0x(cos_rota,sin_rota : real; p0,p: vt3d; var pr: vt3d);
procedure rotp0y(cos_rota,sin_rota : real; p0,p: vt3d; var pr: vt3d);
function polar_angle(x,y : real) : real;
procedure equation_degree1(a,b :real; var x : real ; var ns : integer);
procedure equation_degree2(a,b,c:real; var x1,x2:real ;var ns:integer);
procedure is_line_line(a1,b1,c1, a2,b2,c2 : real; var xs,ys : real;
                                                  var nis : integer);
procedure is_unitcircle_line(a,b,c: real; var x1,y1,x2,y2 : real;
                                                  var nis : integer);
procedure is_circle_line(xm,ym,r, a,b,c: real; var x1,y1,x2,y2 : real;
                                               var nis : integer);
procedure is_circle_circle(xm1,ym1,r1,xm2,ym2,r2: real;
                                 var x1,y1,x2,y2: real; var nis: integer);
function pt_before_plane(p,nv: vt3d; d: real) : boolean;
procedure plane_equ(p1,p2,p3 : vt3d; var nv : vt3d; var d: real;
                                                      var error : boolean);
procedure is_line_plane(p,rv,nv: vt3d; d : real; var pis : vt3d;
                                                 var nis : integer);
procedure is_3_planes(nv1: vt3d; d1: real; nv2: vt3d; d2: real;
                      nv3: vt3d; d3: real;
                      var pis : vt3d; var error: boolean);
procedure is_plane_plane(nv1: vt3d; d1: real; nv2: vt3d; d2: real;
                             var p,rv : vt3d; var error: boolean);
procedure ptco_plane3d(p0,v1,v2,p: vt3d; var xi,eta: real; var error: boolean);
procedure newcoordinates3d(p,b0,b1,b2,b3: vt3d; var pnew: vt3d);


