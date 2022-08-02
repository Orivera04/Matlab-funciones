function yp=fopc_b(t,y,flag,tu,u,ts,s,name,np)
% Subroutine for FOPC; backward integ. of adjoint eqns  
% and Qg=int(HuPhi*HuPhi')dt;            8/97, 7/16/02
%
[dum,ns]=size(s); la=formm(y([1:np*ns]),ns);
u1=interp1(tu,u,t); s1=interp1(ts,s,t);
[fs,fu]=feval(name,u1,s1,t,3);
HuPhi=la'*fu; Qgd=-HuPhi*HuPhi'; lad=-fs'*la;
yp=[formm(lad,'c'); forms(Qgd)];


