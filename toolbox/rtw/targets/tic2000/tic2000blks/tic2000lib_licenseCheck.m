function tic2000lib_licenseCheck(reset)
% tic2000lib_licenseCheck   Checks whether the user has accepted TI's 
%    license agreement, and if not, displays the agreement and
%    asks for acceptance.  This function executes during the
%    initialization callback for each block in tic62dsplib.mdl.
%    Optional parameter RESET = 1 allows you to trigger the license 
%    display again.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/08 20:59:36 $

blk = gcb;
sys = gcs;

% MATLAB Preference identifiers:
group = 'MathWorks_TIC2000';
item  = 'TI_C2000LIB_EndUserLicenseAccepted';

% If the pref val has already been obtained from the prefs area and cached
% in this persistent variable, then we use the cached value in memory for
% efficiency.  Otherwise, we must try to get the val from the prefs area.  
persistent P
if isempty(P) & ispref(group,item),
    P = getpref(group,item);
end

if nargin<1,
    reset=0;
end
if reset,
    % Reset the acceptance flag and get out
    %
    % Note: Never "set" the acceptance flag based on the input parameter
    % Doing so would allow a "sneak path" for circumventing the license
    % text
    P = [];
    setpref(group,item,P);
    return;
end

% We only do the license test on the LAST Target Preference block in the model.
if ~is_last_protected_block(sys),
    return;
end

% If we haven't verified acceptance yet, then we ask (or ask again).
if ( isempty(P) | (~P) ) & ~strcmp(getenv('logname'),'batserve'),
    absDir = fullfile(matlabroot, ...
        'toolbox','rtw','targets','tic2000', 'tic2000blks');
    licExe = fullfile(absDir,'tic2000lib_licenseGui.exe');
    licTxt = fullfile(absDir,'tic2000lib_license.txt');
    licCmd = [licExe ' ' licTxt];
%     P = boolean(dos(licCmd));  % blocking call to DOS

    x = TiLicenseGui;
    P = strcmp(x, 'Accept');
    
    if ~P,
        error(['You have not accepted the terms of the Texas Instruments C2000 ' ...
               'End User License Agreement. You cannot use this product.']);
    end
    
    % Record acceptance of the license agreement:
    setpref(group,item,P);
end


% ----------------------------------------------
function y = is_last_protected_block(sys)

% at this point, we know we're going to fire off an error
% so we can take some time to only fire the error for the FIRST guy
persistent total_protected_blks seen_protected_blks

if isempty(seen_protected_blks),  % not zero, empty!
    % Reset the list, and setup to zero seen:
    
    all_TgtPrefs_block_blks = find_system(sys, ...
        'followlinks','on', ...
        'lookundermasks','on', ...
        'Regexp','on', ...
        'ReferenceBlock','^c2000tgtpreflib');
    
    all_IQmath_block_blks = find_system(sys, ...
        'followlinks','on', ...
        'lookundermasks','on', ...
        'Regexp','on', ...
        'ReferenceBlock','^tiiqmathlib');
    
    all_protected_blocks = [all_TgtPrefs_block_blks; all_IQmath_block_blks ];
  
    total_protected_blks = length(all_protected_blocks);
    seen_protected_blks = 0;
end

% Now, increment seen count;
seen_protected_blks = seen_protected_blks + 1;

if (seen_protected_blks == total_protected_blks),
    % We've now seen them all
    % Reset
    total_protected_blks = [];
    seen_protected_blks = [];
    y = 1;  % alert caller to issue error --- on LAST block
else
    y = 0;  % caller should not emit error yet
end


% [EOF] tic62dsplib_licenseCheck.m
