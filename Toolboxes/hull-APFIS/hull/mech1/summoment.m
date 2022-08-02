function [moment]=summoment(vectors, coords)
%SUMMOMENT Solves for the moment caused by a set of forces.
%   [moment]=SUMMOMENT(VECTORS, [X,Y])  Given a set of known force
%   vectors in standard multi vector format, the routine will return the
%   resultant moment as seen from the coordinates passed in with the known
%   force vectors.  If no coordinates are specified then the moment is 
%   calculated about the origin.  Right hand rule for sign convention.
%
%   See also ONEVECTOR, REACTION, SUMFORCE, THREEVECTOR, TWOVECTOR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if nargin==1 % if coordinates are not included
  xpos=0; % coordinates default to zero
  ypos=0; % coordinates default to zero
else
  xpos=coords(1);
  ypos=coords(2);
end

[xmag,ymag,xcor,ycor]=breakup(vectors); % call subroutine
xmoment=sum(xmag.*(ypos-ycor)); % X forces times moment arm
ymoment=sum(ymag.*(xcor-xpos)); % Y forces times moment arm
moment=xmoment+ymoment; % sum both moments
