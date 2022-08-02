%FFTDEMO Demonstrate use of FFT for spectral analysis.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

clf reset
echo on
clc
%	This example shows the use of the FFT function for spectral 
%	analysis.  A common use of FFT's is to find the frequency
%	components of a signal buried in a noisy time domain signal.
%

pause % Strike any key to continue.
clc
%	First we need to create some data.  Consider data sampled at
%	1000 Hz.  We start by forming a time axis for our data, running
%	from t=0 until t=.25 in steps of 1 millisecond:

t = 0:.001:.25;

pause % Strike any key to continue.

%	Next we can form a signal containing 50 Hz and 120 Hz:

x = sin(2*pi*50*t) + sin(2*pi*120*t);

pause % Strike any key to continue.

%	and add some random noise with a standard deviation of 2 to 
%	produce a noisy signal y:

y = x + 2*randn(size(t));

pause % Strike any key to continue.
x=[];t=[];
clc
%	Let's take a look at our noisy signal y by plotting it.

pause % Strike any key for plot.

plot(y(1:50)), title('Noisy time domain signal'), pause
clc
%	Clearly, it is difficult to identify the frequency components
%	from looking at the original signal; that's why spectral analysis
%	is so popular.
%
%	Finding the discrete Fourier transform of the noisy signal y
%	is easy; we just take the fast-Fourier transform (FFT) :

Y = fft(y,256);

pause % Strike any key to continue.

%	The power spectral density, a measurement of the energy at
%	various frequencies, is found with:

Pyy = Y.*conj(Y)/256;

pause % Strike any key to continue.
Y=[];y=[];
clc
%	To plot the power spectral density, we must first form a 
%	frequency axis:

f = 1000/256*(0:127);

%	which we do for the first 127 points. (The remainder of the 256
%	points are symmetric.)  We can now plot the power spectral
%	density:

pause % Strike any key for plot.

plot(f,Pyy(1:128)), title('Power spectral density'), ...
xlabel('Frequency (Hz)'), pause
clc
%	Let's zoom in and plot only up to 200 Hz:

pause % Strike any key for plot.

plot(f(1:50),Pyy(1:50)), title('Power spectral density'), ...
xlabel('Frequency (Hz)'), pause

clc
echo off

disp('End')
