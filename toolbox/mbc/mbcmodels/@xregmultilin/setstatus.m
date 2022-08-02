function m = setstatus(m,i,s)
%SETSTATUS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:54 $

m2 = setstatus(get(m,'currentmodel'),i,s);
m = set(m,'currentmodel',m2);
