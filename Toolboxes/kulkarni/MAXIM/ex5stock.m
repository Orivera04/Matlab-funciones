function P = ex5stock(L,U);
%P = ex5stock(L,U)
%L = lower support value;
%U = upper support value;
%a = pmf of stock fluctuation;
%P = tr pr matrix for the stockmarket example.
if L < 0 | fix(L) - L ~= 0
msgbox('invalid value for L');P='error';return;
elseif  U < L | fix(U) - U ~= 0
msgbox('invalid value for U');P='error';return;
else
d=U-L+1;
P = zeros(d,d);
P = .2*(diag(ones(d,1),0)+diag(ones(d-1,1),-1)+diag(ones(d-2,1),-2)+diag(ones(d-1,1),1)+diag(ones(d-2,1),2)) ;
P(1:2,1)=[.6 .4]';
P(d-1:d,d)=[.4 .6]';

end;
