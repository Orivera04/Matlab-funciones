function [reactions]=threevector(knowns, unknowns, couples)
%THREEVECTOR Solves for three force vectors of known direction only.
%   THREEVECTOR (KNOWNS, UNKNOWNS, COUPLES)  Routine takes a rigid body 
%   acted upon by a set of known load vectors and balanced by a set of three
%   forces of known direction and unknown magnitude, and solves for the
%   previously unknown magnitudes.   The answer is returned in standard 
%   multivector format. Angles are to be given in radians.
%
%   KNOWNS matrix is in standard format
%   UNKNOWNS: [ANGLE1, X1, Y1; ANGLE2, X2, Y2; ANGLE3, X3, Y3];
%   COUPLES matrix is optional [COUPLE1, COUPLE2, COUPLE3 ...];
%
%   See also ONEVECTOR, REACTION, SUMFORCE, SUMMOMENT, TWOVECTOR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if nargin==2 couples=0; end % couples defaults to zero

coef(1,:)=cos(unknowns(:,1)'); 
coef(2,:)=sin(unknowns(:,1)');
coef(3,:)=unknowns(:,2)'.*coef(2,:)-unknowns(:,3)'.*coef(1,:);

answ(1,:)=(-1)*sum(knowns(:,1));
answ(2,:)=(-1)*sum(knowns(:,2));
answ(3,:)=(-1)*(summoment(knowns)+couples);

valu=inv(coef)*answ; % solving a system of three equations three unknowns

reactions(:,1)=coef(1,:)'.*valu;
reactions(:,2)=coef(2,:)'.*valu;
reactions(:,3:4)=unknowns(:,2:3);
