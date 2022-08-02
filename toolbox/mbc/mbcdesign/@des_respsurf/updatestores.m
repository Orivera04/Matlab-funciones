function des=updatestores(des);
%UPDATESTORES  Updates any runtime data stores
%
%  D=UPDATESTORES(D)  updates any runtime data any returns
%  the object with it correctly updated.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:03:59 $

des.xregdesign=updatestores(des.xregdesign);

sumxtx(des);
[p,des]=vcalc(des);
[p,des]=dcalc(des);
[p,des]=acalc(des);