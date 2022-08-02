function y=fsresize(kn,n)
%FSRESIZE Resize a Fourier Series. (MM)
% FSRESIZE(Kn,N) resizes the complex exponential FS Kn to
% have +-N harmonics. If N is greater than the number of
% harmonics in Kn, zeros are added to the result.
% If N is less than the number of harmonics in Kn, the
% result is a truncated version of the input.
%
% FSRESIZE(Kn,Un) resizes the complex exponential FS Kn to
% have the same number of harmonics as the FS Un.
%
% See also FSHELP

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95, revised 4/2/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

N=length(n);
if N>1, n=(N-1)/2; end
nkn=fssize(kn);	% number of harmonics in kn
if n>=nkn
   zpadd=zeros(1,n-nkn);
   y=[zpadd kn(:).' zpadd];
else
   no=nkn+1;		%index of DC harmonic
   y=kn(no-n:no+n);
end
