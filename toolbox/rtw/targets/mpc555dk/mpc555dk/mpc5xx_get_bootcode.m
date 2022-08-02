% File : mpc5xx_get_bootcode 
%
% Abstract :
%   
%		Returns the location of the bootcode srecord file. This is dependant on the
%
%		toolchain selected 
%		processor variant of the target board
%		oscillator frequency of the target board
%		
%  Copyright 2002-2003 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $
%  $Date: 2004/04/19 01:27:10 $ 
function bootcodeS19 = mpc5xx_get_bootcode
 
	prefs = RTW.TargetPrefs.load('mpc555.prefs');
	osc = prefs.TargetBoard.OscillatorFrequency;
	bootcodename = ['bootcode_osc' osc '_flash.s19' ];
	bootcodeS19 = fullfile(mpc555dkroot,'drivers','src', ...
		'applications','bootcode',mpc555_bin_dir, bootcodename);
