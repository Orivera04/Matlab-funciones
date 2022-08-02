function obj = mbcloadstart
%MBCLOADSTART Object that is guaranteed to load first in an mbc project
%
%  OBJ = MBCLOADSTART creates an object that is designed to perform actions
%  that must take place before any other obejcts in an MBC projcet are
%  loaded.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:45:14 $ 

obj = struct('version',1);
obj = class(obj, 'mbcloadstart');