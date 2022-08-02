function xlabel(string,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8)
%XLABEL	X-axis labels for 2-D and 3-D plots.
% 	XLABEL('text') adds text beside the X-axis on the current axis.
%
%	XLABEL('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%	sets the values of the specified properties of the xlabel.
%
%	See also YLABEL, ZLABEL, TITLE, TEXT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

ax = gca;
h = get(ax,'xlabel');

%Over-ride text objects default font attributes with
%the Axes' default font attributes.
set(h, 'FontAngle',  get(ax, 'FontAngle'), ...
	'FontName',   get(ax, 'FontName'), ...
	'FontSize',   get(ax, 'FontSize'), ...
	'FontWeight', get(ax, 'FontWeight'), ...
	'string',     string);

if nargin > 1,
	if (nargin-1)/2-fix((nargin-1)/2),
		error('Incorrect number of input arguments')
	end
	cmdstr='';
	for i=1:(nargin-1)/2-1,
		cmdstr = [cmdstr,'p',num2str(i),',v',num2str(i),','];
	end
	cmdstr = [cmdstr,'p',num2str((nargin-1)/2),',v',num2str((nargin-1)/2)];
	eval(['set(h,',cmdstr,');']);
end
