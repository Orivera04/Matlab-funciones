function v = FE(f,n)
% FE(f,n): return basis element n of frame f
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
m = inv(f.m(2:4,2:4));
if nargin ~= 2
  error('FE takes two arguments');
else
  v = GA([0;m(1:3,n);0;0;0;0]);
end
