function display(this)
% DISPLAY Formatted display of object properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:47 $

for ct = 1:length(this)
  h = this(ct);
  
  % Remove CR or CR/LF
  Block = regexprep( h.Block, '\n\r?', ' ' );
  
  fprintf('\n(%d) State data for %s block:\n\n', ct, LocalSetHtmlLine(Block) );
  
  if (h.Ts == 0)
    fprintf( '    The block has %d continuous state(s).\n', ...
             prod(h.Dimensions) );
  else
    fprintf( '    The block has %d discrete state(s) with sampling time: %g sec.\n', ...
             prod(h.Dimensions), h.Ts );
  end
  
  fprintf('\n');
  fprintf('           State value : %s\n',   mat2str(h.Value, 4) );
  fprintf('         Initial guess : %s\n',   mat2str(h.InitialGuess, 4) );
  
  if length(h.Estimated) > 1
    fprintf('\n    Estimated elements : %s\n',   mat2str(h.Estimated, 4) );
  else
    fprintf('\n             Estimated : %s\n',   mat2str(h.Estimated, 4) );
  end
end

fprintf('\n')

% --------------------------------------------------------------------------
function html = LocalSetHtmlLine(str)
str1 = sprintf( 'hilite_system(''%s'',''find'')', str );
str2 = 'pause(1)';
str3 = sprintf( 'hilite_system(''%s'',''none'')', str );
html = sprintf( '<a href="matlab:%s;%s;%s">%s</a>', str1, str2, str3, str );
