function [inf,w]=info(des)
%INFO  Return design information
%
%  INF=INFO(DES) returns information for the design
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:43 $




[inf,w]=info(des.xregdesign);
if getstyle(des)==1
   inf=[inf; {'D-Optimal Value',sprintf('%f',dcalc(des));...
            'V-Optimal Value',sprintf('%f',vcalc(des));...
            'A-Optimal Value',sprintf('%f',acalc(des));...
         }];
   
   if nargout>1
      w=[w 80 80 80];
   end
end