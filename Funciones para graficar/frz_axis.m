 function frz_axis(a,b);
% FRZ_AXIS : compatability for axis in all MATLAB versions.
%
%function frz_axis(a,b);
%
% Optional : a = axis grid corner values to be used (as in axis).
%          : b = type of plot being done,
%                0 = x linear, y linear
%                1 = x log, y linear
%                2 = x linear, y log
%                3 = x log, y log
%
% Replacement for axis, maintains compatability from MATLAB v3.x to v4.x
% Uses exist('clf') to determine MATLAB version #.
%
if exist('clf');
  if nargin > 0
    if nargin > 1                               % log based axis(es)
      if ( rem(b,2) == 1 ), a(1:2) = exp(a(1:2)*log(10)); end;
      if ( b > 1 ), a(3:4) = exp(a(3:4)*log(10)); end;
    end;
    axis(a); 
  else
    axis(axis);                                 % clear axis settings 
  end;
else
  if nargin == 0, axis; else; axis(a); end;     % old convention
end;
