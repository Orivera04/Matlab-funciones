function CC=InsLineToComp(l,C); % tested
S=size(l,2);
m=C(1,1);
if m==0,
  CC=[[1 3;-1 S+2] l];
else
  K=C(2,m+1);
  CC=[[m+1;-1] C(:,2:m+1)+1 [K+2;K+S+1] C(:,m+2:K) l];
end;