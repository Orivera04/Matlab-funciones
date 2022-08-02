function ecode = checksiz(sizes,fun)
%CHECKSIZ Test size consistency among input arguments.
%   ECODE = CHECKSIZ(SIZES,FUN) tests for size consistency among arguments. 
%   SIZES is a Mx2 matrix containing the size of each input argument.
%   FUN is the name of the function from which CHECKSIZ is invoked.
%
%   For example, to check for input argument size consistency in the
%   function FOO which takes the inputs A and B, use the call 
%
%   ecode = checksiz([size(A);size(B)],'FOO')
%
%   ECODE = 1 if the size of A and B are inconsistent and an error 
%   message is generated.  Otherwise, ECODE = 0.
%
%   See also CHECKRNG, CHECKTYP.
 

%       Author(s): C.F. Garvin, 7-18-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.8 $   $Date: 2002/04/14 21:55:44 $

row_index = find(sizes(:,1) ~= sizes(1,1) & sizes(:,1) ~= 1);
col_index = find(sizes(:,2) ~= sizes(2,2) & sizes(:,2) ~= 1);
if ~isempty(row_index) | ~isempty(col_index)
  ecode = 1;
  disp(char(7))
  fprintf(['??? Error using ==> %s.\n'...
       'Dimensions of inputs are inconsistent.\n\n'],fun)
else
  ecode = 0;
end
