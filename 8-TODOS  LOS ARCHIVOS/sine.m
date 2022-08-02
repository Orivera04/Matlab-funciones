% SINE returns a matrix with rows of sine waves.
% 
%   WAVE = SINE(FS, FREQUENCIES) returns a matrix with rows of sine waves.
%      All rows containing an integral number of sine cicles (usable in a loop).
%      The length of the matrix depends on the greatest common divisor of the 
%      frequencies specified in the vector FREQUENCIES. 
%      The values are in the range [-1,+1].
%      0 Hz outputs a row of zeros.
%      Negativ frequency values give a 180 degree phase inversion
%      The waveforms will be calculated for a given sampling frequency FS.
%
% SINE is part of the SND_PC toolbox (by Torsten Marquardt)

function wave = sine(sample_rate,frequencies)

error(nargchk(2,2,nargin)),
n_freg = length(frequencies);

l = sample_rate;
for (n = 1:n_freg)
    l = gcd(l,abs(frequencies(n)));
end
l = sample_rate/l;
for (n = 1:n_freg)
    wave(n,:) = linspace(0,frequencies(n)*...
        l/sample_rate*2*pi*(1-1/l), l);
end
wave = sin(wave);
