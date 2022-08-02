function C = GAdual(A)
%GAdual(M): Computes the dual, M/I3, where M is a GA object.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

%The dual is calculated by right multiplication by the inverse of the
%pseudoscalar. In this case we get a negative sign from the grade of the
%pseudoscalar and the other term from the signature.
    S=prod(GAsignature);
    C=GAproduct(A,GA([0;0;0;0;0;0;0;-S]));
