function monitor1(s)
%MONITOR1 Datafeed Toolbox Bloomberg security monitoring example 1.
%   MONITOR1(S) demonstrates the Datafeed Toolbox Bloomberg
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

%Save previous tick information to be compared to next tick
global oldInfo

ax1 = subplot(2,1,1);
set(ax1,'Ylim',[0 8])

%Convert time in seconds to date string
s.LastPriceTime = s.LastPriceTime./3600./24;

t = getappdata(ax1,'textdata');
if isempty(t)
  f = get(0,'fixedwidthfont');
  t(1) = text(0,0,['Bid Price  ' num2str(s.BidPrice(1))]);
  t(2) = text(0,1,['Ask Price  ' num2str(s.AskPrice(1))]);
  t(3) = text(0,2,['Open Price  ' num2str(s.OpenPrice(1))]);
  t(4) = text(0,3,['High Price  ' num2str(s.HighPrice(1))]);
  t(5) = text(0,4,['Low Price   ' num2str(s.LowPrice(1))]);
  t(6) = text(0,5,['Total Volume ' num2str(s.TotalVolume(1))]);
  t(7) = text(0,6,['LastPrice  ' num2str(s.LastPrice(1))]);
  t(8) = text(0,7,datestr(s.LastPriceTime(1),14));
  t(9) = text(0,8,s.SecurityKey(1));
  set(t,{'fontname'},{f})
  setappdata(ax1,'textdata',t)
else
  set(t(1),'String',['Bid Price  ' num2str(s.BidPrice(1))])  
  set(t(2),'String',['Ask Price  ' num2str(s.AskPrice(1))])  
  set(t(3),'String',['Open Price  ' num2str(s.OpenPrice(1))])  
  set(t(4),'String',['High Price  ' num2str(s.HighPrice(1))])
  set(t(5),'String',['Low Price   ' num2str(s.LowPrice(1))])
  set(t(6),'String',['Total Volume ' num2str(s.TotalVolume(1))])
  set(t(7),'String',['LastPrice  ' num2str(s.LastPrice(1))])
  set(t(8),'String',datestr(s.LastPriceTime(1),14))
end

set(ax1,'Visible','off')

ax2 = subplot(2,1,2);

x = s.LastPrice(1);

h = get(ax2,'children');
if isempty(h)
  plot(0,NaN,'linewidth',2,'linestyle','-','marker','*');
  set(ax2,'xtick',[])
  grid on
  hold on
end

if ~isempty(oldInfo)
    h = get(ax2,'children');
    xd = get(h,'xdata');
    yd = get(h,'ydata');
    xd = [xd length(xd)+1];
    yd = [yd x];
    set(h,'xdata',xd,'ydata',yd)
    set(ax2,'Ylim',[x-1 x+1])
    title(datestr(now));
end

drawnow

%Save data to be compared to next tick
oldInfo = s;
