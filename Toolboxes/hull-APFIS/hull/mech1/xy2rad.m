function [vector]=xy2rad(inputs)
%XY2RAD Converts vectors in standard form to radian angle form.
%   XY2RAD (INPUTS) Routine takes any number of force vectors in standard form
%   and returns them in radian angle format.
%
%   INPUTS: [XMAG,YMAG,XCOR,YCOR]
%   OUTPUTS: [ANGLE,MAG,XCOR,YCOR]
%
%   See also DEG2XY, RAD2XY, RISE2XY, XY2DEG.   

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

if c==2 % if coordinates were not given
  xcor=zeros(r,1); ycor=zeros(r,1); % coordinates default to origin
end

mag=sqrt(inputs(:,1).^2+inputs(:,2).^2); % magnitudes from inputs
angle=atan2(inputs(:,2),inputs(:,1)); % angles from inputs

vector=[angle,mag,xcor,ycor]; % reassemble complete answer
