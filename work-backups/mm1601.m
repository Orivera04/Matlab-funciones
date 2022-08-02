%(mm1601.m plot)
t = (1900:10:1990)';
p = [ 75.995;  91.972; 105.711; 123.203; 131.669;
     150.697; 179.323; 203.212; 226.505; 249.633];
plot(datenum(t,1,1),p)
datetick('x','yyyy') % use 4-digit year on the x-axis
title('Figure 16.1: Population by Year')

