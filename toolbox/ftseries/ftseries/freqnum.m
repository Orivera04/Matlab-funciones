function nfreq = freqnum(sfreq)
%FREQNUM returns the numeric representation of the frequency indicator.
%
%   NFREQ = FREQNUM(SFREQ) returns the numeric representation of the 
%   frequency string indicator, SFREQ, as NFREQ.
%
%   Valid string indicators are:   
%
%      UNKNOWN,    Unknown,    unknown,    U, u, 0
%      DAILY,      Daily,      daily,      D, d, 1
%      WEEKLY,     Weekly,     weekly,     W, w, 2
%      MONTHLY,    Monthly,    monthly,    M, m, 3
%      QUARTERLY,  Quarterly,  quarterly,  Q, q, 4
%      SEMIANNUAL, Semiannual, semiannual, S, s, 5
%      ANNUAL,     Annual,     annual,     A, a, 6
%
%   See also FREQSTR.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:28:25 $

switch lower(sfreq)
case {'unknown', 'u'}
    nfreq = 0;
case {'daily', 'd'}
    nfreq = 1;
case {'weekly', 'w'}
    nfreq = 2;
case {'monthly', 'm'}
    nfreq = 3;
case {'quarterly', 'q'}
    nfreq = 4;
case {'semiannual', 's'}
    nfreq = 5;
case {'annual', 'a'}
    nfreq = 6;
otherwise
    error('Ftseries:freqnum:InvalidFreq', ...
        'Invalid FREQ indicator. Please see ''help freqnum''.');
end

% [EOF]