function P = ex5mfg(A,B,a1,a2);
%P = ex5mfg(A,B,a1,a2)
%A = size of bin for machine 1;
%B = size of bin for machine 2;
%a1 = prob(non-defective) for machine 1;
%a2 = prob(non-defective) for machine 2.
%P = tr. pr matrix for the manufacturing system of Example 5.7.
if  (A < 0) | fix(A) -A ~= 0
msgbox('invalid value for A');P='error';return;
elseif  (B < 0) | fix(B) - B ~= 0
msgbox('invalid value for B');P='error';return;
elseif  (a1 < 0) | (a1 > 1)
msgbox('invalid value for a1');P='error';return;
elseif  (a2 < 0) | (a2 > 1)
msgbox('invalid value for a2');P='error';return;
else
P = zeros(A+B+1, A+B+1);
P = (1-a1)*a2*diag(ones(A+B,1),-1) + (a1*a2 + (1-a1)*(1-a2))*eye(A+B+1,A+B+1) + (1-a2)*a1*diag(ones(A+B,1),1);
P(1,1)=1-a1;P(1,2)=a1;
P(A+B+1,A+B+1) = 1-a2;P(A+B+1,A+B) = a2;
end;


