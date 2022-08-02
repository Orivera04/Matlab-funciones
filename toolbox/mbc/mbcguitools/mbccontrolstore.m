function h = mbccontrolstore(fig)
%MBCCONTROLSTORE Return the invisible control store for a figure
%
%  H = MBCCONTROLSTORE(FIG) returns the object that can be used to store HG
%  objects while they are invisible.  This object is used by the MBC HG
%  subclasses to improve figure resizing performance when large numbers of
%  controls are invisible.
%
%  H = MBCCONTROLSTORE(AX) returns the store for the figure that the axes
%  AX are located in.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:33:15 $ 

fig = handle(fig);
if strcmp(fig.Type, 'axes')
    fig = handle(fig.Parent);
end

if isempty(fig.findprop('HGControlStore'))
    schema.prop(fig, 'HGControlStore', 'handle');
end
if isempty(fig.HGControlStore)
    fig.HGControlStore = xregGui.controlStore('Parent', fig);
    fig.HGControlStore.connect(xregfigurehook(fig), 'up');
end
h = fig.HGControlStore;


