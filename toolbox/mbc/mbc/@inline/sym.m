function s= sym(INLINE_OBJ);
% INLINE/SYM convert an inline object to a sym object for the symbolic toolbox

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 06:43:50 $

expr= char(INLINE_OBJ);
% SYM doesn't support .^,.*,./  operators
expr= strrep(expr,'.^','^');
expr= strrep(expr,'.*','*');
expr= strrep(expr,'./','/');
expr= strrep(expr,'.\','\');
% call sym constructor
s= sym(expr);