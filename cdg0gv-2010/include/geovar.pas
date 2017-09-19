 {geovar.pas:}

       null2d : vt2d;  null3d : vt3d;            {Nullvektoren}
       scalefactor: real;                        

    {**fuer area_2d and curve2d:}
       origin2d  : vt2d;

    {**fuer Parallel- und Zentral-Projektion:}
       u_angle,v_angle,                     {Projektionswinkel}
       rad_u,rad_v,                         {rad(u), rad(v)}
       sin_u,cos_u,sin_v,cos_v : real;      {sin-,cos- Werte von u, v}
       e1vt,e2vt,n0vt : vt3d;               {Basis-Vektoren}
                                            {Normalen-Vektor der Bildebene}
    {**fuer Zentral-Projektion:}
       mainpt,                              {Hauptpunkt}
       centre : vt3d;                       {Zentrum}
       distance : real;                     {Distanz Hauptpunkt-Zentrum}

