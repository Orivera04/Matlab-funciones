function ind = pr_getListSelection(list)
%PR_GETEXPRLISTSELECTION
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:27:42 $

% INPUTS    :   list    -   ActiveX list handle
               
% OUTPUTS   :   ind     -   Index into the <listname>label field of cgoptim

hCurr = get(list, 'selecteditem');
key = get(hCurr, 'Key');

% Parse key string
% First three characters give list code, number gives position
ind = str2num(key(4:end));

