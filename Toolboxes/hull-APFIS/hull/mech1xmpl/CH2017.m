Epsilons=[100 150 45]*1e-6;
Thetas=DR([0 45 90]);
Youngs=matprop('structural steel','E','SI');
Poissons=matprop('structural steel','Poissons','SI');
Angle=DR(30);
StrainState=rosette(Epsilons,Thetas)
PrincipleStrains=pristrain(StrainState,'plane stress')
PrinciplePlanesStrain=ppstrain(StrainState)
NewStrainState=straintr(StrainState, Angle)
figure(1)
mohrs2 (StrainState,'plane stress',Poissons,Angle)
StressState=strain2stress(StrainState,Youngs,Poissons)
PrincipleStresses=pristrain(StressState,'plane stress')
PrinciplePlanesStress=ppstress(StressState)
[NormalStress ShearStress]=stresstr(StressState,Angle)
figure(2)
mohrs(StressState,'plane stress',Angle)
