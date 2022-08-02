function stat = islegalname(varargin)
%ISLEGALNAME checks if a data series name is legal.
%
%   STAT = islegalname(DATANAMES) checks to see if the name (string) 
%   in the variable DATANAMES has illegal characters in it.  If it 
%   does, STAT = 0 which means that the name (string) is not a legal 
%   MATLAB variable name; thus, it's not a legal data series name. 
%   Conversly, when STAT = 1, the name (string) is a legal data 
%   series name.
%
%   To check a list of names (strings), DATANAMES must be a vector 
%   cell array, either a row cell array or a column cell array.  
%   When this is so, the size and shape of STAT follows the size and 
%   shape of the DATANAMES cell array.
%
%   Legal characters are:   lowercase latin alphabet, 'a' to 'z'
%                           uppercase latin alphabet, 'A' to 'Z'
%                           underscore, '_'
%
%   So, legal data series names must contain only the above characters 
%   AND they cannot start with a number.  See example below.
%
%   For example: » islegalname({'Pete', 'Dan', 'Stacy', 'Lissa'})
%
%                ans =
%
%                     1     1     1     1
%
%                » islegalname({'Var$'; 'Var_'; '3Var'})
%
%                ans =
%
%                     0
%                     1
%                     0
%
%   See also FINTS/FINTS, FINTS/CHFIELD.
%

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.5 $   $Date: 2002/01/21 12:27:25 $

stat = ones(size(varargin{1}));

switch class(varargin{1}),
case 'char',
   if ischar(varargin{1}) & size(varargin{1}, 1) ~= 1,
      error('One string at a time, please!  Use cell array for a list of strings!');
   end
   varname = varargin{1};
   
   if any(varname(1) >= 48 & varname(1) <= 57),
      stat = 0;
   elseif any((varname < 48) | ...
              (varname > 57 & varname < 65) | ...
              (varname > 90 & varname < 95) | ...
              (varname > 95 & varname < 97) | ...
              (varname >122)),
      stat = 0;
   else,
      stat = 1;
   end
case 'cell',
   if size(varargin{1}, 1) ~= 1 & size(varargin{1}, 2) ~= 1,
      error('Need a column or row cell array!');
   end
   for vidx = 1:length(varargin{1}),
      varname = varargin{1}{vidx};

      if any(varname(1) >= 48 & varname(1) <= 57),
         stat(vidx) = 0;
      elseif any((varname < 48) | ...
                 (varname > 57 & varname < 65) | ...
                 (varname > 90 & varname < 95) | ...
                 (varname > 95 & varname < 97) | ...
                 (varname >122)),
         stat(vidx) = 0;
      else,
         stat(vidx) = 1;
      end
   end
otherwise,   
   error('Invalid input argument type!');
end

return
