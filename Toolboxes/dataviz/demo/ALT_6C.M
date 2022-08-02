%  alt_6b.m

load barley

%  organize yield into arrays by variety and site
%  specific to this data arrangement
nSite = length(SiteName);
nVariety = length(VarietyName);
Site = Site(1:nSite);
ncol = length(Yield)/nSite;
Variety = reshape(Variety,nSite,ncol);
Year = reshape(Year,nSite,ncol);
Yield = reshape(Yield,nSite,ncol);
Variety = Variety(1,1:nVariety);
Year = [Year(1,1) Year(1,end)];
Yield2 = Yield(:,1:nVariety);
Yield1 = Yield(:,nVariety+1:end);

%  use format of mdplot
yAverage = 0.5*(Yield1'+Yield2');
yDifference = Yield2'-Yield1';
hg = plot(yAverage,yDifference,'.');
set(hg,'MarkerSize',14)
naxis = axis;
naxis(1) = 0;
naxis(3) = naxis(3)-5;
naxis(4) = naxis(4)+5;
axis(naxis)
hold on
plot([naxis(1) naxis(2)],[0 0],'k--')
hold off
xlabel('Average Yield')
ylabel('Yield Increase')
title('Barley')
legend(hg,char(SiteName(Site)),3)

yDifference = -yDifference;
yDifference(yDifference<=0) = nan;
hold on
hg1 = plot(yAverage,yDifference,'o');
%set(hg1,'MarkerSize',14)
hold off