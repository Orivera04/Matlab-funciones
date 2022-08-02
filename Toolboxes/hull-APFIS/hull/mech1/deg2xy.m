function [vector]=deg2xy(inputs)
%DEG2XY Converts vectors in degree angles to standard form.
%
%   [VECTOR]=DEG2XY (INPUTS) Routine takes any number of force
%   vectors described by their angle and magnitude along with an optional
%   set of coordinates and returns the force vector in standard form.
%
%   INPUTS: [ANGLE,MAG,XCOR,YCOR]
%
%   See also DIST2X, DIST2Y, DISTLOAD, RAD2XY, RISE2XY, XY2DEG, XY2RAD.   

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

[r,c]=size(inputs);

if c==4
  ycor=inputs(:,4); % pull coordinates out of input matrix
  xcor=inputs(:,3); % pull coordinates out of input matrix
end

mag=inputs(:,2); % pull magnitudes out of input matrix
angle=inputs(:,1); % pull angles out of input matrix

if c==2 % if coordinates were not given
  xcor=zeros(r,1); ycor=zeros(r,1); % coordinates default to origin
end

angle=DR(angle); % convert to radians

xmag=cos(angle).*mag; % equation 1.2   
ymag=sin(angle).*mag; % equation 1.2

vector=[xmag,ymag,xcor,ycor]; % reassemble complete answer
