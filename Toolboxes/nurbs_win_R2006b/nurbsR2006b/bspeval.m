function bspeval
% 
% Function Name:
% 
%   bspeval - Evaluate a univariate B-Spline.
% 
% Calling Sequence:
% 
%   p = bspeval(d,c,k,u)
% 
% Parameters:
% 
%   d	: Degree of the B-Spline.
% 
%   c	: Control Points, matrix of size (dim,nc).
% 
%   k	: Knot sequence, row vector of size nk.
% 
%   u	: Parametric evaluation points, row vector of size nu.
% 
%   p	: Evaluated points, matrix of size (dim,nu)
% 
% Description:
% 
%   Evaluate a univariate B-Spline. This function provides an interface to
%   a toolbox 'C' routine.
