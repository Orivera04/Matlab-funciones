function [b,a] = sos2tf(sos)
%SOS2TF	2nd-order sections to transfer function linear system model conversion
%	[B,A] = SOS2TF(SOS) returns the numerator and denominator coefficients 
%	B and A of the discrete-time linear system given by SOS in second-order
%	sections form.
%
% 	SOS is an L by 6 matrix which contains the coefficients of each 
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
%	See also ZP2SOS, SOS2ZP, SOS2SS, SS2SOS

%	Author(s): T. Krauss, 1993
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/25 17:59:52 $
 
if nargin ~= 1,
    error('Requires one input argument.')
end

L = size(sos,1);
b = 1;
a = 1;
for i=1:L,
    b1 = sos(i,1:3);
    a1 = sos(i,4:6);
    if b1(3) == 0,     % strip zero coefficients
        if b1(2) == 0,
            b1(2:3) = []; 
        else
            b1(3) = []; 
        end
    end
    if a1(3) == 0,     % strip zero coefficients
        if a1(2) == 0,
            a1(2:3) = []; 
        else
            a1(3) = []; 
        end
    end
    b = conv(b,b1);
    a = conv(a,a1);
end

