function [z,zp]=mapsqr(zeta); 
%
% [z,zp]=mapsqr(zeta)
% ~~~~~~~~~~~~~~~~~~~
%
% This function maps the interior of a circle
% onto the interior of a square using a rational 
% function of the approximate form:
%
% z(zeta)=zeta*Sum(a(j)* ...
%         zeta4^(j-1)/(1+Sum(b(j)*zeta4^(j-1))
%
% where zeta4=zeta^4
%
% zeta - matrix of complex values such that 
%        abs(zeta)<=1
% z,zp - matrices of values of the mapping 
%        function and its first derivative
%
% User m functions called:  none
%----------------------------------------------

a=[ 1.07835,  1.37751, -0.02642, -0.09129, ...
    0.13460, -0.15763,  0.07430,  0.14858, ...
    0.01878, -0.00354 ]'; 
b=[ 1.37743,  0.07157, -0.11085,  0.12778, ...
   -0.13750,  0.05313,  0.14931,  0.02683, ...
   -0.00350, -0.000120 ]';

% Evaluate the mapping function
zeta4=zeta.^4; p=zeta.*polyval(flipud(a),zeta4);
q=polyval(flipud([1;b]),zeta4); z=p./q;

% Exit if the derivative of z is not needed
if nargout==1, return, end

% evaluate z'(zeta)
na=length(a); nb=length(b);
pp=polyval(flipud((4*(1:na)'-3).*a),zeta4);
qp=4*zeta.^3.*polyval(flipud((1:nb)'.*b),zeta4);
zp=(q.*pp-p.*qp)./q.^2; 