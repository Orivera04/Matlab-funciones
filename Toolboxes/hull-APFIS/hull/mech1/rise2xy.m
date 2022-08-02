function [vector]=rise2xy(inputs)
%RISE2XY Converts vectors in rise-run format to standard form.
%   RISE2XY (INPUTS) Routine takes any number of force vectors described by
%   their angle and magnitude along with an optional set of coordinates and
%   returns the force vector in standard form.  If the coordinates are not
%   specified, they will default to the origin.   
%
%   INPUTS: [RISE,RUN,MAG,XCOR,YCOR]
%
%   See also DEG2XY, DIST2X, DIST2Y, DISTLOAD, RAD2XY, XY2DEG, XY2RAD.
 
%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00


[r,c]=size(inputs);

if c==5 % if coordinates were given
  ycor=inputs(:,5); % pull coordinates out of input matrix
  xcor=inputs(:,4); % pull coordinates out of input matrix
end

mag=inputs(:,3); % pull magnitudes out of input matrix
run=inputs(:,2); % pull run out of input matrix
rise=inputs(:,1); % pull rise out of input matrix

if c==3 % if coordinates were not given
  xcor=zeros(r,1); ycor=zeros(r,1); % coordinates default to origin
end

angle=atan2(rise,run); % convert to radians

xvec=cos(angle).*mag; % equation 1.2
yvec=sin(angle).*mag; % equation 1.2

vector=[xvec,yvec,xcor,ycor]; % reassemble complete answer
