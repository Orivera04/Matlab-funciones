function obj = sendtoprefs(obj)
%SENDTOPREFS Save object data to preferences file
%
%  OBJ = SENDTOPREFS(OBJ) saves all of hte currently defined functions to
%  the MBC preferences.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:54:03 $ 

P = mbcprefs('mbc');
S=getpref(P,'Optimization');
S.Functions = obj.FunctionNames(:);
setpref(P,'Optimization',S);