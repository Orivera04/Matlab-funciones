function sfreq = freqstr(nfreq)
%FREQSTR returns the string representation of the numeric frequency indicator.
%
%   SFREQ = FREQSTR(SFREQ) returns the string representation of the 
%   frequency numeric indicator, NFREQ, as SFREQ.
%
%   Valid numeric indicators are:   0 -> Unknown
%                                   1 -> Daily
%                                   2 -> Weekly
%                                   3 -> Monthly
%                                   4 -> Quarterly
%                                   5 -> Semiannual
%                                   6 -> Annual
%
%   See also FREQNUM.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:28:30 $

switch nfreq
case 0
    sfreq = 'Unknown';
case 1
    sfreq = 'Daily';
case 2
    sfreq = 'Weekly';
case 3
    sfreq = 'Monthly';
case 4
    sfreq = 'Quarterly';
case 5
    sfreq = 'Semiannual';
case 6
    sfreq = 'Annual';
otherwise
    error('Ftseries:freqstr:InvalidFREQ', ...
        'Invalid FREQ numeric indicator.');
end

% [EOF]