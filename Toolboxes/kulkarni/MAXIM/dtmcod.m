function y = dtmcod(P)
%y = dtmcod(P)
% computes the occupancy distribution of the one step
%probability transition matrix P.
y=checkP(P);
if y(1,1) ~= 'error'
m=size(P);
P=eye(m) -P;
P(:,1) = ones(m(1),1);
y=[1 zeros(1,m(1)-1)]/P;
end;