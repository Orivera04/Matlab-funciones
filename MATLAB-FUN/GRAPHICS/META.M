function meta(a,b)
%META   PostScript hardcopy.
%   The command is obsolete but grandfathered for users of
%   earlier versions of MATLAB. Use PRINT instead.
%
%   Under MS-Windows(tm), META does nothing.
%   If you wish to print to a file, choose the FILE: option
%   on the ports list box in the printer driver installation
%   dialog box.  The system will then prompt you for a filename
%   when to make a print request.
%
%   META <filename> opens the file named 'filename.ps' and saves  
%   the current Figure to it in PostScript form. Subsequent
%   META commands may omit the filename, in which case the
%   plots are appended to the previously named file. 
%
%   By default, META uses the PostScript driver '-dps'.
%   META <filename> -ddevice specifies a different device driver.
%   Available device options are:
%
%      -dps    - PostScript
%      -dpsc   - Color PostScript
%      -dps2   - Level 2 PostScript
%      -dpsc2  - Level 2 Color PostScript
%
%   Note, some devices are not supported with META because
%   they do not support multiple page file formats. For example
%   Encapsulated PostScript (EPS). Use PRINT instead.
%
%   See also PRINT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.


disp('META is obsolete and will be eliminated in future')
disp('versions.  Please use PRINT instead.')
c = computer;
if c(1:2) == 'PC'
   return
end
% Emulate MATLAB 3.5 behavior.
global MetaFileName
global MetaDevice

% list of all devices that don't support '-append', for input validation
devices = [
    'eps  '
    'epsc '
    'eps2 '
    'eps2c'
    'epsc2'
];

% Use globals to remember metafile name and device in-between
% invocations
if nargin > 0
	MetaFileName = a;
end

if nargin == 2
    % -append needed for print.m, but not all devices or file formats   
    % support multiple pages, error out if user specified one of them
    bwidth = size(b,2);
    for r = 1:size(b,1)
        if strcmp( deblank(b(3:bwidth)), deblank(devices(r,:)) )
            error( [ 'Can not use device ''' b ''' with META. ' ...
                     'Please use PRINT instead.' ] );
        end
    end
    MetaDevice = b;
end

if isempty(MetaDevice)
	MetaDevice = '-dps';
end

if isempty(MetaFileName)
	MetaFileName = 'untitled.ps';
end

% Append .ps to filename if not there already
if ~any(MetaFileName == '.')
	MetaFileName = [MetaFileName '.ps'];
end

print(MetaFileName,MetaDevice,'-append')
