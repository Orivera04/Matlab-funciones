function fx=str_func(Model,TeX)
%LOCALMULTI/STR_FUNC
% fx=str_func(Model,TeX)
% outputs a formatted function description
% TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:40:13 $

% no Tex formatting necessary

if nargin<2
    TeX= 0;
end

mdl=get(Model.xregmulti,'currentmodel');

fx= ['Multiple Models: ',name(mdl)];
return