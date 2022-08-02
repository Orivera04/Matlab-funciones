function varargout = WriteCSV(T,varargin)
%WRITECSV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:42 $

% CGNORMALISER/WRITECSV :: writes pertinent information about a cgnormfunction to a string for conversion to a CSV file,
% or directly to a csv file if no arguement is requested.

% We'll write the values in the table and the normaliser details to the file, or returns a string 

name = getname(T);
V = get(T,'values');

BP = get(T,'breakpoints');

str = '';

str = [str name sprintf('\n')]; % First line - name of current table.
str = [str sprintf('\n')]; % Blank line.

[r,c] = size(V);

for i = 1:r
    tempstr = sprintf('%s' ,[num2str(BP(i)), ',',num2str(V(i))]); 
    str = [str tempstr sprintf('\n')];
end

str = [str sprintf('\n')];
    
if nargout == 0
    [Fname,Pname] = uiputfile('untitled.csv','Save Table as:');
    if isnumeric(Fname) | isnumeric(Pname)
        return
    else
        indx=find(Fname == '.');
        if isempty(indx)
            Fname = [Fname '.csv'];
        end
    end
    [fid,message] = fopen([Pname Fname],'w');
    if fid == -1
        h=errordlg(['File opening/creation failed with error: ' message] , 'Cage' , 'modal');
        uiwait(h);
        return;
    end
    fprintf(fid , '%s\n\n' , str);
    fclose(fid);
else
    varargout{1} = str;
end

return