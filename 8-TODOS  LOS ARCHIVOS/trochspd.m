function out=trochspd(t)
global b1
out=((1-b1.*cos(t)).^2+b1.^2.*sin(t).^2).^(.5);