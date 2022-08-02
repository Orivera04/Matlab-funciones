function key = pr_Genkey(listname, keycounter)
% PR_GENKEY Generate a key for one of the ActiveX lists
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:27:33 $

switch listname
case 'Objective'
    key= sprintf('OBJ%d',keycounter);
case 'Operating Point Set'
    key= sprintf('DSE%d',keycounter);    
case 'Constraint'
    key= sprintf('CON%d',keycounter);      
otherwise 
    error(['Cannot generate a key for' listname]);
end

