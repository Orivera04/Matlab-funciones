%% Music Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Music Chapter of "Experiments in MATLAB".
% You can access it with
%
%    music_recap
%    edit music_recap
%    publish music_recap
%
% Related EXM programs
%
%    pianoex

%% Size of a semitone, one twelth of an octave.

   sigma = 2^(1/12)

%% Twelve pitch chromatic scale.

   for n = 0:12
      pianoex(n)
   end

%% C major scale

   for n = [0 2 4 5 7 9 11 12]
      pianoex(n)
   end

%% Semitones in C major scale

   diff([0 2 4 5 7 9 11 12])

%% Equal temperament and just intonation

   [sigma.^(0:12)
    1 16/15 9/8 6/5 5/4 4/3 7/5 3/2 8/5 5/3 7/4 15/8 2]' 

%% C major fifth chord, equal temperament and just temperament

   [sigma.^[0 4 7]
    1 5/4 3/2]'


