function ecode = checktyp(arg_names,actual,data_type,fun)
%CHECKTYP Test input arguments against given data type specification.
%   ECODE = CHECKTYP(ARG_NAMES,ACTUAL,DATA_TYPE,FUN) verifies that a given
%   argument conforms to the specified data type.
%   ARG_NAMES is a string matrix of function input argument names.
%   ACTUAL is the actual value of a given input argument.
%   DATA_TYPE is a string matrix of data type specifications.
%   FUN is the name of the function that calls CHECKTYP.
%
%   DATA_TYPE argument          data type
%              
%         int                    integer
%         str                    string
%         rea                    real
%         cpx                    complex         
%
%   For example, ecode = checktyp('nper',12,'int',mfilename) checks that 
%   the input argument nper is entered as an integer value.

%       Author(s): C.F. Garvin, 7-18-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.9 $   $Date: 2002/04/14 21:55:47 $

[rinp,cinp] = size(arg_names);

ecode = 0;   % Initialize ECODE

for i = 1:rinp
  if data_type(i,:) == 'int'
    if actual(i) ~= floor(actual(i))
      ecode = 1;
      disp(char(7))
      fprintf(['??? Error using ==> %s.\n'...
           '%s must be entered as an integer value.\n\n'],fun,arg_names(i,:))
    end
  elseif data_type(i,:) == 'str' 
    if ~ischar(actual(i))
      ecode = 1;
      disp(char(7))
      fprintf(['??? Error using ==> %s.\n'...
           '%s must be entered as an string value.\n\n'],fun,arg_names(i,:))
    end
  elseif data_type(i,:) == 'rea' 
    if ~isreal(actual(i))
      ecode = 1;
      disp(char(7))
      fprintf(['??? Error using ==> %s.\n'...
           '%s must be entered as a real value.\n\n'],fun,arg_names(i,:))
    end
  elseif data_type(i,:) == 'cpx' 
    if isreal(actual(i))
      ecode = 1;
      disp(char(7))
      fprintf(['??? Error using ==> %s.\n'...
           '%s must be entered as a complex value.\n\n'],fun,arg_names(i,:))
    end
  end
end 
