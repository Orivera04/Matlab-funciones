function mm= MotionManager(figh,varargin)
%MOTIONMANAGER Return a MotionManager object for a figure
%
%  MM = MotionManager(fig)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:33:05 $

persistent MMrunning
persistent MMhelper

if mbciscom(figh)
    % handle an activex MouseMove event
    if isempty(MMrunning)
        MMrunning=1;
        h=MotionManager(get(figh,'Parent'));
        h.doUpdate;
        MMrunning=[];
    end
else
    if ~ishandle(figh) | ~strcmp(get(figh,'type'),'figure')
        error('Not a figure handle.');
    end

    if isempty(MMhelper)
        % Create an empty, dummy manager for access to methods
        MMhelper = xregGui.MotionManager;
    end
    mm = MMhelper.FindManager(figh);
    if nargin>1
        % reconnect the motion function
        set(figh,'WindowButtonMotionFcn','');
        mm.AttachToFigure([]);
        % fire a motion event
        mm.doUpdate;
    elseif isempty(mm)
        MMhelper.AttachToFigure(figh);
        mm = MMhelper;
        MMhelper = [];
    end
end
return