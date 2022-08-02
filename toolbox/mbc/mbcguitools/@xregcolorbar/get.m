function out=get(gr,varargin)
% GRAPH4D/GET   Get interface for the graph4d object
%  Implements get interface for graph4d object
%  Currently supported properties are:
%    'Position'
%    'Visible'
%    'Currentfactor'
%    'Data'
%    'Factors'
%    'Parent'
%    'TransparentColor'
%    'Frame'
%    'Colormap'
%    'cdata' - current selected data
%    'cmax','maxrange' - max limit value
%    'cmin','minrange' - min limit value
%    'edges' - cmap edge info for use in histc
%    'colordata'- color of points within range
%    'index'    - index of points within range
%    'LimitStyle'
%    'Userange'
%    'Callback'
%    'Userangecb'
%
%  The following return a handle, allowing you to set handle graphics properties
%  (NOTE - this could break the object if you're not careful!)
%      'background'
%      'colorbaraxes'
%      'colorbartext'
%      'colorbarpopup'
%      'userangehandles'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:31:20 $


% Bail if we've not been given a graph3d object
if ~isa(gr,'xregcolorbar')
   error('Cannot get properties: not an xregcolorbar object!')
end


ud = get(gr.ctext,'userdata');
% loop over varargin
for n=1:(nargin-1)
   switch lower(varargin{n})
   case 'position'
      out=get(gr.cfactor,'userdata');      
   case 'visible'
      out=get(gr.userange,'userdata'); 
   case {'data','number','value'}
      out=get(gr.colorbar.frame1,'userdata'); 
   case 'factors'
      out=get(gr.cfactor,'string');
   case 'currentfactor'
      out=get(gr.cfactor,'value');
   case {'colormap','cmap'}
      out=get(gr.colorbar.bar,'facevertexcdata');
   case 'colordata'
       out = ud.coldata;
   case 'userange'
      out=get(gr.colorbar.userange,'value');
      if out==0
         out='off';
      elseif out==1
         out='on';
      end
   case 'userangecb'
       out = get(gr.colorbar.userange, 'callback');
   case 'transparentcolor'
      out=get(gr.colorbar.bar,'userdata');
   case 'background'
      out=gr.patch;
   case 'frame'
      out=get(gr.patch,'box');
   case 'colorbartext'
      out=gr.ctext;
   case 'colorbarpopup'
      out=gr.cfactor;
   case 'parent'
      out=get(gr.axes,'parent');
   case 'colorbaraxes'
      out=gr.colorbar.axes;
   case 'colorbarimage'
      out=gr.colorbar.bar;
   case 'limitstyle'
       out=ud.limitstyle;
   case 'cdata'
       out=ud.cdata;
   case 'index'
       out = ud.inds;
   case 'edges'
       out=ud.edges;
   case {'minrange','cmin'}
       out=ud.cmin;
   case {'maxrange','cmax'}
       out=ud.cmax;
   case 'relminrange'
        ud=get(gr.ctext,'userdata');
        clim = ud.clim;
        out = (ud.cmin - clim(1)) ./ (clim(2) - clim(1));
   case 'relmidrange'
        ud=get(gr.ctext,'userdata');
        clim = ud.clim;
        out = (((ud.cmax+ud.cmin)/2) - clim(1)) ./ (clim(2) - clim(1));
   case 'relmaxrange'
        ud=get(gr.ctext,'userdata');
        clim = ud.clim;
        out = (ud.cmax - clim(1)) ./ (clim(2) - clim(1));
    case 'callback'
       ud = get(gr.patch,'userdata');
       out = ud.callback;
    case 'userangehandles'
       out = [gr.colorbar.frame1 gr.colorbar.frame2 gr.colorbar.userange];
   end
end
