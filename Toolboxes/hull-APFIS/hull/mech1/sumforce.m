function [resultant,couple]=sumforce(vectors)
%SUMFORCE Sums a set of vectors into one force vector and a couple.
%   [FORCE, COUPLE]=SUMFORCE (VECTORS)  Given a set of known vectors in 
%   standard multi vector format the routine will return the sum of those 
%   vectors as a single vector acting through a point so that there is no
%   couple needed to balance the original.  If such a vector placement is 
%   not possible, a non-zero value for the couple will be returned. This
%   usually occurs due to a force couple being formed.
%
%   See also ONEVECTOR, REACTION, SUMMOMENT, THREEVECTOR, TWOVECTOR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

[xmag,ymag,xcor,ycor]=breakup(vectors); % call subroutine
couple=0; % set couple to zero
xres=sum(xmag); % x resultant
yres=sum(ymag); % y resultant

if xres==0 % if no x resultant
	ycen=0;	% move resultant onto x axis
	couple=couple+sum(xmag.*(-ycor)); % check for a couple
else % there is an x resultant
	ycen=sum(xmag.*ycor)/xres; % move x res to maintain equal moment 
end

if yres==0 % if no y resultant
	xcen=0; % move resultant onto y axis
	couple=couple+sum(ymag.*xcor); % check for a couple
else % there is a y resultant
	xcen=sum(ymag.*xcor)/yres; % move y res to maintain equal moment
end

resultant=[xres,yres,xcen,ycen]; % reassemble resultant matrix
