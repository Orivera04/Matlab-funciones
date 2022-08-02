% Subplot to show plot types
 
year = 2007:2011;
pop = [0.9  1.4  1.7  1.3  1.8];
subplot(2,2,1)
bar(year,pop)
title('bar')
xlabel('Year')
ylabel('Population')
subplot(2,2,2)
barh(year,pop)
title('barh')
xlabel('Year')
ylabel('Population')
subplot(2,2,3)
area(year,pop)
title('area')
xlabel('Year')
ylabel('Population')
subplot(2,2,4)
stem(year,pop)
title('stem')
xlabel('Year')
ylabel('Population')
