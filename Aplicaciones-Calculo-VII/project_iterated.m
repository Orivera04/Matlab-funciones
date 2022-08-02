close all, clear all, clc
t=linspace(0,2*pi);
a=1;
x=a.*cos(t);
y=a.*cos(t).*sin(t);
x1=cos(t);
y1=sin(t);
display('What would you like to do?')
display('1) Single Plot')
display('2) Iterated Plot')
control=input('');
plot(x,y,x1,y1)
axis equal
    if control==2
    figure
    hold on
        for a=1:.5:10
            x=a.*cos(t);
            y=a.*cos(t).*sin(t);
            x1=a.*cos(t);
            y1=a.*sin(t);
            f1=plot(x,y);
            f2=plot(x1,y1);
            set(f1,'Color',[.9 .5 .1])  
            set(f2,'Color',[.5 .2*a/10 .5])
            set(gco,'Color','k')
        end
    end
axis equal
drawaxes
xlabel('x-axis')
ylabel('y-axis')
S=strvcat('          Lemniscate of Gerono',...
    'x=acos(\theta),  y=asin(\theta)cos(\theta)',...
    '        0 \leq \theta \leq 2\pi');
title(S)


