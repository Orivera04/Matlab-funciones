function display(N)
%DISPLAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:13:49 $

% cgnormaliser display method.

if strcmp(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

disp(str)
disp([inputname(1) ' =']);
disp(str)

if isempty(N)
   disp('Empty or incomplete normalizer');
elseif isempty(N.Breakpoints)

disp(['Normalizer with no breakpoints']);
else
   M = N.Values;
   [m,n]=size(M);
   disp(['Normalizer object with ' num2str(m) ' breakpoints.'])
end

