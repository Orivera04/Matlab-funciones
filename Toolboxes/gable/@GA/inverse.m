function C = inverse(m)
%inverse(m): Computes the inverse of a multivector. 
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
     % G is the Clifford conjugate of m
     G = GA([m.m(1); -m.m(2); -m.m(3); -m.m(4); - m.m(5); -m.m(6);  -m.m(7);  m.m(8)]);
     V = GAproduct(m,G);	% V = mG
     % If mG is scalar, then inverse(mG)=1/(mG) and inverse is cheap
     %  V is of the form Scalar+Pseudoscalar, so to test if it is
     %  a scalar, we just check the pseudoscalar coefficient.
     if V.m(8) == 0
        Den=V.m(1);
        if Den==0
	  disp('This multivector does not have an inverse.');
	  if GAautoscalar
	    C=0;
	  else
	    C=GA([0;0;0;0;0;0;0;0]);
	  end
        else
          if GAautoscalar&isascalar(G)
             C=G.m(1)/Den;
          else
             C=(1/Den)*G;
          end
        end
     else
% Conceptually we want
%        Mi=GAproduct(smallinverse(V),G);
% But the following is more efficient
	Vi = smallinverse(V);
	S = prod(GAsignature);
	Mi = Vi.m(1)*G - S*Vi.m(8)*dual(G);

        if GAautoscalar&isascalar(Mi)
           C=Mi.m(1);
        else
           C=Mi;
        end
     end
