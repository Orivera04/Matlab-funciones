function P = ex5tel(K,a);

%Output:  P = tr pr matrix for the telecommunication example.
%Usage:  K = capacity of the buffer.
%        a = pmf of the arrivals in one time slot.

P = a(1)*diag(ones(K,1),-1);
si = size(a);

for i=0:min(K,si(2)-2)
  P = P+a(i+2)*diag(ones(K-i+1,1),i);
end;

P(1,1:min(K+1,si(2))) = a(1:min(K+1,si(2)));
P(:,K+1) = 0;
x = sum(P');
P(:,K+1) = 1 - x';

