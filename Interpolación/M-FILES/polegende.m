function p=polegende(n)

% p=polegend(n)
% Saves on the rows of the p matrix the coeficients of the legendre polin.

p(1,1)=1;
p(2,1:2)=[1 0]; %??? ¿No debería ser [0 1]???
for k=2:n
   p(k+1,1:k+1)=((2*k-1)*[p(k,1:k) 0]-(k-1)*[0 0 p(k-1,1:k-1)])/k;
end
