function f = mypeaks(xyData , parameterRanges)
%MYPEAKS Sample objective function for differential evolutionary GA demo.
%   F = MYPEAKS(XY, RANGES) returns the value of the objective function F
%   associated with 2-column matrix of (x,y) points in XY. RANGES is 2-by-2
%   matrix of lower/upper bounds for each (x,y) point in the genetic population
%   found in XY.
%
%   This is just a simple wrapper around the PEAKS function, and is used only 
%   for the purpose of demonstrating the GA demo.
%
%   See also DEGATOOL, DISPLAYSUMMARYINFO, DEGADEMO, RUNBUTTONCALLBACK.

% Author(s): R.A. Baker, 06/18/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.6 $   $Date: 2002/04/14 21:45:22 $

x  =  xyData(:,1);
y  =  xyData(:,2);

z = peaks(x , y);


if nargin  == 1
   Xmin  =  -3;
   Xmax  =   3;
   Ymin  =  -3;
   Ymax  =   3;
else
   Xmin  =  parameterRanges(1,1);
   Xmax  =  parameterRanges(1,2);
   Ymin  =  parameterRanges(2,1);
   Ymax  =  parameterRanges(2,2);
end


Xbelow  =  20*abs(min(x    - Xmin , 0)).^1;
Xabove  =  20*abs(min(Xmax - x    , 0)).^1;

Ybelow  =  20*abs(min(y    - Ymin , 0)).^1;
Yabove  =  20*abs(min(Ymax - y    , 0)).^1;


f  =  z  - (Xbelow  +  Yabove  +  Xbelow +  Yabove);

f = z;
