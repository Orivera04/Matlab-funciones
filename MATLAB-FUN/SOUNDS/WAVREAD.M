function [y,Fs,Format]=wavread(wavefile)
%WAVREAD  Load Microsoft Windows 3.1 .WAV format sound files.
%   [y]=WAVREAD(wavefile) loads a .WAV format file specified by "wavefile", 
%       returning the sampled data in variable "y". The .WAV extension 
%       in the filename is optional.
%
%   [y,Fs]=WAVREAD(wavefile) loads a .WAV format file specified by  
%       "wavefile", returning the sampled data in variable "y" and the 
%       sample rate in variable "Fs".
%   
%   [y,Fs,Format]=WAVREAD(wavefile) loads a .WAV format file specified by 
%       "wavefile",returning the sampled data in variable "y", the sample 
%       rate in variable "Fs", and the .WAV file format information in 
%       variable "Format". The format information is returned as a 6 element
%       vector with the following order:
%
%               Format(1)       Data format (always PCM) 
%               Format(2)       Number of channels
%               Format(3)       Sample Rate (Fs)
%               Format(4)       Average bytes per second (sampled)
%               Format(5)       Block alignment of data
%               Format(6)       Bits per sample
%
%   Note: WAVREAD currently supports only 8-bit single channel data.
%
%   See also WAVWRITE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin~=1
	error('WAVREAD takes one argument, which is the name of the .WAV file');
end

if findstr(wavefile,'.')==[]
	wavefile=[wavefile,'.wav'];
end

fid=fopen(wavefile,'rb','l');
if fid ~= -1 
	% read riff chunk
	header=fread(fid,4,'uchar');
	header=fread(fid,1,'ulong');
	header=fread(fid,4,'uchar');
	
	% read format sub-chunk
	header=fread(fid,4,'uchar');
	header=fread(fid,1,'ulong');
	
	Format(1)=fread(fid,1,'ushort');                % PCM format 
	Format(2)=fread(fid,1,'ushort');                % 1 channel
	Fs=fread(fid,1,'ulong');        % samples per second
	Format(3)=Fs;
	Format(4)=fread(fid,1,'ulong'); % average bytes per second
	Format(5)=fread(fid,1,'ushort');                % block alignment
	Format(6)=fread(fid,1,'ushort');                % bits per sample
	
	
	% read data sub-chunck
	header=fread(fid,4,'uchar');
	nsamples=fread(fid,1,'ulong');
	y=fread(fid,nsamples,'uchar');
	fclose(fid);
end     

if fid == -1
	error('Can''t open .WAV file for input!');
end;
