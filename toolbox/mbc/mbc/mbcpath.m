function pth = mbcpath
%MBCPATH Return path to MBC toolbox
%
%  PATH = MBCPATH returns the full path to the mbc toolbox, for example
%  'C:\MATLAB\TOOLBOX\MBC'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:49:01 $ 

pth = fileparts(fileparts(mfilename('fullpath')));