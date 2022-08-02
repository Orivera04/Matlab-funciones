set(0,'DefaultAxesFontSize',(4/3)*20)
set(0,'DefaultTextFontSize',(4/3)*20)
set(0,'DefaultuicontrolFontSize',(4/3)*20)
% This is needed to fit in the x-label:
x0=.13;
y0=.11;
w0=.7750;
h0=.815;
x1 = 0.2;
w1 = 0.72;
h1 = w1*h0/w0;
y1 = .2;
clf
uicontrol('Position',[5 5 120 40], ...
        'String','Do Plot');
plot(humps)
set(gca,'pos',[x1 y1 w1 h1])
set(gcf,'PaperpositionMode','Auto')
print -deps uicontrol_humps