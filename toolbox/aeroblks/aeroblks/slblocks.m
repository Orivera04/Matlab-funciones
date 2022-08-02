function blkStruct = slblocks
%SLBLOCKS Defines the Simulink library block representation
%   for the Aerospace Blockset.

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $  $Date: 2004/04/06 01:04:23 $

  
  
blkStruct.Name    = sprintf('Aerospace\nBlockset');
blkStruct.OpenFcn = 'aerolib';
blkStruct.MaskInitialization = ['th = (pi/3) + (pi/3)*[0:0.1:1];                      '... 
                                'xe = cos(th)+0.5; ye = sin(th)-0.7;                  '...
		                'xp = [ 0.55 0.95 0.90 0.62 0.55 0.55 NaN 0.00 0.55 ];'...
		                'yp = [ 0.60 0.60 0.62 0.65 0.72 0.60 NaN 0.63 0.63 ];'];

blkStruct.MaskDisplay = 'plot([xe, NaN, xp],[ye, NaN, yp]);';


% Define the library list for the Simulink Library browser.
% Return the name of the library model and the name for it
Browser.Library = 'aerolibv1';
Browser.Name    = 'Aerospace Blockset';
Browser.IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;

% End of slblocks.m
