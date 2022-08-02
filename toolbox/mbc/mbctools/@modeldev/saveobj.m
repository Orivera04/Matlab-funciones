function md= saveobj(md);
% MODELDEV/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:53 $

% clear history
md.History=[];
md.Model= saveobj(md.Model);
md.Validation= xregpointer;
md.History =[];
if isa(md.Y,'sweepsetfilter')
	md.Y= saveobj(md.Y);
end


% if iscell(md.Validation)
% 	for i= 1:length(md.Validation)
% 		if isa(md.Validation{i},'sweepset')
% 			md.Validation{i}= saveobj(md.Validation{i});
% 		end
% 	end
% end