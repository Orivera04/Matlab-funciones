function [fit,fitot]=fitness(criteria,chrom,a,b)
%
% Example call: [fit,fitot]=fitness(criteria,chrom,a,b)
% Calculates fitness of set of chromosomes chrom in range a to b.
% using the fitness criterion, criteria.
% Called by optga.
%
[pop bitl]=size(chrom); 
for k=1:pop
  v(k)=binvreal(chrom(k,:),a,b);
  fit(k)=feval(criteria,v(k));
end;
fitot=sum(fit);
