% FRIDAY13  Is the 13th of the month unlikely?

c = zeros(1,7);
for y = 1601:2000
   for m = 1:12
      d = datenum([y,m,13]);
      w = weekday(d);
      c(w) = c(w) + 1;
   end
end
c
bar(c)
axis([0 8 680 690])
avg = 4800/7;
line([0 8], [avg avg],'linewidth',4,'color','black')
set(gca,'xticklabel',{'Su','M','Tu','W','Th','F','Sa'})
title('13th day of the month')
