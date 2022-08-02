function [exponent, polycoeff] = wendcoeff(m)
% WENDCOEFF 
% Wendland's functions take the form positivepart((1-r)^exponent)*(polynomial in r)
% This function computes the exponent and coefficients of the polynomial, which depend on
% the number of factors, and the continuity of Wendland's function required. Used in wendland.m 
% and in the export to simulink. The formulae are given in 'Radial Basis Functions with Compactly
% Support (sic.) and Multizone Decomposition: Applications to environmental modelling', S. M. Wong, 
% Y.C. Hon, and T.S. Li

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:57:31 $

cont = m.cont;%continuity of Wendland's function (0,2,4, or 6)
nf = nfactors( m );

ell = floor(nf/2) + cont/2 + 1; 

switch cont
   case 0
         exponent = ell;
         polycoeff = 1;
   case 2
         exponent = ell +1;
         polycoeff = [ell+1, 1];
   case 4   
         exponent = ell +2;
         polycoeff = [(ell^2 + 4*ell + 3), (3*ell+6) , 3];
   case 6
         exponent = ell +3;
         polycoeff = [(ell^3 + 9*ell^2 + 23*ell + 15), (6*ell^2 + 36*ell + 45), (15*ell+45) , 15];
end   


   