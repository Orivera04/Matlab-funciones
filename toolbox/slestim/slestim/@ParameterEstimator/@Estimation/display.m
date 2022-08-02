function display(this)
% DISPLAY Formatted display of object properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:11 $

if length(this) > 1
  builtin('disp', this)
  return
end

fprintf( '\nEstimated variables for the model ''%s'':\n', this.Model );

fprintf('\nEstimated Parameters\n' );
if ~isempty(this.Parameters)
  format = '   (%d) %s\n';
  for ct = 1:length(this.Parameters)
    if any( this.Parameters(ct).Estimated(:) )
      Name = this.Parameters(ct).Name;
      fprintf(format, ct, Name );
    end
  end
else
  fprintf('   (none)\n' );
end

fprintf('\nUsing Experiments\n' );
if ~isempty(this.Experiments)
  format = '   (%d) %s\n';
  for ct = 1:length(this.Experiments)
    Name = this.Experiments(ct).Description;
    fprintf(format, ct, Name );
  end
else
  fprintf('   (none)\n' );
end

if ~isempty(this.States)
  format = '   (%d) %s\n';
  
  for ct1 = 1:length(this.Experiments)
    Experiment = this.Experiments(ct1);
    fprintf( '\nEstimated States for Experiment ''%s'' \n', ...
             Experiment.Description );

    [nr,nc] = size(this.States);
    for ct2 = 1:nr
      if nc > 1
        idx = ct1;
      else
        idx = 1;
      end
      
      if any( this.States(ct2,idx).Estimated(:) )
        % Remove CR or CR/LF
        Block = regexprep(this.States(ct2,idx).Block, '\n\r?', ' ');
        fprintf(format, ct2, LocalSetHtmlLine(Block) );
      end
    end
  end
else
  fprintf('\nEstimated States \n' );
  fprintf('   (none)\n' );
end

fprintf('\n')

% --------------------------------------------------------------------------
function html = LocalSetHtmlLine(str)
str1 = sprintf( 'hilite_system(''%s'',''find'')', str );
str2 = 'pause(1)';
str3 = sprintf( 'hilite_system(''%s'',''none'')', str );
html = sprintf( '<a href="matlab:%s;%s;%s">%s</a>', str1, str2, str3, str );
