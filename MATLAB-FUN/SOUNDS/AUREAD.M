function y = auread(name)
%AUREAD	Read mu-law encoded audio file.
%	Y = AUREAD('filename') reads the audio file in 'filename'
%	and converts the data from mu-law encoded bytes to a signal
%	in the range -1 <= Y <= 1.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% The data samples processed by the audio device  are  encoded
% in  8  bits.  The high-order bit is a sign bit: 1 represents
% positive data and 0 represents negative data.  The low-order
% 7 bits represent signal magnitude and are inverted (1's com-
% plement).  The magnitude is encoded  according  to  a mu-law
% transfer  function;   such  an encoding provides an improved
% signal-to-noise ratio at low amplitude levels.

fp = fopen(name,'rb');
[mu,len] = fread(fp,inf,'uchar');
fclose(fp);

% Strip off file header
k = max(find(mu(1:64)==0));
mu(1:k) = [];

y = mu2lin(mu);
