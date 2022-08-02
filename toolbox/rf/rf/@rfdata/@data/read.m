function h = read(h, filename)
%READ Read data from a .SNP, .YNP, .ZNP, .HNP or .AMP file.
%   H = READ(H, FILENAME) reads data from a data file and updates
%   properties of the RFDATA.DATA object H. FILENAME is a string,
%   representing the filename of a .SNP, .YNP, .ZNP or .AMP file.
%
%   H = READ(H) prompts users to select a .SNP, .YNP, .ZNP, .HNP or .AMP
%   file and reads data from the data file.
%
%   See also RFDATA, RFCKT

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/12 23:38:24 $

% Get and check the data file name.
switch nargin
    case 1 
        [filename, filetype] = getfile(h);
    case 2
        [filename, filetype] = getfile(h, filename);
end
if isempty(filetype)
    return;
end

% Read the data. 
switch filetype
    case {'YNP' 'SNP' 'ZNP' 'HNP'}
        refobj = readsnp(h, filename);
    case 'FLP'
        refobj = readflp(h, filename);
    case 'AMP'
        refobj = readamp(h, filename);
    case 'S2D'
        refobj = reads2d(h, filename);
end

% Set the properties
set(refobj, 'Name', filename);
if ~isa(get(h, 'Reference'), 'rfdata.reference')
    set(h, 'Reference', refobj);
end
restore(h);

%--------------------------------------------------------------------------
function refobj =  readsnp(h, filename)
%READSNP Parser for SNP, YNP and ZNP files.

% Set the default values.
nPort = [];
NetworkType = '';
Freq = [];
NetworkParameters = [];
NoiseFreq = []; 
NoiseParameters = []; 
Z0 = 50;
DeviceName = fliplr(strtok(fliplr(filename), filesep));
DeviceName = strtok(DeviceName, '.');
FScale = [];
DataFormat = '';

% Parse the header.
% Find the parameter NetworkType from filename.
file_ext = fliplr(strtok(fliplr(filename), '.'));
switch upper(file_ext(1))
    case 'S'
        NetworkType = 'S_PARAMETERS';
    case 'Y'
        NetworkType = 'Y_PARAMETERS';
    case 'Z'
        NetworkType = 'Z_PARAMETERS';
    case 'H'
        NetworkType = 'H_PARAMETERS';    
    otherwise
        error('The filename extension must be .SNP, .YNP, .ZNP or .HNP.')
end

% Find the number of columns in the parameter matrix.
nPort = str2num(file_ext(2:end-1));
if isempty(nPort)
    error('The filename extension must be .SNP, .YNP, .ZNP or HNP.')
end
Col = 2*nPort*nPort + 1;

% Read file for the first time, get DataFormat, the characteristic
% impedance Z0, the scaling factor FScale. Find the start of the numerical
% data.
fid = fopen(filename, 'rt');
if fid == -1
    error([filename, ' does not exist or cannot be found.'])
end

START_OF_DATA = 0; % START_OF_DATA is a flag with initial value zero.
lcounter = 0; % lcounter is the line counter.
cline = '';
while ~START_OF_DATA && (ischar(cline) || isempty(cline))
    cline = upper(fgetl(fid));
    first_char = strtok(cline); % cline is the current line.
    lcounter = lcounter + 1;
    
    % If cline is empty, then do nothing and go to the next line
    if ~isempty(first_char) && ischar(first_char) 
        % If cline starts with '#'
        if strcmp(first_char(1), '#')
            
            % Find the frequency scaling factor.
            if ~isempty(strfind(cline, 'GHZ'))
                FScale = 1e9;
            elseif ~isempty(strfind(cline, 'MHZ'))
                FScale = 1e6;
            elseif ~isempty(strfind(cline, 'KHZ'))
                FScale = 1e3;
            elseif ~isempty(strfind(cline, 'HZ'))
                FScale = 1;
            else
                fclose(fid);
                error(['Missing frequency units information.',...
                    sprintf('\n'),...
                    'It must be "GHz", "MHz", "KHz" or "Hz".']);
            end
            
            % Find the data format.
            if ~isempty(strfind(cline, 'RI'))
                DataFormat = 'RI';
            elseif ~isempty(strfind(cline, 'MA'))
                DataFormat = 'MA';
            elseif ~isempty(strfind(cline, 'DB'))
                DataFormat = 'DB';
            end
            if isempty(DataFormat)
                fclose(fid);
                error(['Missing data format information.',sprintf('\n'),...
                    'It must be "RI", "MA" or "DB".']);
            end
            
            % Find Z0.
            Rpos = strfind(cline, ' R ');
            % Because str2num([]) gives error, need to check first. 
            if isempty(Rpos) || isempty(strtok(cline(Rpos(1)+2:end)))
                id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                warning(id, ['Reference Impedance not found',...
                    sprintf('\n'),'the default 50 ohm is used']);
            else
                Z0 = str2num(strtok(cline(Rpos(1)+2:end)));
                if isempty(Z0)
                    Z0 = 50;
                    id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                    warning(id, ['Reference Impedance not found',...
                            sprintf('\n'),'the default 50 ohm is used']);
                end
            end
            
            % Check if the NetworkType of parameter is consistent.
            if isempty(strfind(cline, [' ', upper(file_ext(1)), ' ']))
                fclose(fid);
                error(['Parameter type ', upper(file_ext(1)),...
                    ' is not found in the comment line',sprintf('\n'),...
                    'that starts with ''#''.']);
            end
            
            % If cline starts with one of the characters in '+-.0123456789'     
        elseif ~isempty(first_char) && ...
            ~isempty(strfind('+-.0123456789', first_char(1)))
            START_OF_DATA = 1;
            % lcounter equals the number of lines above data
            netdata_skip = lcounter - 1;
        end
    end
end

if ~START_OF_DATA
    fclose(fid);
    error('The file does not contain any network data.')
elseif isempty(FScale)
    fclose(fid);
    error('Missing the comment line that starts with "#".')
end

% NOISE_HEADER is a flag, when it is true, there are comments between
% network data and noise data.
NOISE_HEADER = 0;
% noise_skip equals the line number of the first line of noise data minus
% 1.
noise_skip = 0;
% NoiFScale is the scaling factor for the noise frequency points.
NoiFScale = FScale;

if nPort == 2 % Only 2-port network can have noise data.    
    % Search for the end of the network parameter.
    while ischar(cline)
        cline = upper(fgetl(fid)); % cline is the current line.
        lcounter = lcounter + 1;
        % If the current line is empty or contains only spaces
        if isempty(strtok(cline))
            break;
            % If the current line starts with '!'    
        elseif strcmp(cline(1), '!')  
            NOISE_HEADER = 1;
            break;
        end
    end
    
    % Search for the start of the noise parameter.
    while ischar(cline) || isempty(cline)
        cline = upper(fgetl(fid)); % cline is the current line.
        first_char = strtok(cline);
        lcounter = lcounter + 1;
        % If this line starts with a number, then it is the first line of
        % the noise parameter.
        if ~isempty(first_char) && ...
            ~isempty(strfind('+-.0123456789', first_char(1)))
            noise_skip = lcounter - 1;
            break;
        elseif ~isempty(first_char) % If this line is a comment line
            NOISE_HEADER = 1;
            % If this comment line contains 'HZ', this means the frequency
            % scaling factor of the noise parameter can be different from
            % that of the network parameter.
            if ~isempty(strfind(upper(cline), 'HZ'))
                pos = strfind(upper(cline), 'HZ');
                switch upper(cline(pos(1)-1))
                    case 'G'
                        NoiFScale = 1e9;
                    case 'M'
                        NoiFScale = 1e6;
                    case 'K'
                        NoiFScale = 1e3;
                    otherwise
                        NoiFScale = 1;
                end
            end
        end
    end
end

% Read file for the second time and get network data.
% If there is noise data, get it also.
frewind(fid)
% Skip the non-numerical data.
for k=1:netdata_skip
    fgetl(fid);
end

[netdata, netdata_count] = fscanf(fid,'%f',inf);

if nPort == 2 && noise_skip
    % Read file for the third time and only get noise data.
    frewind(fid)
    for k=1:noise_skip
        fgetl(fid);
    end
    % Skip network data and comments.
    [noise_data, noise_count] = fscanf(fid,'%f',inf);
    if mod(noise_count,5) ~= 0
        fclose(fid);
        error('Incomplete noise parameters.')
    end
    noise_data = reshape(noise_data, 5, [])';
    NoiseFreq = noise_data(:,1)*NoiFScale;
    NoiseParameters = noise_data(:,2:end);
    % If there are no comments between network data nad noise data, it is
    % necessary to remove the noise data from the netdata.
    if ~NOISE_HEADER
        netdata = netdata(1:end-noise_count);
        % Remove the noise data from network data.
        netdata_count = netdata_count - noise_count; 
    end
end

if mod(netdata_count, Col) ~= 0
    fclose(fid);
    error('Incomplete network parameters.')
end
netdata = reshape(netdata, Col, [])';

% Collect property data for the RFDATA.DATA object.
% Get the Freq property.
Freq = netdata(:,1)*FScale;

% netdata will contain only network parameters.
netdata = netdata(:,2:end);
netodd = netdata(:,1:2:end); % Extract columns of odd numbers.
neteven = netdata(:,2:2:end); % Extract columns of even numbers.

% tempA will contain magnitude, magnitude(dB) or real part of the network
% parameters.
tempA = zeros(nPort, nPort, size(netdata, 1));
% tempB will contain angle(degree)or imaginary part of the network
% parameters.
tempB = zeros(nPort, nPort, size(netdata, 1));

if nPort <= 2
    for p = 1:size(netdata, 1)
        % Reshape one row of netdata into nPort by nPort matrix.
        tempA(:,:,p) = reshape(netodd(p,:), nPort, nPort);
        tempB(:,:,p) = reshape(neteven(p,:), nPort, nPort);
    end
else
    for p = 1:size(netdata, 1)
        % Reshape one row of netdata into nPort by nPort matrix and
        % transpose it.
        tempA(:,:,p) = reshape(netodd(p,:), nPort, nPort)';
        tempB(:,:,p) = reshape(neteven(p,:), nPort, nPort)';
    end
end

% Pre-allocate the 3D matrix for NetworkParameters. 
NetworkParameters = zeros(nPort, nPort, size(netdata, 1));
% Compute the NetworkParameters.
switch DataFormat
    case 'RI'
        NetworkParameters =  tempA + tempB*j;
    case 'MA'
        NetworkParameters = tempA .* exp(tempB*pi/180*j);
    case 'DB'
        NetworkParameters = 10.^(tempA/20) .* exp(tempB*pi/180*j);
end

% Update the reference
refobj = get(h, 'Reference');
if ~isa(refobj, 'rfdata.reference')
    refobj = rfdata.reference;
end
[Fmin, Gammaopt, Rn] = getnoisedata(NoiseParameters, 'MA', 1);
update(refobj, NetworkType, Freq, NetworkParameters, Z0, NoiseFreq, Fmin,...
    Gammaopt, Rn, [], {}, {}, {});

fclose(fid);


%--------------------------------------------------------------------------
function refobj =  readflp(h, filename)
%READFLP Parser for FLP files.

% Set the default values.
nPort = [];
NetworkType = '';
Freq = [];
NetworkParameters = [];
NoiseFreq = []; 
NoiseParameters = []; 
DataFormat = '';
Z0 = 50;
PoutFreq = [];
Pin = {};
Pout = {};
Phase = {};
DeviceName = '';
IP3POUT = [];
IP3Freq = [];
MAXORDER = [];
HarmonicaData = [];

fid = fopen(filename, 'rt');
if fid == -1
    error(['Cannot open text file ', filename])
end

lcounter = 0; % lcounter is the line counter.
% cline = ''; % cline is the current line.

% Find first nonempty line that does not start with '*' or ';' and contains
% keyword PORT
cline_raw = fgetl(fid);
lcounter = lcounter + 1;
token_raw = strtok(cline_raw);
cline = upper(strtok(cline_raw, ';'));% Remove comments if any
token = strtok(cline);
while (ischar(cline) || isempty(cline)) && ...
    (isempty(token) || strcmp(token(1), '*') ||...
    isempty(token_raw) || strcmp(token_raw(1), ';') || ...
    isempty(strfind(cline, 'PORT')))
    cline_raw = fgetl(fid);
    lcounter = lcounter + 1;
    token_raw = strtok(cline_raw);
    cline = upper(strtok(cline_raw, ';'));% Remove comments if any
    token = strtok(cline);
end

% Check for empty file.
if ~ischar(cline)
    fclose(fid);
    error(['Keyword PORT not found or ', filename,' is empty.'])
end

% cline = upper(strtok(cline, ';')); % Remove comments.
cline = fliplr(deblank(fliplr(cline))); % Remove initial spaces.

% The data name is always at the beginning of the first line and is
% separated from other information by one or more spaces or a colon.
if ~isempty(strfind(cline, ':'))
    DeviceName = strtok(cline, ':');
else
    DeviceName = strtok(cline);
end

% Find the location of the keyword PORT.
% port_pos = cat(1, strfind(cline, ' PORT'), strfind(cline, '-PORT'));
if ~isempty(strfind(cline, '-PORT'))
    port_pos = strfind(cline, '-PORT');
else
    port_pos = strfind(cline, 'PORT');
end
% Check for invalid port_pos.
if length(port_pos) > 1
    fclose(fid);
    error('Multiple instances of keyword PORT found.')
elseif port_pos == 1
    fclose(fid);
    error('Number of ports not found.')
end

% Extract the number of ports.   
for i = port_pos-1:-1:1
    if ~isempty(strfind('0123456789',cline(i)))
        for  k = i-1:-1:1
            if isempty(strfind('0123456789',cline(k)))
                break;
            end
        end
        % k is empty when the number of ports is single digit and the first
        % character of the line.
        % k is 1 when the number of ports is more than one digit and starts
        % in the first character of the line.
        if ~isempty(k) && k ~= 1
            nPort = str2num(cline(k+1:i));
        else
            nPort = str2num(cline(1:i));
            % Use filename as devicename.
            DeviceName = fliplr(strtok(fliplr(filename), filesep));
            DeviceName = strtok(DeviceName, '.');
        end
        if isempty(nPort)
            fclose(fid);
            error('Number of ports not found.')
        end
        break;
    end
end


totnoisec = 0; % Initialize total number of noise parameter sections.
totnetsec = 0; % Initialize total number of network parameter sections.
totpowsec = 0; % Initialize total number of power data sections.
totip3sec = 0; % Initialize total number of ip3 data sections.
totmixersec = 0;% Initialize total number of mixerspurs data sections.
headersec = ''; % Initialize header section.
datasec = ''; % Initialize data section.
noifscale = []; % Initialize noise frequency scaling factor.

% This is the beginning of a BIG while loop that reads the file one section
% at a time
while ischar(cline) || isempty(cline)
    
    % BEGIN reading header section and decide section type
    sectype = '';
    cline = upper(strtok(fgetl(fid), ';'));
    lcounter = lcounter + 1;
    while ischar(cline) || isempty(cline)
        % Remove the spaces in the beginning of the current line
        [token,rem] = strtok(cline);
        cline = [token,rem];
        
        % If the current line starts with a numerical value 
        if ~isempty(token) && ~isempty(strfind('+-.0123456789', token(1)))
            datasec = cline;
            break;
            % If the current line starts with a non-numerical value    
        elseif ~isempty(token)
            headersec = strvcat(headersec, cline);
        end
        cline = upper(strtok(fgetl(fid), ';'));
        lcounter = lcounter + 1;
    end
    
    % If it is the end of the file
    if ~ischar(cline) && cline == -1
        warning(['There is no numerical data that follows the last ',...
            'header section.'])
        break;
    end
    
    headersec = upper(headersec);
    if nPort == 2
        if ~isempty(strmatch('POUT', headersec))
            sectype = 'PowData';
        elseif  (~isempty(strmatch('S', headersec)) ||...
            ~isempty(strmatch('Y', headersec)) ||...
            ~isempty(strmatch('Z', headersec)))&& ...
            ~isempty(strmatch('F', headersec))
            sectype = 'NetParam';
        elseif  ~isempty(strmatch('NOI', headersec))
            sectype = 'NoiParam';
        elseif  ~isempty(strmatch('IP3', headersec))
            sectype = 'IP3';
        elseif  ~isempty(strmatch('MIXERSPURS', headersec))
            sectype = 'MixerData';    
        else
            fclose(fid);
            error('Cannot find data type identifier in the header.')
        end
    else
        if (~isempty(strmatch('S', headersec)) ||...
            ~isempty(strmatch('Y', headersec)) ||...
            ~isempty(strmatch('Z', headersec)))...
                && ~isempty(strmatch('F', headersec))
            sectype = 'NetParam';
        else
            fclose(fid);
            error(['Only network parameters are supported for',...
                sprintf('\n'),'a device that is not 2-port.'])
        end
    end
    % END reading header section.
    
    % Parse header sections and read data sections based on their types.
    switch sectype
        % BEGIN Parsing a power header section and a power data section.    
        case 'PowData'
            % Initialize power input and output units.
            pinunit = '';
            poutunit = '';
            % Initialize frequency point.
            newfreq = [];
            pfscale = 1;
            
            % Parse the lines containing POUT.
            % pout_lnum is the row index of the line that starts with POUT.
            pout_lnum = strmatch('POUT', headersec); 
            if ~isempty(pout_lnum)
                [token,rem] = strtok(headersec(pout_lnum(end), :)); 
                % pout_line is the token that follows POUT.
                pout_line = strtok(rem); 
                if strcmp(pout_line,'DBM')
                    poutunit = 'DBM';
                elseif strcmp(pout_line,'DBW')
                    poutunit = 'DBW';
                elseif strcmp(pout_line,'MW')
                    poutunit = 'MW';
                elseif strcmp(pout_line,'W')
                    poutunit = 'W';
                end
            end
            
            % Parse the lines that start with P1 or PIN.
            pin_lnum = cat(1, strmatch('P1', headersec), ...
            strmatch('PIN', headersec));
            if ~isempty(pin_lnum)
                [token,rem] = strtok(headersec(pin_lnum(end), :));
                pin_line = strtok(rem);
                if strcmp(pin_line,'DBM') 
                    pinunit = 'DBM';
                elseif strcmp(pin_line,'DBW')
                    pinunit = 'DBW';
                elseif strcmp(pin_line,'MW')
                    pinunit = 'MW';
                elseif strcmp(pin_line,'W')
                    pinunit = 'W';
                end
            end
            
            if ~isempty(poutunit) && isempty(pinunit)
                pinunit = poutunit;
            elseif ~isempty(pinunit) && isempty(poutunit)
                poutunit = pinunit;
            elseif isempty(poutunit) && isempty(pinunit)
                pinunit = 'W';
                poutunit = 'W';
            end
            pinunit_default = pinunit;
            poutunit_default = poutunit;
            
            % Parse the line containing keyword FREQ to find the frequency
            % point where the power data is measured.
            freq_line = '';
            for k = size(headersec, 1):-1:1
                if ~isempty(strfind(headersec(k, :), 'FREQ')) ||...
                    ~isempty(strfind(headersec(k, :), ' F'))
                    freq_line = headersec(k, :);
                    break;
                end
            end
            if ~isempty(freq_line)
                % Find the scaling factor of the frequency point.
                if ~isempty(strfind(freq_line, 'GHZ'))
                    pfscale = 1e9;
                elseif ~isempty(strfind(freq_line, 'MHZ'))
                    pfscale = 1e6;
                elseif ~isempty(strfind(freq_line, 'KHZ'))
                    pfscale = 1e3;
                else
                    pfscale = 1;
                end
                
                % Read the number that follows keyword FREQ or F.
                start_of_freq = strfind(freq_line, 'F');
                if length(strfind(freq_line, 'F')) > 1
                    warning(['Multiple frequency points found ',...
                        'in the power data.']);
                end
                for i = start_of_freq(end)+1:length(freq_line)
                    if ~isempty(strfind('+-.0123456789', freq_line(i)))
                        % if it is single digit and the last character of
                        % the line.
                        if i == length(freq_line)
                            newfreq = str2num(freq_line(i));
                        else
                            for p = i+1:length(freq_line)
                                if isempty(strfind('+-.0123456789E',...
                                    freq_line(p)))
                                    newfreq = str2num(freq_line(i:p-1));
                                    break;
                                end
                            end
                        end
                        break;
                    end
                end
            end
            if ~isempty(newfreq)
                newfreq = newfreq*pfscale;
            end
            
            % Read the power data section.
            cline = upper(strtok(fgetl(fid), ';'));
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % if the first character of the current line is numeric,
                % this line is part of the data section.
                if ~isempty(first_char) && ...
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && ...
                    isempty(strfind('+-.0123456789', first_char(1)))
                    % Remove the spaces in the beginning
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = upper(strtok(fgetl(fid), ';'));
                lcounter = lcounter + 1;
            end
            
            totpowsec = totpowsec + 1;
            
            % Readjust the input and output power units and replace the
            % unit characters with spaces so that we can later apply
            % STR2NUM on this line of data section. Notice the input and
            % output power can have different units.
            for k = 1:size(datasec,1)
                [token,rem] = strtok(datasec(k,:));
                if ~isempty(strfind(token, 'DBM'))
                    pinunit = 'DBM';
                    datasec(k,:) = strrep(datasec(k,:), 'DBM', '   ');
                elseif ~isempty(strfind(token, 'DBW'))
                    pinunit = 'DBW';
                    datasec(k,:) = strrep(datasec(k,:), 'DBW', '   ');
                elseif ~isempty(strfind(token, 'MW'))
                    pinunit = 'MW';
                    datasec(k,:) = strrep(datasec(k,:), 'MW', '  ');
                elseif ~isempty(strfind(token, 'W'))
                    pinunit = 'W';
                    datasec(k,:) = strrep(datasec(k,:), 'W', ' ');
                else
                    pinunit = '';
                end
                
                second_token = strtok(rem);
                if ~isempty(strfind(second_token, 'DBM'))
                    poutunit = 'DBM';
                    datasec(k,:) = strrep(datasec(k,:), 'DBM', '   ');
                elseif ~isempty(strfind(second_token, 'DBW'))
                    poutunit = 'DBW';
                    datasec(k,:) = strrep(datasec(k,:), 'DBW', '   ');
                    % The W may have been removed if first token contains W
                    datasec(k,:) = strrep(datasec(k,:), 'DB', '  ');
                elseif ~isempty(strfind(second_token, 'MW'))
                    poutunit = 'MW';
                    datasec(k,:) = strrep(datasec(k,:), 'MW', '  ');
                    % The W may have been removed if first token contains W
                    datasec(k,:) = strrep(datasec(k,:), 'M', ' ');
                elseif ~isempty(strfind(second_token, 'W'))
                    poutunit = 'W';
                    datasec(k,:) = strrep(datasec(k,:), 'W', ' ');
                else 
                    poutunit = '';
                end
                
                % Convert this line of data from characters to numbers
                if k == 1
                    tempA = str2num(datasec(k,:));
                    if isempty(tempA)
                        fclose(fid);
                        error('The POUT data is not correct.')
                    elseif length(tempA) ~= 2 && length(tempA) ~= 3
                        fclose(fid);
                        error('Power data must have 2 or 3 columns.')
                    end
                    % initialize power data
                    powdata = zeros(size(datasec, 1), length(tempA));
                    powdata(1,:) = tempA;
                else
                    tempA = str2num(datasec(k,:));
                    if isempty(tempA)
                        fclose(fid);
                        error('The POUT data is not correct.')
                    elseif length(tempA) ~= 2 && length(tempA) ~= 3
                        fclose(fid);
                        error('Power data must have 2 or 3 columns.')
                    end
                    powdata(k,:) = tempA;
                end
                
                % Convert input and output power to the unit of Watts
                switch pinunit
                    case 'DBM'
                        powdata(k,1) = 0.001*10^(powdata(k,1)/10);
                    case 'DBW'
                        powdata(k,1) = 10^(powdata(k,1)/10);
                    case 'MW'
                        powdata(k,1) = 0.001*powdata(k,1);
                    % If no unit in this line of data, use default unit.    
                    case ''
                        switch pinunit_default
                            case 'DBM'
                                powdata(k,1) = 0.001*10^(powdata(k,1)/10);
                            case 'DBW'
                                powdata(k,1) = 10^(powdata(k,1)/10);
                            case 'MW'
                                powdata(k,1) = 0.001*powdata(k,1);
                        end
                end
                
                switch poutunit
                    case 'DBM'
                        powdata(k,2) = 0.001.*10.^(powdata(k,2)./10);
                    case 'DBW'
                        powdata(k,2) = 10^(powdata(k,2)/10);
                    case 'MW'
                        powdata(k,2) = 0.001*powdata(k,2);
                    case ''
                        switch poutunit_default
                            case 'DBM'
                                powdata(k,2) = 0.001.*10.^(powdata(k,2)./10);
                            case 'DBW'
                                powdata(k,2) = 10^(powdata(k,2)/10);
                            case 'MW'
                                powdata(k,2) = 0.001*powdata(k,2);
                        end
                end
            end
        
            % Assign PoutFreq, Pin, Pout and Phase.
            % If there are more than one set of power data, the frequency 
            % point where each set of power data is measured must be 
            % specified.
            if totpowsec > 1 && isempty(PoutFreq)
                fclose(fid);
                error(['The frequency point where each set of', ...
                        ' power data',sprintf('\n'),...
                        'is measured must be specified.'])
            end
            if ~isempty(newfreq)
                PoutFreq(totpowsec,1) = newfreq;
            end
             
            Pin{totpowsec,1} = powdata(:,1)';
            Pout{totpowsec,1} = powdata(:,2)';
            if size(powdata, 2) == 3
                % Phase{totpowsec,1} = powdata(:,3)'.*pi./180;
                Phase{totpowsec,1} = powdata(:,3)';
            else
                Phase{totpowsec,1} = zeros(1, size(powdata, 1));
            end
            % END Parsing a power header section and a power data section. 
            
        case 'NetParam'
            % Find the line that starts with 'S','Y' or 'Z'.
            type_lnum = cat(1, strmatch('S', headersec), ...
            strmatch('Y', headersec), strmatch('Z', headersec));
            % If there are multiple type lines, use the last one.
            type_line = headersec(type_lnum(end), :); 
            
            % Find the network parameter type.
            if type_line(1) ==  'Y'
                NetworkType = 'Y_PARAMETERS';
            elseif type_line(1) == 'Z'
                NetworkType = 'Z_PARAMETERS';
            elseif type_line(1) == 'S'
                NetworkType = 'S_PARAMETERS';
            elseif type_line(1) == 'H'
                NetworkType = 'H_PARAMETERS';
            end
            
            % Find the data format.
            if ~isempty(strfind(type_line, 'RI'))
                DataFormat = 'RI';
            elseif ~isempty(strfind(type_line, 'MA'))...
                || ~isempty(strfind(type_line, 'MP'))
                DataFormat = 'MA';
            elseif ~isempty(strfind(type_line, 'DB'))
                DataFormat = 'DB';
            else
                switch NetworkType
                    case 'S'
                        DataFormat = 'MA';
                    otherwise
                        DataFormat = 'RI';
                end
            end
            
            % Find Z0.
            Rpos = strfind(type_line, ' R ');
            RREFpos = strfind(type_line, 'RREF');
            if isempty(Rpos) && isempty(RREFpos)
                msg = ['Reference Impedance not found,',...
                    sprintf('\n'),'the default value: 50 ohm is used'];
                warning(msg)
            elseif ~isempty(Rpos) % if keyword R is found
                if isempty(strtok(type_line(Rpos(1)+2:end)))
                    warning(['Reference Impedance not found,',...
                        sprintf('\n'),'the default value: 50 ohm is used']);
                else
                    Z0 = str2num(strtok(type_line(Rpos(1)+2:end)));
                    if isempty(Z0)
                        Z0 = 50;
                        warning(['Reference Impedance not found,',...
                            sprintf('\n'),...
                            'the default value: 50 ohm is used']);
                    end
                end
            else % if keyword RREF is found and keyword R is not found
                for i = RREFpos(end)+3:length(type_line)
                    if ~isempty(strfind('+-.0123456789', type_line(i)))
                        % if Z0 is single digit
                        if i == length(type_line)
                            Z0 = str2num(type_line(i));
                        else
                            for p = i+1:length(type_line)
                                if isempty(strfind('+-.0123456789E',...
                                    type_line(p)))
                                    Z0 = str2num(type_line(i:p-1));
                                    break;
                                end
                            end
                        end
                        break;
                    end
                    % if there is no number following keyword RREF
                    if i == length(type_line)
                        warning(['Reference Impedance not found,',...
                            sprintf('\n'),...
                            'the default value: 50 ohm is used']);
                    end
                end
                if isempty(Z0)
                    Z0 = 50;
                    warning(['Reference Impedance not found,',...
                        sprintf('\n'),'the default value: 50 ohm is used']);
                end
            end
            
            freq_lnum = strmatch('F', headersec);
            freq_line = headersec(freq_lnum(end), :);
            % Find the frequency scaling factor from the last line that
            % starts with F or FREQ.
            if ~isempty(strfind(freq_line, 'GHZ'))
                FScale = 1e9;
            elseif ~isempty(strfind(freq_line, 'MHZ'))
                FScale = 1e6;
            elseif ~isempty(strfind(freq_line, 'KHZ'))
                FScale = 1e3;
            elseif ~isempty(strfind(freq_line, 'HZ'))
                FScale = 1;
            else
                FScale = [];
            end
            % noifscale_default is used in NoiParam case. Sometimes frequency
            % scaling factor is not given in noise data, in which case,
            % noifscale will be the same as FScale.
            noifscale_default = FScale; 
            FScale_default = FScale;
            
            % Read the network parameter data section.
            cline = upper(strtok(fgetl(fid), ';'));
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % If the first character of the current line is numerical,
                % this line is part of the data section.
                if ~isempty(first_char) && ...
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                    % datasec = [datasec, sprintf(' '), cline];
                elseif ~isempty(first_char) && ...
                    isempty(strfind('+-.0123456789', first_char(1)))
                    % Remove the spaces at the beginning of the line.
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = upper(strtok(fgetl(fid), ';'));
                lcounter = lcounter + 1;
            end
            
            totnetsec = totnetsec + 1;
            if totnetsec > 1
                fclose(fid);
                error('More than one network data section found.')
            end
            
            % Readjust the frequency scaling factor and replace the scaling
            % characters with spaces so that we can later apply STR2NUM on
            % the whole data section.
            % current number of parameters at current frequency point
            pcounter = 0; 
            % expected number of parameters at a frequency point
            Col = 2*nPort*nPort + 1;
            % buffer that holds complete data of one frequency point
            netline = [];
            % numerical array that holds all the network parameters
            netdata = [];
            for k = 1:size(datasec,1)
                if pcounter == 0 % if start on a new frequency point
                    token = strtok(datasec(k,:));
                    if ~isempty(strfind(token, 'GHZ'))
                        FScale = 1e9;
                        datasec(k,:) = strrep(datasec(k,:), 'GHZ', '   ');
                    elseif ~isempty(strfind(token, 'MHZ'))
                        FScale = 1e6;
                        datasec(k,:) = strrep(datasec(k,:), 'MHZ', '   ');
                    elseif ~isempty(strfind(token, 'KHZ'))
                        FScale = 1e3;
                        datasec(k,:) = strrep(datasec(k,:), 'KHZ', '   ');
                    elseif ~isempty(strfind(token, 'HZ'))
                        FScale = 1;
                        datasec(k,:) = strrep(datasec(k,:), 'HZ', '  ');
                    else
                        FScale = [];
                    end
                    if isempty(FScale) && isempty(FScale_default)
                        fclose(fid);
                        error(['Missing frequency units information.',...
                            sprintf('\n'),...
                            'It must be "GHz", "MHz", "KHz" or "Hz".'])
                    end
                end
                 % Convert the data section from characters to numbers.
                tempL = str2num(datasec(k,:));
                if isempty(tempL)
                    fclose(fid);
                    error('The network parameters are not correct.')
                end
                pcounter = pcounter + length(tempL);
                % Check if number of data points matches number of ports.
                if pcounter > Col
                    fclose(fid);
                    error(['Number of ports ',...
                            'does not match size of network parameters.'])
                % if data points of one frequency point is complete
                elseif pcounter == Col
                    pcounter = 0; % reset counter
                    netline = cat(2, netline, tempL);
                    if isempty(FScale)
                        % apply default frequency scale
                        netline(1) = netline(1)*FScale_default;
                    else
                        netline(1) = netline(1)*FScale;
                    end
                    netdata = cat(1, netdata, netline);
                    % clear storage of a complete network parameter line
                    netline = []; % reset buffer
                else
                    netline = cat(2, netline, tempL);
                end
            end
            
            % pcounter will be reset if the total number of parameters are
            % correct.
            if pcounter ~= 0
                fclose(fid);
                error('Incomplete network parameters.')
            end
            % Assign Freq and NetworkParameters.
            Freq = netdata(:,1);
            
            % netdata will contain only network parameters.
            netdata = netdata(:,2:end);
            netodd = netdata(:,1:2:end); % Extract columns of odd numbers.
            neteven = netdata(:,2:2:end); % Extract columns of even numbers.
            % tempA will contain magnitude, magnitude(dB) or real part of
            % the network parameters.
            tempA = zeros(nPort, nPort, size(netdata, 1));
            % tempB will contain angle(degree)or imaginary part of the
            % network parameters.
            tempB = zeros(nPort, nPort, size(netdata, 1));
            
            if nPort <= 2
                for p = 1:size(netdata, 1)
                    %Reshape one row of netdata into nPort by nPort matrix.
                    tempA(:,:,p) = reshape(netodd(p,:), nPort, nPort);
                    tempB(:,:,p) = reshape(neteven(p,:), nPort, nPort);
                end
            else
                for p = 1:size(netdata, 1)
                    % Reshape one row of netdata into nPort by nPort matrix
                    % and transpose it.
                    tempA(:,:,p) = reshape(netodd(p,:), nPort, nPort)';
                    tempB(:,:,p) = reshape(neteven(p,:), nPort, nPort)';
                end
            end
            
            % Pre-allocate the 3D matrix for NetworkParameters. 
            NetworkParameters = zeros(nPort, nPort, size(netdata, 1));
            % Compute the NetworkParameters.
            switch DataFormat
                case 'RI'
                    NetworkParameters =  tempA + tempB*j;
                case 'MA'
                    NetworkParameters = tempA .* exp(tempB*pi/180*j);
                case 'DB'
                    NetworkParameters =10.^(tempA/20).*exp(tempB*pi/180*j);
            end
            
        case 'NoiParam'
            % Read the noise data section.
            freq_lnum = strmatch('F', headersec);
            if ~isempty(freq_lnum)
                freq_line = headersec(freq_lnum(end), :);
                % Find the frequency scaling factor from the last line that
                % starts with F or FREQ.
                if ~isempty(strfind(freq_line, 'GHZ'))
                    noifscale_default = 1e9;
                elseif ~isempty(strfind(freq_line, 'MHZ'))
                    noifscale_default = 1e6;
                elseif ~isempty(strfind(freq_line, 'KHZ'))
                    noifscale_default = 1e3;
                elseif ~isempty(strfind(freq_line, 'HZ'))
                    noifscale_default = 1;
                end
            end
            
            cline = upper(strtok(fgetl(fid), ';'));
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % If the first character of the current line is numerical,
                % this line is part of the data section.
                if ~isempty(first_char) && ...
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && ... 
                    isempty(strfind('+-.0123456789', first_char(1)))
                    % Remove the spaces at the beginning of the line.
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = upper(strtok(fgetl(fid), ';'));
                lcounter = lcounter + 1;
            end
            
            totnoisec = totnoisec + 1;
            if totnoisec > 1
                fclose(fid);
                error('More than one noise data section found.')
            end
            
            % Readjust the frequency scaling factor and replace the scaling
            % characters with spaces so that we can later apply STR2NUM on
            % the whole data section.
            noidata = zeros(size(datasec,1),5);
            for k = 1:size(datasec, 1)
                if ~isempty(strfind(datasec(k,:), 'GHZ'))
                    noifscale = 1e9;
                    datasec(k,:) = strrep(datasec(k,:), 'GHZ', '   ');
                elseif ~isempty(strfind(datasec(k,:), 'MHZ'))
                    noifscale = 1e6;
                    datasec(k,:) = strrep(datasec(k,:), 'MHZ', '   ');
                elseif ~isempty(strfind(datasec(k,:), 'KHZ'))
                    noifscale = 1e3;
                    datasec(k,:) = strrep(datasec(k,:), 'KHZ', '   ');
                elseif ~isempty(strfind(datasec(k,:), 'HZ'))
                    noifscale = 1; 
                    datasec(k,:) = strrep(datasec(k,:), 'HZ', '  ');
                else
                    noifscale = []; 
                end
                
                if isempty(noifscale) && isempty(noifscale_default)
                    fclose(fid);
                    error(['The scaling factor of the noise frequency',...
                            ' points not found.'])
                end
                
                % Convert data section from characters to numbers.
                tempA = str2num(datasec(k,:));
                if isempty(tempA)
                    fclose(fid);
                    error('The noise data is not correct.')
                elseif length(tempA) ~= 5
                    fclose(fid);
                    error('Noise parameters must have 5 columns.')
                end
                
                if ~isempty(noifscale)
                    tempA(1) = noifscale*tempA(1);
                else
                    tempA(1) = noifscale_default*tempA(1);
                end
                noidata(k,:) = tempA;
            end
            
            % Assign NoiseFreq and NoiseParameters        
            NoiseFreq = noidata(:,1);
            NoiseParameters = noidata(:,2:end);
            
        case 'IP3'
            % Parse the lines containing IP3.
            % IP3_lnum is the row index of the line that starts with IP3.
            % Find the power unit of IP3
            ip3_lnum = strmatch('IP3', headersec);
            ip3_line = headersec(ip3_lnum(end), :);
            if ~isempty(strfind(ip3_line, 'DBW'))
                ip3unit = 'DBW';
            elseif ~isempty(strfind(ip3_line, 'DBM'))
                ip3unit = 'DBM';
            elseif ~isempty(strfind(ip3_line, 'MW'))
                ip3unit = 'MW';
            else
                ip3unit = 'W'; % The default unit is 'W'
            end
            % ip3unit_default = ip3unit;
            
            freq_lnum = strmatch('F', headersec);
            if ~isempty(freq_lnum)
                freq_line = headersec(freq_lnum(end), :);
                % Find the frequency scaling factor from the last line that
                % starts with F or FREQ.
                if ~isempty(strfind(freq_line, 'GHZ'))
                    ip3fscale = 1e9;
                elseif ~isempty(strfind(freq_line, 'MHZ'))
                    ip3fscale = 1e6;
                elseif ~isempty(strfind(freq_line, 'KHZ'))
                    ip3fscale = 1e3;
                else % default scaling factor is 1 (for Hz)
                    ip3fscale = 1;
                end
            else
                ip3fscale = 1;
            end
            
            % Read the ip3 data section.
            cline = upper(strtok(fgetl(fid), ';'));
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % if the first character of the current line is numeric,
                % this line is part of the data section.
                if ~isempty(first_char) && ... 
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && ...
                    isempty(strfind('+-.0123456789', first_char(1)))
                    % Remove the spaces in the beginning
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = upper(strtok(fgetl(fid), ';'));
                lcounter = lcounter + 1;
            end
            
            totip3sec = totip3sec + 1;% Count the total ip3 data section
            
            % Readjust the frequency scaling factor and replace the scaling
            % characters with spaces so that we can later apply STR2NUM on
            % the whole data section.
            if ~isempty(strfind(datasec(1,:), 'GHZ'))
                ip3fscale = 1e9;
                datasec = char(strrep(cellstr(datasec), 'GHZ', '   ')); 
            elseif ~isempty(strfind(datasec(1,:), 'MHZ'))
                ip3fscale = 1e6;
                datasec = char(strrep(cellstr(datasec), 'MHZ', '   ')); 
            elseif ~isempty(strfind(datasec(1,:), 'KHZ'))
                ip3fscale = 1e3;
                datasec = char(strrep(cellstr(datasec), 'KHZ', '   ')); 
            elseif ~isempty(strfind(datasec(1,:), 'HZ'))
                ip3fscale = 1; 
                datasec = char(strrep(cellstr(datasec), 'HZ', '  ')); 
            end     
            
            % Convert data section from characters to numbers.
            ip3data = str2num(datasec);
            if isempty(ip3data)
                fclose(fid);
                error('The IP3 data is not correct.')
            end
            if size(ip3data, 2) == 2;
                IP3Freq = ip3fscale * ip3data(:,1);
                IP3POUT = ip3data(:,2); 
            elseif  size(ip3data, 2) == 1 && ...
                size(ip3data, 1) == 1 % Only single ip3 data
                IP3Freq = NaN;
                IP3POUT = ip3data(1,1); 
            else
                fclose(fid);
                error('The IP3 data is not correct.')
            end
            % Convert IP3OUT to watts based on unit
            switch ip3unit
                case 'DBM'
                    IP3POUT = 0.001.*10.^(IP3POUT./10);
                case 'DBW'
                    IP3POUT = 10.^(IP3POUT./10);
                case 'MW'
                    IP3POUT = 0.001.*IP3POUT;
            end
            
        case 'MixerData'
            % Parse the line containing keyword MAXORDER to find the
            % maxorder
            maxorder_line = '';
            for k = size(headersec, 1):-1:1
                if ~isempty(strfind(headersec(k, :), 'MAXORDER'))
                    maxorder_line = headersec(k, :);
                    break;
                end
            end
            if isempty(maxorder_line)
                fclose(fid);
                error('Missing keyword MAXORDER in mixer data.')
            end
            % Find the maxorder
            start_of_maxorder = strfind(maxorder_line, 'MAXORDER');
            for i = start_of_maxorder(end)+7:length(maxorder_line)
                if ~isempty(strfind('+-.0123456789', maxorder_line(i)))
                    %if single number and the last character in the line
                    if i == length(maxorder_line)
                        MAXORDER = str2num(maxorder_line(i));
                    else
                        for p = i+1:length(maxorder_line)
                            if isempty(strfind('+-.0123456789E',...
                                maxorder_line(p)))
                                MAXORDER = str2num(maxorder_line(i:p-1));
                                break;
                            end
                        end
                    end
                    break;
                end
            end 
            if isempty(MAXORDER)
                fclose(fid);
                error('Missing maximum order of mixer data.')
            end
            HarmonicaData = zeros(MAXORDER+1,MAXORDER+1);
            
            % Read the mixer data section.
            cline = upper(strtok(fgetl(fid), ';'));
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % if the first character of the current line is numeric,
                % this line is part of the data section.
                if ~isempty(first_char) && ...
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && ...
                    isempty(strfind('+-.0123456789', first_char(1)))
                    % Remove the spaces in the beginning
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = upper(strtok(fgetl(fid), ';'));
                lcounter = lcounter + 1;
            end
            
            % Count the total ip3 data section
            totmixersec = totmixersec + 1;
            
            % Convert data section from characters to numbers.
            for i = 1:MAXORDER+1
                tempA = str2num(datasec(i,:));
                if isempty(tempA) || (length(tempA) ~= MAXORDER+2-i)
                    fclose(fid);
                    error('The mixerspurs data is not correct.')
                end
                HarmonicaData(i,1:MAXORDER+2-i) = tempA;
            end
    end
end

if totnetsec == 0
    warning(['Reference Impedance not found,',...
            sprintf('\n'),'the default value: 50 ohm is used']);
end

% Update the objects
refobj = get(h, 'Reference');
if ~isa(refobj, 'rfdata.reference')
    refobj = rfdata.reference;
end
[Fmin, Gammaopt, Rn] = getnoisedata(NoiseParameters, 'MA', 1);
update(refobj, NetworkType, Freq, NetworkParameters, Z0, NoiseFreq, Fmin,...
    Gammaopt, Rn, PoutFreq, Pin, Pout, Phase);

fclose(fid); 

%--------------------------------------------------------------------------
function refobj =  readamp(h, filename)
%READAMP Parser for .AMP files.

% Set the default values.
nPort = 2;
NetworkType = '';
Freq = [];
NetworkParameters = [];
NoiseFreq = []; 
NoiseParameters = []; 
DataFormat = '';
Z0 = 50;
PoutFreq = [];
Pin = {};
Pout = {};
Phase = {};
DeviceName = '';
IP3POUT = [];
IP3Freq = [];
MAXORDER = [];
HarmonicaData = [];
% Use filename as devicename.
DeviceName = fliplr(strtok(fliplr(filename), filesep));
DeviceName = strtok(DeviceName, '.');

fid = fopen(filename, 'rt');
if fid == -1
    error(['Cannot open text file ', filename])
end

totnoisec = 0; % Initialize total number of noise parameter sections.
totnetsec = 0; % Initialize total number of network parameter sections.
totpowsec = 0; % Initialize total number of power data sections.
totip3sec = 0; % Initialize total number of ip3 data sections.
totmixersec = 0;% Initialize total number of mixerspurs data sections.
headersec = ''; % Initialize header section.
datasec = ''; % Initialize data section.
noifscale = []; % Initialize noise frequency scaling factor.

lcounter = 0; % lcounter is the line counter.
cline = ''; % cline is the current line.

%Check for empty file 
while isempty(strtok(cline))
    cline = fgetl(fid);
    lcounter = lcounter + 1;
end
if ~ischar(cline)
    fclose(fid);
    error(['File ',filename,' is empty.'])
end
% Remove the spaces in the beginning of the current line
[token,rem] = strtok(cline);
cline = [token,rem];
headersec = strtok(cline, ';'); % Remove comments

% This is the beginning of a BIG while loop that reads the file one section
% at a time
while ischar(cline) || isempty(cline)
    
    % BEGIN reading header section and decide section type
    sectype = '';
    cline = strtok(fgetl(fid), ';');
    lcounter = lcounter + 1;
    while ischar(cline) || isempty(cline)
        % Remove the spaces in the beginning of the current line
        [token,rem] = strtok(cline);
        cline = [token,rem];
        
        % If the current line starts with a numerical value 
        if ~isempty(token) && ~isempty(strfind('+-.0123456789', token(1)))
            datasec = cline;
            break;
            % If the current line starts with a non-numerical value    
        elseif ~isempty(token) && ~strcmp(token(1), '*')
            headersec = strvcat(headersec, cline);
        end
        cline = strtok(fgetl(fid), ';');
        lcounter = lcounter + 1;
    end
    
    % If it is the end of the file    
    if ~ischar(cline) && cline == -1
        id = sprintf('rf:%s:read:DataNotFound',strrep(class(h),'.',':'));
        warning(id, ['There is no numerical data that follows the last ',...
            'header section.'])
        break;
    end
    
    headersec = upper(headersec);
    if nPort == 2
        if ~isempty(strmatch('POUT', headersec))
            sectype = 'PowData';
        elseif  (~isempty(strmatch('S', headersec)) ||...
            ~isempty(strmatch('Y', headersec)) ||...
            ~isempty(strmatch('Z', headersec)))&& ...
            ~isempty(strmatch('F', headersec))
            sectype = 'NetParam';
        elseif  ~isempty(strmatch('NOI', headersec))
            sectype = 'NoiParam';
        elseif  ~isempty(strmatch('IP3', headersec))
            sectype = 'IP3';
        elseif  ~isempty(strmatch('MIXERSPURS', headersec))
            sectype = 'MixerData';    
        else
            fclose(fid);
            error('Cannot find data type identifier in the header.')
        end
    else
        if (~isempty(strmatch('S', headersec)) ||...
            ~isempty(strmatch('Y', headersec)) ||...
            ~isempty(strmatch('Z', headersec)))...
                && ~isempty(strmatch('F', headersec))
            sectype = 'NetParam';
        else
            fclose(fid);
            error(['Only network parameters are supported for',...
                sprintf('\n'),'a device that is not 2-port.'])
        end
    end
    % END reading header section.
    
    % Parse header sections and read data sections based on their types.
    switch sectype
        % BEGIN Parsing a power header section and a power data section.    
        case 'PowData'
            % Initialize power input and output units.
            pinunit = '';
            poutunit = '';
            % Initialize frequency point.
            newfreq = [];
            pfscale = 1;
            
            % Parse the lines containing POUT.
            % pout_lnum is the row index of the line that starts with POUT.
            pout_lnum = strmatch('POUT', headersec); 
            if ~isempty(pout_lnum)
                [token,rem] = strtok(headersec(pout_lnum(end), :)); 
                % pout_line is the token that follows POUT.
                pout_line = strtok(rem); 
                if strcmp(pout_line,'DBM')
                    poutunit = 'DBM';
                elseif strcmp(pout_line,'DBW')
                    poutunit = 'DBW';
                elseif strcmp(pout_line,'MW')
                    poutunit = 'MW';
                elseif strcmp(pout_line,'W')
                    poutunit = 'W';
                end
            end
            
            % Parse the lines that start with P1 or PIN.
            pin_lnum = cat(1, strmatch('P1', headersec), ...
            strmatch('PIN', headersec));
            if ~isempty(pin_lnum)
                [token,rem] = strtok(headersec(pin_lnum(end), :));
                pin_line = strtok(rem);
                if strcmp(pin_line,'DBM') 
                    pinunit = 'DBM';
                elseif strcmp(pin_line,'DBW')
                    pinunit = 'DBW';
                elseif strcmp(pin_line,'MW')
                    pinunit = 'MW';
                elseif strcmp(pin_line,'W')
                    pinunit = 'W';
                end
            end
            
            if ~isempty(poutunit) && isempty(pinunit)
                pinunit = poutunit;
            elseif ~isempty(pinunit) && isempty(poutunit)
                poutunit = pinunit;
            elseif isempty(poutunit) && isempty(pinunit)
                pinunit = 'W';
                poutunit = 'W';
            end
            pinunit_default = pinunit;
            poutunit_default = poutunit;
            
            % Parse the line containing keyword FREQ to find the frequency
            % point where the power data is measured.
            freq_line = '';
            for k = size(headersec, 1):-1:1
                if ~isempty(strfind(headersec(k, :), 'FREQ')) ||...
                    ~isempty(strfind(headersec(k, :), ' F'))
                    freq_line = headersec(k, :);
                    break;
                end
            end
            if ~isempty(freq_line)
                % Find the scaling factor of the frequency point.
                if ~isempty(strfind(freq_line, 'GHZ'))
                    pfscale = 1e9;
                elseif ~isempty(strfind(freq_line, 'MHZ'))
                    pfscale = 1e6;
                elseif ~isempty(strfind(freq_line, 'KHZ'))
                    pfscale = 1e3;
                else
                    pfscale = 1;
                end
                
                % Read the number that follows keyword FREQ or F.
                start_of_freq = strfind(freq_line, 'F');
                if length(strfind(freq_line, 'F')) > 1
                    id = sprintf('rf:%s:read:MultipleFreq',strrep(class(h),'.',':'));
                    warning(id, ['Multiple frequency points found ',...
                        'in the power data.']);
                end
                for i = start_of_freq(end)+1:length(freq_line)
                    if ~isempty(strfind('+-.0123456789', freq_line(i)))
                        % if it is single digit and the last character of
                        % the line.
                        if i == length(freq_line)
                            newfreq = str2num(freq_line(i));
                        else
                            for p = i+1:length(freq_line)
                                if isempty(strfind('+-.0123456789E',...
                                    freq_line(p)))
                                    newfreq = str2num(freq_line(i:p-1));
                                    break;
                                end
                            end
                        end
                        break;
                    end
                end
            end
            if ~isempty(newfreq)
                newfreq = newfreq*pfscale;
            end
            
            % Read the power data section.
            cline = strtok(fgetl(fid), ';');
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % if the first character of the current line is numeric,
                % this line is part of the data section.
                if ~isempty(first_char) && ...
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && ...
                    isempty(strfind('+-.0123456789', first_char(1))) && ...
                    ~strcmp(first_char(1), '*')
                    % Remove the spaces in the beginning
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = strtok(fgetl(fid), ';');
                lcounter = lcounter + 1;
            end
            
            totpowsec = totpowsec + 1;
            
            % Readjust the input and output power units and replace the
            % unit characters with spaces so that we can later apply
            % STR2NUM on this line of data section. Notice the input and
            % output power can have different units.
            datasec = upper(datasec);
            for k = 1:size(datasec,1)
                [token,rem] = strtok(datasec(k,:));
                if ~isempty(strfind(token, 'DBM'))
                    pinunit = 'DBM';
                    datasec(k,:) = strrep(datasec(k,:), 'DBM', '   ');
                elseif ~isempty(strfind(token, 'DBW'))
                    pinunit = 'DBW';
                    datasec(k,:) = strrep(datasec(k,:), 'DBW', '   ');
                elseif ~isempty(strfind(token, 'MW'))
                    pinunit = 'MW';
                    datasec(k,:) = strrep(datasec(k,:), 'MW', '  ');
                elseif ~isempty(strfind(token, 'W'))
                    pinunit = 'W';
                    datasec(k,:) = strrep(datasec(k,:), 'W', ' ');
                else
                    pinunit = '';
                end
                
                second_token = strtok(rem);
                if ~isempty(strfind(second_token, 'DBM'))
                    poutunit = 'DBM';
                    datasec(k,:) = strrep(datasec(k,:), 'DBM', '   ');
                elseif ~isempty(strfind(second_token, 'DBW'))
                    poutunit = 'DBW';
                    datasec(k,:) = strrep(datasec(k,:), 'DBW', '   ');
                    % The W may have been removed if first token contains W
                    datasec(k,:) = strrep(datasec(k,:), 'DB', '  ');
                elseif ~isempty(strfind(second_token, 'MW'))
                    poutunit = 'MW';
                    datasec(k,:) = strrep(datasec(k,:), 'MW', '  ');
                    % The W may have been removed if first token contains W
                    datasec(k,:) = strrep(datasec(k,:), 'M', ' ');
                elseif ~isempty(strfind(second_token, 'W'))
                    poutunit = 'W';
                    datasec(k,:) = strrep(datasec(k,:), 'W', ' ');
                else 
                    poutunit = '';
                end
                
                % Convert this line of data from characters to numbers
                if k == 1
                    tempA = str2num(datasec(k,:));
                    if isempty(tempA)
                        fclose(fid);
                        error('The POUT data is not correct.')
                    elseif length(tempA) ~= 2 && length(tempA) ~= 3
                        fclose(fid);
                        error('Power data must have 2 or 3 columns.')
                    end
                    % initialize power data
                    powdata = zeros(size(datasec, 1), length(tempA));
                    powdata(1,:) = tempA;
                else
                    tempA = str2num(datasec(k,:));
                    if isempty(tempA)
                        fclose(fid);
                        error('The POUT data is not correct.')
                    elseif length(tempA) ~= 2 && length(tempA) ~= 3
                        fclose(fid);
                        error('Power data must have 2 or 3 columns.')
                    end
                    powdata(k,:) = tempA;
                end
                
                % Convert input and output power to the unit of Watts
                switch pinunit
                    case 'DBM'
                        powdata(k,1) = 0.001*10^(powdata(k,1)/10);
                    case 'DBW'
                        powdata(k,1) = 10^(powdata(k,1)/10);
                    case 'MW'
                        powdata(k,1) = 0.001*powdata(k,1);
                    % If no unit in this line of data, use default unit.    
                    case ''
                        switch pinunit_default
                            case 'DBM'
                                powdata(k,1) = 0.001*10^(powdata(k,1)/10);
                            case 'DBW'
                                powdata(k,1) = 10^(powdata(k,1)/10);
                            case 'MW'
                                powdata(k,1) = 0.001*powdata(k,1);
                        end
                end
                
                switch poutunit
                    case 'DBM'
                        powdata(k,2) = 0.001.*10.^(powdata(k,2)./10);
                    case 'DBW'
                        powdata(k,2) = 10^(powdata(k,2)/10);
                    case 'MW'
                        powdata(k,2) = 0.001*powdata(k,2);
                    case ''
                        switch poutunit_default
                            case 'DBM'
                                powdata(k,2) = 0.001.*10.^(powdata(k,2)./10);
                            case 'DBW'
                                powdata(k,2) = 10^(powdata(k,2)/10);
                            case 'MW'
                                powdata(k,2) = 0.001*powdata(k,2);
                        end
                end
            end
        
            % Assign PoutFreq, Pin, Pout and Phase.
            % If there are more than one set of power data, the frequency 
            % point where each set of power data is measured must be 
            % specified.
            if totpowsec > 1 && isempty(PoutFreq)
                fclose(fid);
                error(['The frequency point where each set of', ...
                        ' power data',sprintf('\n'),...
                        'is measured must be specified.'])
            end
            if ~isempty(newfreq)
                PoutFreq(totpowsec,1) = newfreq;
            end

            Pin{totpowsec,1} = powdata(:,1)';
            Pout{totpowsec,1} = powdata(:,2)';
            if size(powdata, 2) == 3
                % Phase{totpowsec,1} = powdata(:,3)'.*pi./180;
                Phase{totpowsec,1} = powdata(:,3)';
            else
                Phase{totpowsec,1} = zeros(1, size(powdata, 1));
            end
            % END Parsing a power header section and a power data section. 
            
        case 'NetParam'
            % Find the line that starts with 'S','Y' or 'Z'.
            type_lnum = cat(1, strmatch('S', headersec), ...
            strmatch('Y', headersec), strmatch('Z', headersec));
            % If there are multiple type lines, use the last one.
            type_line = headersec(type_lnum(end), :); 
            
            % Find the network parameter type.
            if type_line(1) ==  'Y'
                NetworkType = 'Y_PARAMETERS';
            elseif type_line(1) == 'Z'
                NetworkType = 'Z_PARAMETERS';
            elseif type_line(1) == 'S'
                NetworkType = 'S_PARAMETERS';
            elseif type_line(1) == 'H'
                NetworkType = 'H_PARAMETERS';    
            end
            
            % Find the data format.
            if ~isempty(strfind(type_line, 'RI'))
                DataFormat = 'RI';
            elseif ~isempty(strfind(type_line, 'MA'))...
                || ~isempty(strfind(type_line, 'MP'))
                DataFormat = 'MA';
            elseif ~isempty(strfind(type_line, 'DB'))
                DataFormat = 'DB';
            else
                switch NetworkType
                    case 'S'
                        DataFormat = 'MA';
                    otherwise
                        DataFormat = 'RI';
                end
            end
            
            % Find Z0.
            Rpos = strfind(type_line, ' R ');
            RREFpos = strfind(type_line, 'RREF');
            if isempty(Rpos) && isempty(RREFpos)
                id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                msg = ['Reference Impedance not found,',...
                    sprintf('\n'),'the default value: 50 ohm is used'];
                warning(id, msg)
            elseif ~isempty(Rpos) % if keyword R is found
                if isempty(strtok(type_line(Rpos(1)+2:end)))
                    id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                    warning(id, ['Reference Impedance not found,',...
                        sprintf('\n'),'the default value: 50 ohm is used']);
                else
                    Z0 = str2num(strtok(type_line(Rpos(1)+2:end)));
                    if isempty(Z0)
                        Z0 = 50;
                        id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                        warning(id, ['Reference Impedance not found,',...
                            sprintf('\n'),...
                            'the default value: 50 ohm is used']);
                    end
                end
            else % if keyword RREF is found and keyword R is not found
                for i = RREFpos(end)+3:length(type_line)
                    if ~isempty(strfind('+-.0123456789', type_line(i)))
                        % if Z0 is single digit
                        if i == length(type_line)
                            Z0 = str2num(type_line(i));
                        else
                            for p = i+1:length(type_line)
                                if isempty(strfind('+-.0123456789E',...
                                    type_line(p)))
                                    Z0 = str2num(type_line(i:p-1));
                                    break;
                                end
                            end
                        end
                        break;
                    end
                    % if there is no number following keyword RREF
                    if i == length(type_line)
                        id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                        warning(id, ['Reference Impedance not found,',...
                            sprintf('\n'),...
                            'the default value: 50 ohm is used']);
                    end
                end
                if isempty(Z0)
                    Z0 = 50;
                    id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                    warning(id, ['Reference Impedance not found,',...
                        sprintf('\n'),'the default value: 50 ohm is used']);
                end
            end
            
            freq_lnum = strmatch('F', headersec);
            freq_line = headersec(freq_lnum(end), :);
            % Find the frequency scaling factor from the last line that
            % starts with F or FREQ.
            if ~isempty(strfind(freq_line, 'GHZ'))
                FScale = 1e9;
            elseif ~isempty(strfind(freq_line, 'MHZ'))
                FScale = 1e6;
            elseif ~isempty(strfind(freq_line, 'KHZ'))
                FScale = 1e3;
            elseif ~isempty(strfind(freq_line, 'HZ'))
                FScale = 1;
            else
                FScale = [];
            end
            % noifscale_default is used in NoiParam case. Sometimes frequency
            % scaling factor is not given in noise data, in which case,
            % noifscale will be the same as FScale.
            noifscale_default = FScale; 
            FScale_default = FScale;
            
            % Read the network parameter data section.
            cline = strtok(fgetl(fid), ';');
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % If the first character of the current line is numerical,
                % this line is part of the data section.
                if ~isempty(first_char) && ...
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                    % datasec = [datasec, sprintf(' '), cline];
                elseif ~isempty(first_char) && ...
                    isempty(strfind('+-.0123456789', first_char(1))) && ...
                    ~strcmp(first_char(1), '*')
                    % Remove the spaces at the beginning of the line.
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = strtok(fgetl(fid), ';');
                lcounter = lcounter + 1;
            end
            
            totnetsec = totnetsec + 1;
            if totnetsec > 1
                fclose(fid);
                error('More than one network data section found.')
            end
            
            % Readjust the frequency scaling factor and replace the scaling
            % characters with spaces so that we can later apply STR2NUM on
            % the whole data section.
            datasec = upper(datasec);
            % current number of parameters at current frequency point
            pcounter = 0; 
            % expected number of parameters at a frequency point
            Col = 2*nPort*nPort + 1;
            % buffer that holds complete data of one frequency point
            netline = [];
            % numerical array that holds all the network parameters
            netdata = [];
            for k = 1:size(datasec,1)
                if pcounter == 0 % if start on a new frequency point
                    token = strtok(datasec(k,:));
                    if ~isempty(strfind(token, 'GHZ'))
                        FScale = 1e9;
                        datasec(k,:) = strrep(datasec(k,:), 'GHZ', '   ');
                    elseif ~isempty(strfind(token, 'MHZ'))
                        FScale = 1e6;
                        datasec(k,:) = strrep(datasec(k,:), 'MHZ', '   ');
                    elseif ~isempty(strfind(token, 'KHZ'))
                        FScale = 1e3;
                        datasec(k,:) = strrep(datasec(k,:), 'KHZ', '   ');
                    elseif ~isempty(strfind(token, 'HZ'))
                        FScale = 1;
                        datasec(k,:) = strrep(datasec(k,:), 'HZ', '  ');
                    else
                        FScale = [];
                    end
                    if isempty(FScale) && isempty(FScale_default)
                        fclose(fid);
                        error(['Missing frequency units information.',...
                            sprintf('\n'),...
                            'It must be "GHz", "MHz", "KHz" or "Hz".'])
                    end
                end
                 % Convert the data section from characters to numbers.
                tempL = str2num(datasec(k,:));
                if isempty(tempL)
                    fclose(fid);
                    error('The network parameters are not correct.')
                end
                pcounter = pcounter + length(tempL);
                % Check if number of data points matches number of ports.
                if pcounter > Col
                    fclose(fid);
                    error(['Number of ports ',...
                            'does not match size of network parameters.'])
                % if data points of one frequency point is complete
                elseif pcounter == Col
                    pcounter = 0; % reset counter
                    netline = cat(2, netline, tempL);
                    if isempty(FScale)
                        % apply default frequency scale
                        netline(1) = netline(1)*FScale_default;
                    else
                        netline(1) = netline(1)*FScale;
                    end
                    netdata = cat(1, netdata, netline);
                    % clear storage of a complete network parameter line
                    netline = []; % reset buffer
                else
                    netline = cat(2, netline, tempL);
                end
            end
            
            % pcounter will be reset if the total number of parameters are
            % correct.
            if pcounter ~= 0
                fclose(fid);
                error('Incomplete network parameters.')
            end
            % Assign Freq and NetworkParameters.
            Freq = netdata(:,1);
            
            % netdata will contain only network parameters.
            netdata = netdata(:,2:end);
            netodd = netdata(:,1:2:end); % Extract columns of odd numbers.
            neteven = netdata(:,2:2:end); % Extract columns of even numbers.
            % tempA will contain magnitude, magnitude(dB) or real part of
            % the network parameters.
            tempA = zeros(nPort, nPort, size(netdata, 1));
            % tempB will contain angle(degree)or imaginary part of the
            % network parameters.
            tempB = zeros(nPort, nPort, size(netdata, 1));
            
            if nPort <= 2
                for p = 1:size(netdata, 1)
                    %Reshape one row of netdata into nPort by nPort matrix.
                    tempA(:,:,p) = reshape(netodd(p,:), nPort, nPort);
                    tempB(:,:,p) = reshape(neteven(p,:), nPort, nPort);
                end
            else
                for p = 1:size(netdata, 1)
                    % Reshape one row of netdata into nPort by nPort matrix
                    % and transpose it.
                    tempA(:,:,p) = reshape(netodd(p,:), nPort, nPort)';
                    tempB(:,:,p) = reshape(neteven(p,:), nPort, nPort)';
                end
            end
            
            % Pre-allocate the 3D matrix for NetworkParameters. 
            NetworkParameters = zeros(nPort, nPort, size(netdata, 1));
            % Compute the NetworkParameters.
            switch DataFormat
                case 'RI'
                    NetworkParameters =  tempA + tempB*j;
                case 'MA'
                    NetworkParameters = tempA .* exp(tempB*pi/180*j);
                case 'DB'
                    NetworkParameters =10.^(tempA/20).*exp(tempB*pi/180*j);
            end
            
        case 'NoiParam'
            % Read the noise data section.
            freq_lnum = strmatch('F', headersec);
            if ~isempty(freq_lnum)
                freq_line = headersec(freq_lnum(end), :);
                % Find the frequency scaling factor from the last line that
                % starts with F or FREQ.
                if ~isempty(strfind(freq_line, 'GHZ'))
                    noifscale_default = 1e9;
                elseif ~isempty(strfind(freq_line, 'MHZ'))
                    noifscale_default = 1e6;
                elseif ~isempty(strfind(freq_line, 'KHZ'))
                    noifscale_default = 1e3;
                elseif ~isempty(strfind(freq_line, 'HZ'))
                    noifscale_default = 1;
                end
            end
            
            cline = strtok(fgetl(fid), ';');
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % If the first character of the current line is numerical,
                % this line is part of the data section.
                if ~isempty(first_char) && ...
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && ... 
                    isempty(strfind('+-.0123456789', first_char(1))) && ...
                    ~strcmp(first_char(1), '*')
                    % Remove the spaces at the beginning of the line.
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = strtok(fgetl(fid), ';');
                lcounter = lcounter + 1;
            end
            
            totnoisec = totnoisec + 1;
            if totnoisec > 1
                fclose(fid);
                error('More than one noise data section found.')
            end
            
            % Readjust the frequency scaling factor and replace the scaling
            % characters with spaces so that we can later apply STR2NUM on
            % the whole data section.
            datasec = upper(datasec);
            noidata = zeros(size(datasec,1),5);
            for k = 1:size(datasec, 1)
                if ~isempty(strfind(datasec(k,:), 'GHZ'))
                    noifscale = 1e9;
                    datasec(k,:) = strrep(datasec(k,:), 'GHZ', '   ');
                elseif ~isempty(strfind(datasec(k,:), 'MHZ'))
                    noifscale = 1e6;
                    datasec(k,:) = strrep(datasec(k,:), 'MHZ', '   ');
                elseif ~isempty(strfind(datasec(k,:), 'KHZ'))
                    noifscale = 1e3;
                    datasec(k,:) = strrep(datasec(k,:), 'KHZ', '   ');
                elseif ~isempty(strfind(datasec(k,:), 'HZ'))
                    noifscale = 1; 
                    datasec(k,:) = strrep(datasec(k,:), 'HZ', '  ');
                else
                    noifscale = []; 
                end
                
                if isempty(noifscale) && isempty(noifscale_default)
                    fclose(fid);
                    error(['The scaling factor of the noise frequency',...
                            ' points not found.'])
                end
                
                % Convert data section from characters to numbers.
                tempA = str2num(datasec(k,:));
                if isempty(tempA)
                    fclose(fid);
                    error('The noise data is not correct.')
                elseif length(tempA) ~= 5
                    fclose(fid);
                    error('Noise parameters must have 5 columns.')
                end
                
                if ~isempty(noifscale)
                    tempA(1) = noifscale*tempA(1);
                else
                    tempA(1) = noifscale_default*tempA(1);
                end
                noidata(k,:) = tempA;
            end
            
            % Assign NoiseFreq and NoiseParameters        
            NoiseFreq = noidata(:,1);
            NoiseParameters = noidata(:,2:end);
            
        case 'IP3'
            % Parse the lines containing IP3.
            % IP3_lnum is the row index of the line that starts with IP3.
            % Find the power unit of IP3
            ip3_lnum = strmatch('IP3', headersec);
            ip3_line = headersec(ip3_lnum(end), :);
            if ~isempty(strfind(ip3_line, 'DBW'))
                ip3unit = 'DBW';
            elseif ~isempty(strfind(ip3_line, 'DBM'))
                ip3unit = 'DBM';
            elseif ~isempty(strfind(ip3_line, 'MW'))
                ip3unit = 'MW';
            else
                ip3unit = 'W'; % The default unit is 'W'
            end
            % ip3unit_default = ip3unit;
            
            freq_lnum = strmatch('F', headersec);
            if ~isempty(freq_lnum)
                freq_line = headersec(freq_lnum(end), :);
                % Find the frequency scaling factor from the last line that
                % starts with F or FREQ.
                if ~isempty(strfind(freq_line, 'GHZ'))
                    ip3fscale = 1e9;
                elseif ~isempty(strfind(freq_line, 'MHZ'))
                    ip3fscale = 1e6;
                elseif ~isempty(strfind(freq_line, 'KHZ'))
                    ip3fscale = 1e3;
                else % default scaling factor is 1 (for Hz)
                    ip3fscale = 1;
                end
            else
                ip3fscale = 1;
            end
            
            % Read the ip3 data section.
            cline = strtok(fgetl(fid), ';');
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % if the first character of the current line is numeric,
                % this line is part of the data section.
                if ~isempty(first_char) && ... 
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && ...
                    isempty(strfind('+-.0123456789', first_char(1))) && ...
                    ~strcmp(first_char(1), '*')
                    % Remove the spaces in the beginning
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = strtok(fgetl(fid), ';');
                lcounter = lcounter + 1;
            end
            
            totip3sec = totip3sec + 1;% Count the total ip3 data section
            
            % Readjust the frequency scaling factor and replace the scaling
            % characters with spaces so that we can later apply STR2NUM on
            % the whole data section.
            datasec = upper(datasec);
            if ~isempty(strfind(datasec(1,:), 'GHZ'))
                ip3fscale = 1e9;
                datasec = char(strrep(cellstr(datasec), 'GHZ', '   ')); 
            elseif ~isempty(strfind(datasec(1,:), 'MHZ'))
                ip3fscale = 1e6;
                datasec = char(strrep(cellstr(datasec), 'MHZ', '   ')); 
            elseif ~isempty(strfind(datasec(1,:), 'KHZ'))
                ip3fscale = 1e3;
                datasec = char(strrep(cellstr(datasec), 'KHZ', '   ')); 
            elseif ~isempty(strfind(datasec(1,:), 'HZ'))
                ip3fscale = 1; 
                datasec = char(strrep(cellstr(datasec), 'HZ', '  ')); 
            end     
            
            % Convert data section from characters to numbers.
            ip3data = str2num(datasec);
            if isempty(ip3data)
                fclose(fid);
                error('The IP3 data is not correct.')
            end
            if size(ip3data, 2) == 2;
                IP3Freq = ip3fscale * ip3data(:,1);
                IP3POUT = ip3data(:,2); 
            elseif  size(ip3data, 2) == 1 && ...
                size(ip3data, 1) == 1 % Only single ip3 data
                IP3Freq = NaN;
                IP3POUT = ip3data(1,1); 
            else
                fclose(fid);
                error('The IP3 data is not correct.')
            end
            % Convert IP3OUT to watts based on unit
            switch ip3unit
                case 'DBM'
                    IP3POUT = 0.001.*10.^(IP3POUT./10);
                case 'DBW'
                    IP3POUT = 10.^(IP3POUT./10);
                case 'MW'
                    IP3POUT = 0.001.*IP3POUT;
            end
            
        case 'MixerData'
            % Parse the line containing keyword MAXORDER to find the
            % maxorder
            maxorder_line = '';
            for k = size(headersec, 1):-1:1
                if ~isempty(strfind(headersec(k, :), 'MAXORDER'))
                    maxorder_line = headersec(k, :);
                    break;
                end
            end
            if isempty(maxorder_line)
                fclose(fid);
                error('Missing keyword MAXORDER in mixer data.')
            end
            % Find the maxorder
            start_of_maxorder = strfind(maxorder_line, 'MAXORDER');
            for i = start_of_maxorder(end)+7:length(maxorder_line)
                if ~isempty(strfind('+-.0123456789', maxorder_line(i)))
                    %if single number and the last character in the line
                    if i == length(maxorder_line)
                        MAXORDER = str2num(maxorder_line(i));
                    else
                        for p = i+1:length(maxorder_line)
                            if isempty(strfind('+-.0123456789E',...
                                maxorder_line(p)))
                                MAXORDER = str2num(maxorder_line(i:p-1));
                                break;
                            end
                        end
                    end
                    break;
                end
            end 
            if isempty(MAXORDER)
                fclose(fid);
                error('Missing maximum order of mixer data.')
            end
            HarmonicaData = zeros(MAXORDER+1,MAXORDER+1);
            
            % Read the mixer data section.
            cline = strtok(fgetl(fid), ';');
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % if the first character of the current line is numeric,
                % this line is part of the data section.
                if ~isempty(first_char) && ...
                    ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && ...
                    isempty(strfind('+-.0123456789', first_char(1))) && ...
                    ~strcmp(first_char(1), '*')
                    % Remove the spaces in the beginning
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = strtok(fgetl(fid), ';');
                lcounter = lcounter + 1;
            end
            
            % Count the total ip3 data section
            totmixersec = totmixersec + 1;
            
            % Convert data section from characters to numbers.
            datasec = upper(datasec);
            for i = 1:MAXORDER+1
                tempA = str2num(datasec(i,:));
                if isempty(tempA) || (length(tempA) ~= MAXORDER+2-i)
                    fclose(fid);
                    error('The mixerspurs data is not correct.')
                end
                HarmonicaData(i,1:MAXORDER+2-i) = tempA;
            end
    end
end

%Check if there is no network parameters
if totnetsec == 0 && totpowsec > 0
    id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
    warning(id, ['Reference Impedance not found,',...
            sprintf('\n'),'the default value: 50 ohm is used']);
end

% Update the objects
refobj = get(h, 'Reference');
if ~isa(refobj, 'rfdata.reference')
    refobj = rfdata.reference;
end
[Fmin, Gammaopt, Rn] = getnoisedata(NoiseParameters, 'MA', 1);
update(refobj, NetworkType, Freq, NetworkParameters, Z0, NoiseFreq, Fmin,...
    Gammaopt, Rn, PoutFreq, Pin, Pout, Phase);

fclose(fid); 

%--------------------------------------------------
function refobj = reads2d(h, filename)
%READS2D Parser for S2D files.

% Set the default values.
nPort = 2;
NetworkType = '';
Freq = [];
FreqOut = [];
NetworkParameters = [];
NoiseFreq = []; 
NoiseParameters = []; 
DataFormat = '';
Z0 = 50;
PoutFreq = [];
Pin = {};
Pout = {};
Phase = {};
PZ0 = 50;
OIP3 = inf;
OneDBC = inf;
PS = inf;
GCS = inf;

% Get the devicename from the filename
% DeviceName = fliplr(strtok(fliplr(filename), filesep));
% DeviceName = strtok(DeviceName, '.');

fid = fopen(filename, 'rt');
if fid == -1
    error(['Cannot open text file ', filename])
end

lcounter = 0; % lcounter is the line counter.
cline = ''; % cline is the current line.

% Find first nonempty line. 
while isempty(strtok(cline))
    cline = fgetl(fid);
    lcounter = lcounter + 1;
end
% Check for empty file.
if ~ischar(cline)
    fclose(fid);
    error([filename,' is empty.'])
end

totnoisec = 0; % Initialize total number of noise parameter sections.
totnetsec = 0; % Initialize total number of network parameter sections.
totpowsec = 0; % Initialize total number of power data sections.
headersec = ''; % Initialize header section.
datasec = ''; % Initialize data section.
noifscale = []; % Initialize noise frequency scaling factor.

% This is the beginning of a BIG while loop that reads the file one section
% at a time
while ischar(cline) || isempty(cline)
    
    % BEGIN reading header section and decide section type
    sectype = '';
    while ischar(cline) || isempty(cline)
        % Remove the spaces in the beginning of the current line
        [token,rem] = strtok(cline);
        cline = [token,rem];
        
        % If the current line starts with a numerical value 
        if ~isempty(token) && ~isempty(strfind('+-.0123456789', token(1)))
            datasec = strtok(cline, '!');
            break;
        % If the current line starts with a non-numerical value and does 
        % not start with '!'   
        elseif ~isempty(token) && ~strcmp(token(1), '!')
            cline = strtok(cline, '!'); %Remove comments that follow
            headersec = strvcat(headersec, cline);
        end
        cline = fgetl(fid);
        lcounter = lcounter + 1;
    end
    
    % If it is the end of the file    
    if ~ischar(cline) && cline == -1
        break;
    end
    
    % Make the header section upper case.
    headersec = upper(headersec);
    header_num = strmatch('BEGIN', headersec);
    % Only one line in the header should start with BEGIN
    if length(header_num) ~= 1
        error('Multiple or no keyword BEGIN found in the header')
    end
    header_line = headersec(header_num,:);
    
    if ~isempty(strfind(header_line, 'ACDATA'))
        sectype = 'ACDATA';
    elseif  ~isempty(strfind(header_line, 'NDATA'))
        sectype = 'NDATA';
    elseif  ~isempty(strfind(header_line, 'GCOMP1'))
        sectype = 'GCOMP1';
    elseif  ~isempty(strfind(header_line, 'GCOMP2'))
        sectype = 'GCOMP2';
    elseif  ~isempty(strfind(header_line, 'GCOMP3'))
        sectype = 'GCOMP3';
    elseif  ~isempty(strfind(header_line, 'GCOMP4'))
        sectype = 'GCOMP4';
    elseif  ~isempty(strfind(header_line, 'GCOMP5'))
        sectype = 'GCOMP5';
    elseif  ~isempty(strfind(header_line, 'GCOMP6'))
        sectype = 'GCOMP6';
    elseif  ~isempty(strfind(header_line, 'GCOMP7'))
        sectype = 'GCOMP7';    
    elseif  ~isempty(strfind(header_line, 'IMTDATA'))
        sectype = 'IMTDATA';    
    else
        fclose(fid);
        error('Block type identifier not found in the header')
    end
    % END reading header section.
    
    % Parse header sections and read data sections based on their types.
    switch sectype
        % BEGIN Parsing a ACDATA section and possibly several power data
        % section. 
        case 'ACDATA'
            
            % Find the option line that starts with '#'.
            option_lnum = strmatch('#', headersec);
            if isempty(option_lnum)
                fclose(fid);
                error(['Missing option line that starts with "#" in ',...
                    'ACDATA block.'])
            end
            % If there are multiple option lines, error out.
            if length(option_lnum) > 1
                fclose(fid);
                error(['More than one option line that starts with "#" ',...
                    'found in ACDATA block.'])
            end
            option_line = headersec(option_lnum(1), :); 
            
            % Find the network parameter type.
            if ~isempty(strfind(option_line, ' Z '))
                NetworkType = 'Z_PARAMETERS';
            elseif ~isempty(strfind(option_line, ' Y '))
                NetworkType = 'Y_PARAMETERS';
            elseif ~isempty(strfind(option_line, ' H '))
                NetworkType = 'H_PARAMETERS';
            elseif ~isempty(strfind(option_line, ' G '))
                fclose(fid);
                error(['Only S,Z,Y,H-parameters are currently supported ',... 
                    'in ACDATA block.'])
            else
                NetworkType = 'S_PARAMETERS';%default type is s_parameters
            end
            
            % Find the data format.
            if ~isempty(strfind(option_line, 'RI'))
                DataFormat = 'RI';
            elseif ~isempty(strfind(option_line, 'VDB'))
                % DataFormat = 'VDB';
                fclose(fid);
                error(['Only RI,MA,DB formats are currently supported ',... 
                    'in ACDATA block.'])
            elseif ~isempty(strfind(option_line, 'DB ')) ||...
                ~isempty(strfind(option_line, 'DB)'))
                DataFormat = 'DB';
            else
                DataFormat = 'MA'; % MA is default
            end
            
            % Find Z0.
            Rpos = strfind(option_line, ' R ');
            if isempty(Rpos) || isempty(strtok(option_line(Rpos(1)+2:end)))
                id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                warning(id, ['Reference Impedance not found in ACDATA block,',...
                        sprintf('\n'),'the default value: 50 ohm is used.']);
            else
                Z0 = str2num(strtok(strtok(option_line(Rpos(1)+2:end),')')));
                if isempty(Z0)
                    Z0 = 50;
                    id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                    warning(id,['Reference Impedance not found in ACDATA block,',...
                            sprintf('\n'),...
                            'the default value: 50 ohm is used.']);
                end
            end
            
            % Find the unit of frequency
            if ~isempty(strfind(option_line, 'MHZ'))
                FScale = 1e6;
            elseif ~isempty(strfind(option_line, 'KHZ'))
                FScale = 1e3;
            elseif ~isempty(strfind(option_line, 'GHZ'))
                FScale = 1e9;
            elseif ~isempty(strfind(option_line, 'HZ'))
                FScale = 1;
            else
                FScale = 1e9; % GHz is the default
                id = sprintf('rf:%s:read:FreqUnitNotFound',strrep(class(h),'.',':'));
                warning(id,['Frequency unit not found in ACDATA block,',...
                            sprintf('\n'),...
                            'the default unit: GHz is used.']);
            end
            % noifscale is used in NoiParam case. Sometimes frequency
            % scaling factor is not given in noise data, in which case,
            % noifscale will be the same as FScale.
            % noifscale = FScale;
            
            % Read FC, set default m and b first
            FC_m = 1;% FreqOut = FScale*(FC_m*Freq + Fc_b);
            FC_b = 0;
            FCpos = strfind(option_line, ' FC ');
            if ~isempty(FCpos) && ~isempty(strtok(option_line(FCpos(1)+3:end)))
                [Token, Rem] = strtok(option_line(FCpos(1)+3:end));
                if ~isempty(str2num(Token))
                    FC_m = str2num(Token);
                end
                if ~isempty(strtok(Rem))
                    Token = strtok(strtok(Rem,')'));
                    if ~isempty(str2num(Token))
                        FC_b = str2num(Token);
                    end
                end
            end
            
            % Read the network parameter data section.
            cline_raw = fgetl(fid); % raw current line
            lcounter = lcounter + 1;
            token_raw = strtok(cline_raw); % raw token
            cline = strtok(cline_raw, '!');% Remove comments if any
            first_char = strtok(cline);
            while ischar(cline) || isempty(cline)
                if ~isempty(token_raw) && ~strcmp(token_raw(1),'!') ...
                        && ~isempty(first_char) && ...
                        isempty(strfind('+-.0123456789', first_char(1)))
                    % Remove the spaces at the beginning of the line.
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    break;
                % If the first character of the current line is
                % numerical, this line is part of the data section.
                elseif ~isempty(token_raw) && ...
                        ~strcmp(token_raw(1),'!') && ...
                        ~isempty(first_char) && ...
                        ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                end
                cline_raw = fgetl(fid); % raw current line
                lcounter = lcounter + 1;
                token_raw = strtok(cline_raw); % raw token
                cline = strtok(cline_raw, '!'); % Remove comments if any
                first_char = strtok(cline);
            end
            
            totnetsec = totnetsec + 1;
            if totnetsec > 1
                fclose(fid);
                error('More than one ACDATA block found.')
            end

            % current number of parameters at current frequency point
            pcounter = 0;
            % buffer that holds complete data of one frequency point
            netline = [];
            % numerical array that holds all the network parameters
            netdata = [];
            for k = 1:size(datasec,1)
                % Convert the data section from characters to numbers.
                tempL = str2num(datasec(k,:));
                if isempty(tempL)
                    fclose(fid);
                    error(['The network parameters contain errors on line ',...
                        num2str(lcounter),'.'])
                end
                pcounter = pcounter + length(tempL);
                % Check if number of data points matches number of ports.
                if pcounter > 9
                    fclose(fid);
                    error(['There must be 8 network ',...
                        'parameters per frequency point.'])
                % if data points of one frequency point is complete
                elseif pcounter == 9
                    pcounter = 0; % reset counter
                    netline = cat(2, netline, tempL);
                    netdata = cat(1, netdata, netline);
                    % clear storage of a complete network parameter
                    % line
                    netline = []; % reset buffer
                else
                    netline = cat(2, netline, tempL);
                end
            end
            datasec = ''; % reset data section

            % Assign Freq and NetworkParameters.
            % Freq = FScale*netdata(:,1).*FC_m + FC_b;
            Freq = FScale*netdata(:,1);
            FreqOut = FScale*(netdata(:,1).*FC_m + FC_b);

            % netdata will contain only network parameters.
            netdata = netdata(:,2:end);
            % Extract columns of odd numbers.
            netodd = netdata(:,1:2:end);
            % Extract columns of even numbers.
            neteven = netdata(:,2:2:end);
            % tempA will contain magnitude, magnitude(dB) or real part
            % of the network parameters.
            tempA = zeros(nPort, nPort, size(netdata, 1));
            % tempB will contain angle(degree)or imaginary part of the
            % network parameters.
            tempB = zeros(nPort, nPort, size(netdata, 1));

            for p = 1:size(netdata, 1)
                % Reshape one row of netdata into nPort by nPort matrix.
                tempA(:,:,p) = reshape(netodd(p,:), nPort, nPort);
                tempB(:,:,p) = reshape(neteven(p,:), nPort, nPort);
            end

            % Pre-allocate the 3D matrix for NetworkParameters.
            NetworkParameters = zeros(nPort, nPort, size(netdata, 1));
            % Compute the NetworkParameters.
            switch DataFormat
                case 'RI'
                    NetworkParameters =  tempA + tempB*j;
                case 'MA'
                    NetworkParameters = tempA .* exp(tempB*pi/180*j);
                case 'DB'
                    NetworkParameters = 10.^(tempA/20) .* ...
                        exp(tempB*pi/180*j);
            end
           
            
            % Search for the end of GCOMP data section
            while (ischar(cline) || isempty(cline)) && ...
                    (isempty(strtok(cline)) || ...
                    ~strcmpi(strtok(cline),'END'))
                cline = fgetl(fid); % Read the next line
                lcounter = lcounter + 1;
            end
            headersec = ''; % reset header section
        
        case {'GCOMP1','GCOMP2','GCOMP3','GCOMP4','GCOMP5','GCOMP6'}
            
            % Find the format line that starts with '%'.
            format_lnum = strmatch('%', headersec);
            if isempty(format_lnum)
                fclose(fid);
                error(['Missing format line that starts with "%" in ',...
                    sectype,' block.'])
            end
            % If there are multiple option lines, use the first one.
            if length(format_lnum) > 1
                fclose(fid);
                error(['More than one format line that starts with "%" ',...
                    'found in ACDATA block.'])
            end
            format_line = headersec(format_lnum(1), :);
            
            % Always sort data in this order:IP3 1DBC PS GCS
            ip3_pos = strfind(format_line, 'IP3');
            db1c_pos = strfind(format_line, '1DBC');
            ps_pos = strfind(format_line, 'PS');
            gcs_pos = strfind(format_line, 'GCS');
            % All the positions should be unique
            if length(ip3_pos)>1 || length(db1c_pos)>1 ...
                    || length(ps_pos)>1 || length(gcs_pos)>1
                fclose(fid);
                error(['Wrong format in ',sectype,' block.'])
            end
            [tempM, index] = sort([ip3_pos; db1c_pos; ps_pos; gcs_pos]);
            
            % Convert data line to numerical value
            netline = str2num(datasec);
            if isempty(netline)
                fclose(fid);
                error([sectype,' block contains errors on line ',...
                        num2str(lcounter),'.'])
            end
            if length(netline) ~= length(index)
                fclose(fid);
                error('Number of GCOMP data must match the format line.')
            end    
            datasec = ''; % Reset data section
            
            % sort data in this order:IP3 1DBC PS GCS
            tempM = sortrows([index, netline'],1);
            netline = tempM(:,2)';
            pcounter = 1; % a counter
            for p = 1:4
                switch p
                    case 1
                        if ~isempty(ip3_pos)
                            OIP3 = netline(pcounter);
                            OIP3 = 0.001*10^(OIP3/10); %Convert to watts
                            pcounter = pcounter + 1;
                        end
                    case 2
                        if ~isempty(db1c_pos)
                            OneDBC = netline(pcounter);
                            OneDBC = 0.001*10^(OneDBC/10);%Convert to watts
                            pcounter = pcounter + 1;
                        end
                    case 3
                        if ~isempty(ps_pos)
                            PS = netline(pcounter);
                            PS = 0.001*10^(PS/10); %Conver to watts
                            pcounter = pcounter + 1;
                        end
                    case 4
                        if ~isempty(gcs_pos)
                            GCS = netline(pcounter);
                            GCS = 10^(GCS/20); %Conver to voltage gain
                            pcounter = pcounter + 1;
                        end
                end
            end
            
            % Search for the end of GCOMP data section
            while (ischar(cline) || isempty(cline)) && ...
                    (isempty(strtok(cline)) || ...
                    ~strcmpi(strtok(cline),'END'))
                cline = fgetl(fid); % Read the next line
                lcounter = lcounter + 1;
            end
            headersec = ''; %reset header section
         
        case 'GCOMP7'
            
            % Find the option line that starts with '#'.
            option_lnum = strmatch('#', headersec);
            if isempty(option_lnum)
                fclose(fid);
                error(['Missing option line that starts with "#" in ',...
                    'GCOMP7 block.'])
            end
            % If there are multiple option lines, error out.
            if length(option_lnum) > 1
                fclose(fid);
                error(['More than one option line that starts with "#" ',...
                    'found in GCOMP7 block.'])
            end
            option_line = headersec(option_lnum(1), :); 
            
            % Find the network parameter type.
            if isempty(strfind(option_line, ' S '))
                id = sprintf('rf:%s:read:GCOMP7Sparam',strrep(class(h),'.',':'));
                warning(id,'Only S-parameters are allowed in GCOMP7 block.')
            end
            
            % Find the data format.
            if ~isempty(strfind(option_line, 'RI'))
                DataFormat = 'RI';
            % Since dbm may appear in this option line, we need to be more 
            % careful about DB format.    
            elseif ~isempty(strfind(option_line, 'DB ')) ||...
                ~isempty(strfind(option_line, 'DB)'))
                DataFormat = 'DB';
            else
                DataFormat = 'MA'; % MA is the default
            end
            
            % Find Z0.
            Rpos = strfind(option_line, ' R ');
            if isempty(Rpos) || isempty(strtok(option_line(Rpos(1)+2:end)))
                id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                warning(id, ['Reference Impedance not found in GCOMP7 block,',...
                        sprintf('\n'),'the default value: 50 ohm is used.']);
            else
                % Also remove bracket that may follows reference impedance
                PZ0 = str2num(strtok(strtok(option_line(Rpos(1)+2:end),')')));
%                 if isempty(PZ0)
%                     PZ0 = 50;
%                     id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
%                     warning(id, ['Reference Impedance not found in GCOMP7 block,',...
%                             sprintf('\n'),...
%                             'the default value: 50 ohm is used.']);
%                 end
            end
            
            % Find the unit of frequency
            if ~isempty(strfind(option_line, 'MHZ'))
                FScale = 1e6;
            elseif ~isempty(strfind(option_line, 'KHZ'))
                FScale = 1e3;
            elseif ~isempty(strfind(option_line, 'GHZ'))
                FScale = 1e9;
            elseif ~isempty(strfind(option_line, 'HZ'))
                FScale = 1;
            else
                FScale = 1e9; % GHz is the default
                id = sprintf('rf:%s:read:FreqUnitNotFound',strrep(class(h),'.',':'));
                warning(id,['Frequency unit not found in GCOMP7 block,',...
                            sprintf('\n'),...
                            'the default unit: GHz is used.']);
            end
            
            % Check unit of power
            if isempty(strfind(option_line, 'DBM'))
                id = sprintf('rf:%s:read:PowerUnitNotFound',strrep(class(h),'.',':'));
                warning(id,['Power unit not found in GCOMP7 block,',...
                            sprintf('\n'),...
                            'the only allowed unit: DBM is used.']);
            end
           
            % At this point, last line in headersec must contain '% F'.
            templine =  headersec(end,:);
            first_token = strtok(templine); 
            if length(templine) > 1
                second_token = strtok(templine(2:end));
            else
                second_token = '';
            end    
            if ~strcmp(first_token(1), '%') || ~strncmp(second_token, 'F',1)
                fclose(fid);
                error(['GCOMP7 block must contain frequency information ',...
                        'for large-signal S21 parameters.'])
            end
            
            % This while loop should be able to read as many power
            % dependent S21 parameters as in the GCOMP7 block
            while ischar(cline) || isempty(cline)

                if ~isempty(first_token) && strcmp(first_token(1), '%')...
                        && strncmp(second_token, 'F',1)
                    % Read the frequency point and store it
                    totpowsec = totpowsec + 1; % Increment totpowsec by 1
                    while (ischar(cline) || isempty(cline)) && ...
                            (isempty(strtok(cline)) || ...
                            strncmp(strtok(cline),'!',1) ||...
                            strncmp(strtok(cline),'%',1))
                        cline = fgetl(fid); % Read the next line
                        lcounter = lcounter + 1;
                    end
                    % Check if it has reached the end of the file
                    if ~ischar(cline)
                        fclose(fid);
                        error(['Missing a frequency point ',...
                            'of the large-signal in GCOMP7 block.'])
                    end
                    cline = strtok(cline, '!'); % Remove comments
                    if isempty(str2num(cline)) || ...
                            max(size(str2num(cline))) ~= 1
                        fclose(fid);
                        error(['Missing a frequency point ',...
                            'of the large-signal in GCOMP7 block.'])
                    end
                    PoutFreq(totpowsec,1) = str2num(cline)*FScale;

                    datasec = ''; % reset data section

                    % Get ready to read the large-signal s-parameters
                    % Find the line that starts with "% PIN ..."
                    cline = fgetl(fid); % Read the next line
                    lcounter = lcounter + 1;
                    while (ischar(cline) || isempty(cline)) && ...
                            (isempty(strtok(cline)) || ...
                            ~strncmp(strtok(cline),'%',1))
                        cline = fgetl(fid); % Read the next line
                        lcounter = lcounter + 1;
                    end
                    % Check if it has reached the end of the file.
                    if ~ischar(cline)
                        fclose(fid);
                        error(['Missing large-signal S21 parameters in ',...
                            'GCOMP7 block.'])
                    end
                    cline = upper(strtok(cline, '!')); % Remove comments
                    % cline needs to be upper case
                    % Check if this is a format line for large-signal
                    if isempty(strfind(cline, 'PIN'))
                        fclose(fid);
                        error(['Illegal format line for power-dependent ',...
                            'S21 parameters in GCOMP7 block'])
                    end

                elseif ~isempty(first_token) && strcmp(first_token(1),'%')...
                        && ~isempty(strfind(cline, 'PIN'))

                    % Find out the order of PIN, N21x and N21y
                    index = zeros(3,1);
                    pin_pos = strfind(cline, 'PIN');
                    n21x_pos = strfind(cline, 'N21X');
                    n21y_pos = strfind(cline, 'N21Y');
                    if length(pin_pos)~=1 || length(n21x_pos)~=1 ...
                            || length(n21y_pos)~=1
                        fclose(fid);
                        error(['Wrong format in line: ',num2str(lcounter)])
                    end
                    [tempM, index] = sort([pin_pos; n21x_pos; n21y_pos]);
                    
                    cline_raw = fgetl(fid); % raw current line
                    lcounter = lcounter + 1;
                    token_raw = strtok(cline_raw); % raw token
                    cline = strtok(cline_raw, '!');% Remove comments if any
                    first_char = strtok(cline);
                    while ischar(cline) || isempty(cline)
                        % Next format line must start with '% F' or 'END'
                        if ~isempty(token_raw) && ...
                                ~strcmp(token_raw(1),'!') && ...
                                ~isempty(first_char) && ...
                                (strcmp('%', first_char(1)) && ...
                                ~isempty(strfind(upper(cline), 'F')) || ...
                                strcmpi('END', first_char))
                            % Remove the spaces at the beginning of the
                            % line.
                            % [token,rem] = strtok(cline);
                            % cline = [token,rem];
                            break;
                        % If the first character of the current line is
                        % numerical,this line is part of the data section.
                        elseif ~isempty(token_raw) && ...
                                ~strcmp(token_raw(1),'!') && ...
                                ~isempty(first_char) && ...
                                ~isempty(strfind('+-.0123456789', ...
                                first_char(1)))
                            datasec = strvcat(datasec, cline);
                        end
                        cline_raw = fgetl(fid); % raw current line
                        lcounter = lcounter + 1;
                        token_raw = strtok(cline_raw); % raw token
                        % Remove comments if any
                        cline = strtok(cline_raw, '!');
                        first_char = strtok(cline);
                    end

                    % Convert data section from characters to numbers.
                    powdata = str2num(datasec);
                    if isempty(powdata)
                        fclose(fid);
                        error(['Power-dependent S21 parameters contain ',...
                            'errors on line ',num2str(lcounter),'.'])
                    end

                    % Assign Pin and PS21
                    if size(powdata, 2) ~= 3
                        fclose(fid);
                        error(['Power-dependent S21 parameters ',...
                            'must have 3 columns.'])
                    end

                    % Put index ahead of transposed power data matrix and
                    % resort it. Then remove the index.
                    powdata = sortrows([index, powdata'], 1);
                    powdata = powdata(:, 2:end)';
                    % Power unit must be DBM
                    Pin{totpowsec,1} = 0.001.*10.^(powdata(:,1)'./10);
                    switch DataFormat
                        case 'RI'
                            S21 = (powdata(:,2)+ powdata(:,3)*j ).';
                            Pout{totpowsec,1} = Pin{totpowsec,1}.*...
                                (abs(S21).^2);
                            Phase{totpowsec,1} = 180*angle(S21)/pi;
                        case 'MA'
                            Pout{totpowsec,1} = Pin{totpowsec,1}.*...
                                (powdata(:,2)'.^2);
                            Phase{totpowsec,1} = powdata(:,3)';
                        case 'DB'
                            Pout{totpowsec,1} = Pin{totpowsec,1}.*...
                                (10.^(powdata(:,2)'/10));
                            Phase{totpowsec,1} = powdata(:,3)';
                    end

                elseif ~isempty(first_token) && strncmp(first_token,'END',3)
                    % Break the loop when keyword END appears
                    break
                else
                    fclose(fid);
                    error(['Wrong format in line: ',num2str(lcounter)])
                end
                
                cline = upper(cline);
                first_token = strtok(cline);
                second_token = strtok(cline(2:end));
                
            end
            % the end of the while loop
            
            % cline contains END at this point
            % headersec = cline; 
            headersec = '';
                           
        case 'NDATA'
            
            % Find the option line that starts with '#'.
            option_lnum = strmatch('#', headersec);
            if isempty(option_lnum)
                fclose(fid);
                error(['Missing option line that starts with "#" in ',...
                    'NDATA block.'])
            end
            % If there are multiple option lines, error out.
            if length(option_lnum) > 1
                fclose(fid);
                error(['More than one option line that starts with "#" ',...
                    'found in NDATA block.'])
            end
            option_line = headersec(option_lnum(1), :);

            % Find the parameter type.
            % if isempty(strfind(option_line, ' S '))
            %    warning('Only S-parameters are allowed in NDATA block.')
            % end

            % Find the data format.
            if ~isempty(strfind(option_line, 'RI'))
                NoiFormat = 'RI';
            elseif ~isempty(strfind(option_line, 'DB'))
                NoiFormat = 'DB';
            else
                NoiFormat = 'MA'; % MA is the default
            end

            % Find Z0.
            NoiZ0 = 50;
            Rpos = strfind(option_line, ' R ');
            if isempty(Rpos) || isempty(strtok(option_line(Rpos(1)+2:end)))
                id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                warning(id,['Reference Impedance not found in NDATA block,',...
                    sprintf('\n'),'the default value: 50 ohm is used.']);
            else
                % Also remove bracket that may follows reference impedance
                NoiZ0 = str2num(strtok(strtok(option_line(Rpos(1)+2:end),')')));
                if isempty(NoiZ0)
                    NoiZ0 = 50;
                    id = sprintf('rf:%s:read:Z0NotFound',strrep(class(h),'.',':'));
                    warning(id,['Reference Impedance not found in NDATA block,',...
                        sprintf('\n'),...
                        'the default value: 50 ohm is used.']);
                end
            end

            % Find the unit of frequency
            if ~isempty(strfind(option_line, 'MHZ'))
                noifscale = 1e6;
            elseif ~isempty(strfind(option_line, 'KHZ'))
                noifscale = 1e3;
            elseif ~isempty(strfind(option_line, 'GHZ'))
                noifscale = 1e9;
            elseif ~isempty(strfind(option_line, 'HZ'))
                noifscale = 1;
            else
                noifscale = 1e9; % GHz is the default
                id = sprintf('rf:%s:read:FreqUnitNotFound',strrep(class(h),'.',':'));
                warning(id,['Frequency unit not found in NDATA block,',...
                    sprintf('\n'),...
                    'the default unit: GHz is used.']);
            end
             
            % Read the noise data section.
            cline_raw = fgetl(fid); % raw current line
            lcounter = lcounter + 1;
            token_raw = strtok(cline_raw); % raw token
            cline = strtok(cline_raw, '!');% Remove comments if any
            first_char = strtok(cline);
            while ischar(cline) || isempty(cline)
                if ~isempty(token_raw) && ~strcmp(token_raw(1),'!') ...
                        && ~isempty(first_char) && ...
                        isempty(strfind('+-.0123456789', first_char(1)))
                    % Remove the spaces at the beginning of the line.
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    break;
                    % If the first character of the current line is
                    % numerical, this line is part of the data section.
                elseif ~isempty(token_raw) && ...
                        ~strcmp(token_raw(1),'!') && ...
                        ~isempty(first_char) && ...
                        ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                end
                cline_raw = fgetl(fid); % raw current line
                lcounter = lcounter + 1;
                token_raw = strtok(cline_raw); % raw token
                cline = strtok(cline_raw, '!'); % Remove comments if any
                first_char = strtok(cline);
            end
            
            %if isempty(datasec)
            %    fclose(fid);error('Missing a noise data section.')
            %end 
            totnoisec = totnoisec + 1;
            if totnoisec > 1
                fclose(fid);
                error('More than one NDATA block found.')
            end
            
            % Convert data section from characters to numbers.
            noidata = str2num(datasec);
            if isempty(noidata)
                fclose(fid);
                error(['The noise parameters contain errors.'])
            end
            
            % Assign NoiseFreq and NoiseParameters.
            if size(noidata, 2) ~= 5
                fclose(fid);
                error('Noise parameters must have 5 columns.')
            end
            NoiseFreq = noidata(:,1)*noifscale;
            NoiseParameters = noidata(:,2:end);
            
            % Search for the end of GCOMP data section
            while (ischar(cline) || isempty(cline)) && ...
                    (isempty(strtok(cline)) || ...
                    ~strcmpi(strtok(cline),'END'))
                cline = fgetl(fid); % Read the next line
                lcounter = lcounter + 1;
            end
            headersec = ''; % reset header section
            
        case  'IMTDATA'
            % Find the option line that starts with '#'.
            option_lnum = strmatch('#', headersec);
            if ~isempty(option_lnum)
                % If there are multiple option lines, use the first one.
                option_line = headersec(option_lnum(end), :);
                [token, rem] = strtok(option_line);
                [token, rem] = strtok(rem); % Read signal level and LO level
                if ~isempty(token) && ~isempty(rem)
                    SigLvl = str2num(token);
                    LOLvl = str2num(rem);
                end
            end
            
            % Read the mixer data section.
            cline = upper(fgetl(fid));
            lcounter = lcounter + 1;
            while ischar(cline) || isempty(cline)
                first_char = strtok(cline);
                % if the first character of the current line is numeric,
                % this line is part of the data section.
                if ~isempty(first_char) && ~isempty(strfind('+-.0123456789', first_char(1)))
                    datasec = strvcat(datasec, cline);
                elseif ~isempty(first_char) && isempty(strfind('+-.0123456789', first_char(1)))
                    % Remove the spaces in the beginning
                    [token,rem] = strtok(cline);
                    cline = [token,rem];
                    headersec = cline;
                    break;
                end
                cline = upper(fgetl(fid));
                lcounter = lcounter + 1;
            end
            
            MAXORDER = length(str2num(datasec(1,:))) - 1;
            if MAXORDER <= 0
                fclose(fid);
                error('Maximum order of mixerspurs data must be a positive integer.')
            end
            % Convert data section from characters to numbers.
            for i = 1:MAXORDER+1
                tempA = str2num(datasec(i,:));
                if isempty(tempA) || (length(tempA) ~= MAXORDER+2-i)
                    fclose(fid);
                    error('The mixerspurs data is not correct.')
                end
                HarmonicaData(i,1:MAXORDER+2-i) = tempA;
            end           
    end
end

% Update the objects
refobj = get(h, 'Reference');
if ~isa(refobj, 'rfdata.reference')
    refobj = rfdata.reference;
end

% First set OIP3, OneDBC, PS and GCS
set(refobj,'OIP3',OIP3,'OneDBC',OneDBC,'PS',PS,'GCS',GCS);
% [Fmin, Gammaopt, Rn] = getnoisedata(NoiseParameters, NoiFormat, NoiZ0);
[Fmin, Gammaopt, Rn] = getnoisedata(NoiseParameters, NoiFormat, 1);
update(refobj, NetworkType, Freq, NetworkParameters, Z0, NoiseFreq, Fmin,...
    Gammaopt, Rn, PoutFreq, Pin, Pout, Phase);

fclose(fid);

%------------------------------------------------
function [fmin, gammaopt, rn] = getnoisedata(noiseparams, format, z0);
if isempty(noiseparams)
    fmin = [];
    gammaopt = []; 
    rn = [];
    return
end
fmin = noiseparams(:, 1);
fmin = 10.^(fmin/10);
switch upper(format)
    case 'MA'
        R = noiseparams(:, 2);
        theta = noiseparams(:, 3) * pi/180;
        gammaopt = R.*exp(i*theta);
    case 'DB'
        R = 10.^(noiseparams(:, 2)/20);
        theta = noiseparams(:, 3) * pi/180;
        gammaopt = R.*exp(i*theta);
    case 'RI'
        gammaopt =  noiseparams(:, 2) + i*noiseparams(:, 3);
end
rn = z0*noiseparams(:, 4);
