function str = description(mod)
%DESCRIPTION Returns a string that deascribes this model
%
%  STR = DESCRIPTION(MOD)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:57:44 $ 

info = getinfo(mod);
str = sprintf('Created by %s on %s.', info.User, info.Date);