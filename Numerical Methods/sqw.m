function y=sqw(t,T,d)
%SQW Square wave generation
%  sqw(t,T,d) generates a square wave of period T
%  that oscillates between 0 and 1 for the time elements 
%  in vector t. The duty cycled determines the percentage 
%  of time that the square wave is "on" (equal to 1).
%
%EXAMPLE
%
%  The following code will produce a square wave of
%  period 8. The duty cycle is 25, representing 25%, determines 
%  that the square wave will be "on" (equal to 1) during the 
%  first 25% of its period, then "off" (equal to 0) during 
%  the remaining 75% of the period.
%
%  t=linspace(0,24,1000);
%  y=sqw(t,8,25);
%  plot(t,y)
%  set(gca,'xtick',0:24)
%  axis tight
%  grid
%
tmp=mod(t,T);
w0=T*d/100;
y=(tmp<w0);