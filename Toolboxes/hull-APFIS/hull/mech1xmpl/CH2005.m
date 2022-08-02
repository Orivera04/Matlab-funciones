forceH=[76 0 10 0];
pointH=twovector(opp(forceH),[DR(-50),DR(40)]);
shearH=pointH(1,:);
ShearMagH=mag(shearH);
areaH=circle(3.5,'area');
SlantAreaH=csc(DR(50))*areaH;
AverageShearH=ShearMagH/SlantAreaH
