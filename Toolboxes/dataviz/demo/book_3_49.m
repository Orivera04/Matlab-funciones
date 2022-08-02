%  book_3_49.m

load fly

uniqueTemp = unique(Temperature);
nT = length(uniqueTemp);

for ii = 1:nT
   index = Temperature==uniqueTemp(ii);
   meanFacet(ii) = mean(FacetNumber(index));
end

%  find a line through the mean values
p = polyfit(uniqueTemp(:),meanFacet(:),1);
fitTemp = linspace(min(uniqueTemp),max(uniqueTemp),50);
fitFacet = polyval(p,fitTemp);

plot(uniqueTemp,meanFacet,'o',fitTemp,fitFacet,'-')
xlabel('Temperature (deg C)')
ylabel('Facet Number')
title('Fly')
