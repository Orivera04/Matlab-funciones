function ecode = checkrng(arg_names,actual,low,up,lowname,upname,leq,ueq,fun)
%CHECKRNG Tests input arguments against upper and lower bounds.
%   ECODE = CHECKRNG(ARG_NAMES,ACTUAL,LOW,UP,LOWNAME,UPNAME,LEQ,UEQ,FUN) 
%   verifies that a given argument meets the specified boundary conditions.
%   This function is called from function in the Financial Toolbox to perform
%   input argument range checking.  ARG_NAMES is a string matrix of function
%   input argument names. ACTUAL is the actual value of a given input argument.
%   LOW is the lower boundary value and UP is the upper boundary value.   
%   LOWNAME is a matrix of the variable names or strings of the lower
%   boundaries.  UPNAME is a matrix of the variable names or strings of the
%   upper boundaries.  Setting LEQ to 'e' constrains the input argument value
%   to be greater than or equal to LOW.  Setting UEQ to 'e' constrains the
%   input argument to be less than or equal to UP.  LEQ = 'l' and UEQ = 'l'
%   constrains the input argument to be greater than LOW and less than UP,
%   respectively.  FUN is the name of the function that calls CHECKRNG. 
%   ECODE = 1 if any boundary conditions are violated.
%
%   For example, checkrng('rate',0.1,0,inf,'0','inf','e','l',mfilename) 
%   checks whether the input argument named rate falls between 0 and infinity.
%   An error message is returned is rate falls outside of these bounds.

%       Author(s): C.F. Garvin, 7-18-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.8 $   $Date: 2002/04/14 21:55:41 $

[rinp,cinp] = size(arg_names);

ecode = 0;  % Initialize ECODE

for i = 1:rinp
 if leq(i) == 'e'
  if any(actual(:,i) < low(:,i))
    ecode = 1;
    disp(char(7))
    fprintf(['??? Error using ==> %s.\n'...
                   '%s must be >= %s\n\n'],fun,arg_names(i,:),lowname(i,:))
  end
 else
  if any(actual(:,i) <= low(:,i))
    ecode = 1;
    disp(char(7))
    fprintf(['??? Error using ==> %s.\n'...
                   '%s must be > %s\n\n'],fun,arg_names(i,:),lowname(i,:))
  end
 end
 if ueq(i) == 'e'
  if any(actual(:,i) > up(:,i))
    ecode = 1;
    disp(char(7))
    fprintf(['??? Error using ==> %s.\n'...
                   '%s must be <= %s\n\n'],fun,arg_names(i,:),upname(i,:))
  end
 else
  if any(actual(:,i) >= up(:,i))
    ecode = 1;
    disp(char(7))
    fprintf(['??? Error using ==> %s.\n'...
                   '%s must be < %s\n\n'],fun,arg_names(i,:),upname(i,:))
  end
 end
end 
