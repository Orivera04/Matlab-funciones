% Script chkhess.m; checks analytical second derivatives 
% of MAR0 for FOP0N2; s=[r u v]'; u=be;          8/15/02
%
% Analytical derivatives of f;
s=[1.2 .1 .9]'; be=.5; t=0;  
[fs,dum,fss]=mar0(be,s,t,3);
%
% Check 2nd derivatives of f w.r.t. r=s(1):
err=zeros(9,3); d=.0001; s1=s+[d 0 0]'; 
fsd=mar0(be,s1,t,3);
for j=1:3
 err(1,j)=(fsd(1,j)-fs(1,j))/d-fss(1,j);
 err(4,j)=(fsd(2,j)-fs(2,j))/d-fss(4,j);
 err(7,j)=(fsd(3,j)-fs(3,j))/d-fss(7,j);
end
%
% Check 2nd derivatives of f w.r.t. u=s(2):
s2=s+[0 d 0]'; fsd=mar0(be,s2,t,3);
for j=2:3
 err(2,j)=(fsd(1,j)-fs(1,j))/d-fss(2,j);
 err(5,j)=(fsd(2,j)-fs(2,j))/d-fss(5,j);
 err(8,j)=(fsd(3,j)-fs(3,j))/d-fss(8,j);
end
%
% Check 2nd derivatives of f w.r.t. v=s(3):
s3=s+[0 0 d]'; fsd=mar0(be,s3,t,3); j=3;
err(3,j)=(fsd(1,j)-fs(1,j))/d-fss(3,j);
err(6,j)=(fsd(2,j)-fs(2,j))/d-fss(6,j);
err(9,j)=(fsd(3,j)-fs(3,j))/d-fss(9,j);
%
% Analytical derivatives of phi:
[dum,phis,phiss]=mar0(be,s,t,2);
%
% Check 2nd derivatives of phi: 
per=zeros(3); [dum,phisd]=mar0(be,s1,t,2);
for j=1:3
  per(1,j)=(phisd(j)-phis(j))/d-phiss(1,j);
end; [dum,phisd]=mar0(be,s2,t,2); 
for j=2:3
  per(2,j)=(phisd(j)-phis(j))/d-phiss(2,j);
end; [dum,phisd]=mar0(be,s3,t,2); j=3;
  per(3,j)=(phisd(j)-phis(j))/d-phiss(3,j);
  
  