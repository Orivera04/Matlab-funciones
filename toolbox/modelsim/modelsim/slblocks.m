function blkStruct = slblocks
%SLBLOCKS Defines Simulink library block representation

% $RCSfile: slblocks.m,v $
% $Revision: 1.3.4.2 $
% $Date: 2004/04/08 20:54:57 $
% Copyright 2003-2004 The MathWorks, Inc.

blkStruct.Name    = ['Link for ModelSim'];
blkStruct.OpenFcn = 'modelsimlib';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = 'disp(''ModelSim'')';

% Define the library list for the Simulink Library browser.
% Return the name of the library model and the name for it

Browser(1).Library = 'modelsimlib';
Browser(1).Name    = 'Link for ModelSim';
Browser(1).IsFlat  = 1;

blkStruct.Browser = Browser;

% [EOF] slblocks.m
