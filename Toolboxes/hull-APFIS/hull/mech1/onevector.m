function [resultant]=onevector(knowns)
%ONEVECTOR Vector that is the negative of sum of forces acting at a point. 
%   ONEVECTOR(KNOWNS)  Routine takes a single point acted upon by a set of 
%   known force vectors and balanced by one unknown force and solves for the
%   unknown force. The answer is returned as a standard multi vector format.
%   This routine is particularly designed for truss problems.
%
%   KNOWNS matrix is in standard multi vector format.
%
%   See also REACTION, SUMFORCE, SUMMOMENT, THREEVECTOR, TWOVECTOR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

[xmag ymag xcor ycor]=breakup(knowns);
flagx = xcor ~= mean(xcor)*ones(size(xcor));
flagy = ycor ~= mean(ycor)*ones(size(ycor));
if (flagx | flagy)
  disp ('In onevec.m all vectors must originate from the same point')
  return
end % if not all from same point

resultant=[-sum(xmag) -sum(ymag) xcor(1) ycor(1)];
