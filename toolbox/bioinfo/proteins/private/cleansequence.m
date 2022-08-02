function seq = cleansequence(seq)
%CLEANSEQUENCE remove nonletter characters, make sequence lowercase

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/01/24 09:20:14 $

% remove the nonletter characters from the sequence
remove = ~isletter(seq);
seq(remove) = '';
seq = lower(seq);

