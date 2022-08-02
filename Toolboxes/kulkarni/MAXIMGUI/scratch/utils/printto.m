function printto(figtype, destination)

% Sends output to either a file or directly to the printer
% Usage:  figtype: type of figure to be printed (must match prefix for *_print_template.m)
%         destination: 'file' or 'printer'

global Printer_name

% create a temporary file name that should not clash with anything
tmp_ = sprintf('%4.0f', rand(1)*10^4) ;
tmp_ = strrep(tmp_, ' ', '0') ;
tmpfile = ['c:\temp\temp' tmp_]; 

% write output to a temporary file using the appropriate printing template
fid = fopen(tmpfile, 'wt'); 
eval(sprintf('%s_print_template(%d);', figtype, fid));

switch lower(destination)
  case 'file'
    fclose(fid) ;

    % Capture file and path name
    [fname,pname] = uiputfile('*.*','SAVE AS') ;
    if (real(fname(1))==0 & real(pname(1))==0)
      return
    end
   
    outfile = [pname fname] ;
    eval(sprintf('!copy %s %s', tmpfile, outfile));

  case 'printer'
    fprintf(fid,'\f') ;
    fclose(fid) ;

    % copy temp file to printer
    eval(sprintf('!copy %s %s', tmpfile, Printer_name)) ;
 
  otherwise
    fclose(fid) ;
end  %switch

% if temp file was successfully created, delete it now
if (fid ~= -1)
  eval(sprintf('!del %s ;', tmpfile))
end
