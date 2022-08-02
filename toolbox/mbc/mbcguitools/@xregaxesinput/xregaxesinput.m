function obj = xregaxesinput(varargin)
%% xregaxesinput Constructor for the axes input object for a ListCtrl
%%
%%   Pass in an array of axes handles to create one input object; a gridlayout
%%   containing these axes
%%
%%   Usage:
%%   x = xregaxesinput(FIG,[axesHandles])
%%   x = xregaxesinput([axesHandles])
%%   x = xregaxesinput('Property1',Value1,...)
%%   x = xregaxesinput(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:31:27 $


fH=[];

if nargin>0 & ishandle(varargin{1}) & strcmp(get(varargin{1},'type'),'figure')
    fh=varargin{1};
    varargin(1)=[];
end

if length(varargin)>0 & all(ishandle(varargin{1}))
    
    axHnd = varargin{1};
    varargin(1)=[]; %% sets us up for property arguments below
    
    axHnd = findobj(axHnd,'flat','type','axes');
    numAx = length(axHnd);
    %% if no fig handle from above, get a figure to parent everything
    if isempty(fh), fh = get(axHnd(1),'parent'); end;
    %% parent all axes with same figure - just making sure ;-)
    set(axHnd,'parent',fh,'units','pixels');
    
    %% wrap the axes
    aws=cell(1,numAx);
    for i = 1:numAx
        aws{i} = axiswrapper(axHnd(i));
    end
    
    obj.axes = axHnd(:); %% column vector
    obj.grid = xreggridlayout(fh,...
        'dimension',[1,numAx],...
        'elements',aws,...
        'correctalg','on',...
        'gapx',20,...
        'border',[35 30 10 20]);
    
    obj = class(obj,'xregaxesinput');
    
    if length(varargin)
        obj=set(obj,varargin{:});
    end
    
else
    error('incorrect input - some inputs may not be valid handles');
    return
end

