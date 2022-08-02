function bspderiv
% 
% Function Name:
% 
%   bspdeval - Evaluate the control points and knot sequence of the derivative
%              of a univariate B-Spline.
% 
% Calling Sequence:
% 
%   [dc,dk] = bspdeval(d,c,k)
% 
% Parameters:
% 
%   d	: Degree of the B-Spline.
% 
%   c	: Control Points, matrix of size (dim,nc).
% 
%   k	: Knot sequence, row vector of size nk.
% 
%   dc	: Control points of the derivative
% 
%   dk	: Knot sequence of the derivative
% 
% Description:
% 
%   Evaluate the derivative of univariate B-Spline, which is itself a B-Spline.
%   This function provides an interface to a toolbox 'C' routine.
