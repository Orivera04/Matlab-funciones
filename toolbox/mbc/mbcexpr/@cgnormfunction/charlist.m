function str = charlist(NF);
% cgnormfunction\charlist
% out=charlist(NF);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:37 $
   str = getname(NF);
   var = NF.Xexpr;
   if isempty(var);
      str = [str '(.)' ];
   else
      strx = var.charlist;
      str = [str,'(',strx,')'];
   end
         