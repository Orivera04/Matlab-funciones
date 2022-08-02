% SND_MULTI.DLL: Record and/or play sound via multiple audio devices
% 
%      Y = SND_MULTI([1 NCH_IN FS NBITS],X,NLOOPS)
%      plays the matrix $X via audio output devices assuming each row of $X
%      represents data for one audio output channel (max. 64). Every two
%      rows will be played on one stereo output device. If the number of
%      rows is odd the last row will be played on both outputs of the last
%      device (mono mode). The audio samples in $X are expected to be in the
%      range [-1,+1]. Data outside this range will be clipped. Towards the
%      LSB the data will be truncated to the specified bits per sample
%      ($NBITS). The data in $X will be played in a $NLOOP times loop. 
%      Ensure the matrix is of sufficient length. The sound driver might 
%      have difficulties to loop blocks which are too short. This is system
%      dependend. (A block of one second should be looped glitch free.)
%      Synchronously samples from audio input devices are recorded into 
%      matrix Y, each row representing one recording channel (up t0 16). 
%      The full dynamic range is again [-1,+1]. 
%      The format vector [1 NCH_IN FS NBITS] always starts with a one,
%      indicating that the audio data are in PCM format (WAVE_FORMAT_PCM).
%      $NCH_IN determines the number of recording channels (up to 16).
%      (The number of output channels depends on the number of rows in $X!)
%      $FS is the sampling frequency and $NBITS is the number of bits per
%      sample. Both are valid for input and output ($NBIT may be 8 16 24
%      or 32 if supported by the audio devices in use).
%      SND_MULTI opens a small window. Closing the window causes premature
%      termination of SND_MULTI.DLL (except if NCH_IN is zero. See below!)
%
%      Y = SND_MULTI([1 NCH_IN FS NBITS],X)
%      Same as above, but no looping (assumes $NLOOPS = 1).
%
%      SND_MULTI([1 NCH_IN FS NBITS],X,NLOOPS)
%      will do sound output only.
%
%      Y = SND_MULTI([1 NCH_IN FS NBITS],ones(0,10000),NLOOPS) 
%      If $X has zero rows (e.g. created by "ones(0,10000)") there will be 
%      no sound output, but the length of $X and $NLOOPS) still determine the
%      number of samples to record.
%
%      RTN = SND_MULTI([1 NCH_IN FS NBITS],X,NLOOPS,WAVEFILE)
%      Recorded data are stored in a file named $WAVEFILE. $RTN is 0
%      if all data are recorded (Not premature terminated). Otherwise $RTN 
%      contains the total number of sampeles recorded (sum in all channels).
%      The maximum number of recording channels ($NCH_IN) when recording into
%      a file is two!
%
%      RESOURCES = SND_MULTI([1 0 FS NBITS],X,NLOOPS)
%      Setting $NCH_IN to zero will force the function to return the control
%      to Matlab after having started sound output. The left hand parameter
%      $RESOURCES will contain the handles to the resources opened.
%      There is no small window opened to terminate sound output premature.
%      Use SND_STOP(RESOURCES) to stop sound output and free the resources.
%      Caution! Failure to free an audio device unavailable. Termination of 
%      Matlab will be necessary to free the device.
%
%      SND_MULTI is written for soundcards by Echo. The driver of those
%      soundcard starts all audio channels (input and output) being in pause
%      mode sample synchronously and stops all channels if one channel is 
%      stopped or paused. This feature is used in SND_MULTI.DLL.
%      Other multichannel audio devices or multipe audio devices might not
%      start sample synchroneously, but might improve synchronisation by this
%      method.
%
%      BUGS: 1. The file opening routine seems to cause the Explorer windows
%               to uptdate what might cause a glitch.
%               => close the Windows Explorer!
%            2. If stopping the recording into a file premature by closing the
%               window the current buffer is not flushed to the file.
%            3. While recording into file, there is a delay before the sound 
%               input and output stops. Thus the file will be a few samples 
%               longer than expected. If $NLOOPS > 1 the begin of $X will be 
%               played again during the delay. 
%            4. specific to Echo driver vers. 4.x: The driver sets wrongly
%               the stereo/mono mode for all its stereo device to the 
%               mode specified last. That leads to mis-interpretation of  
%               the provided sound data in $X (E.g. when $NCH_IN is odd, it 
%		          plays the samples of the first stereo channels pairs 
%               interleaved as mono channel because the last device is set 
%               to mono mode.)
%               => specify only even number of channels when using Echo 
%               Soundcards with driver vers 4.x. Fill the unused row of
%               $X with zeros or discard the unused recorded channel
%               respectively.
%
%
%      See also SND_STOP, SND_READ
%
% SND_MULTI.DLL is part of the Matlab SND_PC toolbox (by Torsten Marquardt)
% and works with Windows 95/98/NT and Matlab 5.x only.