function [a0,a1,a2]=mmfill(x,y,a3,a4,a5,a6)
%MMFILL Fill Plot of Area Between Two Curves. (MM)
% MMFILL(X,Y,Z,C,LB,UB) plots y=f(x) and z=g(x) and fills the
% area between the two curves from LB<= X <=UB with colorspec C.
% X,Y and Z are data vectors of the same length.
% Missing arguments take on default values. Examples:
% MMFILL(X,Y) fills area under y=f(x) with red.
% MMFILL(X,Y,C) fills area under y=f(x) with colorspec C.
% MMFILL(X,Y,Z) fills area between y=f(x) and z=g(x) with red.
% MMFILL(X,Y,Z,C) fills area between y=f(x) and z=g(x) with C.
% MMFILL(X,Y,LB,UB) fills area under y=f(x) in red between bounds.
% MMFILL(X,Y,C,LB,UB) fills area under y=f(x) with C between bounds.
% MMFILL(X,Y,Z,LB,UB) fills area between curves with red between bounds.
%
% A=MMFILL(...) returns the approximate area filled by calling TRAPZ.
% [Hl,Hp]=MMFILL(...) returns handles to the two lines in Hl and
%                       a handle to filled patch in Hp.
% [A,Hl,Hp]=MMFILL(...) returns the area and the handles.
%
% See also AREA

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/23/95, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==2                  % mmfill(x,y)
   z=zeros(size(x));c=[1 0 0];lb=-inf;ub=inf;
elseif nargin==3
   lb=-inf; ub=inf;
   if length(a3)==length(x)  % mmfill(x,y,z)
      z=a3; c=[1 0 0];
   else                      % mmfill(x,y,c)
      z=zeros(size(x)); c=a3;
   end
elseif nargin==4
   if length(a3)==length(x)  % mmfill(x,y,z,c)
      z=a3; c=a4; lb=-inf; ub=inf;
   else                      % mmfill(x,y,lb,ub)
      z=zeros(size(x)); c=[1 0 0]; lb=a3; ub=a4;
   end
elseif nargin==5
   if length(a3)~=length(x)  % mmfill(x,y,c,lb,ub)
      z=zeros(size(x)); c=a3; 
   else                      % mmfill(x,y,z,lb,ub)
      z=a3; c=[1 0 0]; lb=a4; ub=a5;
   end
elseif nargin==6              % mmfill(x,y,z,c,lb,ub)
   z=a3; c=a4; lb=a5; ub=a6;
else
   error('Incorrect number of input arguments.')
end
x=x(:)';	y=y(:)';	z=z(:)';  % make into row vectors

i=find(x>=lb&x<=ub);  % find values between bounds
xp=[x(i) fliplr(x(i))]; % x-axis vertices
yp=[y(i) fliplr(z(i))]; % y-axis vertices

Hl=plot(x,y,'w',x,z,'w');
hold on
Hp=fill(xp,yp,c);
hold off
if nargout==1,		a0=trapz(xp,yp);
elseif nargout==2,	a0=Hl; a1=Hp;
elseif nargout==3,	a0=trapz(xp,yp); a1=Hl; a2=Hp;
end
