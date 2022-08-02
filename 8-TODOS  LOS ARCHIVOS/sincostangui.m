set(0,'DefaultAxesFontSize',(4/3)*20)
set(0,'DefaultTextFontSize',(4/3)*20)
set(0,'DefaultuicontrolFontSize',(4/3)*20)
% This is needed to fit in the x-label:
x0=.13;
y0=.11;
w0=.7750;
h0=.815;
x1 = 0.1;
w1 = 0.72;
h1 = w1*h0/w0;
y1 = .15;
clf
uicontrol('Callback','ezplot(''sin(x)'')', ...
        'Position',[490 351 70 40], ...
        'String','Sine');
    d = 40;
uicontrol('Callback','ezplot(''cos(x)'')', ...
        'Position',[490 351-d 70 40], ...
        'String','Cos');
uicontrol('Callback','ezplot(''tan(x)'')', ...
        'Position',[490 351-2*d 70 40], ...
        'String','Tan');
ezplot('tan(x)')
set(gca,'pos',[x1 y1 w1 h1])
set(gcf,'PaperpositionMode','Auto')
print -deps threebuttons