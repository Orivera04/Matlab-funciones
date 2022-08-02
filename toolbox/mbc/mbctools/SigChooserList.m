function SigChooserLV(action,varargin)
%SIGCHOOSERLIST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:20:40 $

% activex callback for listbox (Click and KeyUp events)
action.inactive=-1;
persistent RUNNING

stop=0;
if varargin{1}==5
	% don't run if just a shift or ctrl key is pressed
	[event,keycode,ext]= deal(varargin{1:3});
	stop= (keycode==16 | keycode==17);
end
if isempty(RUNNING) & ~stop
	RUNNING=1;
	try
		fH= allchild(0);
		% figure should be on the top
		udh= findobj(fH(1),'tag','SignalChooser');
		ud= get(udh,'userdata');
		feval(ud.ListCbk,ud);
	end
	RUNNING=[];
end
action.inactive=0;
