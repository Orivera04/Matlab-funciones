function monitor2(x)
%MONITOR2 Datafeed Toolbox Bloomberg security monitoring.
%   MONITOR2(X) demonstrates the Datafeed Toolbox Bloomberg
%   security monitoring functionality.   S is a Bloomberg header
%   data structure of the form:
%
%                       Status: 0
%                    OpenPrice: 15.2000
%              TodaysOpenPrice: 15.2000
%                    HighPrice: 15.6900
%              TodaysHighPrice: 15.6900
%                     LowPrice: 15.1900
%               TodaysLowPrice: 15.1900
%                    LastPrice: 15.5800
%              TodaysLastPrice: 15.5800
%                  SettlePrice: NaN
%                     BidPrice: NaN
%               TodaysBidPrice: NaN
%                     AskPrice: NaN
%               TodaysAskPrice: NaN
%                     YieldBid: NaN
%               TodaysYieldBid: NaN
%                     YieldAsk: NaN
%               TodaysYieldAsk: NaN
%                      LimitUp: NaN
%                    LimitDown: NaN
%                 OpenInterest: 10054820
%           LastPriceYesterday: 15.0300
%                        Scale: 1
%                LastPriceTime: 53647
%            LastTradeExchange: 5
%                TickDirection: -1
%                      BidSize: NaN
%                TodaysBidSize: NaN
%                      AskSize: NaN
%                TodaysAskSize: 0
%                 BidCondition: NaN
%                 AskCondition: NaN
%           LastTradeCondition: NaN
%          LastMarketCondition: NaN
%                  Monitorable: 1
%                  TotalVolume: 1005720
%            TodaysTotalVolume: 1005720
%           TotalNumberOfTicks: 7236
%     TodaysTotalNumberofTicks: 7236
%             SessionStartTime: 34200
%               SessionEndTime: 59400
%                     Currency: 538989397
%                       Format: 0
%                  SecurityKey: {'FOO US Equity                   '}
%                     AsOfDate: 20030908
%               TodaysAsOfDate: 20030908

% Copyright 2003 The MathWorks, Inc.

global lastPrices
numsec = length(x.LastPrice);
if numsec ~= length(lastPrices)
  lastPrices = [];
end
if isempty(lastPrices)
  lastPrices = zeros(1,numsec);
end

x.LastPriceTime = x.LastPriceTime./24/3600;
newPrices = [x.LastPrice'];
diffPrices = ceil(abs(newPrices - lastPrices));
for i = 1:numsec   
      if diffPrices(i)
        z = [datestr(x.LastPriceTime(i),13) ' '...
             deblank(x.SecurityKey{i}) ' Last: ' num2str(x.LastPrice(i)) ','...
             ' Open: ' num2str(x.OpenPrice(i)) ', High: ' num2str(x.HighPrice(i)) ','...
             ' Low: ' num2str(x.LowPrice(i)) ];
        disp(z)
        drawnow
      end
end

for i = 1:numsec
  lastPrices(i) = x.LastPrice(i);
end