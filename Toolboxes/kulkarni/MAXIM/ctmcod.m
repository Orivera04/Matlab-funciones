function y=ctmcod(R);
%y=ctmcod(R)
%computes the limiting  distribution of an irreducible CTMC with rate matrix R. 
y=checkR(R);
if y(1,1) ~= 'error'
d = sum(R');
Q = R;
m=size(Q);
for i = 1:m(1)
Q(i,i) = -d(i);
end;
Q(:,1) = ones(m(1),1);
y=[1 zeros(1,m(1)-1)]/Q;
end;