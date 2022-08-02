function P =ex5tel(K,a);
%K = capacity of the buffer.
%a = pmf of the arrivals in one time slot.
%P = tr pr matrix for the telecommunication example.
if  K < 0 | fix(K) - K ~= 0
msgbox('invalid entry for K');P='error';return;
elseif  any(a < 0) | sum(a) >1.0
msgbox('invalid entry for a');P='error';return;
else
P=a(1)*diag(ones(K,1),-1);
si=size(a);
for i=0:min(K,si(2)-2)
P=P+a(i+2)*diag(ones(K-i+1,1),i);
end;
P(1,1:min(K+1,si(2))) = a(1:min(K+1,si(2)));
P(:,K+1)=0;
x=sum(P');
P(:,K+1) = 1 - x';
end;
