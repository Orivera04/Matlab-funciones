function blkStruct = slblocks
%SLBLOCKS Defines the block library for a specific Toolbox or Blockset.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $

% Information for "Blocksets and Toolboxes" subsystem
blkStruct.Name = sprintf('Motorola®\nHC12');
blkStruct.OpenFcn = 'hc12drivers';
blkStruct.MaskDisplay = 'disp(''HC12'')';

% Information for Simulink Library Browser
Browser(1).Library = 'hc12drivers';
Browser(1).Name    = 'Embedded Target for Motorola® HC12';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;
