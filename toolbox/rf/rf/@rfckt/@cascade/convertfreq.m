function out = convertfreq(h, in)
%CONVERTFREQ Convert the input frequency to get the output frequency.
%    OUTPUT = CONVERTFREQ(h, input) Convert the input frequency to
%    get the output frequency.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:36:15 $

out = in;
% Get and check the cascaded CKTS
ckts = get(h, 'CKTS');
nckts = length(ckts);

% Calculate the output frequency
for i=1:nckts
    ckt = ckts{i};
    out = convertfreq(ckt, out);
end


