function sos = ss2sos(a,b,c,d,IU,direction_flag)
%SS2SOS	State-space to second-order sections linear system model conversion
%	SOS = SS2SOS(A,B,C,D) finds a matrix SOS in second-order sections form
%	which represents the same system as the one with single-input, 
%	single-output state space matrices A, B, C, and D.  The zeros and 
%	poles of the system A, B, C, D must be in complex conjugate pairs.
%
%	SOS = SS2SOS(A,B,C,D,IU) uses the IUth input of the multi-input, single-
%	output state space matrices A, B, C and D.
% 
%	SS2SOS(A,B,C,D,'down') and SS2SOS(A,B,C,D,IU,'down') order the sections
%	so that the first row of SOS contains the poles closest to the unit 
%	circle.  Without the 'down' flag, the sections are ordered in the other
%	direction.
%
%	The output SOS is an L by 6 matrix which contains the coefficients 
%	of each second-order section in its rows:
%	    SOS = [ b01 b11 b21  a01 a11 a21 
%	            b02 b12 b22  a02 a12 a22
%	            ...
%	            b0L b1L b2L  a0L a1L a2L ]
%	The pole-zero conjugate pairs which are closest to each other are 
%	arranged into the same 2nd-order section.  Furthermore, the numerator
%	coefficients of each section are scaled so that the maximum of the
%	magnitude of the DTFT of the cascade is very close to 1.
%
%	The system transfer function is the product of the second-order transfer
%	functions of the sections.  Each row of the SOS matrix describes
%	a 2nd order transfer function as
%	        b0k +  b1k z^-1 +  b2k  z^-2
%	        ----------------------------
%	        a0k +  a1k z^-1 +  a2k  z^-2
%	where k is the row index.
%
%	See also SOS2SS, ZP2SOS, SOS2TF, SOS2ZP, CPLXPAIR.

%       NOTE: restricted to real coefficient systems (poles and zeros 
%             must be in cojugate pairs)

%	Author(s): T. Krauss, 1993
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.6 $  $Date: 1994/01/25 18:00:01 $
 
error(nargchk(4,6,nargin))
if nargin == 4,
    IU = 1;
    direction_flag = 'up';
elseif nargin == 5,
    if isstr(IU),
        direction_flag = IU;  IU = 1;
    else
        direction_flag = 'up';
    end
end
if ~(strcmp(direction_flag,'up') | strcmp(direction_flag,'down')),
   error('The direction_flag argument to SS2SOS must be either ''up'' or ''down''.')
end
if size(b,2)>1,
    error('State-space system must have only 1 input')
end
 
[z,p,k]=ss2zp(a,b,c,d,IU);
sos = zp2sos(z,p,k,direction_flag);

