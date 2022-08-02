function [vector]=xy2deg(inputs)
%XY2DEG Converts vectors in standard form to degree angle form.
%   XY2DEG (INPUTS) Routine takes any number of force vectors in standard form
%   and returns them in degree angle format.
%
%   INPUTS: [XMAG,YMAG,XCOR,YCOR]
%   OUTPUTS: [ANGLE,MAG,XCOR,YCOR]
%
%   See also DEG2XY, RAD2XY, RISE2XY, XY2RAD.
%

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
angle=RD(atan2(inputs(:,2),inputs(:,1))); % angles from inputs

vector=[angle,mag,xcor,ycor]; % reassemble complete answer
