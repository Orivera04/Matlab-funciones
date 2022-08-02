% This reads time and temperature data for an afternoon
%  from a file and plots the data

timetemp=[1 2 3 4 5 6 7 8 9 10;30 25 34 40 31 24 18 24 27 15]

% The times are in the first row, temps in the second row
time = timetemp(1,:);
temp = timetemp(2,:);

% Plot the data and label the plot
plot(time,temp,'-r*')
xlabel('Tiempo')
ylabel('Temperatura')
title('Temperaturas por la tarde')
