function obj = xreglytinput(varargin)
%% xreglytinput Constructor for the layout input object.
%%
%%   Pass in a layout object to create a listctrl input containing this layout
%%
%%   Usage:
%%   x = xreglytinput(FIG,LAYOUT)
%%   x = xreglytinput(LAYOUT)
%%   x = xreglytinput('Property1',Value1,...)
%%   x = xreglytinput(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:18 $

obj.lyt = [];

if nargin>0 & ishandle(varargin{1}) & strcmp(get(varargin{1},'type'),'figure')
   fh=varargin{1};
   varargin(1)=[];
end

if length(varargin)>0 & isa(varargin{1},'xregcontainer')
   lyt=varargin{1};
   fh = get(lyt,'parent');
   varargin(1)=[];
else
   error('incorrect input');
   return
end

obj.lyt=lyt;

obj = class(obj,'xreglytinput');

if length(varargin)
   obj=set(obj,varargin{:});
end
