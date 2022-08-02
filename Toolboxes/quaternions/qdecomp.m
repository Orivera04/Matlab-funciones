function [v,phi]=qdecomp(q)
% [V,PHI]=QDECOMP(Q) breaks out the unit vector and angle of rotation
%     components of the quaternion(s).  Input will be run through QNORM to
%     insure that the component quaternion(s) are normalized.
%
% See also ISNORMQ, QNORM.
  
% Release: $Name: quaternions-1_2_2 $
% $Revision: 1.10 $
% $Date: 2001/05/01 20:20:30 $
 
% Copyright (C) 2001, Jay A. St. Pierre.  All rights reserved.
 

if nargin~=1
  error('qdecomp() requires one input argument');
else
  qtype = isq(q);
  if ( qtype == 0 )
    error(['Input Q must be a quaternion or a vector of quaternions'])
  end
end

% Make sure q is a column of quaternions
if( qtype == 1 )
  q=q.';
end

% Make sure quaternion is normalized to prevent warnings when using
% sin(acos())
q=qnorm(q);

half_phi=acos(q(:,4));

sin_half_phi=sin(half_phi);

phi_zero_index    = find(sin_half_phi==0);
phi_notzero_index = find(sin_half_phi~=0);

if (~isempty(phi_zero_index))
  v1(phi_zero_index) = q(phi_zero_index, 1);
  v2(phi_zero_index) = q(phi_zero_index, 2);
  v3(phi_zero_index) = q(phi_zero_index, 3);
end

if (~isempty(phi_notzero_index))
  v1(phi_notzero_index) = ...
      q(phi_notzero_index,1)./sin_half_phi(phi_notzero_index);
  v2(phi_notzero_index) = ...
      q(phi_notzero_index,2)./sin_half_phi(phi_notzero_index);
  v3(phi_notzero_index) = ...
      q(phi_notzero_index,3)./sin_half_phi(phi_notzero_index);
end

v=[v1(:) v2(:) v3(:)];
phi=2*half_phi;
