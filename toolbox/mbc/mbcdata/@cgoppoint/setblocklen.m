function op = setblocklen(op, thiscase)
%CGOPPOINT/SETBLOCKLEN Set the block length field when required
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:52:17 $

if nargin < 2
    thiscase = '';
end
bl = get(op, 'blocklen');
fact_i = 1:length(op.ptrlist);
isimported = (op.grid_flag(fact_i)==7);

if any(isimported)
    if strmatch(thiscase, 'removedrow', 'exact')
        % Removed rows from view data AND imported data exists
        data = get(op, 'data');
        blocklen = size(data ,1);
    else
        % Leave the block length alone
        blocklen = bl;
    end
else
    % Set the block length to zero
    blocklen = 0;
end

op = set(op, 'blocklen', blocklen);
