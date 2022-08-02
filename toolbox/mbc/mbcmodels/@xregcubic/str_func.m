function fx=str_func(Model,TeX)
%xregcubic/str_func
% fx=str_func(Model,TeX)
% outputs a formatted function description
% TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:41 $

if nargin==1
   TeX=0;
end
s= get(Model,'symbol');

% Basic Function Description
order = get(Model,'order');
if TeX
   s=detex(s);
end

s=[s(:) num2cell(order(:))]';

fmtstr='%s^%1d, ';
fmtstr=repmat(fmtstr,1,length(order));

fx=sprintf(['f(' fmtstr(1:end-2) ')'],s{:}); 



