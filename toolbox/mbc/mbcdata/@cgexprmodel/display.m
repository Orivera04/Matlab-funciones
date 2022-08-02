function display(E)
%cgExprModel/DISP display method.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:37 $

if strmatch(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

if isempty(E)
   disp(str);
   disp('Empty Expression Model object');
   disp(str);
   return
end

num_inputs = nfactors(E);
if num_inputs>0
   disp(str)
   disp(['Expression Model Object with ',num2str(num_inputs),' argument(s) defined.']);
   disp(str)   
else
   disp('Empty Expression Model object');
end
