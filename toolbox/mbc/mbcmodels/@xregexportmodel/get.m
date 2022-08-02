function out = get(E,prop)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:19 $

% Get command for Exportmodels. 
%         property    
%
%         name        -  Name of the model
%         info        -  Information field
%         constraints -  Constraints structure


switch prop
case 'name'
   out = getname(E);
case 'info'
   out = getinfo(E);
case 'constraints'
   out = E.constraints;
end

   