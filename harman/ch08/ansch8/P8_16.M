% P8_16.M  Plot frequency spectrum of clock pulse
%  The components are 2/(n pi); n odd 
%    Plot 10 components
% 
% Plot a discrete spectrum [f F] by calling CLPTDSCF.M
%  Input to function is 
%	f 	- frequencies 
%	F 	- spectral values
%	xunit	- units of frequency (Hz or rad/sec)
%
clear
xunit='MHz'
fdc=4*.05/.125
w=2*pi*8*.05/2
% Fundamental is 8 MHz
f(1)=0.0
Fn=zeros(1,6);		% Row vector of 6 elements
% Compute half spectrum-positive frequencies
for n=1:6;		% Compute 6 positive components
 f(n+1)=8*n;
 Fn(n)=((2*fdc)/2)*abs(sin(n*w)/(n*w)); 
end
Fn=[fdc Fn];		% Add the zero value
%
clf
clptdscf(f,Fn,xunit)

