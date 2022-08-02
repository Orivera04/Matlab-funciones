@audio : An object to read and write large MS Windows .wav files.

Digital audio, when directly read to the Matlab Workspace, occupies
a lot of memory. @audio makes it easy to excess header information
and data portions of a .wav by only loading data on demand.

To Install,
1. cd to a directory somewhere on your matlabpath 
   (e.g. where you put your objects)
2  place the files into an '@audio' directory
   (e.g. tar xvf audio.tar)

Example:
A typical session using @audio would look like

>> % Reading
>> au = audio('sonny_rollins1.wav')

sonny_rollins1.wav

Data Format        : PCM      
Size (on Disk)     : 1723 KBytes
Size (in Workspace): 6891 KBytes
Length             : 441000 Samples
Time               : 10.00 Seconds
Fs                 : 44100 Hz
Channels           : 2
Block Alignment    : 4
Bits/Sample        : 16

>> Fs = au.Fs; % Get the sampling Frequency
>> Formatstruct = au.Format; % Get the structure containing format information
>> y = au(0, 1024); % Get the first 1024 samples 
>> whos
  Name      Size         Bytes  Class

  Formatstruct       1x1           1056  struct array
  Fs        1x1              8  double array
  au        1x1           1494  audio object
  y      1024x2          16384  double array

>> y = au(40000, 1024); % Get the next 1024 samples starting from 40001'th

>> % Writing
>> x = some_sound;
>> au2 = audio(x, 'some_sound.wav');

Enjoy,

Ps: Tested only on MATLAB Version 5.2.0.3084 on LNX86

Ali Taylan Cemgil,
SNN - University of Nijmegen, 
Department of Medical Physics and Biophysics
http:\\www.mbfys.kun.nl/~cemgil
cemgil@mbfys.kun.nl 
