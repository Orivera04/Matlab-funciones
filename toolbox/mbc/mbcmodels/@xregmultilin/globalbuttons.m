function hands= globalbuttons(m,varargin)
%GLOBALBUTTONS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:55:29 $

if ishandle(varargin{1})
   action='create';
else
   action=varargin{1};
end
switch lower(action)
case 'id'
   hands='linearmultimod';
   
case 'toolbar'
    hands= globalbuttons(get(m,'currentmodel'),varargin{:});

case 'utilities'
   hands= globalbuttons(get(m,'currentmodel'),varargin{:});
end