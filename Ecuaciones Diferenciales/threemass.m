function [m,c,k,f1,f2,w,nt,y0,v0]=threemass
%
% [m,c,k,f1,f2,w,nt,y0,v0]=threemass
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function creates data for a three mass
% system. The name of the function should be 
% changed to specify different problems. However,
% the output variable list should remain unchanged
% for compatibility with the data input program. 

m=eye(3,3); k=[2,-1,0;-1,2,-1;0,-1,2]; c=.05*k;

% Data to excite the highest mode
f1=[-1;0;1]; f2=[0;0;0]; w=1.413; nt=1000;

% Data to excite the lowest mode
% f1=[1;1;1]; f2=[0;0;0]; w=.7652; nt=1000;

% Homogeneous initial conditions
y0=[-.5;0;.5]; v0=zeros(3,1); y0=0*y0;