function mbc_startup(mode, filename)
%MBC_STARTUP Startup tasks common to both browsers
%
%  MBC_STARTUP(MODE, FILENAME)
%  
%  This function attempts to bring all browser startup tasks into one
%  place.  It is intended that mbcmodel and cage call this function if they
%  need to start their browser.
%
%  mbc_startup('mbcmodel');
%  mbc_startup('mbcmodel', 'project.mat');
%
%  mbc_startup('cage');
%  mbc_startup('cage', 'project.cag');

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.5 $    $Date: 2004/04/04 03:25:43 $ 

error(nargchk(1, 2, nargin, 'struct'));

% Need to check if the JVM (and swing) is running - need to do this first
if ~usejava( 'swing' )
     error('mbc:mbc_startup:NoJVM', ...
         'The Model-Based Calibration Toolbox requires a JVM to run.');
end

% Get the info structure for starting up the specifed tool
info = i_getmodeinfo(mode);
if isempty(info)
    error('mbc:mbc_startup:InvalidArgument', ...
        'Mode must be either ''mbcmodel'' or ''cage''.');
end

% Check and possibly prompt to install the ocx controls
ocxOK = mbcocxdlg;
if ~ocxOK
    error('mbc:mbc_startup:ActiveXError', ...
        'The Model-Based Calibration Toolbox ActiveX controls must be installed.');
end

% Create the splash screen
fsplash = [xregrespath,'\mbcsplash.bmp'];
h = com.mathworks.toolbox.mbc.gui.SplashScreen(fsplash, mbcver, info.splashMode);
h.setStatusString( info.statusString );
h.nonBlockingShow;

% Initialisations (screen size, classes, prefs )
try
   [ok, err] = i_initialisation(h, info);
catch
   ok = false;
   err = 'An untrapped error has occurred.';
end

if ~ok
    % Toolbox failed to start - close splash screen and exit
    h.setStatusString('Cleaning up...');
    try
        feval(info.cleanupFcn);
    end
    h.dispose;
    error('mbc:mbc_startup:InitializationFailed', err);
end

% Now try to start the browsers
try
    if nargin > 1
        h.setStatusString('Creating window and loading file...');
        feval( info.startFcn, filename );
    else
        h.setStatusString('Creating window...');
        feval(info.startFcn);
    end
    h.dispose;
catch
    h.setStatusString('Cleaning up...');
    try
        feval( info.cleanupFcn);
    end
    h.dispose;
    rethrow( lasterror );
end



% ----------------------------------------
function [OK, err] = i_initialisation( h, info )
% Checks screen size and current directory checks out licenses and
% initialises classes and preferences 

OK = true;
err = '';

%  (1) Check screen size
h.setStatusString('Checking display size...');
screensize = get(0,'screensize');
if screensize(3)<1024 || screensize(4)<768
   OK = false;
   err = ['Display size too small.  The Model-Based Calibration Toolbox ' ...
       'requires a screen size of at least 1024 x 768 pixels.'];
   return
end

%  (2) Check we are not in a class/package directory
[path_notused, currentDir] = fileparts( pwd );
if ~isempty(currentDir) && strcmp(currentDir(1), '@')
    OK = false;
    err = ['The Model-Based Calibration Toolbox should not be started from ' ...
        'within a MATLAB class directory.  Change the current MATLAB directory ' ...
        'to a folder that does not start with an ''@'' character.'];    
end

%  (3) Checkout essential licenses
h.setStatusString('Checking out toolbox licenses...');
if ~mbcchecklicenses( info.licenseChkOuts )
   OK = false;
   err = ['Failed to check out required toolbox licenses.  Check that you ' ... 
       'have available licenses for the products that the Model-Based ' ...
       'Calibration Toolbox depends on'];
   return
end

%  (4) Initialise UDD Classes
h.setStatusString('Loading classes...');
try
    for n = 1:length( info.packageList )
        findclass( findpackage( info.packageList{n} ) );
    end
catch
    OK = false;
    err = ['Failed to initialise class definitions.  Try resetting you toolbox ' ...
        'path cache (see HELP REHASH) and check that your MATLAB path is set ' ...
        'up correctly.  If you still see this error then your installation of ' ...
        'the Model-Based Calibration Toolbox may be corrupted or incomplete.'];
    return
end

%  (5) Initialise Prefs
%  This will gather the user information if this is the first time run
h.setStatusString('Loading preferences');
try
    P = mbcprefs('mbc');
catch
    OK = false;
    err = ['Failed to initialise preferences.  Your Model-Based Calibration ' ...
        'Toolbox user preferences may be corrupted.  You can reset the preferences ' ...
        'by deleting any "MBC" sub-directories from the MATLAB preference ' ...
        'directory (Your MATLAB preferences are stored in the location returned ' ...
        'by the function PREFDIR).'];
    return
end

% ----------------------------------------
function i_CGCleanup
% Called if there was an error during browser creation

c = cgbrowser;
try
    c.forceclose;
end
try
    delete(c);
end
clear cgbrowser;
hCG = cgf;
if ~isempty(hCG)
    try
        delete(hCG);
    end
end

% ----------------------------------------
function i_MBCleanup
% Called if there was an error during browser creation

mb = MBrowser;
try
    delete(mb);
end
clear MBrowser;
hMB = mvf;
if ~isempty(hMB)
    try
        delete(hMB);
    end
end


% ----------------------------------------
function info = i_getmodeinfo(mode)
% Return the correct info structure for mode
switch mode
    case 'mbcmodel'
        info = struct(...
            'startFcn', @MBstart, ...
            'cleanupFcn', @i_MBCleanup, ...
            'statusString', 'Starting Model-Based Calibration...', ...
            'splashMode', com.mathworks.toolbox.mbc.gui.SplashScreen.MBCMODEL, ...
            'licenseChkOuts', [0 2 4 6 8], ...
            'packageList', {{'mbcfoundation', 'mbcwidgets', 'xregGui', ...
            'mbctable', 'mbcgraph', 'xregtools', 'xregMdlGui', ...
            'xregdesgui', 'xregdatagui'}} ...
            );
    case 'cage'
        info = struct(...
            'startFcn', @cgbstart, ...
            'cleanupFcn', @i_CGCleanup, ...
            'statusString', 'Starting Calibration Tool...', ...
            'splashMode', com.mathworks.toolbox.mbc.gui.SplashScreen.CAGE, ...
            'licenseChkOuts', [2 4 6 8], ...
            'packageList', {{'mbcfoundation', 'mbcwidgets', 'xregGui', ...
            'mbctable', 'mbcgraph', 'cgtools', 'cgcategory', 'cgtypes', ...
            'cgdatasetgui', 'cgtradeoffgui', 'cgoptimgui', 'cgsurfview'}} ...
            ); 
    otherwise
        info = [];
end
