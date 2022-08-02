function A=poisson2(n)
% © Stoyan Gisbert 1998; program a Linearis algebra c. reszhez

al=n*n;n1=n-1;nn=n1*n1;
c=-al*ones(n1,1);
B=spdiags([c,-4*c,c],[-1,0,1],n1,n1);
A=kron(speye(n1),B); % A Kronecker-szorzattal kapjuk az A blokk-f"oatlojat
c1=-al*ones(nn,1);
A=spdiags([c1,c1],[-n1,n1],A); % A spdiags 2. formaja a fenti tablazatban