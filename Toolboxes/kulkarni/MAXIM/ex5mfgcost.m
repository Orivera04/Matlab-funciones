function c = ex5mfgcost(A,B,a1,a2,r,du,hA,hB);
%c = ex5mfgcost(A,B,a1,a2,r,du,hA,hB)
%A = size of bin for machine 1;
%B = size of bin for machine 2;
%a1 = prob(non-defective) for machine 1;
%a2 = prob(non-defective) for machine 2.
%r = revenue from an assembled unit.
%du = cost of turning on a machine.
%hA = cost of holding an item in bin A.
%hB = cost of holding an item in bin B.
% c(i) = expected one period cost in state i.

if  (A < 0) | fix(A) -A ~= 0
msgbox('invalid value for A');P='error';return;
elseif  (B < 0) | fix(B) - B ~= 0
msgbox('invalid value for B');P='error';return;
elseif  (a1 < 0) | (a1 > 1)
msgbox('invalid value for a1');P='error';return;
elseif  (a2 < 0) | (a2 > 1)
msgbox('invalid value for a2');P='error';return;
else
   c=zeros(A+B+1,1);
   c(1)=hB*B-r*a1+du*a1;
      for i=2:B
      c(i) = hB*(B+1-i)-r*a1;
   end;
   c(B+1)=-r*a1*a2;
   for i=B+2:A+B
      c(i) = hA*(i-B-1)-r*a2;
   end;
   c(A+B+1)=hA*A - r*a2 + du*a2;

end;


