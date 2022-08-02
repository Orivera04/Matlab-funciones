function blkStruct = slblocks
% SLBLOCKS  Defines the Simulink library block representation
%           for the Simulink Parameter Estimation

% Copyright 1995-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $  $Date: 2004/04/11 00:44:00 $

blkStruct.Name    = sprintf('Simulink\nParameter\nEstimation');
blkStruct.OpenFcn = 'spelib';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = '';

% Define the library list for the Simulink Library browser.
% Return the name of the library model and the name for it.
Browser(1).Library = 'spelib';
Browser(1).Name    = 'Simulink Parameter Estimation';
Browser(1).IsFlat  = 0; % Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;

% End of slblocks.m
