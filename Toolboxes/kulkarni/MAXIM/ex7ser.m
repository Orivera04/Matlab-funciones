function [P,w] = ex7ser(N,v,tau);
%[P,w] = ex7ser(N,v,tau)
%N = number of components.
%v=column vector of length N; v(i)=1/mean up time of component i.
%tau = column vector of length N; tau(i)=mean down time of component i.
P='error';
w='error';
[mv nv]=size(v);
[mtau ntau]=size(tau);
if N < 1 | N - fix(N) ~=0
   msgbox('invalid netry for N'); return;
elseif nv > 1 | mv ~= N 
   msgbox('v must be a column vector of length N');return;
elseif any(v < 0)
   msgbox('invalid entry for v'); return;
elseif ntau > 1 | mtau ~= N
   msgbox('tau must be a column vector of length N');return;
elseif any(tau < 0)
   msgbox('invalid entry for tau'); return;
else
   P= zeros(N+1,N+1);
   P(1,2:N+1) = v'/sum(v);
   P(2:N+1,1)=ones(N,1);
   w=[1/sum(v); tau];
return;
end;