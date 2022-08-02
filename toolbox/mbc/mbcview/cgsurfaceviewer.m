function app=cgsurfaceviewer(nodes,select)
%CGSURFACEVIEWER Function that controls the CAGE surface viewer
%
%  app=cgsurfaceviewer(nodes, select)
%  app=cgsurfaceviewer(action)
%
%  Permitted values for the action are:
%     'get' : The handle (if any) of the existing surface viewer is returned.
%     'show': The (existing) surface is shown.  An error occurs if no
%             surface viewer exists.
%     'hide': The surface viewer, if it exists and is visible, is hidden.
%     'close' or 'delete': Any existing surface viewer is destroyed.
%
%  Only one instance of the surface viewer can exist at any one time. If an
%  instance exists, it will be used by this method.  Otherwise, a new
%  instance is created.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.10.8.3 $  $Date: 2004/02/09 08:39:43 $

persistent sv

app=[]; % for safety

if ischar(nodes)
    % special cases, where the parameter is a string
    switch upper(nodes)
    case 'GET'
        app=sv;
    case 'SHOW'
        app=sv;
        % we don't want to catch any error here
        set(sv,'visible','on');
    case 'HIDE'
        app=sv;
        if ~isempty(sv) && ishandle(sv)
            set(sv,'visible','off');
        end
    case {'CLOSE','DELETE'}
        if ~isempty(sv) && ishandle(sv)
            p = sv.displayoptions('get');
            setpref(mbcprefs('mbc'),'cgsurfaceviewer',p);
            delete(sv);
        else
            hFig = findall(0, 'type', 'figure', 'tag', 'cgsurfview');
            if ~isempty(hFig)
                sv = get(hFig, 'userdata');
                delete(sv);
            end
        end
        sv=[];
        app=[];
    otherwise
        warning(['Action ' nodes ' not recognised.']);
   end
   return;
else
    if (nargin<2)
        if length(nodes)>0
            select=1;       
        else
            select=[];
        end
    end
end

if isempty(sv) || ~isa(sv,'cgsurfview.app') || ~ishandle(sv.fig)
    % Search for the tag
    hFig = findall(0, 'type', 'figure', 'tag', 'cgsurfview');
    if isempty(hFig)
        % no valid surface viewer exists.  create a new one
        p = getpref(mbcprefs('mbc'),'cgsurfaceviewer');
        sv = cgsurfview.app(nodes,select,p);
    else
        sv = get(hFig, 'userdata');
        sv.setnodes(nodes,select);
        set(sv,'visible','on');
    end
else
    % a valid surface viewer exists.  use the new set of nodes.
    sv.setnodes(nodes,select);
    set(sv,'visible','on');
end

app=sv;
