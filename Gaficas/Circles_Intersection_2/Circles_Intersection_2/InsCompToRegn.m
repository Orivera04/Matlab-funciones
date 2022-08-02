function RR=InsCompToRegn(c,R); % tested
S=size(c,2);
m=R(1,1);
if m==0,
  RR=[[1 3;-2 S+2] c];
else
  K=R(2,m+1);
  RR=[[m+1;-1] R(:,2:m+1)+1 [K+2;K+S+1] R(:,m+2:K) c];
end;