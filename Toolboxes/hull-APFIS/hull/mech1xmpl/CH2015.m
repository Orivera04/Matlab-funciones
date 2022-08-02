StrainStateFF=[500,350,0];
StrainStateGG=[700,460,-400];
PoisonsFF=matprop('titanium','Poissons','SI');
figure(1)
mohrs2(StrainStateFF,'plane strain',PoisonsFF)
figure(2)
mohrs2(StrainStateGG,'plane stress',0.35)
