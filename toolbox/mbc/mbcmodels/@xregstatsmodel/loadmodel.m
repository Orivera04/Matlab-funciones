function OK = loadmodel( m )
%LOADMODEL Attempt to load the project file this model was exported from
%
%  OK = LOADMODEL( MODEL )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:57:53 $

minfo = getinfo( m );

if ~isfield(minfo, 'Parent') || exist( minfo.Parent, 'file')~=2
    % Can't find project
    OK = 0;
    return
else
    projfile = minfo.Parent;
	h = MBrowser;
	if h.GUIExists
		h = MBrowser;
		figure(h.Figure);
		drawnow;
        % is this file the current project
		if strcmp(projfile, projectfile(h.RootNode.info))
            % Project is already loaded
			OK = 1;
        else
            % Load project into Model Browser
			OK = h.OpenProject( projfile );
		end
	else
        % Start Model Browser and open project
		mbcmodel( projfile );
		OK = 1;
		h = MBrowser;
	end

    % We loaded the project ok - now find this model in the tree
	if OK && isfield(minfo, 'path')
		p = findnode(h.RootNode.info, minfo.path);
		if p~=0
			if p~= h.CurrentNode
                % Select the node
				OK = h.SelectNode(p);
			end
		else
			OK = 0;
		end
	end		
end
