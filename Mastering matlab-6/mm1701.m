%(MM1701.m plot)
temps =[12  8  18
  15  9  22
  12  5  19
  14  8  23
  12  6  22
  11  9  19
  15  9  15
  8  10  20
  19  7  18
  12  7  18
  14  10  19
  11  8  17
  9  7  23
  8  8  19
  15  8  18
  8  9  20
  10  7  17
  12  7  22
  9  8  19
  12  8  21
  12  8  20
  10  9  17
  13  12  18
  9  10  20
  10  6  22
  14  7  21
  12  5  22
  13  7  18
  15  10  23
  13  11  24
  12  12  22];
d = 1:31;   % number the days of the month
plot(d,temps)

xlabel('Day of Month'), ylabel('Celsius')
title('Figure 17.1: Daily High Temperatures in Three Cities')
