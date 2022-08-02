function display(LT)
%DISPLAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:18 $

% cglookupOne display method.

if strcmp(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

disp(str)
disp([inputname(1) ' =']);
disp(str)

if isempty(LT)
   disp('Empty or incomplete cglookupOne Object');
elseif isempty(get(LT,'breakpoints'))
   disp(['cglookupOne object with no breakpoints']);
else
   M = get(LT, 'values');
   [m,n]=size(M);
   disp(['cglookupOne object with ' num2str(m) ' breakpoints.'])
end
disp(str)
