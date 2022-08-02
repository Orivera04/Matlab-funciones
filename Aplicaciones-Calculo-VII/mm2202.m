% mm2202.m

t=[0 .2 .2 .4 .4 .6 .6];
s=[0 10 0  10  0 10  0];
plot(t,s)
axis([0 .6 0 10])
set(gca,'Xtick',[0 .2 .4 .6],...
   'Ytick',[0 5 10],'Box','off')
title('Figure 22.2: Sawtooth Waveform')