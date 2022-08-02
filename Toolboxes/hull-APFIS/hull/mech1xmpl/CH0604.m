qcordx=25*cos(DR(-17));
qcordy=25*sin(DR(-17));
qload=[0,-420,qcordx,qcordy];
qunknowns(1,:)=[0,0,0];
qunknowns(2,:)=[DR(90),0,0];
qunknowns(3,:)=[DR(76),50*cos(DR(-17)),50*sin(DR(-17))];
qcouple=72;
q=threevector(qload,qunknowns,qcouple)
