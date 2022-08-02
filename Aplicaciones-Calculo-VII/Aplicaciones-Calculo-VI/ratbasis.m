function [rA,nA]=ratbasis(A)
%RATBASIS Range Space Basis and Null Space Basis.
% [R,N]=RATBASIS(A) returns rational basis sets for the
% range space of A in R and the null space in N.
%
% This function is meant for academic exercises only. An error
% is returned if the elements of A are not rational numbers
% as determined by the function RAT.
%
% See also RREF, NULL, ORTH

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/15/02

[na,da]=rat(A);
if ~isequal(A,na./da)
   error('A Must Contain Rational Elements.')
end
[m,n]=size(A);
[R,pc]=rref(A);
% rational null space code from NULL function
rnk=length(pc);
npc=1:n;
npc(pc)=[];
nA=zeros(n,n-rnk);
if n>rnk
   nA(npc,:)=eye(n-rnk);
   if rnk>0
      nA(pc,:)=-R(1:rnk,npc);
   end
end
rA=A(:,pc);
