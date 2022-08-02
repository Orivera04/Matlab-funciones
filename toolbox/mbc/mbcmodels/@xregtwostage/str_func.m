function fx=str_func(Model,TeX)
%twostage/str_func
% fx=str_func(Model,TeX)
% outputs a formatted function description
% TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:00:17 $
if isempty(TeX)
   TeX=0;
end
s= get(Model,'symbol');
if TeX
   s= detex(s);
end
nl= nlfactors(Model);
s1=sprintf('%s,',s{1:nl});
s2=sprintf('%s,',s{nl+1:end});

fx= ['f([',s1(1:end-1),'],g([',s2(1:end-1),']))'];



