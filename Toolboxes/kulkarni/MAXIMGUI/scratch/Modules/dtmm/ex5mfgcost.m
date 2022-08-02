function c = ex5mfgcost(A,B,a1,a2,r,du,hA,hB);

% Returns vector of expected one period cost in state i
% Usage:  A = size of bin for machine 1;
%         B = size of bin for machine 2;
%         a1 = prob(non-defective) for machine 1;
%         a2 = prob(non-defective) for machine 2.
%         r = revenue from an assembled unit.
%         du = cost of turning on a machine.
%         hA = cost of holding an item in bin A.
%         hB = cost of holding an item in bin B.

c = zeros(A+B+1,1);
c(1) = hB*B - r*a1 + du*a1;

for i=2:B
  c(i) = hB*(B+1-i) - r*a1;
end;

c(B+1) = -r*a1*a2;

for i = B+2:A+B
  c(i) = hA*(i-B-1) - r*a2;
end;

c(A+B+1) = hA*A - r*a2 + du*a2;


