function wavappend(y,wavfile)

%This file appends a wave file with the data y
%Of course, the sampling rate, bit rate and channels have to be the same

%Suresh E Joel, June 19,2002

switch(nargin)
case 0
   error('Too few input arguements for wavappend');
case 1
   [filename pathname]=uiputfile('*.*','Save as');
   wavfile=strcat(pathname,filename);
case 2
   %do nothing
end

%Check if y is valid data
if(size(y,1)>2 | size(y,2)<2),
   error('Not valid data');
end

tempfile=strcat(wavfile(1:length(wavfile)-4),'temp.wav');

%Make temporary copy of file
fcopy(wavfile,tempfile);

%Copy temp file to original except for the sizes
fidout=fopen(wavfile,'w');
fidin=fopen(tempfile,'r');
%Copy string 'RIFF'
for i=1:4
   fwrite(fidout,fread(fidin,1,'uchar'),'uchar');
end

fseek(fidin,34,'bof');
nbits=fread(fidin,1,'ushort');
fseek(fidin,4,'bof');
nbytes=ceil(nbits/8);

fmt.filename=wavfile;
fmt.nBitsPerSample=nbits;
fmt.wFormatTag=1;


%change size to 
old_total_bytes=fread(fidin,1,'int')-36;
new_total_bytes=(length(y)*nbytes)+old_total_bytes;
fwrite(fidout,new_total_bytes+36,'int');

for i=1:32
   fwrite(fidout,fread(fidin,1,'uchar'),'uchar');
end

fwrite(fidout,new_total_bytes,'int');
fseek(fidin,44,'bof');
%while(~feof(fidin)),
for i=1:nbytes*old_total_bytes,
   fwrite(fidout,fread(fidin,1,'uchar'),'uchar');
end
fclose(fidin);

%Delete temporary wave file
s=sprintf('%s\t%s','!del',tempfile);
eval(s);

write_wavedat(fidout,fmt,y);
fclose(fidout);

% -----------------------------------------------------------------------
function y = PCM_Quantize(x, fmt)
% PCM_Quantize:
%   Scale and quantize input data, from [-1, +1] range to
%   either an 8- or 16-bit data range.

% Clip data to normalized range [-1,+1]:
ClipMsg  = ['Data clipped during write to file:' fmt.filename];
ClipWarn = 0;

% Determine slope (m) and bias (b) for data scaling:
nbits = fmt.nBitsPerSample;
m = 2.^(nbits-1);

switch nbits
case 8,
   b=128;
case 16,
   b=0;
otherwise,
   error('Invalid number of bits specified - must be 8 or 16.');
end

y = round(m .* x + b);

% Determine quantized data limits, based on the
% presumed input data limits of [-1, +1]:
ylim = [-1 +1];
qlim = m * ylim + b;
qlim(2) = qlim(2)-1;

% Clip data to quantizer limits:
i = find(y < qlim(1));
if ~isempty(i),
   warning(ClipMsg); ClipWarn=1;
   y(i) = qlim(1);
end

i = find(y > qlim(2));
if ~isempty(i),
   if ~ClipWarn, warning(ClipMsg); end
   y(i) = qlim(2);
end

return


% -----------------------------------------------------------------------
function err = write_wavedat(fid,fmt,data)
% WRITE_WAVEDAT: Write WAVE data chunk
%   Assumes fid points to the wave-data chunk
%   Requires <wave-format> structure to be passed.

err = '';

if fmt.wFormatTag==1,
   % PCM Format
   
   data = PCM_Quantize(data, fmt);
   
   switch fmt.nBitsPerSample
   case 8,
      dtype='uchar'; % unsigned 8-bit
   case 16,
      dtype='short'; % signed 16-bit
   otherwise,
      err = 'Invalid number of bits specified.'; return;
   end
   
   % Write data, one row at a time (one sample from each channel):
   [samples,channels] = size(data);
   total_samples = samples*channels;
   
   if (fwrite(fid, reshape(data',total_samples,1), dtype) ~= total_samples),
      err = 'Failed to write PCM data samples.'; return;
   end
   
   % Determine # bytes/sample - format requires rounding
   %  to next integer number of bytes:
   BytesPerSample = ceil(fmt.nBitsPerSample/8);
   
   % Determine if a pad-byte must be appended to data chunk:
   if rem(total_samples*BytesPerSample, 2) ~= 0,
      fwrite(fid,0,'uchar');
   end
   
else
  % Unknown wave-format for data.
  err = 'Unsupported data format.';
end

return
