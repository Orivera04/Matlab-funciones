function fts = filter(b, a, ftsa)
%@FINTS/FILTER filters FINTS object components.
%
%   FILTER filters a whole financial time series object with a certain
%   filter specification.  The filter is specified in a transfer
%   function expression.
%
%   NEWFTS = FILTER(B, A, OLDFTS) filters the data in the OLDFTS with 
%   the filter described by vectors A and B to create the filtered data
%   stored in NEWFTS.  The filter is a "Direct Form II Transposed" 
%   implementation of the standard difference equation.
%
%   See also FILTER, FILTER2.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/02/05 15:52:04 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['FILTERed ', ftsa.data{1}];

fts.data{4} = filter(b, a, ftsa.data{4});

% [EOF]
