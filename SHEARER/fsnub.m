function [force]=fsnub(u)
%FSNUB	Compute nonlinear snubber force for snubber simulation
%	
%	Computes mechanical snubber force as a function of 
%	displacement and velocity
%	
%	Companion file for "Dynamic Modeling 
%	and Control of Engineering Systems", 2nd ed. 
%	
%	
%	Arguments:
%	u(1)	Displacement
%	u(2)	Velocity
%	

%	Created: 2/1/96
%	Author:	J.F. Gardner
%	Copyright 1997 by J.F. Gardner
%
%	Define parameters
%
x1=1.0;	% location of snubber
k2=100.0;	% spring constant of snubber
b=10.0;	% damping constant of snubber
%
%  CHeck to see if displacement of
%  mass exceeds the threshold
%
if u(1)<x1 
	force=0.0;
else
	force=k2*(u(1)-x1)+b*u(2);
end;
%
% Check to ensure that the snubber
% force remains nonnegative
%
if force<0  
	force=0;
end;

