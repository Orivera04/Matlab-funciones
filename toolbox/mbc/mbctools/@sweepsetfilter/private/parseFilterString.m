function filter = parseFilterString(filterString)
%PARSEFILTERSTRING

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:11:50 $

% Make sure inputs are strings
filterString = char(filterString);

filter.OK = false;
filter.filterExp = filterString;
filter.filterResult = [];
filter.inlineExp = vectorize(mbcinline(filterString));
filter.result    = '';
