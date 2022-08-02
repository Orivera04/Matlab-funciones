function varargout = WriteCSV(T,varargin)
%WRITECSV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:29 $

% CGNORMFUNCTION/WRITECSV :: writes pertinent information about a cgnormfunction to a csv file.

% We'll write the values in the table and the normaliser details to the file. 


name = getname(T);
V = get(T,'values');

str = '';

if ~isempty(varargin)
    flag = varargin{1};
else
    flag = 1;
end

if flag
    str = [str name sprintf('\n')]; % First line - name of current table.
    str = [str sprintf('\n')]; % Blank line.
    [r,c] = size(V);
    for i = 1:r
        tempstr = sprintf('%s' ,[num2str(i-1), ',',num2str(V(i))]); 
        str = [str tempstr sprintf('\n')];
    end
    str = [str sprintf('\n')];
end

xNormaliser = get(T,'x');
xstr = xNormaliser.WriteCSV;

str = [str xstr];

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