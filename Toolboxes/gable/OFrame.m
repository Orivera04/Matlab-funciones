function f = OFrame(nf)
%OFrame(nf): set the output frame to nf.
% With no arguments, return the current output frame.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
persistent of;
if nargin==1
  of = nf;
end
f = of;
