function y=dirac(x)
c=137.03599905320282423;
Z=20;dx=0.03;Rmt=2;
kappa=-1;n=3;s=sqrt(kappa^2-Z^2/c^2);n_mt=361;
Enk=Enk_no_int(Z,n,kappa);
r=Rmt*exp(dx*(x-n_mt));
y=dx*[-kappa, (c+Enk/c)*r+Z/c; ...
    (c-Enk/c)*r-Z/c,  kappa];
return