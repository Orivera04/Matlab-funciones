function b = isavector(G)
%isavector(G): Return 1 if G is a vector, 0 otherwise
% Obsolete.  Use GAisa or isGrade instead.
%
%See also gable, GAisa, isGrade.


% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if isa(G,'GA') & sum(abs(G.m(5:8))) == 0 & G.m(1)==0
  b = 1;
else
  b = 0;
end
