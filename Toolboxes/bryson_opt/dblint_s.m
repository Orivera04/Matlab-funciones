function sp=dblint_s(t,s,flag,p)
% Subroutine for DBLINT_F & _C; 9/17/02
%
N=length(p); y=s(1); v=s(2); tp=[0:1/(N-1):1]';
a=interp1(tp,p',t); sp=[v a]';
 