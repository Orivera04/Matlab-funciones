function [p,fval,xflag]=mmnlfit(x,y,fun,po,options)
%MMNLFIT Nonlinear Curve Fitting. (MM)
% P=MMNLFIT(X,Y,FUN,P0,OPTIONS) fits the data in X and Y in a
% least squares sense to the function described by FUN.
% FUN is a function handle or a function M-file that evaluates FUN(X,P).
% MMNLFIT solves:
%                 min ||Y - FUN(X,P)||^2
%                  P
% X is a vector of the independent variable. FUN(X,P) must
% return an array the same size as Y. P is a vector of parameters
% to be determined and P0 is the initial guess.
%
% MMNLFIT calls the standard MATLAB function FMINSEARCH to perform
% the minimization. OPTIONS is an optional structure as used by
% FMINSEARCH.
%
% [P,E,XFLAG]=MMNLFIT(...) in addition returns the sum of the squared
% errors of the fit in E and the logical scalar XFLAG which is true if
% FMINSEARCH terminated properly.
% 
% See also MMNLFIT2, FMINSEARCH, FEVAL.

% Calls: mmnlfit_

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/14/96, v5: 1/14/97, 4/14/99, 5/16/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<5, options=[]; end
sy=size(y);
yf=feval(fun,x,po);
sf=size(yf);
if any(sy-sf)
   error('Y and FUN(X,P) Must be the Same Size.')
end

[p,fval,xflag]=fminsearch('mmnlfit_',po,options,x,y,[],fun);

if xflag~=1
   warning('Maximum Number of Iterations Reached. Solution Questionable.')
end