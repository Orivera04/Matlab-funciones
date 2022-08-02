function out=get(gr,varargin)
%GET Get interface for mvgraph2d object
%  Implements get interface for graph2d object
%  Currently supported properties are:
%    'Position'
%    'Visible'
%    'Currentxfactor'
%    'Currentyfactor'
%    'Data'
%    'Factors'
%    'Parent'
%    'TransparentColor'
%    'Callback'
%    'Userdata'
%    'Frame'
%    'Backgroundcolor'
%
%  The following return a handle, allowing you to set handle graphics properties
%  (NOTE - this could break the object if you're not careful!)
%      'background'
%      'axes'
%      'line'
%      'xtext'
%      'ytext'
%      'xpopup'
%      'ypopup'
%      'image'
%      'colorbaraxes'
%      'colorbarimage'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:04 $

% Bail if we've not been given a graph2d object
if ~isa(gr,'mvgraph2d')
    error('Cannot set properties: not a mvgraph2d object!')
end


% loop over varargin
ud = gr.DataPointer.info;
for n=1:(nargin-1)
    switch lower(varargin{n})
        case 'position'
            out = ud.position; 
        case 'visible'
            out = ud.visible; 
        case {'data','number','value'}
            out = ud.data; 
        case 'factors'
            out = ud.factors;
        case 'currentxfactor'
            out = get(gr.xfactor,'value');
        case 'currentyfactor'
            out = get(gr.yfactor,'value');
        case 'colormap'
            out = get(gr.colorbar.bar,'facevertexcdata');
        case 'limits'
            out = ud.limits;
        case 'factorselection'
            if ud.factorselection==1
                out = 'exclusive';
            else
                out = 'normal';
            end
        case 'transparentcolor'
            out = ud.transcolor;
        case 'backgroundcolor'
            out = get(gr.patch,'facecolor');
        case 'callback'
            out = ud.callback;
        case 'frame'
            if strcmp(get(gr.patch,'edgecolor'),'none')
                out='off';
            else
                out='on';
            end
        case 'userdata'
            out = ud.userdata;
        case 'background'
            out = gr.patch;
        case 'axes'
            out = gr.axes;
        case 'line'
            out = gr.line;
        case 'xtext'
            out = gr.xtext;
        case 'ytext'
            out = gr.ytext;
        case 'xpopup'
            out = gr.xfactor;
        case 'ypopup'
            out = gr.yfactor;
        case 'parent'
            out = get(gr.axes,'parent');
        case 'image'
            out = gr.image;
        case 'colorbaraxes'
            out = gr.colorbar.axes;
        case 'colorbarimage'
            out = gr.colorbar.bar;
        case 'markersize'
            out = get(gr.line,'markersize');
        case 'hittest'
            out = get(gr.axes,'hittest');
        case 'datatags'
            if ud.datatags==0
                out = 'none';
            elseif ud.datatags==1
                out = 'enumerate';
            elseif ud.datatags==2
                out = 'custom';
            end
        case 'customdatatags'
            out = ud.customdatatags;
    end
end
