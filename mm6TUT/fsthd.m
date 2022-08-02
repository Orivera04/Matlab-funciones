function d=fsthd(kn,i)
%FSTHD Total Harmonic Distortion of a Fourier Series. (MM)
% FSTHD(Kn) computes the total harmonic distortion of
% the Fouries series Kn, using its fundamental component
% as the reference signal.
% FSTHD(Kn)=sqrt(FSMSV(Kn#)/FSMSV(K1)) where
% Kn# is Kn with its -1 and +1 components deleted, and K1 is
% a Fourier series containing the -1 and +1 components only.
%
% FSTHD(Kn,i) computes the distortion using the -i and +i
% components as the reference signal.
%
% See also FSHELP.

% Calls: fssize fsmsv fsharm

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/15/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

ndc=fssize(kn)+1;
k=kn;
if nargin==1, i=[-1 1];       % use fundamental components
else,         i=[-i(1) i(1)]; % use selected components
end
k(ndc+i)=[];
d=sqrt(fsmsv(k)/fsmsv(fsharm(kn,i)));
