function blkStruct = slblocks
% SLBLOCKS Defines the block library for Real-Time Workshop
% Embedded Coder

%   Copyright 1994-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $
%   $Date: 2003/05/17 04:47:42 $

blkStruct.Name = sprintf('Real-Time Workshop\nEmbedded Coder');
blkStruct.OpenFcn = 'rtweclib';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = 'disp(''RTW-EC'')';

Browser(1).Library = 'rtweclib';
Browser(1).Name    = sprintf('Real-Time Workshop Embedded Coder');
Browser(1).IsFlat  = 0; % Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;
  
