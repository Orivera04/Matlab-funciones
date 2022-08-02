% mm2617.m
z = randn(30,1); % create some random data
stem(z,'--') % draw a stem plot using dashed linestyle
set(gca,'YGrid','on')
title('Figure 26.17: Stem Plot of Random Data')