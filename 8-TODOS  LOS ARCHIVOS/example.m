% EXAMPLE is a example of using SND_MULTI (SND_PC toolbox) 
% This example plays a 201 Hz tone on the left channel 
% and a 200 Hz tone on the right channel. The duration will
% be 10 seconds ( because "sine(SAMPLE_RATE,[1001 1000])"
% returns 2 times 44100 matrix which will be played 10 times
% at a sample rate of 44.1 kHz). 
% Simoulanously the signal at the audio input device will be 
% recorded into the file 'c:\tmp\tst.wav'.
% Thereafter it palys a 201 Hz tone on both channels (mono)
% returns control to Matlab and plots the SND_MULTI help while
% playing the sound. After further 5 seconds ("pause(5)") the 
% sound output will be stopped by calling SND_STOP.DLL
%
% This EXAMPLE is part of the Snd_PC toolbox (by Torsten Marquardt).


SAMPLE_RATE = 44100;
BITS_PER_SAMPLE = 16;

n = snd_multi([1 1 SAMPLE_RATE BITS_PER_SAMPLE], ...
   [sine(SAMPLE_RATE,[1201]) sine(SAMPLE_RATE,[201])], 1,'c:\temp\tst.wav'),

s = snd_read('c:\temp\tst.wav'),
[f s] = snd_read('c:\temp\tst.wav');

m = snd_multi([1 1 SAMPLE_RATE BITS_PER_SAMPLE], ...
   [sine(SAMPLE_RATE,[1201]) sine(SAMPLE_RATE,[201])],2);

r = snd_multi([1 0 SAMPLE_RATE BITS_PER_SAMPLE], ...
   sine(SAMPLE_RATE,[1201 200]), 2);

help snd_multi
pause(5)

snd_stop(r)