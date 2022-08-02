[naforce, naplacement]=distload(7,0,9);
na=[0,-naforce,naplacement,0];
nb=deg2xy([70,4,13,0]);
nload=[na;nb];
[nRforce, nRmoment]=reaction(nload,[0,0])
