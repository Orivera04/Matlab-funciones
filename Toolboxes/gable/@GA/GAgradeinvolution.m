function T = GAgradeinvolution(A)
%GAgradeinvolution(A): returns the grade involution of a GA object.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
T=GA([A.m(1);-A.m(2);-A.m(3);-A.m(4);A.m(5);A.m(6);A.m(7);-A.m(8)]);
     
