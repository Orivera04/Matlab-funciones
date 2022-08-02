function W=romb(func,a,b,d)
% Implements Romberg integration.
%
% Example call: W=romb(func,a,b,d)
% Integrates user defined function func from a to b, using d stages.
%
T=zeros(d+1,d+1);
for k=1:d+1
  n=2^k; T(1,k)=simp1(func,a,b,n);
end
for p=1:d
  q=4^(p+1);
  for k=0:d-p
     T(p+1,k+1)=(q*T(p,k+2)-T(p,k+1))/(q-1);
  end
end
% for i=1:d+1
%   table=T(i,1:d-i+2); disp(table)
% end
W=T(d+1,1);
