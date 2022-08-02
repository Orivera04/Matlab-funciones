%  alt_3_49.m
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
fitTemp = linspace(min(uniqueTemp),max(uniqueTemp),50);
fitFacet = polyval(p,fitTemp);

plot(uniqueTemp,meanFacet,'o',fitTemp,fitFacet,'-')
xlabel('Temperature (deg C)')
ylabel('Facet Number')
title('Fly')
