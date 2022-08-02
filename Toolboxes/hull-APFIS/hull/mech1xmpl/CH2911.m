Strains=[25 0 35]*1e-6;
Angles=DR([0 45 90]);
StrainState=rosette(Strains,Angles);
E=matprop('aluminum','E','SI')*1e9;
v=matprop('aluminum','Poissons','SI');
StressState=strain2stress(StrainState,E,v)
radius=0.03; %meters
thickness=0.001e-3;

PressureAxial=StressState(1)*2*thickness/radius
PressureHoop=StressState(2)*thickness/radius

Pressure=mean([PressureAxial PressureHoop])
