function mmlsim(A,B,C,D,U,T,Xo,Ylim)
%MMLSIM Linear System Simulation Using MMODESS. (MM)
% MMLSIM(A,B,C,D,U,T,Xo,Ylim) plots the response of the state space
% system  .
%         x = Ax + Bu
%         y = Cx + Du
%
% A,B,C,D are the state space matrices of the system as described above.
% The system input is given by the linear interpolation of U and the 
% time vector T. Integration starts at T(1) and ends at T(length(T)).
% For example, U=[1;1] and T=[0 10] applies a single unit step input and
% integrates from 0 to 10 seconds.
% U must have as many columns as there are columns in B and as many rows
% as there are elements in T.
% Xo is a vector of initial conditions.
% Ylim sets the Y axis limits for the plot.
%
% See also MMODESS, MMODEINI, MMPLOTI

% Calls mmodeini mmodess mmploti mminterp mmlsim_

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/11/96, revised 9/19/96, v5: 1/14/97, 2/25/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMLSIM_A MMLSIM_BU

Xo=Xo(:);
T=T(:);
[ra,ca]=size(A);
[rb,cb]=size(B);
[rc,cc]=size(C);
[rd,cd]=size(D);
[ru,cu]=size(U);
xlen=length(Xo);
tlen=length(T);
if ra~=ca, error('A Must be Square.'), end
if ra~=xlen, error('Columns of A Must Equal Length of Xo.'), end
if tlen~=ru, error('Rows of U Must Equal Length of T.'), end
if cc~=xlen, error('Columns of C Must Equal Length of Xo.'), end
if rc~=rd, error('Rows of C Must Equal Rows of D.'), end
if cb~=cd, error('Columns of B Must Equal Columns of D.'), end
if cu~=cb, error('Columns of B Must Equal Rows of U.'), end

mmodeini('reltol',2e-4)  % for integration

mmploti([T(1) T(tlen) Ylim(1) Ylim(2)])  % initialized plot axes

MMLSIM_A=A;
TU=[T U];
t=T(1);  % initial data
X=Xo;
u=U(1,:)';
MMLSIM_BU=B*u;
Xp=feval('mmlsim_',t,X');
Yo=C*X + D*u;
mmploti(t,Yo')  % plot initial conditions

while t<T(tlen)  % integrate
   u=mminterp(TU,1,t);	
   MMLSIM_BU=B*u';
   [t,X,Xp]=mmodess('mmlsim_',t,X,Xp);
   Y=C*X(:) + D*u;
   mmploti(t,Y')
end
mmploti done
