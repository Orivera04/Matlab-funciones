function display(this)
% DISPLAY Formatted display of object properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:42:42 $

for ct = 1:length(this)
  h = this(ct);
  
  fprintf('\n(%d) Parameter data for ''%s'':\n\n', ct, h.Name);

  fprintf('       Parameter value : %s\n', LocalMat2Str(h.Value, 4) );
  fprintf('         Initial guess : %s\n', LocalMat2Str(h.InitialGuess, 4) );

  if length(h.Estimated) > 1
    fprintf('\n    Estimated elements : %s\n', LocalMat2Str(h.Estimated, 4) );
  else
    fprintf('\n             Estimated : %s\n', LocalMat2Str(h.Estimated, 4) );
  end
  
  fprintf('\n          Referenced by: ');
  for i = 1:length(h.ReferencedBy)
    % Remove CR or CR/LF
    Block = regexprep( h.ReferencedBy{i}, '\n\r?', ' ' );
    if i == 1
      fprintf('%s\n', LocalSetHtmlLine(Block) );
    else
      fprintf('                         %s\n', LocalSetHtmlLine(Block) );
    end
  end
end

fprintf('\n')

% --------------------------------------------------------------------------
function html = LocalSetHtmlLine(str)
str1 = sprintf( 'hilite_system(''%s'',''find'')', str );
str2 = 'pause(1)';
str3 = sprintf( 'hilite_system(''%s'',''none'')', str );
html = sprintf( '<a href="matlab:%s;%s;%s">%s</a>', str1, str2, str3, str );

% --------------------------------------------------------------------------
function str = LocalMat2Str(value, N)
try
  str = mat2str(value, N);
catch
  s1  = regexprep( num2str(size(value)), ' *', 'x' );
  str = sprintf('[%s %s]', s1, class(value));
end
