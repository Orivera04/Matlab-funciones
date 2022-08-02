x = linspace(0,2,21); % create a vector
y = erf(x); % y is the error function of x
e = rand(size(x))/10; % e contains random error values
errorbar(x,y,e) % create the plot
title('Figure 25.18: Errorbar Plot')