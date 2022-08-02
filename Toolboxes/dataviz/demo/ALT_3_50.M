%  alt_3_50.m
%  show better fit after data swap

load fly

uniqueTemp = unique(Temperature);
nT = length(uniqueTemp);

for ii = 1:nT
   index = Temperature==uniqueTemp(ii);
   meanFacet(ii) = mean(FacetNumber(index));
end

%  swap 2 points
temp = meanFacet(5);
meanFacet(5) = meanFacet(6);
meanFacet(6) = temp;

p = polyfit(uniqueTemp(:),meanFacet(:),1);
fitFacet = polyval(p,uniqueTemp);
residual = meanFacet(:)-fitFacet(:);

plot(uniqueTemp,residual,'o',[min(uniqueTemp) max(uniqueTemp)],[0 0],'-')
xlabel('Temperature (deg C)')
ylabel('Residual Facet Number')
title('Fly')
