function newchrom=selectga(criteria,chrom,a,b)
%
% Example call: newchrom=selectga(criteria,chrom,a,b)
% Selects best chromosomes from chrom for next generation
% using function criteria in range a to b.
% Called by function optga.
%
[pop bitlength]=size(chrom);
fit=[ ];
%calculate fitness
[fit,fitot]=fitness(criteria,chrom,a,b);
for chromnum=1:pop
  sval(chromnum)=sum(fit(1,1:chromnum));
end;
%select according to fitness
parname=[ ];
for i=1:pop
  rval=floor(fitot*rand);
  if rval<sval(1)
    parname=[parname 1];
  else
    for j=1:pop-1
      sl=sval(j); su=sval(j)+fit(j+1);
      if (rval>=sl) & (rval<=su)
         parname=[parname j+1];
      end
    end
  end	
end
newchrom(1:pop,:)=chrom(parname,:);
