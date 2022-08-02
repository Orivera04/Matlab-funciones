function responsevec=Sorder(omega,zeta,gain,Step)
%
%	Utility file called by STEP2.M. 
%
%  Function to return the step response of a second order system
%
%	Omega - Natural Frequency
%	Zeta - Damping Ratio
%	Gain - Gain of the first order system
%	Step - Size of step input
%
%	Returns a vector [t u y] of the response and time, suitable for PLOTIT
%
%	Copyright 1997 by J.F. Gardner
%
endtime=ceil(5/zeta/omega);
delt=endtime/100;
t=[0:delt:endtime]';
StepV(1:101) = ones(101,1)';
StepV=StepV * Step;
if zeta ~= 1
a=zeta/(sqrt(1-zeta*zeta));
end;
b=zeta*omega;
od=omega*sqrt(1-zeta*zeta);
exp_part=exp(-b*t);
if zeta==1 
sin_part=(ones(101,1)+omega*t);
else
sin_part=cos(od*t)+a*sin(od*t);
end;

responsevec=[t StepV' gain*(ones(101,1)-exp_part.*sin_part)];
