function display(NF)
% cgnormfunction\display
% displays a description of the object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:38 $

if strcmp(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

disp(str)
disp([inputname(1) ' =']);
disp(str)

if isempty(NF)
   disp('Empty or incomplete cgnormfunction Object');
elseif isempty(NF.Breakpoints)
   disp(['cgnormfunction object with no breakpoints']);
else
   M = NF.Values;
   [m,n]=size(M);
   disp(['cgnormfunction object with ' num2str(m) ' breakpoints.'])
end

