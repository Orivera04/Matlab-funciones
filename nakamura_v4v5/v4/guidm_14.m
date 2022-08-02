%GuiDm_14:  Illustrates multiple axes.
% Copyright S. Nakamura, 1995
close,h1=figure(1);clf 
set(h1,'Position',[300,300,350,350],...
       'NUmberTitle','off',...
       'Name','GuiDm_14  Using multiple axes')
x=0:0.1:10;
axes('Position',[0.1, 0.3, 0.3, 0.3]);
plot(x,sin(x));
axes('Position',[0.5, 0.1, 0.4, 0.4]);
plot(x,exp(-x))

