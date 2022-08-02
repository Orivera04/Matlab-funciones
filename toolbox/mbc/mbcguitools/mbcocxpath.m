function pth = mbcocxpath
%MBCOCXPATH Return the path to the mbc ocx directory
%
%  PTH = MBCOCXPATH returns teh full path to the directory where the MBC
%  ocx file and its supporting libraries are held.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.4.2 $

pth = fullfile(fileparts(mfilename('fullpath')), 'ocx');