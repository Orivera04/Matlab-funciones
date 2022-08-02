function eyediagram(y,fs,dt)
%EYEDIAGRAM plots the eye diagram for pulse amplitude modulation.
%
% Usage:  eyediagram(y,fs,dt) 
% 
% The vector 'y' contains the PAM signal to be transmitted, while 'fs'
% is the oscilloscope sweep rate and 'dt' is the sampling period. 

%---------------------------------------------------------------
% copyright 1996, 2001, by John Buck, Michael Daniel, and Andrew Singer.
% For use with the textbook "Computer Explorations in Signals and
% Systems using MATLAB", Prentice Hall, 1997, 2002.
%---------------------------------------------------------------

tindcs=0:dt:2/fs;
hold off;
for k=4:length(y)*dt*fs-1-4,
  indcs=[ceil((k-1)/fs/dt):ceil((k+1)/fs/dt)]+1;
  plot(tindcs,y(indcs));
  hold on
end
hold off
 
