%  book_6_4.m
%  calls addfit, dotplot

load livestock

%  form an array of livestock count by country(rows) and name (columns)
n = length(LivestockType);
nl = length(LivestockName);
uniqueType = unique(LivestockType);
nc = n/nl;
countData = zeros(nc,nl);

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
%  we don't care about mean value
mu = mean(logCountData(:));
logCountData = logCountData-mu;

%  make unweighted additive fit
[alpha, beta] = addfit(logCountData);

%  use it to start bisquare
x0 = [alpha(:); beta(:); 0];
options = optimset('fminsearch');
options = optimset(options,'Display','off','TolFun',0.01,'TolX',0.01);
x = fminsearch('addfiterrb',x0,options,logCountData);
alpha = x(1:nc);
beta = x(nc+1:end-1);

%  order results to match book
[sortAlpha index] = sort(alpha);
index = flipud(index);
sortAlpha = flipud(sortAlpha);

all = [sortAlpha(:); nan; flipud(beta(:))];
blank = {' '};
allName = [CountryName(index) blank fliplr(LivestockName)];

clf
dotplot(all,allName)
xlabel('Main Effects (log_1_0 counts)')
%  make room for ylabels
pos = get(gca,'Position');
change = 0.15*pos(3);
pos(3) = pos(3)-change;
pos(1) = pos(1)+change;
set(gca,'Position',pos)
