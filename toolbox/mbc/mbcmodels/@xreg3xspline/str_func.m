function fx=str_func(Model,TeX)
%xreg3xspline/str_func
% fx=str_func(Model,TeX)
% outputs a formatted function description
% TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:24 $
if nargin < 2
   TeX=0;
end
s= get(Model,'symbol');

% Basic Function Description
order = get(Model,'order');
if TeX
   s=detex(s);
end

s=[s num2cell(order(:))]';

fmtstr='%s^%1d, ';
fmtstr=repmat(fmtstr,1,length(order));

fx=sprintf(['f(' fmtstr(1:end-2) ')'],s{:}); 

% Generates string describing spline
% get knots
K     = get(Model,'naturalknots');
% Spline variable
var       = get(Model,'spline');
% Convert knots to natural values (knots are stored in coded values)


% PHI function notation
if TeX
   phi = ['{\fontsize{14}\phi} = \bf\it{B}\rm(',...
         sprintf('%s^%1d, n_{knots}=%1d)',s{1,var},order(var),length(K))];
else
   phi = sprintf(['phi = %s^%1d, nknots=%1d'],s{1,var},order(var),length(K));
end
fx= [fx,': ',phi];
