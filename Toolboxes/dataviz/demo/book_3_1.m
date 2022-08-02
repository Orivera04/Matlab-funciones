%  book_3_1.m
%  Plot ganglion data

load ganglion

hg = plot(Area,CPratio,'o');
xlabel('Area (mm^2)')
ylabel('CP Ratio')
title('Ganglion')
