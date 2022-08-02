function [xval,maxf]=optga(fun,range,bits,pop,gens,mu,matenum)
% Determines maximum of a function using the Genetic algorithm.
%
% Example call: [xval,maxf]=optga(fun,range,bits,pop,gens,mu,matenum)
% fun is name of a single variable user defined positive valued function.
% range is 2 element row vector giving lower and upper limits for x.
% bits is number of bits fo rthe variable, pop is population size.
% gens is number of generations, mu is mutation rate, 
% matenum is proportion mated in range 0 to 1.
% For further details, see page 291.
% WARNING. Method is not guarenteed to find global optima
% and may be slow if very accuarte answer required.
%
newpop=[ ]; a=range(1); b=range(2);
newpop=genbin(bits,pop);
for i=1:gens
  selpop=selectga(fun,newpop,a,b);
  newgen=matesome(selpop,matenum);
  newgen1=mutate(newgen,mu);
  newpop=newgen1;
end
[fit,fitot]=fitness(fun,newpop,a,b);
[maxf,mostfit]=max(fit);
xval=binvreal(newpop(mostfit,:),a,b);
