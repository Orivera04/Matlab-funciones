function str = char(NF);
% cgnormfunction\char
% out=char(NF);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:36 $
   str = getname(NF);
   var = NF.Xexpr;
   if isempty(var);
      str = [str '(.)' ];
   else
      strx = var.char;
      str = [str,'(',strx,')'];
   end
         