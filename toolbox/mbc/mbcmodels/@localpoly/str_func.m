function fx=str_func(Model,TeX)
%polynom/str_func
% fx=str_func(Model,TeX)
% outputs a formatted function description
% TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:51 $
if nargin < 2
	TeX=0;
end
s= detex(get(Model,'symbol'));

% Basic Function Description
order = get(Model,'order');


yi= yinfo(Model);
fx= ['f(',s{1},'^',sprintf('%1d',order),')'];



