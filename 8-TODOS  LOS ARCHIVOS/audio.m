function [au] = audio(varargin)
% AUDIO/AUDIO		Registers a MS Windows .wav file as an audio object 
%
% Digital audio, when directly read to the Matlab Workspace, occupies
% a lot of memory. @audio makes it easy to excess header information
% and data portions of a .wav by only loading data on demand.
% 
%  AU = AUDIO(WAVFILE)
%       AUDIO(Y, <WAVFILE>, <FS>, <BITS>, <SCALE>)
% 
% Inputs :
%    WAVEFILE : Name of the target file. If no extension is specified
%               '.wav' is padded automatically,
%    Y        : A numeric array containig sound samples. 
%    FS       : Sampling Frequency in Hz,
%    BITS     : # of bits per sample (1<= bits <= 16). The .wav file is
%		saved as 8 or 16 bits/sample.
%    SCALE    : Multiplication factor before uniform quantization.
%               The default value is computed from Y as such to minimize the quantization distortion.
% 
% Outputs :
%    AU : An Audio Object
% 
% Usage Example : au = audio('sonny.wav');
%                 au = audio(x, 'sil.wav');
%                 au = audio(x, 'sil.wav', 44100, 16, 1); % Write exact numerical values 
%                 au = audio(x, 'sil.wav', 11025, 12);  % Use only 12 bits
% 
% Note     : For converting other sound file formats to .wav, 
%            you can download the SOX converter package by Chris Bagwell
%            from http://home.sprynet.com/sprynet/cbagwell/projects.html. 
%            It supports a lot of popular sound file formats.
%
%
% See also : what audio, @audio/Readme.txt

% Uses :

% Change History :
% Date		Time		Prog	Note
% 11-Jan-1999	 3:07 PM	ATC	Created under MATLAB 5.2.0.3084

% ATC = Ali Taylan Cemgil,
% SNN - University of Nijmegen, Department of Medical Physics and Biophysics
% e-mail : cemgil@mbfys.kun.nl 

au = struct(...
    'Filename',[],...
    'Format',[],...
    'fpp',[]...
);

if nargin<1, error('Please check arguments to the constructor..'); end;
%% Maybe add later :: au = audio % Recording..');

switch class(varargin{1}),
  case 'audio',
    au = varargin{1};
    return;
  case 'char',
    au.Filename = varargin{1};
    
    fid = fopen(au.Filename,'rb','l');
    if fid == -1, error(['Error while opening file ' au.Filename]); end; 

    [au.Format au.fpp] = wavGetFormat(fid);
    
    fclose(fid);
  case 'double',
    x = varargin{1};
    [m n] = size(x);
    
    % make x a long row matrix
    if m>n, x = x'; [m n] = size(x); end;

    if nargin<2, au.Filename = [tempname '.wav']; else au.Filename = varargin{2}; end;
    if nargin<3, Fs = 44100; else Fs=varargin{3}; end;
    if nargin<4, bits = 16; else bits=varargin{4}; end;
    if nargin<5, scale = (2^(bits-1)-1)/max(abs(x(:))); else scale=varargin{5}; end;

    if bits>16 | bits<1, error('bits must be <= 16 or > 0'); end;
    if bits>8, bits = 16; else bits = 8; end;
    
    if isempty(findstr(au.Filename,'.')), au.Filename=[au.Filename,'.wav']; end;
    
    Format = empty_Format;

    Format.DataFormat = 1; % PCM
    Format.Fs = Fs;
    Format.Channel = m;
    Format.Length = n;
    Format.BitsPerSample = bits;
    Format.SizeInBytes = Format.Channel * Format.Length * Format.BitsPerSample/8;
    Format.AverageBytes = Format.Fs * Format.Channel * Format.BitsPerSample/8;
    Format.BlockAlignment = Format.Channel * Format.BitsPerSample/8;

    au.Format = Format;
    
    fid =  fopen(au.Filename,'wb','l');
    if fid == -1, error(['Error while creating file ' au.Filename]); end; 
    
    au.fpp = wavPutFormat(fid, Format);

    switch Format.BitsPerSample,
      case 8,
	fwrite(fid, round(x(:).*scale) + 128, 'uchar');
      case 16,
	  fwrite(fid, round(x(:).*scale), 'int16');
      otherwise,
	error('Only 8 or 16 bits per sample');
    end;
    
    fclose(fid);
    
  otherwise,
end;
  
au = class(au,'audio');

% ------------------------------

function [Format] = empty_Format

Format = struct(...
    'DataFormat', [],...   % 'PCM','<Unknown>','<Unknown>','<Unknown>','<Unknown>','CCITT-A','CCITT-mu'
    'Fs',[],...
    'Channel',[],...
    'Length',[],...
    'SizeInBytes',[],...
    'BitsPerSample',[],...
    'AverageBytes',[],...
    'BlockAlignment',[]...
);

% ------------------------------

function [Format, fpp] = wavGetFormat(fid)
% Format Structure
% FPP : File Position Pointer, for later use by read operations

Format = empty_Format;

% Some Format Checks must come here...
% read riff chunk
header=fread(fid,4,'uchar');
header=fread(fid,1,'ulong');
header=fread(fid,4,'uchar');

% read format sub-chunk
header=fread(fid,4,'uchar');
header=fread(fid,1,'ulong');

Format.DataFormat = fread(fid,1,'ushort');                
Format.Channel = fread(fid,1,'ushort');         
Format.Fs = fread(fid,1,'ulong');               

Format.AverageBytes = fread(fid,1,'ulong');
Format.BlockAlignment = fread(fid,1,'ushort');
Format.BitsPerSample = fread(fid,1,'ushort');   

% read data sub-chunck
header=fread(fid,4,'uchar');
Format.SizeInBytes = fread(fid,1,'ulong');

Format.Length = Format.SizeInBytes * 8 / (Format.BitsPerSample * Format.Channel);

fpp = ftell(fid);




% ----------------

function [fpp] = wavPutFormat(fid, Format)
% FPP : File Position Pointer, for later use by read operations

riffsize= 36 + Format.SizeInBytes;;
% write riff chunk
fwrite(fid,'RIFF','uchar');
fwrite(fid,riffsize,'ulong');
fwrite(fid,'WAVE','uchar');

% write format sub-chunk
fwrite(fid,'fmt ','uchar');
fwrite(fid,16,'ulong');

fwrite(fid, Format.DataFormat, 'ushort'); 
fwrite(fid, Format.Channel, 'ushort');    
fwrite(fid, Format.Fs, 'ulong');    % samples per second
fwrite(fid, Format.AverageBytes, 'ulong');    % average bytes per second
fwrite(fid, Format.BlockAlignment, 'ushort');    
fwrite(fid, Format.BitsPerSample, 'ushort'); 


% write data sub-chunck
fwrite(fid, 'data', 'uchar');
fwrite(fid, Format.SizeInBytes, 'ulong');

fpp = ftell(fid);


