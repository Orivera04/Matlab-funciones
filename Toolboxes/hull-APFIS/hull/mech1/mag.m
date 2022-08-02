function [magnitude]=mag(inVector, direction)
% MAG Returns the magnitude of a vector.
%   MAG(VECTOR) is the total magnitude of the vector.
%
%   MAG(VECTOR, 'x') is the magnitude in the X direction.
%
%   MAG(VECTOR, 'y') is the magnitude in the Y direction.
%
%   See also MOVE, OPP.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

[xmag ymag xcor ycor]=breakup(inVector);
if nargin == 1
  direction='none';
end

direction = lower(direction);

if strcmp(direction,'x')
  magnitude=xmag;
elseif strcmp(direction,'y')
  magnitude=ymag;
else
  magnitude=sqrt(xmag.^2 + ymag.^2);
end
