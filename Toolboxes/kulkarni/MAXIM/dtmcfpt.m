function y=dtmcfpt(T,P);
%y=dtmcfpt(T,P)
%P is a transition probability matrix of a DTMC.
%T is a vector of target states.
% Output [y(0) y(1) y(2)]  = the [i mean  second moment]
% of the first passage time into any states in $T$,
% starting from states i not in  T.
y=checkP(P);
if y(1,1) ~= 'error'   
s=size(P);sx=s(1);
x=[1:sx];
s=size(T);
for i=1:s(2)
x(T(i))=0;
end;
NT=[];
for i=1:sx
if x(i) ~= 0
NT=[NT i];
end;
end;
s=size(NT);
y1=(eye(s(2))-P(NT,NT))\ones(s(2),1);
y2=(eye(s(2))-P(NT,NT))\(2*(y1-ones(s(2),1)));
y=[NT' y1 y2+y1];
end;