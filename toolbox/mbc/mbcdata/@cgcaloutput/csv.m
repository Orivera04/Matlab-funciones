function ret=csv(obj,opt)
%CSV  Export to CSV format
%
%  RET = CSV(OBJ) exports the output object to a CSV-like format file.  The file
%  will look like:
%
%    ----------------------------------------------------------------
%    Constant1 10
%    ConstantN 20
%    
%    
%    1D_Table
%
%    0, 0
%    2, 20
%    5, 100
%
%
%    2D_Table
%    
%    1, 2, 2.2
%    2, 3, 4
%    2.5, 2.9, 4.1
%    ----------------------------------------------------------------
%
%  RET will be true if the file was successfully written, false otherwise.
%
%  INFO = CSV(OBJ, 'getname') returns a cell array containing the
%  information required for building a list of available output formats. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.3 $  $Date: 2004/02/09 06:49:25 $



if nargin>1 && strcmp(opt,'getname')
    ret = {'*.csv', 'Comma Separated Value (*.csv)'};
else
    if ~isempty(obj.filename)
        str1D = '';  str2D = '';  strC = '';
        if ~isempty(obj.ptrlist)
            objects = info(obj.ptrlist);
            if ~iscell(objects)
                objects = {objects};
            end
            for n = 1:length(objects)
                this = objects{n};
                name = getname(this);
                switch class(this)
                    case {'cgnormaliser','cgnormfunction','cglookupone'}
                        thisStr = i_OneD(this);
                        if ~isempty(thisStr)
                            str1D = [str1D name sprintf('\n\n')]; % First line - name of current table.
                            str1D = [str1D thisStr sprintf('\n')];
                        end
                    case 'cgconstant'
                        V = getvalue(this);
                        if ~isempty(V)
                            strC = [strC sprintf('%s, %5.6g\n', name, V)]; 
                        end
                    case 'cglookuptwo'
                        thisStr = i_LookupTwo(this);
                        if ~isempty(thisStr)
                            str2D = [str2D name sprintf('\n\n')]; % First line - name of current table.
                            str2D = [str2D thisStr sprintf('\n')];
                        end
                end
            end
        end
        [fid,message] = fopen(obj.filename,'w');
        if fid == -1
            ret = false;
        else
            ret = true;
            fprintf(fid , '%s\n\n' , strC);
            fprintf(fid , '%s\n\n' , str1D);
            fprintf(fid , '%s\n\n' , str2D);
            fclose(fid);
        end
    else
        ret = false;
    end
end



%---------------------------------------------------
function str = i_OneD(T)
%---------------------------------------------------
V = get(T,'values');
try
    BP = get(T,'breakpoints');
catch
    r = length(V);
    BP = 0:r-1;
end

str = sprintf('%5.6g, %5.6g\n',[BP,V]');


%---------------------------------------------------
function str = i_LookupTwo(T)
%---------------------------------------------------
V = get(T,'values');
[r,c] = size(V);

str = sprintf([repmat('%5.6g, ',1,c-1) '%5.6g\n'], V');