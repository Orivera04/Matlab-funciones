function A=tridiago(n)
% © Stoyan Gisbert 1998; program a Linearis algebra c. reszhez

B=-(n+1)^2*ones(n,1);B=[B,-2*B,B];
A=spdiags(B,[-1,0,1],n,n);