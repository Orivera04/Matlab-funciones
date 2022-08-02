function bspdegelev
% 
% Function Name:
% 
%   bspdegevel - Degree elevate a univariate B-Spline.
% 
% Calling Sequence:
% 
%   [ic,ik] = bspdegelev(d,c,k,t)
% 
% Parameters:
% 
%   d	: Degree of the B-Spline.
% 
%   c	: Control points, matrix of size (dim,nc).
% 
%   k	: Knot sequence, row vector of size nk.
% 
%   t	: Raise the B-Spline degree t times.
% 
%   ic	: Control points of the new B-Spline.
% 
%   ik	: Knot vector of the new B-Spline.
% 
% Description:
% 
%   Degree elevate a univariate B-Spline. This function provides an
%   interface to a toolbox 'C' routine.
