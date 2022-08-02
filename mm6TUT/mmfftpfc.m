function [Y,Wp]=mmfftpfc(X,W)
%MMFFTPFC FFT Positive Frequency Components. (MM)
% Y=MMFFTPFC(X) returns the DC and positive frequency components
% of the FFT data in X.
% X must be the vector or matrix output of the FFT function.
%
% [Y,Wp]=MMFFTPFC(X,W) where W is the FFT bin frequencies associated
% with X, i.e., W=MMFFTBIN(X,Ts), in addition returns a modified
% FFT bin frequency vector in Wp.
%
% See also: MMFFTBIN, MMFTFIND, FFT, IFFT.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/29/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

xsiz=size(X);
if ndims(X)>2, error('X Must be 2D.'), end

if min(xsiz)>1  % matrix input
   Np=floor(xsiz(2)/2)+1;
   Y=X(1:Np,:);
else            % vector input
   Np=floor(max(xsiz)/2)+1;
   Y=X(1:Np);
end
if nargout==2 & nargin==2
   Wp=W(1:Np);
end
