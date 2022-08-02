function [phia,gammaa,L1,L2]=dts(phi,gamma,c,zroots1,zroots2);
%DTS	Digital tracking system design.
%	[phia,gammaa,L1,L2]=dts(phi,gamma,c,zroots1,zroots2) designs a
%	full-state feedback digital tracking system for a plant whose
%	ZOH equivalent is (phi,gamma,c).  The vector zroots1 contains
%	z-plane pole locations for desired additional dynamics.  The vector
%	zroots2  contains desired closed-loop z-plane pole locations for the 
%	design model (cascade of plant and additional dynamics).  
%
%	The function returns (phia,gammaa), a state-space model for the
%	additional dynamics, as well as L1 and L2, partitions of the feedback
%	gains.  If the plant has multiple inputs, DTS automatically replicates
%	the additional dynamics.

%  R.J. Vaccaro  6/93

delta=-poly(zroots1);
delta(1)=[];
gammaa=delta';
[m,n]=size(c);
q1=length(gammaa)-1;
phia=[gammaa [eye(q1);zeros(1,q1)]];
if m>1
  phia=kron(eye(m),phia);
  gammaa=kron(eye(m),gammaa);
end
phid=[phi zeros(n,(q1+1)*m);gammaa*c phia];
gammad=[gamma;zeros(length(gammaa(:,1)),length(gamma(1,:)))];
L=fbg(phid,gammad,zroots2);
L1=L(:,1:n);
L2=L(:,n+1:n+(q1+1)*m);
return
