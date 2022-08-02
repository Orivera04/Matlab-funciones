function C=DrawOuter(A,B)
%DrawOuter(A,B): Draw A^B
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

C=DrawProduct(A,B,'wedge');
