function hnd=term_selector(varargin)
%TERM_SELECTOR   Constructor function for term_selector object
%   Constructor function for the term_selector object
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:44:13 $


% Use given figure handle or current figure by default (creates one if necessary)
if nargin & ishandle(varargin{1})
   parent=varargin{1};
   poss=strcmp(lower(varargin(2:2:length(varargin))),'position');
   ind=1+2*find(poss);
else
   parent=gcf;
   poss=strcmp(lower(varargin(1:2:length(varargin))),'position');
   ind=2*find(poss);
end

% limit table width to limit damage to memory!
if ~isempty(ind)
   %need to grab out position setting and limit it
   pos=varargin{ind};
   %centre the term selector
   pos(1)=pos(1)+(pos(3)-200).*0.5;
   pos(3)=200;
   varargin(ind)={pos};
else
   %add a limited position set of my own
   pos=[50 50 200 400];
   varargin(end+1)={'position'};
   varargin(end+1)={pos};
end

t=xregtable(varargin{:});
set(t,'cols.size',35,'rows.size',16,'cells.defaultfontsize',8);
hnd.objecthandle=uicontrol('parent',parent,...
   'visible','off');

ud.model=[];
ud.updatefunction='';
ud.updateparams=[];
ud.killedvis=0;
ud.visible=1;
ud.badim=image('parent',get(t,'bghandle'),...
   'cdata',pr_badim,...
   'xdata',[.4 .6],...
   'ydata',[.4 .6],...
   'visible','off',...
   'clipping','off');
t.userdata=ud;
hnd.userdata=[];
hnd=class(hnd,'term_selector',t);
builtin('set',hnd.objecthandle,'userdata',hnd);
return
