function [y] = subsref(au, S)
% AUDIO/SUBSREF		Subscripted Reference to Audio Objects
% 
%   Y = AU(OFFSET, LENGTH)
%     = AU(:)
% 
% Inputs :
%    AU : Audio Object
%    OFFSET : Index of starting sample (First sample = 0)
%    LENGTH : Length of the chunk to be read into workspace (in Samples)
% 
% Outputs :
%    Y = Audio Data (Rows:Samples, Coloumns:Channels)
% 
% Usage Example : au(0 ,1024)
%		  au(:)
%		  au.Fs
% 
% 
% Note     :
% See also AUDIO

% Uses :

% Change History :
% Date		Time		Prog	Note
% 11-Jan-1999	 4:46 PM	ATC	Created under MATLAB 5.2.0.3084

% ATC = Ali Taylan Cemgil,
% SNN - University of Nijmegen, Department of Medical Physics and Biophysics
% e-mail : cemgil@mbfys.kun.nl 



switch S(1).type,
  case '()',
    N = length(S(1).subs);
    if N<1, error('see : help audio/subsref;'); end;
    
    if S(1).subs{1} == ':',
      offset = 0;
      len = au.Format.Length;
    else,
      offset = S(1).subs{1};
      if N>=2,  len = S(1).subs{2}; else len = 1; end;
    end;
  
    fid = fopen(au.Filename,'rb','l');
    if fid == -1, error(['Error while opening ' au.Filename]); end;
    
    fseek(fid, au.fpp, 'bof');
    
%    nsamples=nbyteforsamples/block;
    if (offset+len) > au.Format.Length, len = max(0,au.Format.Length-offset); end;

    switch au.Format.BitsPerSample,
      case 8,
	fseek(fid,offset*au.Format.Channel,'cof');
	y = fread(fid,[au.Format.Channel, len],'char')'-128;
      case 16,
	fseek(fid, offset*au.Format.Channel*2, 'cof');
	y = fread(fid,[au.Format.Channel, len], 'int16')';
      otherwise,
	error('Currently, only 8 or 16 bit files are supported..');
    end;
    fclose(fid);
  case '.',
    if isfield(struct(au),S(1).subs),
      y = getfield(struct(au), S(1).subs); 
    else,
      y = getfield(au.Format, S(1).subs); 
    end;
  otherwise,
    error('see : help audio/subsref;');
end;
