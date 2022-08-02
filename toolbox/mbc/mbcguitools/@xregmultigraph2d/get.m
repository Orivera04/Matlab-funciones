function out=get(gr,varargin)
% XREGMULTIGRAPH2D/GET   Get interface for graph2d object
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
%    'colorbar'
%    'marker'
%    'markercolor'
%    'showlegend'
%
%  The following return a handle, allowing you to set handle graphics properties
%  (NOTE - this could break the object if you're not careful!)
%      'background'
%      'axes'
%      'xtext'
%      'ytext'
%      'xpopup'
%      'ypopup'
%      'lines'
%      'patches'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:58 $

% Bail if we've not been given a graph2d object
if ~isa(gr,'xregmultigraph2d')
   error('Cannot set properties: not a xregmultigraph2d object!')
end


ud = get(gr.axes,'userdata');
% loop over varargin
for n=1:(nargin-1)
   switch lower(varargin{n})
   case 'position'
      out=ud.pos;      
   case 'visible'
      out=get(gr.badim,'userdata'); 
   case {'data','number','value','xdata'}
      out=get(gr.xtext,'userdata'); 
   case {'ydata','outdata'}
      out=get(gr.ytext,'userdata'); 
   case {'cdata','colordata'}
      out=get(gr.yfactor,'userdata'); 
   case {'factors','xfactors','infactors'}
      out=get(gr.xfactor,'string');;
   case {'yfactors','outfactors'}
      out=get(gr.yfactor,'string');;
  case 'colorfactor'
      out=ud.colorfactor;
   case 'currentxfactor'
      out=get(gr.xfactor,'value');
   case 'currentyfactor'
      out=get(gr.yfactor,'value');
   case 'currentcfactor'
      out=get(gr.colorbar,'currentfactor');
   case 'colormap'
      out=get(gr.colorbar,'colormap');
   case 'limits'
      out=ud.limits;
%    case 'factorselection'
%       if get(gr.yfactor,'userdata')
%          out='exclusive';
%       else
%          out='normal';
%       end
   case 'transparentcolor'
      out=ud.transcolor;
   case 'backgroundcolor'
      out=get(gr.patch,'facecolor');
   case 'callback'
      out=ud.callback;
   case 'frame'
      if strcmp(get(gr.patch,'edgecolor'),'none')
         out='off';
      else
         out='on';
      end
   case 'userdata'
      out=ud.userdata;
   case 'background'
      out=gr.patch;
   case 'axes'
      out=gr.axes;
   case 'xtext'
      out=gr.xtext;
   case 'ytext'
      out=gr.ytext;
   case 'xpopup'
      out=gr.xfactor;
   case 'ypopup'
      out=gr.yfactor;
   case 'parent'
      out=get(gr.axes,'parent');
   case 'colorbar'
      out=gr.colorbar;
   case 'markersize'
      out=ud.markersize;
   case {'lines','line'}
      out=ud.line_h;
   case {'patch','patches'}
      out=ud.patch_h;
   case 'marker'
      out = ud.marker;
   case 'markercolor'
      out = ud.markercolor;
   case 'showlegend'
      if ud.lastcalltype==1
          out = 'off';
      else
          out = 'on';
      end
   end
end
