function [f,g,H]=slbt2_f(y)               
% Subroutine for Example 1.5.1; sailboat max velocity using FMINCON;
% y=[V Wr al th ps]'; 	                         1/93, 9/96, 4/16/98 
%
V=y(1); f=-V; g=[-1 0 0 0 0]; H=zeros(5);

