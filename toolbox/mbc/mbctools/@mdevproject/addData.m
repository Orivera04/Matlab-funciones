function MP= addData(MP,p);
% MDEVPROJECT/ADDDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:03:16 $

name = p.get('label');
if isempty(name)
	name = 'Data';
end

p.info = p.set('label', getValidDataName(MP, name));

% Add the pointer to the datalist and update the project
MP.Datalist = [MP.Datalist p];
pointer(MP);