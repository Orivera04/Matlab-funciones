function out=getunits(des);
% GETUNITS  Get preferred viewing units
%
%   TP=GETUNITS(D) returns either 'coded' or 'natural'
%   This setting may be used for deciding how GUIs should appear.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:42 $

% Created 9/2/00


switch des.displaynatural
case 0
   out='coded'; 
case 1
   out='natural';
end
