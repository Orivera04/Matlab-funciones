function mlist = exportmodel(t,View)
% TESTPLAN/EXPORTMODEL  prepares a model for export 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:43 $

%% get cell array of p.exportmodel for each Response node
mlist= children(t,'exportmodel');

%% NOTE: if datum model, entry for Response node will be a cell array {TS, datum}
%% if this node not validated, it will just be empty i.e. []
notvalid= cellfun('isempty',mlist);
if any(notvalid)
	names= children(t,find(notvalid),'name');
	if iscell(names)
		h=errordlg('You cannot export from this node','Export error','modal');
	else
		h=errordlg(['You must validate the models ',sprintf('%s ',names),...
				'before exporting response models'],'Export error','modal');
	end
	waitfor(h);
	mlist=[];
else %% everything okay and we can export mlist
	isc= cellfun('isclass',mlist,'cell');
	mlist= [mlist{isc},mlist(~isc)];
end