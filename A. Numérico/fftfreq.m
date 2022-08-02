function f = fftfreq(fNyq,Npts)

%FFTFREQ To produce a two-sided frequency vector for use with an FFT.
%
%       f = FFTFREQ(fNyq,Npts) fNyq is the Nyquist frequency (half the
%       sampling frequency) and Npts is the number of points of the
%       associated FFT.  The frequency
%       extends from -fNyq to fNyq. E.g. try:
%
%       plot(fftfreq(1,N),abs(fftshift(fft(1:N))))
%
%       for N odd and N even.

%                                   Andrew Knight, June 1991

f = ( -floor(Npts/2) + ((1:Npts)-1) )*2*fNyq/Npts;

