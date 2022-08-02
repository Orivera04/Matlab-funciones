% Script p9_3_02.m; min time to x=v=0 for double integrator
% plant with bounded control;                   7/98, 3/31/02
%
v=-[0:.01:1]; x=v.^2/2; un=ones(1,101); tf=1; vt=[-1:.02:1]; 
xt=-tf^2*un/2+(vt-tf*un).^2/4; xt1=tf^2*un/2-(vt+tf*un).^2/4;
%
figure(1); clf; plot(x,v,-x,-v,'b',0,0,'ro',-un+x,v,'b',...
   -un+x,-v,'b',un-x,v,'b',un-x,-v,'b',xt,vt,'r--',...
   xt1,vt,'r--'); grid; axis([-1 1 -1 1])
xlabel('Ax'); ylabel('v'); text(.25,.1,'At_f=1')