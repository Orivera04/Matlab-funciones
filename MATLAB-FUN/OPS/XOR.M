function X = xor(S,T)
%XOR	Exclusive "or".
%	xor(S,T) is the symmetric difference of the nonzero
%	structures of S and T.  The result is one where
%	either S or T, but not both, is nonzero.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

X = (S|T) - (S&T);
