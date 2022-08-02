function updateflag(h, index, iflag, nflags)
%UPDATEFLAG Update the Flag.
%   UPDATEFLAG(H, INDEX, IFLAG, NFLAGS) updates the property FLAG.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:41 $

% Check the input
if (index < 1) || (index >= nflags)
    id = sprintf('rf:%s:updateflag:IndexOutOfRange', strrep(class(h),'.',':'));
    error(id, 'The input INDEX is out of range.');
end
if (iflag ~= 0) && (iflag ~= 1)
    id = sprintf('rf:%s:updateflag:WrongFlag', strrep(class(h),'.',':'));
    error(id, 'The input IFLAG must be 1 or 0.');
end

% Set the flag
cflag = get(h, 'Flag');
cflag = bitset(cflag, index, iflag);
set(h, 'Flag', cflag);
