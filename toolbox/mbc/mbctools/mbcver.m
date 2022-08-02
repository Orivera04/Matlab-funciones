function [v,n]=mbcver
% MBCVER  Return the version number of the MBC toolbox
%
%  [STR, NUM]=mbcver returns a string and a numeric equivalent indicating 
%  the version of the Model-Based Calibration Toolbox.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.2.4 $  $Date: 2004/02/09 08:20:45 $



% use ver to get version number
versionStruct = ver('mbc');
% string representation
v=versionStruct.Version;
% numeric equivalent
n = sscanf(v, '%f');
