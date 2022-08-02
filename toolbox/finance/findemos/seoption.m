function o = seoption(prange,strike,rate,mats,sig,contract,measure)
%SEOPTION Calculates sensitivity measures of portfolio of options.
%   O = SEOPTION(PRANGE,STRIKE,RATE,MATS,SIG,CONTRACT,MEASURE) calculates
%   the sensitivity measure of a portfolio of options.  PRANGE is the price
%   range of the underlying asset, STRIKE is a vector of exercises prices,
%   RATE is the risk free interest rate, MATS is a vector of periods until
%   maturity, SIG is overall volatility of the portfolio, and CONTRACT is
%   the number of options (options/contract*contracts) of each instrument.

%
%       Function calculates sensitivities for call options and is called by
%       FEXPO.M.
%

%       Author(s): C.F. Garvin, 3-10-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.8 $   $Date: 2002/04/14 21:42:53 $

long = max(mats);
opt = zeros(long,max(size(prange)));
maxmat = length(mats);
% if volatility and rate are scalar, expand to size of number of options
if length(sig) == 1
 sig = sig*ones(maxmat,1);
end
if length(rate) == 1
 rate = rate*ones(maxmat,1);
end

plen = length(prange);
c = zeros(long,plen);

for i = 1:maxmat
  pad = ones(mats(i),plen);
  newrange = prange(ones(mats(i),1),:);
  t = (1:mats(i))';
  newt = t(:,ones(plen,1));
  newstrike = strike(i)*pad;
  newsig = sig(i)*pad;
  newrate = rate(i)*pad;
  c(long-mats(i)+1:long,:) = c(long-mats(i)+1:long,:) + contract(i)*...
        eval([measure,'(newrange,newstrike,newrate,newt/long,newsig)']);
  end

if nargout == 0
  MSH = mesh(prange,1:long,c);
  set(MSH,'tag','sensmesh')
  view(60,60),set(gca,'xdir','reverse')
  axis([min(prange) max(prange) 0 long -inf inf])
else
  o = c;
end
