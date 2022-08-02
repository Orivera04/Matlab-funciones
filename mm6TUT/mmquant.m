function [xq,b]=mmquant(x,n,xmin,xmax)
%MMQUANT Quantize Input Values. (MM)
% Xq=MMQUANT(X,N,Xmin,Xmax) or Xq=MMQUANT(X,N,[Xmin Xmax])
% quantizes the array X to N levels between Xmin and Xmax.
%
% If Xmin and Xmax are not given, Xmin=0 and Xmax=1 are used.
% Values in X less than Xmin are set to Xmin.
% Values in X greater than Xmax are set to Xmax.
%
% [Xq,B]=MMQUANT(...) in addition returns the bin number B for each element
% in X. B=0 when X=Xmin, B=N-1 when X=Xmax.

% Calls: mmlimit

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/20/97, 5/8/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<3
   xmin=0; xmax=1;
elseif nargin==3 & length(xmin)>1
   xmax=xmin(2);
   xmin=xmin(1);
elseif nargin~=4
   error('Incorrect Number of Input Arguments.')
end
if n<2, error('N Must be Greater than 1.'), end

xq=mmlimit(x,xmin,xmax);

delta=abs(xmax-xmin)/(n-1);

bb=floor((xq-xmin)/delta+1/2);
xq=delta.*bb + xmin;

if nargout==2
   b=bb;
end
