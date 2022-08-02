function [X,Y]=DataPtr(MD,var)
% MODELDEV/DATAPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:08 $

X= MD.X;
Y= MD.Y;
if nargin>1
   switch upper(var)
   case 'Y'
      X=Y;
   case 'X'
   case 'DATA'
      X=MD.Data;
   otherwise
      error('Inavalid Argument')
   end
end


