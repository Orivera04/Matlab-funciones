function imaqsupport(varargin)
% IMAQSUPPORT Image Acquisition Toolbox troubleshooting utility.
% 
%    IMAQSUPPORT, returns diagnostic information for all installed hardware
%    adaptors and saves output to text file 'imaqsupport.txt' in the current
%    directory.
%
%    IMAQSUPPORT('ADAPTOR'), returns diagnostic information for hardware adaptor,
%    'ADAPTOR', and saves output to text file, 'imaqsupport.txt' in the 
%    current directory.
%
%    IMAQSUPPORT('ADAPTOR','FILENAME'), returns diagnostic information for hardware
%    adaptor, 'ADAPTOR', and saves the results to the text file FILENAME in the 
%    current directory.  
% 
%    Examples:
%       imaqsupport
%       imaqsupport('winvideo')
%       imaqsupport('winvideo','myfile.txt')
%
%   See also IMAQHWINFO, VIDEOINPUT.

%   KL 10-24-02
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:02 $

filename = 'imaqsupport.txt'; %default text file name
hwInfo=imaqhwinfo;
switch nargin,
    case 0,
        adaptors=hwInfo.InstalledAdaptors;
    case 1,
        adaptors=varargin(1);
    case 2,
        adaptors=varargin(1);
        filename = varargin{2};
    otherwise,
        error(nargchk(0, 2, nargin, 'struct'));
end % switch

% Check that adaptor string is contained in a cell.
if ~iscellstr(adaptors),
    error('imaq:imaqsupport:stringAdaptor','ADAPTOR must be specified as a string.');
end

% Deletes text file, 'FILENAME', if one already exists.
if exist(filename,'file')
    try
        delete(filename);
    catch
        error('imaq:imaqsupport:filedelete', 'Unable to delete existing file.');
    end
end % if

% Opens 'FILENAME' for writing
fid = fopen(filename,'w');
if (fid==-1)
    error('imaq:imaqsupport:fileopen','Can not open file for writing.');
end

% Display message to command window.
disp('Generating diagnostic information ...');

% Variables cr and sp represent strings that are repeatedly called.
cr = sprintf('\n');
sp = '----------';

% MATLAB, OS, Java, and IMAQ Toolbox version information
fprintf(fid, evalc('ver(''imaq'')')); 

% DirectX version information
if ispc
    imaqroot = which('imaqmex.dll', '-all');
    adaptordir = [fileparts(imaqroot{1}) 'adaptors'];
    adaptor = fullfile(adaptordir, 'win32', 'mwwinvideoimaq.dll');
    fprintf(fid, [cr,'DirectX Version: %s', cr, cr], mexdxver(adaptor));
end
 
% MATLABROOT directory
fprintf(fid, [cr, sp, 'MATLAB ROOT DIRECTORY', sp, cr, cr]);
fprintf(fid, ['\t%s', cr], matlabroot);

% MATLAB path
fprintf(fid, [cr, sp, 'MATLAB PATH', sp, cr]);
fprintf(fid, '%s', evalc('path'));

% IMAQMEM information
imaqmemstr = evalc('disp(imaqmem)');
fprintf(fid, [cr, cr, sp, 'IMAGE ACQUISITION MEMORY INFORMATION', sp, cr, cr, '%s'], imaqmemstr);

% IMAQ Hardware information  
imaqhwinfostr = evalc('disp(imaqhwinfo)');
fprintf(fid, [cr, sp, 'AVAILABLE HARDWARE', sp, cr, cr, '%s'], imaqhwinfostr);

% Display IMAQ adapter and device information
for adaptorcount = 1:length(adaptors), 
    adaptorname = adaptors{adaptorcount};
    fprintf(fid, [cr, sp,'%s ADAPTOR', sp, cr, cr], upper(adaptorname));  
    
    % IMAQ Adapter info
    try
        adaptorInfo = imaqhwinfo(adaptorname); %imaqhwinfo for adaptor
    catch
        % invalid adaptor name
        [msg, id] = lasterr;
        fclose(fid); % close the file
        delete(filename) % delete the file
        error(id, msg);
    end %try
    
    if ~isempty(adaptorInfo)
        fprintf(fid, ['Adaptor Name: %s', cr], adaptorInfo.AdaptorName);
        fprintf(fid, ['Adaptor DLL: %s', cr, cr], adaptorInfo.AdaptorDllName);
    end
    
    % IMAQHWINFO for adaptor
    imaqhwadaptstr = evalc(['disp(imaqhwinfo(''',adaptorname,'''))']); 
    fprintf(fid, ['IMAQHWINFO: ', cr, '%s'], imaqhwadaptstr);
    
    % IMAQ Device info
    fprintf(fid, [cr, 'Available Devices: ', cr]);
    if ~isempty(adaptorInfo)
        for devicecount = 1:length(adaptorInfo.DeviceInfo),          
            fprintf(fid, [cr, '\tDevice Name: %s', cr], ...
                adaptorInfo.DeviceInfo(devicecount).DeviceName);
            fprintf(fid, ['\tDevice ID: %i', cr], ...
                adaptorInfo.DeviceInfo(devicecount).DeviceID);
            fprintf(fid, ['\tDevice File Supported: %i', cr], ...
                adaptorInfo.DeviceInfo(devicecount).DeviceFileSupported);
            fprintf(fid, ['\tDefault Format: %s', cr], ...
                adaptorInfo.DeviceInfo(devicecount).DefaultFormat);
            fprintf(fid, ['\tSupported Formats: ', cr, cr, '%s'], ...
                evalc('disp(adaptorInfo.DeviceInfo(devicecount).SupportedFormats)'));         
        end % for      
    end % if
       
end % for


% Create video input objects for all devices and formats.

% cycle through list of adaptors
for adaptorcount = 1:length(adaptors),
    adaptorname = adaptors{adaptorcount};
    adaptorInfo = imaqhwinfo(adaptorname); %imaqhwinfo for adaptor
    fprintf(fid, [cr, cr, sp,'VIDEOINPUT OBJECT CREATION - ', upper(adaptorname), sp, cr]);
    
    % cycle through list of devices
    for devicecount = 1:length(adaptorInfo.DeviceInfo),
        adaptorID = num2str(adaptorInfo.DeviceInfo(devicecount).DeviceID);
        fprintf(fid, cr);
        
        % cycle through list of formats
        for formatcount = 1:length(adaptorInfo.DeviceInfo(devicecount).SupportedFormats),
            currentformat = adaptorInfo.DeviceInfo(devicecount).SupportedFormats{formatcount};
            evalstr = ['videoinput(''', adaptorname,''',',adaptorID,',''',currentformat,''')'];
            fprintf(fid, evalstr);
            
            % Try to create videoinput object
            % If successful, then it is necessary to delete the object
            % otherwise objects remain in memory after function exits. 
            try
                lasterr('');
                evalc(['vidobj = ', evalstr]);
                fprintf(fid, ['--SUCCEEDED', cr]);
                delete(vidobj);  
            catch
                fprintf(fid, ['--FAILED', cr, lasterr, cr, cr]);
            end %try
            
        end%for     
        
    end % for
    
end % for


fprintf(fid, [cr, sp, sp,'END TEST', sp, sp, cr]);
fprintf(fid, [cr, 'This information has been saved in the text file: ', cr, ...
        '%s', cr], filename);
fprintf(fid, [cr, 'If any errors occured, please e-mail this information to:', cr, ...
        'support@mathworks.com', cr]);

% Close file for writing and display text output to user
fclose(fid);
edit(filename);
% end imaqsupport