%  book_3_43.m
%  calls equalcount, givenplot

load polarization

nbar = 15;  % number of bars to plot
overlapFraction = 0.5;

%  find endpoints for bars
breakPoint = equalcount(Concentration.^(1/3),nbar,overlapFraction);

givenplot(breakPoint)
xlabel('Cube Root Concentration')
title('Polarization')

