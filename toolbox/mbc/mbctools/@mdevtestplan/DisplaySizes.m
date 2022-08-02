function TP= DisplaySizes(TP,View)
% MDEVTESTPLAN/DISPLAYSIZES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:07:13 $



if IsMatched(TP)
	dp= TP.DataLink;
	Name = dp.get('label');
	set(View.StageClick,'Enable','off');
	set(View.menus.viewchild(1),'Enable','on');
else
	Name= 'No data is selected';
	set(View.StageClick,'Enable','on');
	set(View.menus.viewchild(1),'Enable','off');
end
	
dstr= [colhead(TP); num2cell(statistics(TP))];
str= [Name,sprintf('\n\n') sprintf('%-12s: %4d\n',dstr{:})];
set(View.DataInfo,'string',str,'FontName','FixedWidth');

