%MBCSETUP Install system files needed by MBC Toolbox on local machine.
%   This function is implemented as a MEX file and will install 
%   files into the system folder on the local machine.
%
%   This should not be called directly, instead you should use the 
%   MBCCONFIG.M file as an interface to this function.
%
%   See also MBCCONFIG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.7.6.1 $  $Date: 2004/02/09 06:49:04 $


%   This function is provided as a way to update the system files from MATLAB
%   so that you don't need to run the installer.  This is useful for sites that
%   have one central MATLAB installation instead of installing MATLAB localy on
%   each machine.
%
%
%  Calling syntax:
%
%  [stat, errmsg] = mbcsetup(mode, fname, sysfile, reg, count)
%
%  Inputs: mode - 'install' or 'uninstall'
%          fname - Fully qualified path to file to install or uninstall
%                  This file should always be in the MATLAB tree, even when
%                  we are uninstalling it from the system folder.
%          sysfile - 1 if file belongs in the windows system folder.
%                    0 if file belongs somewhere in the the MATLAB tree.
%          reg - 1 to register/unregister file, 
%                0 to not register/unregister
%          count - 1 to modify the the SharedDLLs registry counter, 
%                  0 to not modify the registry.
%   
%  Outputs: stat - 1 for success, 0 for failure
%           errmsg - String containing any error message on failure.
%                    Empty string on success.
% 
%  If less than two outputs are specified and there is an error, this 
%  function will generate an error and will not return a value.
%

