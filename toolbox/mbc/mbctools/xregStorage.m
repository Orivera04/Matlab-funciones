function [f] = xregStorage(parent, framework)
%XREGSTORAGE open the a storage view attached to the framework supplied
%
%  F = XREGSTORAGE(FRAMEWORK)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:21:06 $ 

% Try getting the storage handle
f = handle(mvf('storage'));
% Do we already have a valid storage handle?
if ishandle(f)
    f.visible = 'on';
    return
end

% Create a figure to hold the storage view
f = xregGui.figure('visible', 'off',...
    'name', 'Storage',...
    'pointer', 'watch',...
    'tag', 'storage',...
    'closeRequestFcn', @i_storageCloseClicked);

% Create the storage view
view = xregdatagui.storageview('parent', f,...
    'DataMessageService', framework.DataMessageService,...
    'Framework', framework);

% Listen to the visibility of the parent to ensure that we are invisible
% when they are - i.e. simulate a close clicked
listener = handle.listener(parent, parent.findprop('visible'), 'PropertyPostSet', @i_storageCloseClicked);
listener.CallbackTarget = f;

% Push the view into the new figure
set(f, 'LayoutManager', view,...
    'pointer', 'arrow',...
    'userdata', listener,...
    'visible', 'on');



% ------------------------------------------------------------------------------
%
% ------------------------------------------------------------------------------
function i_storageCloseClicked(src, event)
set(src, 'visible', 'off');