function p = getDataDependancies(MP, pSSF, USE_PARENT)
% Get the list of data pointers from the mdevproject

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:53 $

% By Default USE_PARENT
if nargin < 3
    USE_PARENT = true;
end

dlist =  MP.Datalist;
p = [];
levels = [];
% Normally the parent is this pSSF
pParent = pSSF;
% However if this dataset is an original then it is possible that the underlieing
% sweepset has also changed. Hence that is the parent
if USE_PARENT
	pParent = pSSF.dataptr;
end
% Find all the children
for i = 1:length(dlist)
	[OK, level] = isChild(dlist(i).info, pParent);
	if OK
		p = [p dlist(i)];
		levels = [levels level];
	end
end
% Sort them in order of distance from the parent
[levels, i] = sort(levels);
p = p(i);
% Is pSSF in this list (as a child of a sweepset?). If so remove it
p = p(~ismember(double(p), double(pSSF)));