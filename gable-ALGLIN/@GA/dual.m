function C = dual(A)
%dual(A): Computes the dual, A/I3
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

%The dual is calculated by right multiplication by the inverse of the
% pseudoscalar. In this case we get a negative sign from the grade of 
% the pseudoscalar and the other term from the signature.
    S=GAsignature;
% Conceptually we want
%    T=GAproduct(A,GA([0;0;0;0;0;0;0;-prod(S)]));
% but the code is more efficient as
    T = GA([A.m(8);S(1)*A.m(6);S(2)*A.m(7);S(3)*A.m(5);-S(1)*S(2)*A.m(4);-S(2)*S(3)*A.m(2);-S(3)*S(1)*A.m(3);-S(1)*S(2)*S(3)*A.m(1)]);
    if GAautoscalar&isascalar(T)
       C=T.m(1);
    else
       C=T;
    end
