%  book_3_66.m
%  calls loess, bank45

load melanoma

lambda = 1;
el = 30;
alpha = el/length(Year);
fit = loess(Year,Incidence,Year,alpha,lambda);
residualIncidence = Incidence(:)-fit(:);

plot(Year,residualIncidence,'-o',[min(Year) max(Year)],[0 0],'--')
xlabel('Year')
ylabel({'Residual Incidence'})
bank45(Year,residualIncidence)