function out2=spd(s)
global k
out2=((1-k.*cos(s)).^2+k^2*sin(s).^2).^(1/2);
