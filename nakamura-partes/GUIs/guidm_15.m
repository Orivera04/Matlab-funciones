% GuiDm_15  Using subplot with axes.
% Copyright S. Nakamura, 1995
close,h1=figure(1);
set(h1,'Position',[300,100,350,350],...
       'NUmberTitle','off',...
       'Name','GuiDm_15  Using subplot with axes')
x=0:0.1:10;
h1=axes('Position',[0.1, 0.3, 0.3, 0.3]);
plot(x,sin(x));
h2=axes('Position',[0.55, 0.1, 0.4, 0.4]);
plot(x,exp(-x))
%
subplot(h1)
hold on; plot(x,cos(x),':'); hold off
%
subplot(h2)
hold on; plot(x,sin(x.*x),':'); hold off

