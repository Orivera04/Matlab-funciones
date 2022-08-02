function table = getStateData(this, row)
% GETSTATESDATA Construct states data array from object properties
%
% ROW : Row index of the state in the StateList
% The output TABLE:  TABLE(1): cell array of strings

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:30 $

icdata    = this.States( row );

fullname = regexprep(icdata.Block, '\n\r?', ' ');
htmlstr  = sprintf( '<a href="%s">%s</a>', fullname, fullname );

slash    = max( findstr(fullname, '/') );
block    = fullname( slash+1:end );

table = { block, ...
          icdata.Value, ...
          icdata.InitialGuess, ...
          icdata.Minimum, ...
          icdata.Maximum, ...
          icdata.TypicalValue, ...
          icdata.Ts, ...
          htmlstr };
