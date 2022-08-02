function p = psubst(p1,p2)
%PSUBST Solve p1 o p2
%   PSUBST(p1,p2) returns the polynomial coefficients for p1 o p2, i.e.
%   returns p2 subsituted for the variable of p1. The resulting
%   vector is length (LENGTH(p1)-1)*(LENGTH(p2)-1)+1.
%
%   For example:
%     p1=f(y),     p2=f(x) ==> PSUBST(p1,p2)=p1(p2(x))
%     p1=y^2+4y+6, p2=x+1  ==> PSUBST(p1,p2)=x^2+6x+11

%   J.D. Hol & J.O. Enzinger
%   Freeware (send applepies to: 
%                University of Twente
%                Faculty of Constructing Science
%                Department of Mechanical engeneering
%                Postbus 217
%                7500 AE Enschede
%                The Netherlands)
%   $Revision: 1.01 $  $Date: 2001/12/14 23:24:25 MET $

o1=(length(p1)-1);
o2=(length(p2)-1);
o=o1*o2;
p=zeros(1,o+1);
p(end)=p1(end);
q=1;
for i=1:o1
   q=conv(q,p2);
   p=p+[zeros(1,o-o2*i) q*p1(o1+1-i)];
end