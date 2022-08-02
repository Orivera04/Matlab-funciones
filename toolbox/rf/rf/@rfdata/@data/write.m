function status = write(h, filename, dataformat, funit, printformat, freqformat)
%WRITE Create the formatted RF network data file.
%   STATUS = WRITE(H, FILENAME, DATAFORMAT, FUNIT, PRINTFORMAT, FREQFORMAT)
%   creates a .SNP, .YNP, .ZNP, .HNP or .AMP file using information from
%   data object H, returns STATUS = True if successful and False otherwise.
%
%   H is the RFDATA.DATA object that contains sufficient information to
%   write a .SNP, .YNP, .ZNP, .HNP or .AMP file. FILENAME is a string,
%   representing the name of the file to be written. DATAFORMAT is a string
%   that can only be 'RI','MA' or 'DB'. FUNIT is a string, representing the
%   frequency units, it can only be 'GHz','MHz','KHz' or 'Hz'. PRINTFORMAT
%   is a string that specifies the precision of the network and noise
%   parameters. FREQFORMAT is a string that specifies the precision of the
%   frequency. See the list of allowed precisions under FPRINTF.
%
%   See also RFDATA, RFCKT

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:28 $

error(nargchk(1,6,nargin))

status = false;
if ~islegalsparam(h)
    error('Data object has illegal network parameters.')
end

% Assign local variables.
nPort = getnport(h);
OrigType = 'S_PARAMETERS';
WriteType = 'S_PARAMETERS'; %default type is S
Freq = get(h, 'Freq');
NetworkParameters = get(h, 'S_Parameters');
Z0 = get(h, 'Z0');
isAMP = false;

NoiseFreq = [];
NoiseParameters = [];
refobj = get(h, 'Reference');
if isa(refobj, 'rfdata.reference') 
    noisedata = get(refobj, 'NoiseData');
    if isa(noisedata, 'rfdata.noise')
        NoiseFreq = get(noisedata, 'Freq');
        NoiseParameters = getnoisedata(noisedata);
    end
end
% DeviceName = get(h, 'DeviceName');

OVERWRITE_CHECK = 1; % If 1, then if file exists, prompt user to confirm overwriting.
if nargin == 1 || isempty(strtok(filename))
    [filename, pathname] = uiputfile('*.*P', 'Save as');
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end
    filename = fullfile(pathname, filename);
    OVERWRITE_CHECK = 0;
end

if ~ischar(filename)
    error('Filename must be a string.')
end

% Get filename extension.
filename = deblank(filename);
file_ext = fliplr(strtok(fliplr(filename), '.'));
% Check if the filename extension contains the correct number of ports and
% the parameter type.
if ~isempty(file_ext) && ~isempty(str2num(file_ext(2:end-1)))...
        && upper(file_ext(end))=='P' && ~isempty(strfind('SYZH', upper(file_ext(1))))
    WriteType = [upper(file_ext(1)),'_PARAMETERS'];
    if str2num(file_ext(2:end-1)) ~= nPort
        error(['The number of ports in the filename extension does not match the number of ports ', ...
                num2str(nPort), ' to be written to the file.'])
    end
    if isemptysparam(h)
        error(['S_Parameters of data object cannot be empty!']);
    end
elseif ~isempty(file_ext) && strcmpi(file_ext,'amp')
    isAMP = true;
    if nPort ~= 2
        error('AMP file only allows 2-port network parameters.')
    end
else
    % Append the filename extension if it does not have one.    
    filename = [filename, '.', upper(WriteType(1)), num2str(nPort), 'P'];
    OVERWRITE_CHECK = 1;
    if isemptysparam(h)
        error(['S_Parameters of data object cannot be empty!']);
    end
end

if OVERWRITE_CHECK
    [tempfile, temppath] = strtok(fliplr(filename), filesep);
    tempfile = fliplr(tempfile);
    temppath = fliplr(temppath);
    % If the path to the file is not included in the filename, then check
    % if the file exists in the current directory.
    if isempty(temppath)
        if exist([pwd,filesep,tempfile], 'file')
            button = questdlg([pwd, filesep, tempfile, ' already exists. Do you want to replace it?'], ...
                'Continue Operation','Yes','No','Yes');
            if strcmp(button,'No')
                status = false;
                return;
            end
        end
    else
        if exist(filename, 'file')
            button = questdlg([filename, ' already exists. Do you want to replace it?'], ...
                'Continue Operation','Yes','No','Yes');
            if strcmp(button,'No')
                status = false;
                return;
            end
        end
    end  
end

if nargin < 3 || isempty(dataformat)
    dataformat = 'RI';
end

% Check if the units of frequency are missing or empty.
if nargin < 4 || isempty(funit)
    % Decide the unit of frequency.
    if median(Freq) >= 1e9
        funit = 'GHz';
    elseif median(Freq) >= 1e6
        funit = 'MHz';
    elseif median(Freq) >= 1e3
        funit = 'KHz';
    else
        funit = 'Hz';
    end
end
switch upper(funit)
    case 'GHZ'
        Freq = Freq./1e9;
    case 'MHZ'
        Freq = Freq./1e6;
    case 'KHZ'
        Freq = Freq./1e3;
    case 'HZ'
        Freq = Freq;
    otherwise
        error('Frequency unit must be GHz,MHz,KHz or Hz.')
end
funit = [upper(funit(1:end-1)), lower(funit(end))];

% Check if printformat is missing or empty.
if nargin < 5 || isempty(printformat)
    printformat = '%22.10f';
elseif ~ischar(printformat) || printformat(1)~='%'
    error('PRINTFORMAT must be a string starting with "%".')
end

% Check if freqformat is missing or empty.
if nargin < 6 || isempty(freqformat)
    freqformat = '%-22.10f';
elseif ~ischar(freqformat) || freqformat(1)~='%'
    error('FREQFORMAT must be a string starting with "%".')
end

% AMP file does not require network parameters, need to check the existance
% of s_parameters first.
if ~isemptysparam(h)
    % Calculate the number of columns.
    Col = 2*nPort*nPort + 1;
    netdata = zeros(length(Freq), Col); % Preallocate netdata.
    netdata(:,1) = Freq(:);
    
    % Find out the type of the network parameter.
    % WriteType = upper(WriteType);
    NetworkParameters = convertmatrix(h, NetworkParameters, OrigType, ...
        WriteType, Z0, Z0);
    typetitle = [WriteType(1),'-Parameters'];
    
    
    % Generate 2D data matrix (netdata) based on NetworkParameters and its
    % format.
    % tempC will contain complex network parameters in 2D format.
    tempC = zeros(size(NetworkParameters,3), nPort*nPort);
    if nPort <= 2
        for p = 1:size(NetworkParameters,3)
            tempC(p, :) = reshape(NetworkParameters(:,:,p), 1, []);
        end
    else
        for p = 1:size(NetworkParameters,3)
            tempC(p, :) = reshape(NetworkParameters(:,:,p).', 1, []);
        end
    end
    
    switch upper(dataformat)
        case 'RI'
            netdata(:, 2:2:end) = real(tempC);
            netdata(:, 3:2:end) = imag(tempC);
        case 'MA'
            netdata(:, 2:2:end) = abs(tempC);
            netdata(:, 3:2:end) = angle(tempC)*180/pi;
        case 'DB'
            netdata(:, 2:2:end) = 20*log10(abs(tempC) + eps);
            netdata(:, 3:2:end) = angle(tempC)*180/pi;
        otherwise
            error('The data format must be "RI", "MA" or "DB".');
    end
    
    % Also generate the column headers for netdata.
    % colheader is a cell array that contains strings such as 'reZ11', 'magY21', etc.
    switch nPort
        case 2 
            switch upper(dataformat)
                case 'RI'
                    colheader = {['re',WriteType(1),'11']; ['im',WriteType(1),'11'];...
                            ['re',WriteType(1),'21']; ['im',WriteType(1),'21'];...
                            ['re',WriteType(1),'12']; ['im',WriteType(1),'12'];...
                            ['re',WriteType(1),'22']; ['im',WriteType(1),'22']};
                case 'MA'
                    colheader = {['mag',WriteType(1),'11']; ['ang',WriteType(1),'11'];...
                            ['mag',WriteType(1),'21']; ['ang',WriteType(1),'21'];...
                            ['mag',WriteType(1),'12']; ['ang',WriteType(1),'12'];...
                            ['mag',WriteType(1),'22']; ['ang',WriteType(1),'22']};
                case 'DB'
                    colheader = {['db',WriteType(1),'11']; ['ang',WriteType(1),'11'];...
                            ['db',WriteType(1),'21']; ['ang',WriteType(1),'21'];...
                            ['db',WriteType(1),'12']; ['ang',WriteType(1),'12'];...
                            ['db',WriteType(1),'22']; ['ang',WriteType(1),'22']};
            end
            
        otherwise
            colheader = cell(2*nPort, nPort);
            switch upper(dataformat)
                case 'RI'
                    for p = 1:nPort
                        for k = 1:nPort
                            if nPort >= 10
                                colheader{2*k-1,p}= ['re',WriteType(1),num2str(p),',',num2str(k)];
                                colheader{2*k,p}= ['im',WriteType(1),num2str(p),',',num2str(k)];
                            else
                                colheader{2*k-1,p}= ['re',WriteType(1),num2str(p),num2str(k)];
                                colheader{2*k,p}= ['im',WriteType(1),num2str(p),num2str(k)];
                            end
                        end
                    end
                case 'MA'
                    for p = 1:nPort
                        for k = 1:nPort
                            if nPort >= 10
                                colheader{2*k-1, p} = ['mag', WriteType(1), num2str(p),',',num2str(k)];
                                colheader{2*k, p} = ['ang', WriteType(1), num2str(p),',',num2str(k)];
                            else
                                colheader{2*k-1, p} = ['mag', WriteType(1), num2str(p), num2str(k)];
                                colheader{2*k, p} = ['ang', WriteType(1), num2str(p), num2str(k)];
                            end
                        end
                    end
                case 'DB'
                    for p = 1:nPort
                        for k = 1:nPort
                            if nPort >= 10
                                colheader{2*k-1, p} = ['db', WriteType(1), num2str(p), ',',num2str(k)];
                                colheader{2*k, p} = ['ang', WriteType(1), num2str(p), ',',num2str(k)];
                            else
                                colheader{2*k-1, p} = ['db', WriteType(1), num2str(p),num2str(k)];
                                colheader{2*k, p} = ['ang', WriteType(1), num2str(p),num2str(k)];
                            end
                        end
                    end
            end
    end
end

% create a cell arrary to store powerdata
if ~isemptypower(h, isAMP)
    powercell = cell(1, length(h.Reference.PowerData.Freq));
    for k = 1:length(h.Reference.PowerData.Freq)
        % each cell contains an N by 3 matrix: [Pin, Pout, Phase]
        powercell{1, k} = [w2dbm(h.Reference.PowerData.Pin{k}'),...
                w2dbm(h.Reference.PowerData.Pout{k}'),...
                h.Reference.PowerData.Phase{k}'];
    end
end

% Open file, write comments and column headers.
fid = fopen(filename, 'wt');
% Throw an error when fid is -1
if fid == -1
    error(['Fail to create ', filename,'.', sprintf('\n'),...
        'You may not have write permission to the specified directory.'])  
end
% File header for AMP file
if isAMP
    fprintf(fid, '* %s: %s\n', filename, ...
        'the data of an amplifier in .AMP format of the MathWorks');
end

% Write network parameters section if s_parameters exist
if ~isemptysparam(h)
    if ~isAMP % SNP file:network parameters section header
        fprintf(fid, '# %s %s %s %s %s\n', funit, WriteType(1), upper(dataformat), 'R', num2str(Z0)); % First line
        fprintf(fid, '! %s data\n', typetitle); % Second line
        fprintf(fid, '! Freq'); % Third line that contains the column headers
        % Write column headers that show how numerical data is printed.
        switch nPort
            case {1, 2}
                headerformat = [repmat('%8s',1,2*nPort*nPort), '\n']; 
            case {3, 4}
                headerformat = [repmat([repmat('%8s',1,2*nPort), '\n!', blanks(5)], 1, nPort)]; 
                headerformat = [headerformat, '\n'];
            otherwise
                % If nPort is larger than 4, each line contains 4 network parameters
                headerformat = [repmat([repmat('%12s',1,8), '\n!', blanks(5)], 1, floor(2*nPort*nPort/8)),...
                        repmat('%12s',1,mod(2*nPort*nPort,8))];
                headerformat = [headerformat, '\n'];
        end
        fprintf(fid, headerformat, colheader{:}); 
    else % AMP file:network parameters section header
        fprintf(fid, '%s %s %s %s\n', WriteType(1), upper(dataformat), 'R', num2str(Z0)); % First line
        fprintf(fid, '%s %s\n', 'FREQ', funit); % Second line
        fprintf(fid, '* Freq'); % Third line that contains the column headers
        % Write column headers that show how numerical data is printed.
        % Amplifier must be 2-port
        headerformat = [repmat('%8s',1,2*nPort*nPort), '\n']; 
        fprintf(fid, headerformat, colheader{:}); 
    end
    
    % Network parameters section data:write frequency and netdata.
    netformat = [' ', printformat];
    switch nPort
        case {1, 2}
            totformat = [freqformat, repmat(netformat, 1, Col-1), '\n'];
        case{3, 4}
            % Find the appropriate length of spaces before the second data line.
            tempL = floor(abs(str2num(freqformat(2:end-1))));
            totformat = [freqformat, repmat([repmat(netformat,1,2*nPort), '\n', blanks(tempL)], 1, nPort)];
            totformat = deblank(totformat);
        otherwise 
            % If nPort is larger than 4, each line contains 4 network parameters
            tempL = floor(abs(str2num(freqformat(2:end-1))));
            totformat = [freqformat, repmat([repmat(netformat,1,8), '\n', blanks(tempL)], 1, floor(2*nPort*nPort/8)),...
                    repmat(netformat,1,mod(2*nPort*nPort,8))];
            totformat = deblank(totformat);
            if mod(2*nPort*nPort,8) ~= 0
                totformat = [totformat, '\n'];
            end
    end
    fprintf(fid, totformat, netdata');
end

% Check if NoiseFreq and NoiseParameters are both nonempty, if NoiseFreq
% is a vector, if NoiseParameters is 2D, if the number of rows in NoiseParameters
% equals the number of noise frequency points, if it is a two-port network.
[s1, s2, s3] = size(NoiseParameters);
[row, col] = size(squeeze(NoiseFreq));
if ~isempty(NoiseFreq) && ~isempty(NoiseParameters) && ...
        (s3 == 1) && (row == 1 || col == 1)  && ...
        (s1 == length(NoiseFreq)) && (nPort == 2)
    if isemptysparam(h) && isemptypower(h, isAMP)
        fclose(fid);
        error(['A .amp file cannot contain only noise parameters.']); 
    end
    % Write NoiseFreq and noisedata if they exist
    if ~isempty(NoiseFreq)
        switch upper(funit)
            case 'GHZ'
                NoiseFreq  = NoiseFreq ./1e9;
            case 'MHZ'
                NoiseFreq  = NoiseFreq ./1e6;
            case 'KHZ'
                NoiseFreq  = NoiseFreq ./1e3;
        end
        if ~isAMP % SNP file
            fprintf(fid, '! Noise Parameters\n'); %Add one comment line
            fprintf(fid, '! %s %s %s %s %s\n', ['Freq(',funit,')'], ...
                'Fmin(dB)','GammmaOpt(MA:Mag)', 'GammmaOpt(MA:Ang)',...
                'RN/Zo'); % second line:comment
        else % AMP file
            % header for noise data
            fprintf(fid, '\n%s %s\n', 'NOI', 'RN'); % first line
            fprintf(fid, '%s %s\n', 'FREQ', funit); % second line
            fprintf(fid, '* %s %s %s %s %s\n', 'Freq', 'Fmin(dB)',...
                'GammmaOpt(MA:Mag)', 'GammmaOpt(MA:Ang)',...
                'RN/Zo'); % third line:comment
        end
        noisedata = [NoiseFreq(:), NoiseParameters];
        netformat = [' ', printformat];
        netformat = [freqformat, repmat(netformat, 1, 4), '\n'];
        fprintf(fid, netformat, noisedata');
    end
elseif ~isempty(NoiseFreq) || ~isempty(NoiseParameters)
    warning('Incorrect noise data, not written to the file.')
end

% For amp file, write power data to file
if ~isemptypower(h, isAMP)
    for k = 1:length(powercell)
        switch upper(funit)
            case 'GHZ'
                PowerFreq = h.Reference.PowerData.Freq(k)/1e9;
            case 'MHZ'
                PowerFreq = h.Reference.PowerData.Freq(k)/1e6;
            case 'KHZ'
                PowerFreq = h.Reference.PowerData.Freq(k)/1e3;
            otherwise
                PowerFreq = h.Reference.PowerData.Freq(k);
        end
        % header for power data header
        fprintf(fid, '\n%s %s\n', 'POUT', 'dBm'); % first line
        fprintf(fid, ['%s %s %s ',freqformat,'%s\n'], 'PIN', 'dBm',...
            'FREQ =', PowerFreq, funit); % second line
        fprintf(fid, '* %s %s %s\n', 'Pin', 'Pout',...
            'Phase(degrees)'); % third line:comment
        % write power data
        netformat = [printformat, ' '];
        netformat = [repmat(netformat, 1, 3), '\n'];
        fprintf(fid, netformat, powercell{k}');
    end
end

% close the data file
fclose(fid);
status = true;

%--------------------------------------------------------------------------
function y = isemptysparam(h)
% Check the existance of S_Parameters
y = true;
if ~isempty(get(h, 'S_Parameters'))
    y = false;
end

%--------------------------------------------------------------------------
function result = islegalsparam(h)
%ISLEGALSPARAM Check for s_parameters in an RFDATA.DATA object.
%   RESULT = ISLEGALSPARAM(H) returns True if H is an RFDATA.DATA object
%   that contains legal s_parameters and False otherwise.

error(nargchk(1,1,nargin))

% Declare local variables.
nPort = getnport(h);
Freq = get(h, 'Freq');
S_Parameters = get(h, 'S_Parameters');

% Set the default result to true.
result = true;

% Allow empty s_parameters
if isemptysparam(h)
    return
end

if isempty(Freq) || ~isreal(Freq) 
    result = false;
    return
end
[row, col] = size(squeeze(Freq));
% Check if Freq is a vector
if row ~= 1 && col ~= 1
    result = false;
    return
end

% Check S_Parameters
if ~isnumeric(S_Parameters)
    result = false;
    return
else
    [s1 s2 s3 s4] = size(S_Parameters);
    if s4 ~= 1 % S_Parameters must be 3D
        result = false;
        return
    elseif s1 ~= s2 % The first and second dimension must be equal
        result = false;
        return
    elseif s1 ~= nPort % The first dimension must equal the number of ports
        result = false;
        return
    elseif s3 ~= length(Freq) % The third dimension must equal the number of frequency points
        result = false;
        return
    end
end

%--------------------------------------------------------------------------
function noisedata = getnoisedata(noise);
fmin = get(noise, 'FMIN');
gammaopt = get(noise, 'GAMMAOPT');
rn = get(noise, 'RN');
if ~(length(fmin) == length(gammaopt) && length(fmin) == length(rn))
    error('Data object has illegal noise parameters!')
end    
noisedata(:, 1) = 10.*log10(fmin);
noisedata(:, 2) = abs(gammaopt);
noisedata(:, 3) = unwrap(angle(gammaopt)) * 180 / pi;
noisedata(:, 4) = rn;

%--------------------------------------------------------------------------
function y = w2dbm(x)
% Watt to dBM conversion
y = 10*log10(1000*x);

%--------------------------------------------------------------------------
function y = isemptypower(h, isAMP)
% Check the existance of PowerData when fileformat is AMP
y = true;
if isAMP
    if ~isempty(h.Reference) && ~isempty(h.Reference.PowerData)...
            && ~isempty(h.Reference.PowerData.Freq)
        y = false;
    end
end
