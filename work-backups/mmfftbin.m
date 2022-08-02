function w=mmfftbin(X,Ts)
%MMFFTBIN FFT Bin Frequencies. (MM)
% MMFFTBIN(X,Ts) returns the continuous time bin frequencies
% in rad/sec associated with the components of the FFT data in X.
% Ts is the sampling period of the underlying time domain signal.
% X must be the vector or matrix output of the FFT function.
%
% For example, if N=length(X)=8, w=[0 1 2 3 4 -3 -2 -1]*2*pi/(N*Ts).
%
% See also: MMFFTPFC, MMFFTPFC, MMFTFIND, FFT, IFFT

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/29/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

xsiz=size(X);
if ndims(X)>2, error('X Must be 2D.'), end

if min(xsiz)>1  % matrix input
   N=xsiz(2);
else            % vector input
   N=max(xsiz);
end
w=[0:floor(N/2) floor((-N/2+1)):-1]*2*pi/(N*Ts);

if min(xsiz)>1 | xsiz(2)==1  % return column if X is a column or matrix
   w=w';
end
