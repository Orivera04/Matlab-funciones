%  alt_3_71.m
%  calls loess
%  smoothing sunspot data helps comparison with melanoma

load melanoma

%  Scale Year for better fitting.
offsetYear = Year-Year(1);

%  get residuals from first loess fit
lambda = 1;
el = 30;
alpha = el/length(Year);
fit = loess(offsetYear,Incidence,offsetYear,alpha,lambda);
residualIncidence = Incidence(:)-fit(:);

%  get residuals from second loess fit
lambda = 2;
el = 9;
alpha = el/length(Year);
residualFit = loess(offsetYear,residualIncidence,offsetYear,alpha,lambda)';

%  set plot time scale
axlim = [1935 1975 -inf inf];

subplot(2,1,1)
plot(Year,residualFit,'-')
ylabel({'Residual Incidence'})
xlabel('Year')
axis(axlim)
set(gca,'XGrid','on')

load sunspot

%  use a loess fit to go with melanoma smoothing
lambda = 2;
el = 9;
alpha = el/length(Year);
fitSunspot = loess(offsetYear,SunspotNumber,offsetYear,alpha,lambda);

%  plot at aligned time
subplot(2,1,2)
plot(Year+1.5,fitSunspot)
xlabel('Year + 1.5')
ylabel('Sunspot Number')
axis(axlim)
set(gca,'XGrid','on')
