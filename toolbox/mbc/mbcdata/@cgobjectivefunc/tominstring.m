function str = tominstring(OF)
%---------------------------------------------------------------

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:50:33 $


% Type of optimisation (i.e. max/min)
typevec = OF.minstr;

switch typevec
case 'min'
    str = 'Minimize';
case 'max'
    str = 'Maximize';
case {'helper', 'neither'}
    str = 'Helper';
otherwise
    str = '';
end




