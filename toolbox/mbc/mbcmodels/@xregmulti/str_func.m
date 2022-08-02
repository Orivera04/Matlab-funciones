function fx=str_func(Model,TeX)
%xregmulti/str_func
% fx=str_func(Model,TeX)
% outputs a formatted function description
% TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:11 $

% no Tex formatting necessary

nmdls=length(Model.weights);
if nmdls>1
   fx= ['Multi-model containing ' sprintf('%d', nmdls) ' models.'];
else
   fx= ['Multi-model containing ' sprintf('%d', nmdls) ' model.'];
end
return