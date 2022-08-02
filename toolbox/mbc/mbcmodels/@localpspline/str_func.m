function fx=str_func(ps,TeX)
%POLYSLINE/str_func
% fx=str_func(Model,TeX)
% outputs a formatted function description
% TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:38 $
s= detex(get(ps,'symbol'));

fx= ['f(',s{1},'^{',sprintf('%d',ps.order(2)),'}_-,',s{1},'^{',sprintf('%d',ps.order(1)),'}_+)'];



