function P = ex5mr(uu,dd,k, r);

%Output P = tr pr matrix for the machine reliability problem.
%Usage: uu = P(up|up); 
%       dd = P(down|down);
%       k = number of machines;
%       r = number of repair persons.

r = min(r,k);
U = diag((1-uu)*ones(k+1,1)) + diag((uu)*ones(k,1),1);
D = diag((1-dd)*ones(k+1,1)) + diag((dd)*ones(k,1),1);
PD = zeros(k+1);
PU = zeros(k+1);
PU(1,:) = [1 zeros(1,k)];
PD(1,:) = [1 zeros(1,k)];

for i=2:k+1
  PU(i,:) = PU(i-1,:)*U;
  PD(i,:) = PD(i-1,:)*D;
end;

for i=0:k
  for j=0:k
    P(i+1,j+1) = 0;
    for m = max([0 j-r j+i-k]):min([i j])
      P(i+1,j+1) = P(i+1,j+1) + PU(i+1,m+1)*PD(min(k-i,r)+1,min(k-i,r)-j+m+1);
    end;
  end;
end;
