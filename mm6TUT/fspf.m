function [PF,phi]=fspf(Vn,In)
%FSPF Power Factor Computation from Fourier Series. (MM)
% FSPF(Vn,In) computes the power factor associated with the
% voltage and current Fourier Series given Vn and In respectively.
% FSPF(In) assumes that the voltage is a cosine at the fundamental.
%
% [PF,phi]=PFACTOR(...) also returns the power factor angle
% phi in degrees. If phi>0 power factor is lagging (inductive).
% If phi<0 power factor is leading (capacitive).
%
% See also FSHELP

% Calls: fsmsv fsharm

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/15/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2 % voltage is a cosine
   In=Vn;
   Vn=[1 0 1]/2;
end
Pn=conv(Vn,In);
ndc=(length(Pn)+1)/2;
PF=real(Pn(ndc))/sqrt(fsmsv(Vn)*fsmsv(In));
if nargout>1
   phi=180*(angle(fsharm(Vn,1))-angle(fsharm(In,1)))/pi;
end
