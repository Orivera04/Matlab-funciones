function [pn,Pn]=mmrwpfit(x,y,nw,p,P)
%MMRWPFIT Recursive Weighted Polynomial Curve Fitting. (MM)
% [p,P]=MMRWPFIT(x,y,N,W) finds the polynomial of degree N that fits the
% data y=f(x) in a weighted least squares sense. The weighting vector W
% must have a length equal to x and y, or be a scalar in which case all
% data are given the scalar weight. If not given, W=ones(size(y)).
% W(i) is the weight given to the i(th) data pair, x(i) and y(i).
% If requested, the matrix P contains information for future recursive calls.
%
% [pn,Pn]=MMRWPFIT(xn,yn,Wn,p,P) updates the fitted polynomial using recursive
% least squares given new data pairs xn and yn, where Wn is the weighting
% scalar or vector associated with the new data pairs, and p and P are the
% output from the previous function call. If not given, Wn=ones(size(xn)).
% pn is the updated polynomial and Pn is the updated P matrix.
%
% See also MMRWLS, POLYFIT, POLYVAL.

% Duane Hanselman, University of Maine, Orono, ME,  04469
% 5/17/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

x=x(:);  % make sure x is a column
if nargin<3, error('Not enough input arguments.'), end
if length(nw)==1 & nargin<5  % nonrecursive call
   
   V(:,nw+1)=ones(length(x),1);  % build Vandermonde matrix
   for j=nw:-1:1
      V(:,j)=x.*V(:,j+1);
   end
   if nargin==3, p=ones(size(x)); end  % default weights
   if nargout==1,  pn=mmrwls(y,V,p);      % no recursion
   else,          [pn,Pn]=mmrwls(y,V,p);  % recursion
   end
   pn=pn.';  % polynomials are row vectors
else  % recursive call
   
   if nargin==4, P=p; p=nw; nw=ones(size(x)); end
   n=length(p);
   V(:,n)=ones(length(x),1);  % build Vandermonde matrix
   for j=n-1:-1:1
      V(:,j)=x.*V(:,j+1);
   end
   p=p(:);  % make p a column for mmrwls
   if nargout==1,  pn=mmrwls(y,V,nw,p,P);      % no recursion
   else,          [pn,Pn]=mmrwls(y,V,nw,p,P);  % recursion
   end
   pn=pn.';  % polynomials are row vectors
end
