function [p,fval,xflag]=mmnlfit2(x,y,z,fun,po,options)
%MMNLFIT2 2D Nonlinear Curve Fitting. (MM)
% P=MMNLFIT2(X,Y,Z,FUN,P0,OPTIONS) fits the data in X, Y, and Z
% in a least squares sense to the function described by FUN.
% FUN is a function handle or a function M-file that evaluates FUN(X,Y,P).
% MMNLFIT2 solves:
%                 min ||Z - FUN(X,Y,P)||^2
%                  P
% X and Y are vectors of independent variables or they are plaid
% matrices (such as returned by MESHGRID). FUN(X,Y,P) must return
% an array the same size as Z. Z is usually a matrix whose (i)th row
% is associated with the (i)th element of Y and whose (j)th column
% is associated with the (j)th element of X. P is a vector of
% parameters to be determined and P0 is the initial guess.
%
% MMNLFIT2 calls the standard MATLAB function FMINSEARCH to perform
% the minimization. OPTIONS is an optional structure as used by
% FMINSEARCH.
%
% [P,E,XFLAG]=MMNLFIT2(...) in addition returns the sum of the squared
% errors of the fit in E and the logical scalar XFLAG which is True if
% FMINSEARCH terminated properly.
%
% See also MMNLFIT, FMINSEARCH, FEVAL.

% Calls: mmnlfit_

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/14/96, v5: 1/14/97, 4/14/99, 5/16/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<6, options=[]; end
sz=size(z);
zf=feval(fun,x,y,po);
sf=size(zf);
if any(sz-sf)
   error('Z and FUN(X,Y,P) Must be the Same Size.')
end

[p,fval,xflag]=fminsearch('mmnlfit_',po,options,x,y,z,fun);

if xflag~=1
   warning('Maximum Number of Iterations Reached. Solution Questionable.')
end