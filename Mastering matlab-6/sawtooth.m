function f=sawtooth(t,To)
%SAWTOOTH Sawtooth Waveform Generation.
% SAWTOOTH(t,To) computes values of a sawtooth having
% a period To at the points defined in the vector t.
f = 10*rem(t,To)/To;
f(f==0 | f==10) = 5; % must average value at discontinuity!