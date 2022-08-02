%  book_3_71.m
%  calls loess

load melanoma

%  Scale Year for better fitting.
offsetYear = Year-Year(1);

%  make smooth fit
lambda = 1;
el = 30;
alpha = el/length(Year);
fit = loess(offsetYear,Incidence,offsetYear,alpha,lambda);
residualIncidence = Incidence(:)-fit(:);

%  make not so smooth fit
lambda = 2;
el = 9;
alpha = el/length(Year);
residualFit = loess(offsetYear,residualIncidence,offsetYear,alpha,lambda)';

axlim = [1935 1975 -inf inf];

subplot(2,1,1)
plot(Year,residualFit,'-')
ylabel({'Residual Incidence'})
axis(axlim)
set(gca,'XGrid','on')

load sunspot

subplot(2,1,2)
plot(Year,SunspotNumber)
xlabel('Year')
ylabel('Sunspot Number')
axis(axlim)
set(gca,'XGrid','on')
