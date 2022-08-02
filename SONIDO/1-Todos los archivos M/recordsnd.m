%RECORDSND Record sound directly into a matrix.
%   Y=RECORDSOUND(SECONDS) records a monophonic sound for SECONDS
%   number of seconds at a sampling rate of 8192 Hz and at 8 bits
%   into the vector Y with range -1.0 <= y <= 1.0.
%
%   Y=RECORDSOUND(SECONDS,SAMPLERATE) records a sound with
%   sampling rate SAMPLERATE.
%
%   Y=RECORDSOUND(SECONDS,SAMPLERATE,NUMCHANNELS) where
%   NUMCHANNELS = 2 records a stereo sound.  Y is a N-by-2 matrix.
%
%   Y=RECORDSOUND(SECONDS,SAMPLERATE,NUMCHANNELS,BITS) where
%   BITS = 8 or 16, uses BITS bits/sample in recording.
%
%
%   The shareware version of RECORDSND for PC Windows Matlab 5
%   will only record for a second or less.
%   To receive the full synchronous and asynchronous versions
%   of RECORDSND, as well as free updates, please send your
%   email address and a check for $25 to the following address:
%     Daniel D. Lee
%     806 Morris Tpk. #3O2
%     Short Hills, NJ 07078
%
%   I also welcome any suggestions for improving RECORDSND.
%   Thanks for your support!

