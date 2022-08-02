function table = getParameterData(this, row)
% GETPARAMETERDATA Construct parameter data array from object properties
%
% ROW : Row index of the parameter
% The output TABLE:  TABLE(1): cell array of strings

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:40:29 $

pardata = this.Parameters( row );

ReferencedBy = regexprep( pardata.ReferencedBy, '\n\r?', ' ');
htmlstrs = cell( size(ReferencedBy) );
for ct = 1:length(htmlstrs)
  str = ReferencedBy{ct};
  htmlstrs{ct} = sprintf( '<a href="%s">%s</a>', str, str );
end

table = { pardata.Name, ...
          pardata.Value, ...
          pardata.InitialGuess, ...
          pardata.Minimum, ...
          pardata.Maximum, ...
          pardata.TypicalValue, ...
          htmlstrs{:} };
