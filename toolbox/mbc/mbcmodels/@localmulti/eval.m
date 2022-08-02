function y= eval(L,X);
%LOCALMULTI/EVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:39:55 $

m= get(L.xregmulti,'currentmodel');
y= EvalModel(m,X);
