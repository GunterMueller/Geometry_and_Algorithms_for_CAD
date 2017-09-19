UNIT hiddenl;

INTERFACE

USES GEOGRAPH;
{************************}
{***  h i d d e n l ***}
{************************}

{fuer Hiddenline:}

const {Achtung: es muss  array_size>=nfmax  sein  !!!}
       nfmax= 10000;  nemax=20000;    nsegmax=10;  npfmax=10;

type   vts2d_pol  = array[0..npfmax] of vt2d;
       vts3d_pol  = array[0..npfmax] of vt3d;
       r_array_seg  = array[0..nsegmax] of real;
       i_array_seg  = array[0..nsegmax] of integer;
       box3d_dat = record
                   xmin,xmax,ymin,ymax,zmin,zmax : real;
                   end;
       face_dat = record
                  npf,nef : integer;
                  fp,fe : array[1..npfmax] of integer;
                  vis : boolean;
                  box : box3d_dat;
                  discentre,d : real;
                  nv : vt3d;
                  end;
       edge_dat = record
                  vis : boolean;
                  ep1,ep2,color,linew : integer;
                  end;

var    ne,nf,np: integer;  {Anzahl der Kanten, Facetten,Punkte}
       p    : vts3d;       {Punkte des Polyeders} 
       face : array[1..nfmax] of face_dat;
       edge : array[1..nemax] of edge_dat;
       pdist: r_array;     {pdist[i]: Abstand d. i-ten Punktes von d. Bildeb.} 
       error,oriented_faces,is_permitted,newstyles: boolean;
{$i include/head_zpo.pas}

IMPLEMENTATION

{$i include/proc_zpo.pas}

END. {of IMPLEMENTATION}
