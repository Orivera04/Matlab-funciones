function [s,errmsg] = sprintf(obj,format,varargin);
%SPRINTF

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:50 $

if format(1:2) == '%p'
	i = findstr(format,'.');
	dp = str2num(format(3:i-1));
	width = str2num(format(i+1:end));
	format = i_FormatStr(varargin{1},dp,width);
end

[s,errmsg] = sprintf(format,varargin{:});

%----------------------------------------------------
% FUNCTION i_FormatStr
%
% Direct copy of FormatStr from GuiTools but keeping
% it local to the table object
%----------------------------------------------------

function fstr= i_FormatStr(s,maxdp,maxwidth);
% Note maxwidth less than 8 really isn't enought to have %p 
% notation

% Ensure that s ~= 0 for the log below
s(s==0)=1;

sc = fix(log10(abs(s)));

is_neg = s < 0;
left_dp = max(sc,0);
precision = max(maxdp-sc-(left_dp>0),0);
has_dp = precision > 0;

is_integer = fix(s) == s;
% Decide how to format
% Hello boys, we have an integer that isn't too long
if is_integer & (sc + is_neg < maxwidth)
	% So print it as an integer
	fstr = '%d';	
% Ok it's not an integer and isn't too long
elseif ~is_integer & precision + is_neg + left_dp + has_dp < maxwidth
	% Fixed width float
	fstr = sprintf('%%%d.%df',maxwidth,precision);
% So, it must be exp notation
else
	% 7 comes from 5 (e+000) and 2 (0.) as required in exp notation
	precision = max(maxwidth - (7 + is_neg),0);
	fstr= sprintf('%%%d.%de',maxwidth,precision);
end
