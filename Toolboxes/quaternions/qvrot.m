function v_out=qvrot(q,v)
% QVROT(Q,V) rotates the vector V using the quaternion Q.
%     Specifically performs the operation Q*V*qconj(Q), where the vector
%     is treated as a quaternion with a scalar element of zero.
%
%     Q and V can be vectors of quaternions and vectors, but they must
%     either be the same length or one of them must have a length of one.
%     The output will have the same shape as V.  Q will be passed through
%     QNORM to ensure it is normalized.
%
% See also QVXFORM, QNORM

% Release: $Name: quaternions-1_2_2 $
% $Revision: 1.7 $
% $Date: 2002/01/21 06:46:20 $
 
% Copyright (C) 2000-02, Jay A. St. Pierre.  All rights reserved.


if nargin~=2
  error('qvrot() requires two input arguments');
else
  q     = qconj(q);
  v_out = qvxform(q, v);
end
