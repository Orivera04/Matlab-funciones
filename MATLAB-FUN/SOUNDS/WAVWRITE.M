function wavwrite(waveData,sRate,wavefile)
%WAVWRITE Saves Microsoft Windows 3.1 .WAV format sound files.
%   WAVWRITE(y,Fs,wavefile) saves a .WAV format file specified by "wavefile".
%
%   The input arguments for WAVWRITE are as follows:
%
%       y           The sampled data to save (8 bit max)
%       Fs          The rate at which the data was sampled
%       wavefile    A string containing the name of the .WAV file to create
%               
%   Note: WAVWRITE will create an 8-bit, simgle channel wave file. Non 8-bit
%   sample data will be truncated.
%
%   See also WAVREAD.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin~=3
	error('WAVWRITE needs three arguments!');
end
if isstr(waveData) %old symtax, reorder args
   tmp = waveData;
   waveData = wavefile;
   wavefile = sRate;
   sRate = tmp;
end

if findstr(wavefile,'.')==[]
	wavefile=[wavefile,'.wav'];
end

fid=fopen(wavefile,'wb','l');

if fid ~= -1
	[m,n]=size(waveData);
	nsamples=m*n;

	riffsize=36+nsamples;

	% write riff chunk
	fwrite(fid,'RIFF','uchar');
	fwrite(fid,riffsize,'ulong');
	fwrite(fid,'WAVE','uchar');

	% write format sub-chunk
	fwrite(fid,'fmt ','uchar');
	fwrite(fid,16,'ulong');

	fwrite(fid,1,'ushort');         % PCM format 
	fwrite(fid,1,'ushort');         % 1 channel
	fwrite(fid,sRate,'ulong');      % samples per second
	fwrite(fid,sRate,'ulong');      % average bytes per second
	fwrite(fid,1,'ushort');         % block alignment
	fwrite(fid,8,'ushort');         % bits per sample


	% write data sub-chunck
	fwrite(fid,'data','uchar');
	fwrite(fid,nsamples,'ulong');
	fwrite(fid,waveData,'uchar');

	if ((ceil(nsamples/2))~=(nsamples/2)) 
		fwrite(fid,0,'uchar');
	end;
	fclose(fid);
end;

if fid == -1
	error('Can''t open .WAV file for input!');
end;
