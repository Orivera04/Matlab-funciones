%WAVPLAY  Plays 16-bit audio vectors or WAV files under Win32
%
%   Please see the WAVPLAY.TXT file for full information.
%
%   Usage summary:
%
%   WAVPLAY(data)             -- Play 'data' at 44.1 kHz
%   WAVPLAY(data,Fs)          -- Play 'data' at 'Fs' Hz
%   WAVPLAY(data,Fs,attr)     -- Play 'data' at 'Fs' Hz with the attributes
%                                given in the scalar structure 'attr'
%   WAVPLAY('file.wav')       -- Play 'file.wav'
%   WAVPLAY('file.wav',attr)  -- Play 'file.wav' with the attributes
%                                given in the scalar structure 'attr'
%   WAVPLAY('WIN:Sound')      -- Play the Windows sound name 'Sound'
%   WAVPLAY('WIN:Sound',attr) -- Play the Windows sound name 'Sound'
%                                with the attributes in 'attr'
%   WAVPLAY(0)                -- Stop all sounds
%   WAVPLAY('stop')           -- Stop all sounds (equivalent to WAVPLAY(0))
%   retval = WAVPLAY(.....)   -- Return value is 1 for success, 0 for failure
%
%   'attr' is a structure with fields (* marks default):
%         async    = {0|1}       *0=synchronous, 1=asynchronous
%         channels = {0|1|2|3}   *0=normal, 1=force mono,
%                                 2=force stereo left, 3=force stereo right
%         scaling  = {'auto'|'none'|NNNN}   *'auto'=scale to maximum amplitude
%                                            'none'=use data as-is
%                                             NNNN =scale to amplitude NNNN
%         flow     = {'auto'|'try'}  *'auto'=stop any currently playing sound
%                                     'try' =fail if sound is currently playing
%         count    = {N|'loop'}      N=play sound N times (N=1 is the default)
%                               'loop'=play sound continuously (or set N=0)

% Author: Andrew Sterian <asterian@umich.edu>
% Version 1.0
% August 1997
%
% Copyright  (c)  1997 Andrew Sterian
% Copyright  (c)  1997 THE REGENTS OF THE UNIVERSITY OF MICHIGAN
% ALL RIGHTS RESERVED
% Please see WAVPLAY.TXT for full copyright information

