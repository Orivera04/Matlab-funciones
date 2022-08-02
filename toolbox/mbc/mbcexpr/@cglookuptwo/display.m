function display(LT)
%DISPLAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:31 $

% LookupTwo display method.

if strcmp(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

disp(str)
disp([inputname(1) ' =']);
disp(str)

if isempty(LT.Values)

disp(['LookupTwo object with no values']);
else
   M = LT.Values;
   [m,n]=size(M);
   disp(['LookupTwo object with ' num2str(m) ' by ' num2str(n) ' values.'])
end

