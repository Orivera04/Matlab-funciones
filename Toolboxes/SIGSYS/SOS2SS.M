function [a,b,c,d] = sos2ss(sos)
%SOS2SS	Second-order sections to state space linear system model conversion
%	[A,B,C,D] = SOS2SS(SOS) returns the state space matrices A, B, C and D
%	of the discrete-time system given by SOS in second-order sections form.
%	SOS is an L by 6 matrix which contains the coefficients of each 
%	second-order section in its rows:
%	    SOS = [ b01 b11 b21  a01 a11 a21 
%	            b02 b12 b22  a02 a12 a22
%	            ...
%	            b0L b1L b2L  a0L a1L a2L ]
%	The system transfer function is the product of the second-order transfer
%	functions of the sections.  Each row of the SOS matrix describes
%	a 2nd order transfer function as
%	    b0k +  b1k z^-1 +  b2k  z^-2
%	    ----------------------------
%	    a0k +  a1k z^-1 +  a2k  z^-2
%	where k is the row index.
%
%	See also SS2SOS, ZP2SOS, SOS2ZP, SOS2TF 

%	Author: T. Krauss, 1993 
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/25 17:59:51 $
 
if nargin ~= 1,
    error('Requires one input argument.')
end

L = size(sos,1);
z = []; p = [];
for i=1:L,
    z = [z; roots(sos(i,[1 2 3]))];
    p = [p; roots(sos(i,[4 5 6]))];
end

k = prod(sos(:,1)./sos(:,4));

[a,b,c,d]=zp2ss(z,p,k);

