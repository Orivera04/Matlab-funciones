function [nodes, weights] = gausspoints(nquad)
% GAUSSPOINTS points for Gaussian quadrature 
%
% [nodes, weights] = gausspoints(nquad)
% computes the nodes and weights for Gaussian quadrature with nquad (<=5) quadrature points on 
% the standard interval [-1,1]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:01:57 $


% The coefficients appear on pg 213 of 
% Numerical Mathematics and Computing, Ward Cheney and David Kincaid


switch nquad   
case 1 
   nodes = 0;
   weights = 2;
case 2
   nodes = [-sqrt(1/3) sqrt(1/3)];
   weights = [1 1];
case 3
   nodes = [-sqrt(3/5) 0 sqrt(3/5)];
   weights = [5/9, 8/9, 5/9];
case 4
   nodes = [-sqrt((3+4*sqrt(0.3))/7) -sqrt((3-4*sqrt(0.3))/7)  sqrt((3-4*sqrt(0.3))/7) sqrt((3+4*sqrt(0.3))/7)];
   weights = [0.5-sqrt(10/3)/12, 0.5+sqrt(10/3)/12 , 0.5+sqrt(10/3)/12,  0.5-sqrt(10/3)/12];
case 5   
   nodes = [-sqrt((5+2*sqrt(10/7))/9) -sqrt((5-2*sqrt(10/7))/9) 0 sqrt((5-2*sqrt(10/7))/9) sqrt((5+2*sqrt(10/7))/9)]; 
   weights = [0.3*((0.7+5*sqrt(0.7))/(2+5*sqrt(0.7))), 0.3*((-0.7+5*sqrt(0.7))/(-2+5*sqrt(0.7))) , ...
                128/225, 0.3*((-0.7 + 5*sqrt(0.7))/(-2+5*sqrt(0.7))), 0.3*((0.7 + 5*sqrt(0.7))/(2+5*sqrt(0.7)))];
otherwise
   error('The Gaussian nodes and weights are unknown for this number of quadrature points')
end