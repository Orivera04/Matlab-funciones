function candle(hi,lo,cl,op,color,dates,dateform) 
%CANDLE Candlestick chart. 
%
%   CANDLE(HI,LO,CL,OP,COLOR,DATES,DATEFORM) plots a candlestick chart given
%   the high HI, low LO, closing CL, and opening OP, prices of a security.
%   All prices data must be specified as column vectors.
%
%   If the closing price is greater than the opening price, the body (the
%   region between the opening and closing price) is empty.  If the
%   opening price is greater than the closing price, the body is filled.
%   color specifies the candlestick color; enter it as a string.  MATLAB
%   supplies a default color if none is specified.  The default color
%   differs depending on the background color of the figure window.  See
%   COLORSPEC in the MATLAB Reference Guide for color names.
%
%   You may supply your own set of dates to be the X-axis tick labels.  
%   The dates are specified as a column-vector DATES.  DATEFORM dictates 
%   the format of the date string tick labels.  See DATEAXIS for details 
%   on the date string formats.
% 
%   See also HIGHLOW, BOLLING, MOVAVG, POINTFIG. 
%
 
%	Author(s): C.F. Garvin, 2-23-95 
%	Copyright 1995-2002 The MathWorks, Inc.  
%	$Revision: 1.9 $   $Date: 2002/04/14 21:57:59 $ 
 
if nargin < 5 
  cls = get(gca,'colororder'); 
  color = cls(1,:); 
end 
if nargin < 4 
  error(sprintf('Missing high, low, closing, or opening data.')) 
end 
[m,n] = size(hi); 
if size(hi, 2) > 1 | size(lo, 2) > 1 | size(cl, 2) > 1 | size(op, 2) > 1, 
  error(sprintf('Please specify input data as column vectors.')) 
elseif size(hi, 1) ~= size(lo, 1) | size(lo, 1) ~= size(cl, 1) | size(cl, 1) ~= size(op, 1),
	error('Number of data must be consistent across inputs.');
end 
if nargin == 6 | nargin == 7,
	if size(dates, 2) ~= 1,
		error('DATES must be a column vector.');
	elseif size(dates, 1) ~= size(hi, 1),
		error('Number of dates must correspond to number of data.');
	end
end

back = get(gca,'color');

% Determine if current plot is held or not 
if ishold 
  hldflag = 1; 
else 
  hldflag = 0; 
end 
   
m = length(hi(:)); 
 
% Need to pad all inputs with NaN's to leave spaces between day data 
tmp = nan; 
nanpad = tmp(1,ones(1,m)); 
hilo = [hi';lo';nanpad];
index = 1:m;
indhilo = index(ones(3,1),:);
plot(indhilo(:),hilo(:))
clpad = [cl(:)';nanpad]; 
clpad = clpad(:)'; 
oppad = [op(:)';nanpad]; 
oppad = oppad(:)'; 
 
% Create boundaries for filled regions 
xbottom = index-0.25;  
xbotpad = [xbottom(:)';nanpad]; 
xbotpad = xbotpad(:)'; 
xtop = index+0.25; 
xtoppad = [xtop(:)';nanpad]; 
xtoppad = xtoppad(:)'; 
ybottom = min(clpad,oppad); 
ytop = max(clpad,oppad); 
 
% Plot lines between high and low price for day 
hold on 
 
% Plot box representing closing and opening price span 
% If the opening price is less than the close, box is empty 
i = find(oppad(:) <= clpad(:)); 
boxes(i) = patch([xbotpad(i);xbotpad(i);xtoppad(i);xtoppad(i)],... 
     [ytop(i);ybottom(i);ybottom(i);ytop(i)],... 
     back,'edgecolor',color); 
% If the opening price is greater than the close, box is filled
i = find(oppad(:) > clpad(:)); 
boxes(i) = patch([xbotpad(i);xbotpad(i);xtoppad(i);xtoppad(i)],... 
     [ytop(i);ybottom(i);ybottom(i);ytop(i)],... 
     color,'edgecolor',color); 
 
setappdata(gca,'plottype','Candle ')        % set tag for use with timeser.m  

% Add support for providing dates.
if nargin == 6 | nargin == 7,
	dateset = dates;

	hcdl_vl = findobj(gca, 'Type', 'line');
	hcdl_bx = findobj(gca, 'Type', 'patch');

	% The CANDLE plot is made up of patch(es) and a line.  hcdl_vl is the 
	% handle to the vertical lines; it's actually only 1 line object.  
	% hcdl_bx contains the handle(s) of the patch object(s) that make up the 
	% empty and filled boxes.  The XData of those objects need to be changed 
	% to dates so that ZOOM works correctly.
	line_xdata = get(hcdl_vl, 'XData');
	set(hcdl_vl, 'XData', dateset(line_xdata));
	for pidx=1:length(hcdl_bx),   % Need to do loop since there can be 1 or 2 patches.
	   patch_xdata = get(hcdl_bx(pidx), 'XData');
	   offset = [-0.25*ones(2, size(patch_xdata, 2)); ...
	             +0.25*ones(2, size(patch_xdata, 2))] * min(abs(diff(dateset)));
	   set(hcdl_bx(pidx), 'XData', dateset(round(patch_xdata))+offset);
	end   

	% Change XTickLabel to date string format.
	if ~exist('dateform', 'var') | isempty(dateform),
	   datetick('x');
	else,
	   datetick('x', dateform);
	end
end


% If original figure was not held, turn hold off 
if ~hldflag 
  hold off 
end
