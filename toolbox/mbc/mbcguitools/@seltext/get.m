function out=get(obj,varargin)
%SELTEXT/GET   Get interface for seltext object
%   Implements get interface for seltext object
%   Currently supported properties are:
%    'Position'   -   4 element vector
%    'Visible'
%    'Userdata'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:20:32 $

% Created 6/10/2000


% Bail if we've not been given an seltext object
if ~isa(obj,'seltext')
   error('Cannot get properties: not a seltext object!')
end

ud=get(obj.back,'userdata');
% loop over varargin
for n=1:(nargin-1)
   switch lower(varargin{n})
   case 'position'
      out=ud.position;
   case 'userdata'
      out=ud.userdata;
   case 'visible'
      out=get(ud.back,'visible');
   case 'backgroundcolor'
      out=ud.bgcolor;
   case 'selectedcolor'
      out=ud.selcolor;
   case 'selected'
      opts={'off','on'};
      out=opts{ud.selected+1};
   case 'parent'
      out=get(get(obj.back,'parent'),'parent');
   case 'interruptible'
      out=get(obj.back,'interruptible');
   case 'value'
      out=0;
   case 'callback'
      out=ud.callback;
   case 'enable'
      opts={'off','on'};
      out=opts{ud.callback+1};
   otherwise
      out=get(obj.axestext,varargin{n});
   end
   
end