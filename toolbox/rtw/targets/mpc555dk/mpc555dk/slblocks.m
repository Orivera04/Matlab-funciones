function blkStruct = slblocks
%SLBLOCKS Defines the block library for a specific Toolbox or Blockset.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.2.2 $
%   $Date: 2004/04/19 01:27:14 $

% Information for "Blocksets and Toolboxes" subsystem
blkStruct.Name = sprintf('Motorola®\nMPC555');
blkStruct.OpenFcn = 'mpc555library';
blkStruct.MaskDisplay = 'disp(''MPC555'')';

% Information for Simulink Library Browser
Browser(1).Library = 'mpc555library';
Browser(1).Name    = 'Embedded Target for Motorola® MPC555';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;

% End of slblocks
