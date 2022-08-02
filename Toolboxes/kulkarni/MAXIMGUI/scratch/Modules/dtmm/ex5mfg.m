function P = ex5mfg(A,B,a1,a2);

%Output: P = tr. pr matrix for the manufacturing system of Example 5.7.
%Usage: A = size of bin for machine 1;
%       B = size of bin for machine 2;
%       a1 = prob(non-defective) for machine 1;
%       a2 = prob(non-defective) for machine 2.

P = zeros(A+B+1, A+B+1);
P = (1-a1)*a2*diag(ones(A+B,1),-1) + (a1*a2 + (1-a1)*(1-a2))*eye(A+B+1,A+B+1) + (1-a2)*a1*diag(ones(A+B,1),1);
P(1,1) = 1-a1;P(1,2)=a1;
P(A+B+1,A+B+1) = 1-a2;
P(A+B+1,A+B) = a2;


