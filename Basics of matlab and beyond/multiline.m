% Adjust these by trial and error:
x1=.2;
y1=.3;
top=0.8;
ScaleFact = 3;

% This is needed to fit in the x-label:
x0=.13;
y0=.11;
w0=.7750;
h0=.815;
h1=top-y1;
w1=w0*h1/h0;
set(gcf,'DefaultAxesFontSize',(4/3)*20/ScaleFact)
set(gcf,'DefaultTextFontSize',(4/3)*20/ScaleFact)
set(gcf,'DefaultAxesLineWidth',.5*w1/(w0*ScaleFact))
set(gcf,'DefaultLineLineWidth',.5*w1/(w0*ScaleFact))

plot([1 2 3])
set(gca,'pos',[x1 y1 w1/ScaleFact h1/ScaleFact])
xlabel('x axis')
ylabel('y axis')
title('Title')
print -deps labels
yl = get(gca,'ylabel');
set(yl,'Rotation',0)
pos = get(yl,'pos');
set(yl,'pos',[0.35 3])
print -deps labels-yhor
str = {'The answer is below:';
['It is ' num2str(pi)]};
title(str)  
print -deps multiline