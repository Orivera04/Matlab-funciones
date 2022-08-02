% GuiDm_13: Illustrates axes command.
% Copyright S. Nakamura, 1995
close,h1=figure(1);clf 
set(h1,'Position',[300,300,350,300],...
       'NUmberTitle','off',...
       'Name','GuiDm_13  Using axes command')
x=0:0.1:10;
axes('Position',[0.1, 0.1, 0.5, 0.5]);
plot(x,sin(x))

