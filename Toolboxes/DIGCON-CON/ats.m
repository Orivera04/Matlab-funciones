function [phia,gammaa,L1,L2]=dts(A,b,c,sroots1,sroots2);
%DTS	Digital tracking system design.
%	[phia,gammaa,L1,L2]=dts(A,b,c,sroots1,sroots2) designs a
%	full-state feedback analog tracking system for a plant whose
%	state-space model is (phi,gamma,c).  The vector sroots1 contains
%	s-plane pole locations for desired additional dynamics.  The vector
%	sroots2  contains desired closed-loop s-plane pole locations for the 
%	design model (cascade of plant and additional dynamics).  
%
%	The function returns (phia,gammaa), a state-space model for the
%	additional dynamics, as well as L1 and L2, partitions of the feedback
%	gains.  If the plant has multiple inputs, ATS automatically replicates
%	the additional dynamics.

%  R.J. Vaccaro  4/02

delta=-poly(sroots1);
delta(1)=[];
gammaa=1;
[m,n]=size(c);
q1=length(gammaa)-1;
phia=[delta [eye(q1);zeros(1,q1)]];
if m>1
  phia=kron(eye(m),phia);
  gammaa=kron(eye(m),gammaa);
end
phid=[A zeros(n,(q1+1)*m);gammaa*c phia];
gammad=[b;zeros(length(gammaa(:,1)),length(b(1,:)))];
L=fbg(phid,gammad,sroots2);
L1=L(:,1:n);
L2=L(:,n+1:n+(q1+1)*m);
return
