% SND_READ.DLL:  read  audio data from an audio file (".wav")
%
%    [Y FORMAT] = SND_READ(WAVEFILE, START, END, BUFFERLENGTH)
%    accumulates the audio data contained in the audio file (".wav")
%    specified by the string $WAVEFILE and located beetween the sample
%    positions $START and $END (incl). The averaged samples are return 
%    in matrix $Y which is $BUFFERLENGTH long. Each row of Y represents 
%    an audio channel (Caution! That is in contrast to Matlabs WAVEREAD,
%    which returns channels column wise)!). The samples in $Y are devided
%    by the number of averages, keeping the them in a range of [-1,+1]. 
%    The format information of the audio file will be stored in the four
%    element vector $FORMAT in the form: 
%          [1 nChannels SampleRate nBitsPerSample].    (see snd_multi.m)
%
%    Wave files with 8, 16, 24 and 32 bits per sample and up to two channels 
%    are supported.
%
%    [Y FORMAT] = SND_READ(WAVEFILE, START, END) reads the samples
%    between the sample positions specified in $START and $END (incl.).
%    No averaging is performed. 
%
%    [Y FORMAT] = SND_READ(WAVEFILE, START) reads the samples from
%    sample positions $START (inclusive) to the end of the file.
%    No averaging is performed. 
%
%    [Y FORMAT] = SND_READ(WAVEFILE) reads the whole file into Y.
%    No averaging is performed. 
%
%    [SIZE] = SND_READ(WAVEFILE) returns the total number of sampels 
%    contained in all channels of the audio file $WAVEFILE.
%    No data are returned.
%
%    See also SND_MULTI, WAVREAD, WAVWRITE, AUREAD, AUWRITE.
%
% SND_READ is part of the SND_PC toolbox (by Torsten Marquardt)
% and works with Windows 95/98/NT and Matlab 5.x only.