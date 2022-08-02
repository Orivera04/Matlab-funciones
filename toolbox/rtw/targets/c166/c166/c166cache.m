function valout = C166CACHE(command,name,valin)
% C166CACHE caches information required during the build process
%    C166CACHE('set',NAME,VALUE) sets NAME equal to VALUE and this data persists
%    for the duration of the build.
%
%    VALUE = C166CACHE('get',NAME) returns the VALUE of NAME.
%    
%    C166CACHE('clear') clears the cache
  
% Copyright 2003 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.1.6.1 $
%   $Date: 2003/07/31 18:02:37 $  

  persistent data
  
switch lower(command)
 case 'set'
  eval(['data.' name ' = valin;']);
 case 'get'
  try 
    eval(['valout = data. ' name ';']);
  catch
    errdlg(['No cached value for ' name ],['Embedded Target for Infineon C166 Microcontrollers']);
  end
 case 'clear'
  clear data
end
