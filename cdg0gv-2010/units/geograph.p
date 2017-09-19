UNIT geograph;

{SMARTLINK ON}

INTERFACE

USES Unix {linux};
{************************}
{***  g e o g r a p h ***}
{************************}

const {$i include/geoconst.pas}
type  {$i include/geotype.pas}
var   {$i include/geovar.pas}

{$i include/head_geo.pas}
{$i include/head_ag.pas}
{$i include/head_pp.pas}
{ i include/head_ks.pas}
{ i include/head_pks.pas}
{ i include/head_qua.pas}
{ i include/head_pqu.pas}
{$i include/head_zp.pas}

IMPLEMENTATION

{$i include/geoproc.pas}
{$i include/proc_ag.pas}
{$i include/proc_pp.pas}
{ i include/proc_ks.pas}
{ i include/proc_pks.pas}
{ i include/proc_qua.pas}
{ i include/proc_pqu.pas}
{$i include/proc_zp.pas}

END. {of IMPLEMENTATION}
