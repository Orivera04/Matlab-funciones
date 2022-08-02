function b = isabivector(G)
%isabivector(G): Return 1 if G is a bivector, 0 otherwise
% Obsolete.  Use GAisa or isGrade instead.
%
%See also gable, GAisa, isGrade.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if isa(G,'GA') & sum(abs(G.m(1:4))) == 0 & G.m(8)==0
  b = 1;
else
  b = 0;
end
