subplot(2,2,1)
t = 0:pi/50:2*pi;
r = exp(-0.05*t);
stem3(r.*sin(t), r.*cos(t),t,'k'),grid off
