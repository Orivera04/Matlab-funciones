function [Phi,Psi,Phip]=strfun(a,b,z)
%
% [Phi,Psi,Phip]=strfun(a,b,z)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function evaluates the complex
% stress functions Phi(z), and Psi(z)
% as well as the derivative function Phi'(z)
% using series coefficients determined from
% function platecrc. The calculation also
% uses a function polflip defined such that
% polflip(a,z)=polyval(flipud(a(:)),z). 
%
% a,b     - series coefficients defining Phi
%           and Psi
% z       - matrix of complex values
%
% Phi,Psi - complex stress function values
% Phip    - derivative Phi'(z)
%
% User m functions called: polflip
%----------------------------------------------

zi=1./z; np=length(a); a=a(:);
Phi=polflip(a,zi); Psi=polflip(b,zi);
Phip=-polflip((1:np-1)'.*a(2:np),zi)./z.^2;