function y=ctmcfpt(T,R);
% y=ctmcfpt(T,R)
%R is a rate matrix of a CTMC (0 diagonal entries).
%T is a vector of target states.
% Output [NT y(1) y(2)]  = the [non-target states,  mean,   second moment] of the first passage time into
% any state in $T$, starting from states not in T.
y=checkR(R);
if y(1,1) ~= 'error'
d = sum(R');
Q = R;
m=size(Q);
for i = 1:m(1)
Q(i,i) = -d(i);
end;
s=size(T);
Q(T,:)=[];
Q(:,T)=[];
NT =[1:m(1)];
NT(T)=[];
y1=-Q\ones(m(2)-s(2),1);
y2=-Q\(2*y1);
y=[NT' y1 y2];
end;
