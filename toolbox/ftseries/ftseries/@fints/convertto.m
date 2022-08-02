function fts = convertto(old_FTS, newperiod)
%@FINTS/CONVERTTO converts a FINTS object to one of another frequency.
%
%   CONVERTTO converts a financial time series of any frequency to one of a
%   specified frequency.
%
%   NEWFTS = CONVERTTO(OLDFTS, NEWFREQ) converts the object OLDFTS to the
%   new time series object NEWFTS of frequency NEWFREQ.  
%
%   Valid parameters (can be either an integer or a string) for NEWFREQ
%   are:
%
%         1, DAILY,      Daily,      daily,      D, d
%         2, WEEKLY,     Weekly,     weekly,     W, w
%         3, MONTHLY,    Monthly,    monthly,    M, m
%         4, QUARTERLY,  Quarterly,  quarterly,  Q, q
%         5, SEMIANNUAL, Semiannual, semiannual, S, s
%         6, ANNUAL,     Annual,     annual,     A, a
%
%   See also TOANNUAL, TODAILY, TOMONTHLY, TOQUARTERLY, TOSEMI, TOWEEKLY.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/04/14 16:31:05 $

switch newperiod
case {1, 'DAILY', 'Daily', 'daily', 'D', 'd'}
    freqdata = 1;
    fts = todaily(old_FTS);
    
case {2, 'WEEKLY', 'Weekly', 'weekly', 'W', 'w'}
    freqdata = 2;
    fts = toweekly(old_FTS);
    
case {3, 'MONTHLY', 'Monthly', 'monthly', 'M', 'm'}
    freqdata = 3;
    fts = tomonthly(old_FTS);
    
case {4, 'QUARTERLY', 'Quarterly', 'quarterly', 'Q', 'q'}
    freqdata = 4;
    fts = toquarterly(old_FTS);
    
case {5, 'SEMIANNUAL', 'Semiannual', 'semiannual', 'S', 's'}
    freqdata = 5;
    fts = tosemi(old_FTS);
    
case {6, 'ANNUAL', 'Annual', 'annual', 'A', 'a'}
    freqdata = 6;
    fts = toannual(old_FTS);
    
otherwise
    error('Ftseries:ftseries_fints_convertto:InvalidFrequency', ...
        'Invalid frequency FREQ indicator.');
end

% [EOF]
