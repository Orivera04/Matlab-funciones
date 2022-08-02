function blkStruct = slblocks
%SLBLOCKS Defines the block library for a specific Toolbox or Blockset.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.2.4.2 $

% Information for "Blocksets and Toolboxes" subsystem
blkStruct.Name = sprintf('OSEK-VDX');
blkStruct.OpenFcn = 'oseklibrary';
blkStruct.MaskDisplay = 'disp(''OSEK'')';

% Information for Simulink Library Browser
Browser(1).Library = 'oseklibrary';
Browser(1).Name    = 'Embedded Target for OSEK/VDX';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;
