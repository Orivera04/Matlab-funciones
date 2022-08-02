function [OK,err]=cg_startup(h)
% CG_STARTUP  Startup tasks for the Calibration Tool
%
%   cg_startup(t)  where t is a uicontrol text object
%   which can be updated to display the current startup task.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.10.4.3 $  $Date: 2004/02/09 08:39:19 $

OK=1;
err='';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
%  (1) Check screen size                             %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h.setStatusString('Checking display size...');
screensize = get(0,'screensize');
if screensize(3)<1024 | screensize(4)<768
   OK=0;
   err= 'Display size too small!  The Model-Based Calibration Toolbox requires at least 1024 x 768 pixels.';
   return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
%  (2) Check MATLAB Version                          %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h.setStatusString('Checking MATLAB version...');
ver=version;
vernum=str2double(ver(1:3))+str2double(ver(5)).*0.01;
if vernum<6
   ButtonName=questdlg(strvcat(...
      'The Model-Based Calibration Toolbox has been designed to run on MATLAB v6 or higher.',...
      'You will immediately experience fatal problems in this version.  Quit?'),'Invalid MATLAB version','OK','OK');
   switch ButtonName
   case {'OK'}
      OK=0;
      err='The Model-Based Calibration Toolbox requires MATLAB v6 or higher.';
      return
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
%  (3) Checkout essential licenses                   %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h.setStatusString('Checking out toolbox licenses...');
if ~mbcchecklicenses([2 4 6 8])
   OK=0;
   err='Failed to check out necessary toolbox licenses';
   return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
%  (4) Initialise UDD Classes                        %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.setStatusString('Loading classes...');
try
    findclass(findpackage('mbcfoundation'));
    findclass(findpackage('xregGui'));
    findclass(findpackage('mbctable'));
    findclass(findpackage('cgtools'));
    findclass(findpackage('cgsurfview'));
    findclass(findpackage('cgoptimgui'));
    findclass(findpackage('cgtypes'));
catch
    OK=0;
    err='Failed to initialise class definitions';
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
%  (5) Initialise Prefs                              %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This will gather the user information if this is the first time run
h.setStatusString('Loading preferences');
try
   P=mbcprefs('mbc');
catch
   OK=0;
   err='Failed to initialise preferences';
end
