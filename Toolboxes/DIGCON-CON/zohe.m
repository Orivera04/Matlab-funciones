function [phi,gamma]=zohe(A,b,T,D);
%ZOHE	Zero-order-hold equivalent discrete-time model of an analog system.
%	[phi,gamma]=zohe(A,b,T) computes the discrete-time, state-space
%	system (phi,gamma) given an analog system (A,b) and sampling interval
%	T. (phi,gamma) is an exact model for the cascade of the following three
%	systems:                    .
%	a D/A converter, the system x = Ax + bu, and an A/D  converter.
%	This function implements equation (4.14) of the book ``Digital
%	Control: A State-Space Approach.''
%
%	[phi,gamma]=zohe(A,b,T,Ds).  The number Ds is an optional value of time delay. 
%	If Ds is omitted, it will be set to zero.
%	Time delay may only be modeled for single-input systems.

%  R.J. Vaccaro 10/93,11/98

[n,p]=size(b);

expm(T*[A b;zeros(p,n+p)]);
phi=ans(1:n,1:n);
gamma=ans(1:n,n+1:n+p);
if nargin==3,return,end
if D<=0
   fprintf('\nThe time delay must be a positive real number in ZOHE.\n'),
   phi=[];gamma=[];
   return,
end
if p>1
   fprintf('\nZOHE can model time delay only for single-input systems.\n')
   phi=[];gamma=[];
   return
end

q=floor(D/T);
if round(D/T)==D/T
   q=q-1;
   gamma1=gamma;
   gamma0=0*gamma;
else
   gam=D-q*T;
   expm((T-gam)*[A b;zeros(p,n+p)]);
   gamma0=ans(1:n,n+1:n+p);
   gamma1=gamma-gamma0;
end

if q==0
   phi=[phi gamma1;zeros(1,n+1)];
   gamma=[gamma0;1];
 else   
   phi=[phi gamma1 gamma0 zeros(n,q-1);....
       zeros(q,n+1) eye(q);zeros(1,n+q+1)];
   gamma=[zeros(n+q,1);1];
 end
  
