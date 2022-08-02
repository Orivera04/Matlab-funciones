%  book_6_1.m
%  calls multidotplot

load livestock

%  form an array of livestock count by country(rows) and name (columns)
n = length(LivestockType);
nl = length(LivestockName);
uniqueType = unique(LivestockType);
countData = zeros(n/nl,nl);

%  make array by country and livestock type
for ii = 1:nl
   index = LivestockType==uniqueType(ii);
   selectCount = Count(index);
   selectCountry = Country(index);
   [temp,index] = sort(selectCountry);
   selectCount = selectCount(index);
   countData(:,ii) = selectCount;
end

%  use logs of counts since range is very large
logCountData = log10(countData);
%  put country data in decreasing order of median of counts 
medLogCountData = median(logCountData,2);
[medLogCountData, index] = sort(medLogCountData);
index = flipud(index);
CountryName = CountryName(index);
logCountData = logCountData(index,:);

%  define desired subplot locations to match book
subLocations = [2 1;2 2;2 3;1 1;1 2];

multidotplot(logCountData,CountryName,'Log_1_0 Livestock Count',LivestockName,subLocations)
