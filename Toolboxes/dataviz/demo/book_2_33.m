%  book_2_33.m
%  calls powerxform, normalqqplot

load fusion

%  define powers to use
powerSet = [-1 -0.5 -0.25 0 0.25 0.5 1];
%  define corresponding subplot locations
loc = [7 8 5 6 3 4 1];
np = length(powerSet);

%  set axis limits for all plots
axisLimit = [-2.5 2.5 0 inf];

for ii = 1:np
   temp = real(powerxform(VV,powerSet(ii)));
   subplot(4,2,loc(ii))
   normqqplot(temp)
   axis(axisLimit)
   title(sprintf('%5.2f',powerSet(ii)))
   if loc(ii)<np
      set(gca,'XTickLabel',[])
   else
      xlabel('Unit Normal Quantile')
   end
   %  make slightly bigger
   pos = get(gca,'Position');
   pos(3) = 1.15*pos(3);
   pos(4) = 1.05*pos(4);
   set(gca,'Position',pos)
end

