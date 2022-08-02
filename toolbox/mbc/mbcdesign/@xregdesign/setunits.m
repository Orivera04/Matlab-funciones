function d=setunits(des,in);
% SETUNITS  Set preferred viewing units
%
%   D=SETUNITS(D,TP) where TP is 'coded' or 'natural' sets
%   a units flag in D.  This flag may be read using GETUNITS
%   and GUIs initialised appropriately.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:44 $

% Created 9/2/00


switch lower(in)
case 'coded'
   des.displaynatural=0; 
case 'natural'
   des.displaynatural=1;
end


if ~nargout
   nm=inputname(1);
   assignin('caller',nm,des);
else
   d=des;
   
end
