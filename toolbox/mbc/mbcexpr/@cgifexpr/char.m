function str = char(ifexp)
%CHAR Return string description of if expression
%
%  STR = CHAR(IFEXP) returns a description of the IF expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:07 $

str = ['IF ',get(ifexp,'leftname'),' < ' ,get(ifexp,'rightname'),...
         ' THEN ',getname(ifexp),' = ',get(ifexp,'out1name'),' ELSE ',...
         getname(ifexp),' = ',get(ifexp,'out2name')];