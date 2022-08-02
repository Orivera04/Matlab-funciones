StressStateR=[200,0,120];
StressStateS=[-240,-150,-180];
PrincipleStressR=pristress(StressStateR,'plane stress')
PrincipleStressS=pristress(StressStateS,'plane stress')
PrinciplePlanesR=ppstress(StressStateR)
PrinciplePlanesS=ppstress(StressStateS)
RD(PrinciplePlanesR)
RD(PrinciplePlanesS)
