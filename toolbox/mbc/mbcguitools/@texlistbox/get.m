function out=get(obj,varargin)
%TEXLISTBOX/GET   get interface for texlistbox object
%   Implements get interface for texlistbox object
%   Currently supported properties are:

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:20:37 $

%    'Value'
%    'String'
%    'Min'
%    'Max'
%    'Listboxtop'
%    'Userdata'
%    'Callback'

% Created 5/10/2000


% Bail if we've not been given an texlistbox object
if ~isa(obj,'texlistbox')
   error('Cannot get properties: not a texlistbox object!')
end

% loop over varargin
ud=get(obj.xreglistctrl,'userdata');
for n=1:(nargin-1)
   switch lower(varargin{n})
   case 'userdata'
      out=ud.userdata;
   case 'value'
      out=ud.value;
   case 'string'
      out=ud.string;
   case 'min'
      out=ud.min;
   case 'max'
      out=ud.max;
   case 'listboxtop'
      out=get(obj.xreglistctrl,'top');
   case 'parent'
      out=ud.parent;
   case 'callback'
      out=ud.callback;
   case 'fontname'
      out=ud.fonts.fontname;
   case 'fontsize'
      out=ud.fonts.fontsize;
   otherwise
      out=get(obj.xreglistctrl,varargin{n});
   end
end