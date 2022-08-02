function MVTinstall(varargin)
% MVTinstall installs the Marine Visualization Toolbox (MVT), version 1.0
%    MVTinstall install the Marine Visualization Toolbox functions and help
%    files as described below.
%
%    MVTinstall('toolbox') installs the Marine Visualization Toolbox into
%    the MATLAB path '[matlabroot]\toolbox\mvt', and adds this folder to 
%    your MATLAB search path. This enables the use of MVT as any other 
%    toolbox in MATLAB.
%
%    MVTinstall('help') install the help on how to use the Marine
%    Visualization Toolbox for use with the MATLAB help browser.
%
%    MVTinstall('uninstall') removes both the installations above, but not
%    the zipped files they were extracted from: MVT_toolbox.zip and
%    MVT_help.zip. These must be removed manually.
%
% Author:       Andreas Lund Danielsen
% Date:         26th November, 2003
% Revisions:    


% if no input arguments, install both the toolbox function and the help
% files
if ~nargin
    % headline
    disp('Installing the Marine Visualization Toolbox, version 1.0');
    disp(' ');
    % install toolbox
    MVTinstall('toolbox');
    % install help
    MVTinstall('help');
    % return from function
    return;
end

% convert input to char array
in_arg = char(varargin);

% search for installed files
disp('Searching for installed components...');
if ispref('mvt')
    
    % retrieve installed MVT version
    mvt_ver = getpref('mvt', 'version');
    disp(['Found the Marine Visualization Toolbox, version: ' num2str(mvt_ver)]);
    
    % display installed components
    % toolbox functions
    if ispref('mvt', 'toolbox')
        tbx_ver = getpref('mvt', 'toolbox');
        disp(['Found toolbox functions, version: ' num2str(tbx_ver)]);
    else
        disp('Toolbox not installed');
    end
    % help files
    if ispref('mvt', 'help')
        help_ver = getpref('mvt', 'help');
        disp(['Found help files, version: ' num2str(help_ver)]);
    else
        disp('Help files not installed');
    end
    disp(' ');
    
    % if the installed components are newer than this version (1.0),
    % ask is the user wants to continue
    if mvt_ver > 1
        
        % display 'Are you sure...' dialog
        disp('A newer version of the MVT is detected, continue?');
        buttonName = questdlg('A newer version of the MVT is detected, continue anyway?', ...
            'Continue?', 'Yes','No','No');        
        
        switch buttonName,
            case 'Yes', 
                % continue installation
                disp('Installation continued...');
                disp(' ');
            case 'Yes',
                error('Installation aborted by user.')            
        end % switch        
    end % if
    
else
    
    % does not exist
    disp('No components were found.');
    disp(' ');
    
    % uninstall?
    if strcmp(in_arg, 'uninstall')
        error('Cannot uninstall, no components were found!');
    end
    
end


% take action according to input
switch in_arg
    % install the toolbox files
    case 'toolbox'
        
        % is the file MVT_toolbox.zip located in this directory?
        if ~(exist('MVT_toolbox.zip')==2)
            error('The file MVT_toolbox.zip was not found!');
        end
        
        disp('Installing toolbox functions:');
        
        % name of toolbox folder
        mvt_folder = fullfile(matlabroot, 'toolbox', '');
        
        % unzip MVT functions to directory
        unzip('MVT_toolbox.zip', mvt_folder);
        
        % display message
        disp(['The Marine Visualization Toolbox was successfully extracted to: ' mvt_folder filesep 'mvt']);
        
        % add folder to MATLAB search path
        addpath([mvt_folder filesep 'mvt']);
        disp([mvt_folder filesep 'mvt added to your MATLAB search path']);
        
        % refresh the toolbox directories
        rehash toolbox;
        disp('Refreshing toolbox folder...');
        disp('Toolbox folder refreshed');
        
        % change preferences
        getpref('mvt', {'version', 'toolbox'}, {1.0, 1.0});
        
        % display final message
        disp(' ');
        disp('The Marine Visualization Toolbox was successfully installed.');
        disp(' ');
        
        
    % install the help files
    case 'help'
        % is the file MVT_help.zip located in this directory?
        if ~(exist('MVT_help.zip')==2)
            error('The file MVT_help.zip was not found!');
        end
        
        disp('Installing help files:');

        % name of help folder
        mvt_folder = fullfile(matlabroot, 'help', 'toolbox', '');
        
        % unzip MVT help files to directory
        unzip('MVT_help.zip', mvt_folder);
        
        % display message
        disp(['Help files extracted to:' mvt_folder filesep 'mvt']);
        
        % move table-of-contents file 'mwdoctoc_mvttbx.xml' to help folder
        toc_file = 'mwdoctoc_mvttbx.xml';
        help_folder = fullfile(matlabroot, 'help');
        movefile([mvt_folder filesep 'mvt' filesep toc_file], help_folder);
        disp([toc_file ' moved to: ' help_folder]);
        
        % change preferences
        getpref('mvt', {'version', 'help'}, {1.0, 1.0});
        
        % display final message
        disp(' ');
        disp('Help on The Marine Visualization Toolbox was successfully installed.');
        disp('You must restart MATLAB to use the MVT help with your MATLAB help browser!');
        disp(' ');

        
    % uninstall all files
    case 'uninstall'
        
        % display 'Are you sure...' dialog
        buttonName = questdlg('Are you sure to uninstall the MVT?', ...
                              'Uninstall the MVT', ...
                              'Yes','No','No');        
        switch buttonName,
            case 'No', 
                
                % abort uninstall
                disp('Cancelled by user, the Marine Visualization Toolbox was not uninstalled.');
                disp(' ');
                
            case 'Yes',
                
                % delete files if found
                tbx_folder = fullfile(matlabroot, 'toolbox', 'mvt', '');
                help_folder = fullfile(matlabroot, 'help', 'toolbox', 'mvt', '');
                % delete functions
                if ispref('mvt', 'toolbox')
                    % remove folder with subfolders
                    rmdir(tbx_folder, 's');
                    rmpref('mvt', 'toolbox');
                    disp('MVT functions deleted');
                    % remove path from MATLAB search path
                    rmpath(tbx_folder);
                    disp('MVT removed from search path');
                end
                % delete help files
                if ispref('mvt', 'help')
                    % remove folder with subfolders
                    rmdir(help_folder, 's');
                    rmpref('mvt', 'help');
                    % remove toc file in help folder
                    delete([matlabroot filesep 'help' filesep 'mwdoctoc_mvttbx.xml']);
                    disp('MVT help deleted');
                end
                % remove last preference
                if ispref('mvt')
                    % remove MVT preference
                    rmpref('mvt');
                    disp('MVT removed');
                end
                
        end % switch
        
    % just checking
    case 'check'
        % do nothing
        % version numbers are already displayed
        
    % error
    otherwise
        disp('Not a valid input argument!');
        disp('Valid input arguments are:');
        disp('      ''toolbox''     - install the MVT toolbox files');
        disp('      ''help''        - install help on MVT');
        disp('      ''uninstall''   - uninstall all MVT files');
        
end % switch