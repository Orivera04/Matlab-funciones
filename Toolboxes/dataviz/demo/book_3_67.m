%  book_3_67.m
%  calls loess, bank45

load melanoma

%  Scale Year for better fitting.
offsetYear = Year-Year(1);

%  make smooth fit
lambda = 1;
el = 30;
alpha = el/length(Year);
fit = loess(offsetYear,Incidence,offsetYear,alpha,lambda)';
residualIncidence = Incidence(:)-fit(:);

%  make not so smooth fit
lambda = 2;
el = 9;
alpha = el/length(Year);
residualFit = loess(offsetYear,residualIncidence,offsetYear,alpha,lambda)';

plot(Year,residualIncidence,'o',Year,residualFit,'-',[min(Year) max(Year)],[0 0],'--')
xlabel('Year')
ylabel({'Residual Incidence'})
bank45(Year,residualFit)