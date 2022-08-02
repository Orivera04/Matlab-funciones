function seasonalPart = seasonaloess(time,Y,period,elShort,lambdaShort)
%  Seasonal loess curve fit
%  seasonaloess(time,Y,period,elShort,lambdaShort)
%  (time,Y)  data values to fit
%  period   number of time steps in a period to fit
%  elShort and lambdaShort  loess fit parameters
%  Works best with the Signal Processing Toolkit for filtering.

% Copyright (c) 1998-2000 by Datatool
% $Revision: 1.10 $


time = time(:);
Y = Y(:);

n = length(time);
p = period;   %  observations per period
nSubseries = floor(n/p);  %  number of cycles at this period

%  loess parameter for seasonal fit
alphaShort = elShort/nSubseries;

%  initialize long term fit to 0
longtermPart = zeros(size(Y));
oldSeasonalPart = ones(size(Y));
tol = 0.001;
test = 10*tol;

while test>tol
   residual = Y-longtermPart(:);
   %  fit across seasons
   subseries = reshape(residual,p,nSubseries);
   fitTime = 0:nSubseries+1;
   fitC = zeros(p,nSubseries+2);
   %  using loess
   for ii = 1:p
      fitC(ii,:) = loess(1:nSubseries,subseries(ii,:),fitTime,alphaShort,lambdaShort);
   end
   %  estimate the smooth long term component
   %  filter over the entire series
   fitC = fitC(:);
   %  Use hanning.
   filt1 = 0.5-0.5*cos(2*pi*(1:p)/(p+1));
   filt1 = filt1(:);
   if exist('filtfilt')
       filteredC = filtfilt(filt1,sum(filt1),fitC);
   else
       filteredC = filter(filt1,sum(filt1),fitC);
       filteredC = filter(filt1,sum(filt1),filteredC);
   end
   filt2 = [1/4 1/2 1/4];
   filteredC = filter(filt2,sum(filt2),filteredC);
   %  use loess with different parameters
   lambdaF = 1;
   temp = floor(p);
   if rem(temp,2)
      elF = temp;
   else
      elF = temp-1;
   end
   alphaF = elF/(n+2*p);
   smoothC = loess((1:n+2*p)',filteredC,(p+1:n+p)',alphaF,lambdaF)';
   goodfitC = fitC(p+1:n+p);
   %  subtract longterm component to get seasonal component estimate
   seasonalPart = goodfitC-smoothC;
   %  estimate nonseasonal component
   residual2 = Y-seasonalPart;
   %  estimate a new long term component
   lambdaLong = 1;
   elLong = round(1.5*p/(1-1.5/elShort));
   alphaLong = elLong/n;
   longtermPart = loess(time,residual2,time,alphaLong,lambdaLong);
   test = 2*sum(abs(seasonalPart-oldSeasonalPart))/(n*sum(abs(oldSeasonalPart)));
   oldSeasonalPart = seasonalPart;
end

