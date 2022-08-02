function lenfts = length(fts)
%@FINTS/LENGTH Gets the number of dates (rows) in a FINTS object.
%
%   LENFTS = LENGTH(FTS) returns the number of dates (rows) in the
%   FINTS object FTS and return it in the variable LENFTS.  This is
%   the same as issuing;
%
%      LENFTS = size(FTS, 1);
%
%   See also SIZE, LENGTH, @FINTS/LENGTH.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.6 $   $Date: 2002/01/21 12:23:13 $

lenfts = size(fts, 1);

% [EOF]