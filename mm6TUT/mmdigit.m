function y=mmdigit(x,n,b,t)
%MMDIGIT Round Values to Given Significant Digits. (MM)
% MMDIGIT(X,N,B) rounds array X to N significant places in base B.
% If B is not given, B=10 is assumed.
% If X is complex the real and imaginary parts are rounded separately.
% MMDIGIT(X,N,B,'fix') uses FIX instead of ROUND.
% MMDIGIT(X,N,B,'ceil') uses CEIL instead of ROUND.
% MMDIGIT(X,N,B,'floor') uses FLOOR instead of ROUND.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 4/20/96, v5: 1/13/97, v5.3: 5/14/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2
   error('Not enough input arguments.')
elseif nargin==2
   b=10;
   t='round';
elseif nargin==3
   t='round';
end
n=round(abs(n(1)));
if isempty(b), b=10;
else           b=round(abs(b(1)));
end

if isreal(x)
   y=abs(x)+(x==0);
   e=floor(log(y)./log(b)+1);
   p=repmat(b,size(x)).^(n-e);
   if strncmpi(t,'round',1)
      y=round(p.*x)./p;
   elseif strncmpi(t,'fix',2)
      y=fix(p.*x)./p;
   elseif strncmpi(t,'ceil',1)
      y=ceil(p.*x)./p;
   elseif strncmpi(t,'floor',2)
      y=floor(p.*x)./p;
   else
      error('Unknown rounding requested')
   end
else % complex input
   y=complex(mmdigit(real(x),n,b,t),mmdigit(imag(x),n,b,t));
end