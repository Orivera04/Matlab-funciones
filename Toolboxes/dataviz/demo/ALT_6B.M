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

%  use format of qqplot
hg = plot(Yield1',Yield2','.');
set(hg,'MarkerSize',14)
naxis = axis;
naxis(1) = min(naxis(1),naxis(3));
naxis(3) = naxis(1);
naxis(2) = max(naxis(2),naxis(4))+10;
naxis(4) = naxis(2);
axis(naxis)
hold on
plot([naxis(1) naxis(2)],[naxis(3) naxis(4)],'k--')
hold off
xlabel('Yield in 1931')
ylabel('Yield in 1932')
title('Barley')
legend(hg,char(SiteName(Site)),2)
