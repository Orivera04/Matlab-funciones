function s = mbcordinalstring(N, start)
%MBCORDINALSTRING Generate a cell array containing an ordinal string sequence
%
%  MBCORDINALSTRING(N) creates an (N-by-1) cell array containing the
%  strings '1', '2', ...'N'.
%
%  MBCORDINALSTRING(N, START) allows you to specify a starting point.  The
%  resultant cell array will contain the strings 'START', 'START+1', ...
%  'START+N-1'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:29:26 $ 

if nargin==1
    start = 0;
else
    % Adjust start value to actually be an offset
    start = start-1;
end
s = cell(N,1);
for m =1:N
    s{m} = sprintf('%d', m+start);
end
