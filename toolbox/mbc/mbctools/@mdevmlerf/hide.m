function [View,OK]= hide(mdev,mbH,View);
% MDEVMLERF/HIDE 
%
% [View,OK]= hide(mdev,mbH,View);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:05:39 $



% if status(mdev)==1
% 	% status 1 means outliers have been applied and MLE not updated.
% 	
% 	p= parent(mdev);
% 	pnext= mbH.treeview('current');
% 	% don't bring up mle dialog if the next node is the local model.
% 	if pnext~=p;
% 		hFig= p.mledialog('The MLE Model has changed and needs to be updated.');
% 		% wait for figure to close
% 		uiwait(hFig);
% 	end
% 
% end

OK=1;
