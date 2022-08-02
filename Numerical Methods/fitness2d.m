function [fit,fitot]=fitness2d(criteria,chrom,a,b)
%
% Example call: [fit,fitot]=fitness2d(criteria,chrom,a,b)
% Calculates fitness of a set of chromosomes chrom for a two variable function.
% Each variable is defined in the range a to b 
% using a two variable function given by criteria
% [pop bitl]=size(chrom); vlength=floor(bitl/2);
for k=1:pop
  v=[ ];v1=[ ];v2=[ ]; partchrom1=chrom(k,1:vlength);
  partchrom2=chrom(k,vlength+1:2*vlength);
  v1=binvreal(partchrom1,a,b); v2=binvreal(partchrom2,a,b);
  v=[v1 v2]; fit(k)=feval(criteria,v);
end;
fitot=sum(fit);