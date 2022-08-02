StressStateHH=[420 0 40]*1e3;
StressStateII=[6 19 74]*1e3;
EHH=matprop('aluminum','E','US');
PoissonsHH=matprop('aluminum','Poissons','US');
EII=matprop('bronze','E','SI');
PoissonsII=matprop('bronze','Poissons','SI');
StrainStateHH=stress2strain(StressStateHH,EHH,PoissonsHH)
StrainStateII=stress2strain(StressStateII,EII,PoissonsII)
