function [chanNames, rootSrcName] = privateChanNameInfo(videoFormat)
%PRIVATECHANNAMEINFO Get channel name information.
% 
%    [NAMES, SRCROOT] = PRIVATECHANNAMEINFO(FORMAT) returns 
%    the cell array of NAMES to be used for the ChannelName property,
%    and SRCROOT, the root string for the SourceName property.
%

%    CP 1-20-2002
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:07 $

% Define the names 
switch videoFormat,
case 'rs170',
    rootSrcName = 'rs170-';
    chanNames = {'mono'};
case 'ccir',
    rootSrcName = 'ccir-';
    chanNames = {'mono'};
case {'rgb', 'rgbntsc', 'rgbpal'},
    rootSrcName = 'rgb-';
    chanNames = {'red', 'green', 'blue'};
case 'pal',
    rootSrcName = 'pal-';
    chanNames = {'composite'};
case 'ntsc',
    rootSrcName = 'ntsc-';
    chanNames = {'composite'};
case 'secam',
    rootSrcName = 'secam-';
    chanNames = {'composite'};
case 'svideo',
    rootSrcName = 'svideo-';
    chanNames = {'composite'};
case 'y/c',
    rootSrcName = 'y/c-';
    chanNames = {'composite'};
case 'custom',
    rootSrcName = 'custom-';
    chanNames = {'custom'};
end
