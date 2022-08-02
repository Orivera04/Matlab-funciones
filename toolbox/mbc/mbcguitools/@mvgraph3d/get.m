function out=get(gr,varargin)
%GET Get interface for graph3d objects
%  Implements get interface for graph2d object
%  Currently supported properties are:
%    'Position'
%    'Visible'
%    'Currentxfactor'
%    'Currentyfactor'
%    'Currentzfactor'
%    'Data'
%    'Factors'
%    'Parent'
%    'Xgrid'
%    'Ygrid'
%    'Zgrid'
%    'Limits'
%    'Frame'
%
%  The following return a handle, allowing you to set handle graphics properties
%  (NOTE - this could break the object if you're not careful!)
%      'background'
%      'axes'
%      'surface'
%      'xtext'
%      'ytext'
%      'ztext'
%      'xpopup'
%      'ypopup'
%      'xpopup'
%      'colorbaraxes'
%      'colorbarimage'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:24 $

% Bail if we've not been given a graph3d object
if ~isa(gr,'mvgraph3d')
    error('Cannot set properties: not a mvgraph3d object!')
end

ud = gr.DataPointer.info;
% loop over varargin
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
        case 'currentzfactor'
            out = get(gr.zfactor,'value');
        case 'colormap'
            out = get(gr.colorbar.bar,'facevertexcdata');
        case 'factorselection'
            if ud.factorselection
                out='exclusive';
            else
                out='normal';
            end
        case 'frame'
            out={'off','on'};
            out=out{ud.frame+1};
        case 'xgrid'
            out = get(gr.axes,'xgrid');
        case 'ygrid'
            out = get(gr.axes,'ygrid');
        case 'zgrid'
            out = get(gr.axes,'zgrid');
        case 'limits'
            out = ud.limits;
        case 'background'
            out = gr.patch;
        case 'axes'
            out = gr.axes;
        case 'surface'
            out = gr.surf;
        case 'xtext'
            out = gr.xtext;
        case 'ytext'
            out = gr.ytext;
        case 'ztext'
            out = gr.ztext;
        case 'xpopup'
            out = gr.xfactor;
        case 'ypopup'
            out = gr.yfactor;
        case 'zpopup'
            out = gr.zfactor;
        case 'parent'
            out = get(gr.axes,'parent');
        case 'colorbaraxes'
            out = gr.colorbar.axes;
        case 'colorbarimage'
            out = gr.colorbar.bar;
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