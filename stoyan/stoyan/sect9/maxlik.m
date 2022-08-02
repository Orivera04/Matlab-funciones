% © Fazekas Istvan 1998; program a Statisztika c. reszhez

x1=binornd(100,0.4,1,1);
x=binornd(100, 0.4, 333, 1);
%(a) binomialis eloszlas becsles
[p,konfidencia]=binofit(x1,100)
%(b) Poisson eloszlas becsles
[lambda, konfi]=mle('Poisson',x)
%(c) normalis eloszlas becsles
[mu, sig, konfmu, konfsig]=normfit(x)