function A = GAZ(B)
% GAZ(B): Set to zeros any element of the multivector B less than 1e-15
% 
%See also gable, gazv, blade, grade.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
A = B;
if abs(A) < 1e-15
    A = 0;
end
if ~GAautoscalar
    A = GA(A);
end
