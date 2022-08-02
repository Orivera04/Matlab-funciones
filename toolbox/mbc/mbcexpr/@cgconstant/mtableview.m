function mtableview(T,ThisTable)
%MTABLEVIEW Initialise table with data
%
%  MTABLEVIEW(OBJ, TABLE) sets the gui object TABLE to display OBJ.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.4 $  $Date: 2004/04/12 23:34:33 $

ThisTable.Table.initTable(getvalue(T), {getname(T)}, '#.######');
