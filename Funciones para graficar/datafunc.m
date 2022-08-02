function [ubot,utop,ulft,urht,a,b,...
      nx,ny,N]=datafunc
%  
% [ubot,utop,ulft,urht,a,b,...
%         nx,ny,N]=datafunc
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This is a sample data case which can be 
% modified to apply to other examples
a=3; b=2; e=1e-5; N=100;
x=linspace(0,1,201)'; s=sin(pi*x);
c=cos(pi*x); ubot=[a*x,2-4*s];
utop=[a*x,interp1([0,1/3,2/3,1],...
      [-2,2,2,-2],x)];
ulft=[b*x,2*c]; urht=ulft; nx=51; ny=31;