function p = DataLinkPtr(T);
% MDEVTESTPLAN/DATALINKPTR returns the pointer to the data used in the testplan

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.8.2 $  $Date: 2004/02/09 08:07:05 $

if isa(T.DataLink, 'xregpointer')
    p = T.DataLink;
else
    % In older mbc files T.DataLink is a sweepsetfilter and the upgrade occurs
    % after this function is called - thus ensure that an xregpointer is always
    % returned
    p = xregpointer;
end

