function Hn=fsdivide(Fn,Gn)
%FSDIVIDE Fourier Series Time Division. (MM)
% FSDIVIDE(Fn,Gn) returns the Fourier Series of f(t)/g(t),
% as represented by their Fourier Series Fn and Gn respectively.
% The resulting Fourier Series is as large as the largest of
% Fn and Gn.
%
% The function f(t)/g(t) must be well defined, e.g., g(t) must
% not cross zero. If g(t) crosses zero an error is returned.
%
% FSDIVIDE(1,Gn) finds the Fourier Series of the inverse of g(t).
%
% Warning: Both f(t) and g(t) may be well defined by Fn and Gn,
% but f(t)/g(t) may require many more harmonics than those in 
% Fn and Gn. This is particularly true if the f(t)/g(t) has
% sharp peaks.
%
% See also FSHELP

% Calls: fssize fsresize fsinterp

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/28/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[nf,msg]=fssize(Fn);
error(msg)
[ng,msg]=fssize(Gn);
error(msg)
nh=max(nf,ng);
Fn=fsresize(Fn,nh);  % make Fn and Gn the same size
Gn=fsresize(Gn,nh);
Gnr=Gn(end:-1:1);    % reverse Gn for convenience
tzero=fsinterp(Gn,0);
if ~isempty(tzero)
   error('G Must be NonZero Everywhere.')
end
Hlen=2*nh+1;   % length of FS vector
A=zeros(Hlen); % initial coefficient matrix
for i=1:nh     % fill in top half of matrix
   A(i,1:(nh+i))=Gnr((nh-i+2):end);
end
A(nh+1,:)=Gnr; % middle row
for i=1:nh     % fill in bottom half of matrix
   A(nh+1+i,(i+1):end)=Gnr(1:(end-i));
end
Hn=(A\Fn.').';