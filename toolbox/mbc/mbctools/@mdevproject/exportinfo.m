function info= exportinfo(mp,p,mlist);
%EXPORTINFO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:03:26 $





% create information struct to be included in each cgstatsmodel
info.User = getusername(initfromprefs(mbcuser)); 
info.Date = date; 
info.mvver = mbcver; 
info.Parent = mp.Filename;
info.path = p.fullname;
%% ==== put engine data into info.new{1} field ====
if ~isempty(mp.Information)
	%% user changed engine data already
	info.new{1} = mp.Information;   
else
	info.new{1} = [];
end

xi= xinfo(mlist{1});
info.Variables = xi.Names;
