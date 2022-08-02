ssa=[12,20,-10];
ssb=[-100,500,-225];
PrincipleStressesA=pristress(ssa,'plane stress')
PrincipleStressesB=pristress(ssb,'plane stress')
PrinciplePlanesA=RD(ppstress(ssa))
PrinciplePlanesB=RD(ppstress(ssb))
