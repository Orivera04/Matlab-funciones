function C = GAplus(M,N)
%GAplus(M,N): add two multivectors.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
    C=GA([M+N;0;0;0;0;0;0;0]);
