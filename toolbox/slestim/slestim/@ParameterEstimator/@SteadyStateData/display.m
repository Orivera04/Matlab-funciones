function display(this)
% DISPLAY Formatted display of object properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:59 $

for ct = 1:length(this)
  h = this(ct);
  
  % Remove CR or CR/LF
  Block = regexprep( h.Block, '\n\r?', ' ' );
  
  if strcmp(h.PortType, 'Signal')
    fprintf('\n(%d) Steady-state data for output port %d of %s block:\n', ...
            ct, h.PortNumber, LocalSetHtmlLine(Block) );
  else
    fprintf('\n(%d) Steady-state data for %s block %s:\n', ...
            ct, h.PortType, LocalSetHtmlLine(Block) );
  end
  
  ns = h.getDataLength;
  nc = prod(h.Dimensions);
  fprintf('\n    Data set has %d samples and %d channels.\n', ns, nc);
end

fprintf('\n')

% --------------------------------------------------------------------------
function html = LocalSetHtmlLine(str)
str1 = sprintf( 'hilite_system(''%s'',''find'')', str );
str2 = 'pause(1)';
str3 = sprintf( 'hilite_system(''%s'',''none'')', str );
html = sprintf( '<a href="matlab:%s;%s;%s">%s</a>', str1, str2, str3, str );
