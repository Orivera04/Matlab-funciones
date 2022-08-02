function [reactions]=twovec(knowns, unknowns)
%TWOVECTOR Solves for two force vectors of known direction only.
%   TWOVECTOR(KNOWNS, UNKNOWNS)  Routine takes a single point acted upon by
%   a set of known load vectors and balanced by a set of two forces of known
%   direction and unknown magnitude, and solves for the previously unknown 
%   magnitudes. The answer is returned in standard multi vector format. 
%   Angles are to be given in radians. This routine is particularly designed
%   for truss problems.
%
%   KNOWNS matrix is in standard format
%   UNKNOWNS matrix [ANGLE1, ANGLE2];
%
%   See also ONEVECTOR, REACTION, SUMFORCE, SUMMOMENT, THREEVECTOR.


%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

[xmag ymag xcor ycor]=breakup(knowns);
flagx = xcor ~= mean(xcor)*ones(size(xcor));
flagy = ycor ~= mean(ycor)*ones(size(ycor));
if (flagx | flagy)
  disp ('In twovec.m all vectors must originate from the same point')
  return
end % if not all from same point
knowns=[sum(xmag) sum(ymag) xcor(1) ycor(1)];
[xmag ymag xcor ycor]=breakup(knowns);

k=sqrt(xmag^2+ymag^2);
angle=atan2(ymag, xmag);
alpha=unknowns(1);
beta=unknowns(2);

coef=[cos(alpha) cos(beta);sin(alpha) sin(beta)];
answ=-k*[cos(angle);sin(angle)];

mag=inv(coef)*answ;

reactions=[rad2xy([alpha mag(1) xcor ycor; beta mag(2) xcor ycor])];
