function [str] = description(mod)
%DESCRIPTION A short description of the function
%
%  STR = DESCRIPTION(MOD)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:49:36 $ 

info = getinfo( mod );
user = info.User;


str = sprintf('Created from "%s"', getname(mod.modObj));