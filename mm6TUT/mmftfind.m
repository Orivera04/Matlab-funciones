function [F,w]=mmftfind(FUN,Tmin,Tmax,N,win,p)
%MMFTFIND Find Fourier Transform Approximation. (MM)
% [F,w]=MMFTFIND('FUN',Tmin,Tmax,N,Win,P) computes the Fourier Transform
% of the real valued signal described by the function FUN which is the
% character string name of a user created M-file function.
% The function is called as f=FUN(t) where t=linspace(Tmin,Tmax,N).
% Make N a power of 2 for speed.
%
% Win is an optional string identifying the window function to use:
% 'rec' = Rectangular or Boxcar
% 'bar' = Bartlett (triangle with zero endpoints)
% 'tri' = Triangular (nonzero endpoints)
% 'han' = Hann or Hanning
% 'ham' = Hamming
% 'bla' = Blackman common coefs.
% 'blx' = Blackman exact coefs.
% 'rie' = Riemann {sin(x)/x}
% 'tuk' = Tukey,  0< P < 1; P = 0.5 is default
% 'poi' = Poisson, 0< P < inf; P = 1 is default
% 'cau' = Cauchy, 1< P < inf; P = 1 is default
% 'gau' = Gaussian, 1< P < inf; P = 1 is default
%
% P is an optional parameter for the last four window functions.
% If Win is not given the time domain signal is not windowed.
%
% F is the Fourier Transform with frequency bins in FFT order.
% w is the FFT bin frequencies associated with F.
% Use MMFFTPFC(F,w) to extract the positive frequency components.
%
% See also: MMWINDOW, MMFFTPFC, MMFFTBIN, FFT.

% Calls: mmfftbin mmwindow

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/29/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<6, p=[]; end
if nargin<5, win='rec'; end
if ~ischar(FUN), error('FUN Must be a Function M-file Name.'), end
if ~ischar(win), error('Win Must be a Character String.'), end

t=linspace(Tmin,Tmax,N);
Ts=t(2)-t(1);
f=feval(FUN,t);
w=mmwindow(win,f,p);
F=fft(f.*w)*Ts;  % FT is FFT * Ts
w=mmfftbin(F,Ts);
