%  alt_6a.m
%  calls addfit, rfplot

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

%  use logs since count range is very large
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
muf = x(end);

fit = repmat(alpha,1,nl)+repmat(beta',nc,1)+muf;
residual = logCountData-fit;

rfplot(fit(:),residual(:),'Log_1_0 Counts')
