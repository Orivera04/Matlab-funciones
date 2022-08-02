function h = highlow(hi,lo,cl,op,color,dates,dateform)  
%HIGHLOW High, low, open, close chart.
%
%   HIGHLOW(HI,LO,CL,OP,COLOR) displays the high, low, opening,   
%   and closing price of an asset.  Plots are vertical lines whose top is the 
%   high, bottom is the low, open is a left tick, and close is a right tick.  
%   HI is the high price of asset, LO is the low price of asset, CL is the 
%   closing price of asset, OP is the opening price of asset, and COLOR is the 
%   line color.  All input prices are specified as column vectors.
%
%   MATLAB supplies a default color if none is specified.   The default color
%   differs depending on the background color of the figure window.  See
%   COLORSPEC in the MATLAB Reference Guide for COLOR names.
%
%   OP is optional.  To specify COLOR when OP is unknown, enter OP as an
%   empty matrix, []. 
%
%   HIGHLOW(HI,LO,CL,OP,COLOR)  plots the figure and returns the handles
%   H of the lines.  See the MATLAB User's Guide for information on Handle 
%   Graphics.
%
%   HIGHLOW(HI,LO,CL,OP,COLOR,DATES,DATEFORM) allows you to specify your own 
%   date vector DATES.  DATES must be a column vector.  DATEFORM is an 
%   optional input argument dictating the format of the date string as tick 
%   labels.  See DATEAXIS for the details on date string formats.
% 
%   For example, if the high, low, and closing prices for an asset are   
%   stored in the vectors asseth, assetl, and assetc, respectively, the   
%   High-Low-Close plot is displayed with the command  
%   highlow(asseth,assetl,assetc).  
%  
%   See also CANDLE.  
%
  
%	Author(s): C.F. Garvin, 2-23-95  
%   Copyright 1995-2002 The MathWorks, Inc. 
%	$Revision: 1.9 $   $Date: 2002/04/14 21:58:02 $  
  
if nargin < 3  
  error(sprintf('Missing high, low, or closing price data.'))  
end  
  
[m,n] = size(hi);  
if size(hi, 2) > 1 | size(lo, 2) > 1 | size(cl, 2) > 1 | (exist('op', 'var') & size(op, 2) > 1), 
  error(sprintf('Please specify input data as column vectors.')) 
elseif size(hi, 1) ~= size(lo, 1) | size(lo, 1) ~= size(cl, 1) | size(cl, 1) ~= size(hi, 1),
	error('Number of data must be consistent across inputs.');
end 
if nargin == 6 | nargin == 7,
	if size(dates, 2) ~= 1,
		error('DATES must be a column vector.');
	elseif size(dates, 1) ~= size(hi, 1),
		error('Number of dates must correspond to number of data.');
	end
end
  
m = length(hi(:));  
tmp = nan;  
nanpad = tmp(ones(m,1),1);  
if nargin < 4   
  op = nanpad;  
end  
if nargin < 5  
  cls = get(gca,'colororder');  
  color = cls(1,:);  
end  
if isempty(op)  
  op = nanpad;  
end  
  
inc = 0.4;                                 % Visual length of tick marks  
  
% Pad data with Nan's for plotting  
hilo = [hi(:) lo(:) nanpad]';
ind = 1:m;
indhilo = ind(ones(3,1),:);
clo = [cl(:) cl(:) nanpad]';
ope = [op(:) op(:) nanpad]';
clt = [ind(:) ind(:)+inc nanpad]';
opt = [ind(:) ind(:)-inc nanpad]';
alldat = [hilo clo ope];
allind = [indhilo clt opt];
hdles = plot(allind(:),alldat(:),'color',color);
setappdata(gca,'plottype','HighLow')  
if nargout == 1  
  h = hdles;  
end


if nargin == 6 | nargin == 7,
	hhll = hdles;

	% Replace default X-axis data with dates.
	% Generate the 3 sections of dates: INDHILO, CLT, OPT. (Refer to FinTbx's HIGHLOW).
	dateset1 = dates(:, ones(1,3))';
	dateset1 = dateset1(:);
	dateset2 = dateset1;
	dateset2(3:3:end) = NaN * ones(size(3:3:length(dateset1)));
	dateset3 = dateset2;
	% Generate the horizontal tick size for open and close price indicators.
	offsetsize = mean(diff(dates));
	offset = zeros(size(dateset1));
	offset(2:3:end) = (0.4 * offsetsize) * ones(size(2:3:length(dateset1)));
	% Generate the offset dates for the open and close price indicators.
	dateset2 = dateset2 + offset;
	dateset3 = dateset3 - offset;
	% Combine all three DATESETs to make the new X-axes data.
	newdtaxis = [dateset1', dateset2', dateset3'];

	% Set the XData of the plot to the new dates.
	set(hhll, 'XData', newdtaxis);

	% Change XTickLabel to date string format.
	if ~exist('dateform', 'var') | isempty(dateform),
	   datetick('x');
	else,
	   datetick('x', dateform);
	end
end

return

