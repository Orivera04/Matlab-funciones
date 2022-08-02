function display(this)
% DISPLAY Display method

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:13 $

if length(this) > 1
  builtin('disp', this)
  return
end

fprintf( '\nExperimental transient data set for the model ''%s'':\n', ...
         this.Model );

fprintf('\nOutput Data\n' );
if ~isempty(this.OutputData)
  format = '   (%d) %s\n';
  for ct = 1:length(this.OutputData)
    % Remove CR or CR/LF
    Block = regexprep(this.OutputData(ct).Block, '\n\r?', ' ');
    fprintf(format, ct, LocalSetHtmlLine(Block) );
  end
else
  fprintf('   (none)\n' );
end

fprintf('\nInput Data\n' );
if ~isempty(this.InputData)
  format = '   (%d) %s\n';
  for ct = 1:length(this.InputData)
    % Remove CR or CR/LF
    Block = regexprep(this.InputData(ct).Block, '\n\r?', ' ');
    fprintf(format, ct, LocalSetHtmlLine(Block) );
  end
else
  fprintf('   (none)\n' );
end

fprintf('\nInitial States\n' );
if ~isempty(this.InitialStates)
  format = '   (%d) %s\n';
  for ct = 1:length(this.InitialStates)
    % Remove CR or CR/LF
    Block = regexprep(this.InitialStates(ct).Block, '\n\r?', ' ');
    fprintf(format, ct, LocalSetHtmlLine(Block) );
  end
else
  fprintf('   (none)\n' );
end

fprintf('\n')

% --------------------------------------------------------------------------
function html = LocalSetHtmlLine(str)
str1 = sprintf( 'hilite_system(''%s'',''find'')', str );
str2 = 'pause(1)';
str3 = sprintf( 'hilite_system(''%s'',''none'')', str );
html = sprintf( '<a href="matlab:%s;%s;%s">%s</a>', str1, str2, str3, str );
