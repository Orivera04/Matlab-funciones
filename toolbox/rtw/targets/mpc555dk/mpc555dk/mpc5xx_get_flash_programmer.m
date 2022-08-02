% File : mpc5xx_get_flash_programmer
%
% Abstract :
%   
%		Returns the location of the flash_programmer elf file. This is dependant on the
%
%		toolchain selected 
%		processor variant of the target board
%		Oscillator Frequency of the target board
%
%		
%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.3 $
%  $Date: 2004/04/19 01:27:11 $ 
function flash_programmer = mpc5xx_get_flash_programmer
 
	prefs = RTW.TargetPrefs.load('mpc555.prefs');
	osc = prefs.TargetBoard.OscillatorFrequency;
    switch prefs.TargetBoard.ProcessorVariant
        case '555'
            % The 555 has an oscillator specific flash driver
            osc = [ '_osc' osc ];
        case {'561' '562' '563' '564' '565' '566'}
            % These processors do not have oscillator specific flash
            % drivers
            osc = '';
        otherwise
            error('Unknown MPC5xx variant specified!');
    end
	flash_programmer = ['flash_programmer' osc '_ram.elf' ];

	flash_programmer = fullfile(mpc555dkroot,'drivers','src', ...
        'applications','flash_programmer', ...
        mpc555_bin_dir, flash_programmer);
