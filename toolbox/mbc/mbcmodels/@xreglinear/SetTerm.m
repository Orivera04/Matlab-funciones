function m=SetTerm(m,i,s)
%SETTERM
%
%  M=SETTERM(M, IND, INVECT)
%
%  INVECT= 0/1 vector.  Only settings which are consistent with the term 
%  status will be accepted.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:09 $

if length(i)>1 & length(s)==1
   s=repmat(s,length(i),1);
end
allwd=(m.TermStatus(i)==3) | (m.TermStatus(i)==2 & s==0) | (m.TermStatus(i)==1 & s==1);
m.TermsOut(i(allwd))= ~s(allwd);