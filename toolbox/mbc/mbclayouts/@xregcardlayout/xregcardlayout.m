function obj = xregcardlayout(varargin)
%  Synopsis
%     function obj = xregcardlayout(parameter,value,parameter,....)
%     function obj = xregcardlayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xregcardlayout container in the (optional) figure fig.
%
%  See also
%     xregcardlayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:02 $

fig=[];
if nargin
    if ~ischar(varargin{1}) ...
            && ishandle(varargin{1}) ...
            && strcmp(get(varargin{1},'type'),'figure')
        fig = varargin{1};
        varargin(1) = [];
    end
end
if isempty(fig)
    fig = gcf;
end

c = xregcontainer(fig);

obj.version = 1.0;
obj.g = xregGui.RunTimePointer;
connectdata(c, obj.g);

ud.numcards = 3;
ud.carddraw = [0 0 0];
ud.alwaysdraw = 0;     % turning flag on forces a repack whenever a card is selected
ud.currentcard = 1;
ud.cards = [];
ud.id = [];
ud.nextid = 1;
ud.visible = 1;
obj.g.info = ud;

obj = class(obj,'xregcardlayout',c);
set(obj,varargin{:});
