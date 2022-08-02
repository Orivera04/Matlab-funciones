function blkStruct = slblocks
%SLBLOCKS Defines the block library for a specific Toolbox or Blockset.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.2.4.2 $
%   $Date: 2004/04/19 01:18:40 $

% Information for "Blocksets and Toolboxes" subsystem
blkStruct.Name = sprintf('Infineon C166®\nMicrocontrollers');
blkStruct.OpenFcn = 'c166library';
blkStruct.MaskDisplay = 'disp(''C166'')';

% Information for Simulink Library Browser
Browser(1).Library = 'C166library';
Browser(1).Name    = 'Embedded Target for Infineon C166® Microcontrollers';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;

% End of slblocks
