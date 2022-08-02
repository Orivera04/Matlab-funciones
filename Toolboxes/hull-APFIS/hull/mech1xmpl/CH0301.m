af=[deg2xy([(-45),10,2,2])];
unknowns=[0,0,0;DR(90),0,0;DR(150),2,4];
solution=threevector(af,unknowns)
showvect([af;solution]);
