% File : mpc555_build_drivers
%
% Abstract :
%   Build the driver libraries for the mpc555
%

%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.2.6.5 $
%  $Date: 2004/04/29 03:40:06 $ 

function mpc555_build_drivers

	import('javax.swing.*');

	prefs = RTW.TargetPrefs.load('mpc555.prefs');
	try
		prefs.validate;
	catch
		uiwait(errordlg(lasterr,'Target Preference Error'));
		prefs.gui;
		return;
	end

	root = mpc555dkroot;

	switch prefs.ToolChain
	case 'Diab'
		toolchain = 'DIAB';
		toolchainroot = ['DIABROOT="' prefs.ToolChainOptions.CompilerPath '"'];
	case 'CodeWarrior'
		toolchain = 'CODE_WARRIOR';
		toolchainroot = ['CWROOT="' prefs.ToolChainOptions.CompilerPath '"'];
	end

	gmake = fullfile(matlabroot,'toolbox','rtw','targets','mpc555dk','bin','win32','make.exe'); 
	
	msg = { [ 'Build MPC555 driver library using '  prefs.ToolChain '.' ] , ' ', ...
			    'Which optimization level do you wish to use ? ' , ' ',  ...
				 [ 'speed = ' prefs.ToolChainOptions.CompilerOptimizationSwitches.Speed ] , ...
				 [ 'size  = ' prefs.ToolChainOptions.CompilerOptimizationSwitches.Size  ] , ...
				 [ 'debug = ' prefs.ToolChainOptions.CompilerOptimizationSwitches.Debug  ] , ' ', ...
				 'The above optimization settings are the values set in your' , ...
				 'Embedded Target for Motorola MPC555 Target Preferences', ' ' , ...
				 'clean = Delete all object files' , ' ' , ...
				 'Choose ''clean'' to delete all object files if you wish' , ...
				 'to completely rebuild the libraries. Selecting the other', ...
				 'optimization options without cleaning will only rebuild files', ...
				 'that may have changed since the last library build.', ' ', ...
				 'help   = get help on this dialog.' , ...
				 'cancel = do nothing and return to Matlab.' , ' ' };

	build = JOptionPane.showOptionDialog([], msg , 'Embedded Target for Motorola MPC555', ...
		JOptionPane.YES_NO_CANCEL_OPTION , JOptionPane.QUESTION_MESSAGE , ...
		[] , { 'Speed','Size','Debug','Clean','Help','Cancel' }, 'Cancel');

	clean = 0;
	opts = '';
    debugopts = '';
	switch build
	case 0
		opts=prefs.ToolChainOptions.CompilerOptimizationSwitches.Speed;
	case 1
		opts=prefs.ToolChainOptions.CompilerOptimizationSwitches.Size;
	case 2
		debugopts=prefs.ToolChainOptions.CompilerOptimizationSwitches.Debug;
	case 3
		clean = 1;
	case 4
		try
		helpview([docroot '/toolbox/mpc555dk/mpc555dk.map'],'mpc555_build_drivers')
		catch
		end
		mpc555_build_drivers;
		return;
	otherwise
		disp('Compiling canceled');
		return;
	end


	if clean
		cmd = sprintf(['%s -f rt_makefile DRIVERS_clean '...
                       'MPC555_TOOL_CHAIN=%s MPC555_OPTIMIZATION_FLAGS="%s" MPC555_DEBUG_FLAGS="%s" '...
                       'OVERRIDE_DEFAULT_OPT_OPTS=1 OVERRIDE_DEFAULT_DEBUG_OPTS=1 '... 
                       'MATLAB_ROOT="%s" %s'], ... 
			gmake, toolchain, opts, debugopts, bk2fwdslash(matlabroot), bk2fwdslash(toolchainroot));
	else
		cmd = sprintf(['%s -f rt_makefile DRIVERS '...
                       'MPC555_TOOL_CHAIN=%s MPC555_OPTIMIZATION_FLAGS="%s" MPC555_DEBUG_FLAGS="%s" '...
                       'OVERRIDE_DEFAULT_OPT_OPTS=1 OVERRIDE_DEFAULT_DEBUG_OPTS=1 '... 
                       'MATLABROOT="%s" %s'], ... 
			gmake, toolchain, opts, debugopts, bk2fwdslash(matlabroot), bk2fwdslash(toolchainroot));
	end

	disp('----------------------------------------------------------------------------------');
	disp(cmd);
	disp('----------------------------------------------------------------------------------');

    wd = cd;
    try
        cd(root);
        system(cmd);
        cd(wd);
    catch
        disp(lasterr);
        cd(wd);
    end


    function str = bk2fwdslash(str)
      str = strrep(str,'\','/');


