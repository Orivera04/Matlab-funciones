function v=mmvolume(x,y,z)
%MMVOLUME Cummulative Volume Integral Using Trapezoidal Rule. (MM)
% V=MMVOLUME(X,Y,Z) computes the cummulative integral of the function
% z=f(x,y) as tabulated in X,Y, and Z.
% X and Y can be plaid matrices, e.g., created by MESHGRID
% or they can be vectors defining the x and y axes.
%
% V(i,j) is the volume under Z from x(1) to x(j) and y(1) to y(i).
% V(end) is the total volume under f(x,y).
%
% MMVOLUME(Z) computes the integral assumming that X=1:size(Z,2) and
% Y=1:size(Z,1)

% D.C. Hanselman, University of Maine, Orono ME,  04469-5708
% 2/17/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1  % MMVOLUME(Z)
   z=x;
   x=1:size(z,2);
   y=1:size(z,1);
elseif nargin~=3
   error('Incorrect Number of Input Arguments.')
end
sx=size(x);
sy=size(y);
sz=size(z);
if all(sx==sz), x=x(1,:); end		% get x-axis vector
if all(sy==sz), y=y(:,1); end		% get y-axis vector

v=zeros(size(z));
[dx,dy]=meshgrid(diff(x),diff(y));

n=1:sz(1)-1; s=2:sz(1);  % indices for trapezoidal rule
w=1:sz(2)-1; e=2:sz(2);

v(s,e)=dx.*dy.*(z(n,w)+z(n,e)+z(s,w)+z(s,e))/4;
v=cumsum(cumsum(v,1),2);

