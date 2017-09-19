{geotype.pas:}

       r_array = array [0..array_size] of real;
       i_array = array [0..array_size] of integer;
       b_array = array [0..array_size] of boolean;
       vt2d    = record  x: real;  y: real; end;
       vt3d    = record  x: real;  y: real;  z: real; end;
       vts2d   = array[0..array_size] of vt2d;
       vts3d   = array[0..array_size] of vt3d;
       matrix3d= array[1..3,1..3] of real;
