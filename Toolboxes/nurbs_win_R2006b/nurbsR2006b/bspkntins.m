function bspkntins
% 
% Function Name:
% 
%   bspkntins - Insert knots into a univariate B-Spline.
% 
% Calling Sequence:
% 
%   [ic,ik] = bspkntins(d,c,k,u)
% 
% Parameters:
% 
%   d	: Degree of the B-Spline.
% 
%   c	: Control points, matrix of size (dim,nc).
% 
%   k	: Knot sequence, row vector of size nk.
% 
%   u	: Row vector of knots to be inserted, size nu
% 
%   ic	: Control points of the new B-Spline, of size (dim,nc+nu)
% 
%   ik	: Knot vector of the new B-Spline, of size (nk+nu)
% 
% Description:
% 
%   Insert knots into a univariate B-Spline. This function provides an
%   interface to a toolbox 'C' routine.
