% File : mpc555_bdm_blinky
%
% Abstract :
%   Runs a simple file that will 
%

%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.1.4.3 $
%  $Date: 2004/04/19 01:26:48 $ 
echo off
disp('#################################################################');
disp('Embedded Target For Motorola MPC555: Test Application.');
disp(' ');
disp('This command will load prebuilt application into the external RAM of the MPC555.');
disp('The program will alternate the state of the MIOS digital output pins.');
disp('If you are using a Phytec board you will see two LED''s flashing.');
disp(' ');
disp('Ensure that you have attached your BDM cable and have setup your hardware');
disp('according to the documentation for the Embedded Target for Motorola MPC555.');
disp(' ');
disp('Ensure that you have setup your Target Preferences for the Embedded Target');
disp('for Motorola MPC555. These will allow you to choose your compiler and debugger.');
disp('Target preferences can be accessed from the MATLAB start menu.');
disp(' ');
disp('#################################################################');
yn = input('Do you wish to load the applications? (Y/N)','s');
disp(' ');
disp(' ');

prefs = RTW.TargetPrefs.load('mpc555.prefs');
try
	prefs.validate;
catch
	uiwait(errordlg(lasterr,'Target Preference Error'));
	prefs.gui;
	return;
end

file = fullfile(mpc555dkroot,'drivers','src','applications', ...
		'test_external_ram', mpc555_bin_dir, 'test_external_ram.elf');

if ~isempty(regexp(yn,'^[Yy]'))
	 try
    	tgtaction('run','exe',file);
 	 catch
		disp('Error : Test Application');
		disp(' ');
		disp(lasterr);
	 end
end
