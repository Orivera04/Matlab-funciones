function fx=str_func(Model,TeX)
%polynom/str_func
% fx=str_func(Model,TeX)
% outputs a formatted function description
% TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:07 $
if nargin < 2
	TeX=0;
end

fx= str_func(Model.userdefined,TeX);


