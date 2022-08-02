%  book_3_64.m
%  calls bank45

load melanoma

plot(Year,Incidence,'.-')
xlabel('Year')
ylabel('Incidence')
bank45(Year,Incidence)