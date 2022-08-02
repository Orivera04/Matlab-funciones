function responsevec=FOrder(Tau,Gain,Step)
%
%  Function to return the step response of a first order system
%
%	Tau - time constant (sec)
%	Gain - Gain of the first order system
%	Step - Size of step input
%
%	Returns a vector [t u y] of the response and time, suitable for PLOTIT
%
%   Utility file to be used with STEP1.M.
%
%	Copyright 1997 by J.F. Gardner
%
endtime=5;
delt=endtime/100;
t=[0:delt:endtime]';
StepV(1:101) = ones(101,1)';
StepV=StepV * Step;
responsevec=[t StepV' Gain*(1-exp(-t/Tau))];
