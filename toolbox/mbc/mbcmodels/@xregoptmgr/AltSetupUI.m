function h= AltSetupUI(om,hFig,varargin)
%ALTSETUPUI

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:38 $

if ~strcmp(get(hFig,'type'),'figure')
	varargin= get(hFig,'userdata');
end
if ~isempty(om.Alternatives)
	j=1;
	% find alternatives
	for i=1:length(om.Alternatives)
		[oa,OK]= feval(om.Alternatives{i},varargin{:});
		if OK
			% check this algorithm is OK
			oaList{j}= oa.name;
			j=j+1;
		end
	end
   % make alternative popup
   val= find(strcmp(om.name,oaList));
   Props= {'style','popup',...
         'string',oaList,...
         'value',val(1),...
         'userdata',varargin};
else
   % make a pop up with just one option
   Props= {'style','popup',...
         'string', om.name,...
         'Backgroundcolor', get(xregGui.SystemColorsDbl, 'CTRL_BACK'),...
         'enable', 'inactive',...
         'userdata',varargin};
end
if strcmp(get(hFig,'type'),'figure')
	h{1}= uicontrol('parent',hFig,...
		'horizontalAlign','Left',...
		'Backgroundcolor','w',...
        'visible','off',...
		Props{:});
else
	set(hFig,Props{:});
	h= [];
end
	
	
