x = -2.9:0.2:2.9; % specify the bins to use
y = randn(5000,1); % generate 5000 random data points
hist(y,x) % draw the histogram
title('Figure 25.16: Histogram of Gaussian Data')