function a=mmsparea(a,b,c,d)
%MMSPAREA Spline Area. (MM)
% MMSPAREA(X,Y,Xmin,Xmax) uses cubic spline interpolation to fit the
% data in X and Y, then computes the area from Xmin to Xmax.
%
% MMSPAREA(PP,Xmin,Xmax) computes the area under the curve described
% by the cubic spline piecewise polynomial PP from Xmin to Xmax.
%
% min(X) <= Xmin <= max(X) and min(X) <= Xmax <= max(X) is required.
%
% See also MMSPHELP

% Calls mmspint

% D.C. Hanselman, University of Maine, Orono, ME 04469
% v5: 1/29/97, 4/26/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==3
	pp=a; xmin=b; xmax=c;
elseif nargin==4
	pp=spline(a,b);
	xmin=c; xmax=d;
else
	error('Incorrect Number of Input Arguments.')
end
[x,c,l,k]=unmkpp(pp);  % tear apart pp form
if xmin<min(x) | xmin>max(x)
	error('min(X)<=Xmin<=max(X) Required.')
end
if xmax<min(x) | xmax>max(x)
	error('min(X)<=Xmax<=max(X) Required.')
end

ppi=mmspint(pp);
a=mmppval(ppi,[xmin xmax]);
a=a(2)-a(1);
