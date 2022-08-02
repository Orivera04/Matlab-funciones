function y = ctmcod(R);

% Computes the limiting distribution of an irreducible CTMC with rate matrix R. 

d = sum(R');
Q = R;
m = size(Q);
for i = 1:m(1)
  Q(i,i) = -d(i);
end;

Q(:,1) = ones(m(1),1);
y = [1 zeros(1,m(1)-1)]/Q;