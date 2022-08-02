function L = setprecision(L,P)
%SETPRECISION Set precision on table
%
%  TBL = SETPRECISION(TBL, PREC)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:12:13 $

L = set(L,'precision',P);
val = get(L,'values');
L = set(L,'values',{val,'Precision properties altered and applied'});