function pInfo = getAllTableData(obj)
%GETALLTABLEDATA Return all information on current setup of tables
%
%  P_INFO = GETALLTABLEDATA(OBJ) returns a (numTables-by-3) pointer array.
%  The first column contains a list of pointers to tables.  The second
%  column contains a list of pointers to filling items.  The third column
%  contains a list of pointers to items that indicate "valid points" for
%  the corresponding filling item.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:26 $ 

pInfo = [obj.Tables(:), obj.FillExpressions(:), obj.FillMaskExpressions(:)];
