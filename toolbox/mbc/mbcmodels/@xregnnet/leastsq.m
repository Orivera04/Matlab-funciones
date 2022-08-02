function [nn,OK] = leastsq(nn, x, y)
% LEASTSQ initialise and train neural network

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:56:24 $

% initialise network

[r,c]= size(x);
if r>c
   x=x';
   y=y';
end

%begin training
%create figure for displaying performance

if length(y)> numParams(nn)
	temp = figure('windowstyle','modal','visible','on',...
		'tag','train',...
		'numbertitle','off','name','Training Progress ...');
	uicontrol('parent',temp,'visible','off');
	drawnow
	
	[nn.param, tr] = train(nn.param, x, y);
	delete(temp) %close temporary figure
	OK= isfinite(tr.perf(end));
else
	OK= 0;
end


