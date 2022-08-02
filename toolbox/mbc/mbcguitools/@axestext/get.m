function out=get(at,varargin)
%AXESTEXT/GET   /get interface for axestext object
%   Implements get interface for axestext object
%   Currently supported properties are:
%    'Position'   -   4 element vector
%    'Userdata'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.4 $  $Date: 2004/02/09 07:17:53 $

% Created 1/9/2000


% Bail if we've not been given an axestext object
if ~isa(at,'axestext')
   error('Cannot get properties: not a axestext object!')
end

% loop over varargin
for n=1:(nargin-1)
   switch lower(varargin{n})
   case 'position'
      ud=get(at.wrappedobject,'userdata');
      out=ud.position;
   case 'userdata'
      ud=get(at.wrappedobject,'userdata');
      out=ud.userdata;
   case 'clipping'
      ud=get(at.wrappedobject,'userdata');
      opts={'off','on'};
      out=opts{ud.clipping+1};
   case 'string'
      ud=get(at.wrappedobject,'userdata');
      if ud.clipping
         out=ud.string;
      else
         out=get(at.wrappedobject,'string');
      end
   case 'shortstring'
      ud=get(at.wrappedobject,'userdata');
      out=ud.altstring;
   case 'parent'
      out=get(get(at.wrappedobject,'parent'),'parent');
   case 'extent'
      h=handle(at.wrappedobject);
      if strcmp(get(at.wrappedobject,'visible'),'off')
         h.doMoveOffScreen(false);
         out=h.extent;
         h.doMoveOffScreen(true);
      else
         out=h.extent;
      end
   otherwise
      out=get(at.wrappedobject,varargin{n});
   end
   
end