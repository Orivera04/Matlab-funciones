function ret = m_file(obj,opt)
%M_FILE  Export to M-file format
%
%  RET = M_FILE(OBJ) exports the output object to an M-file script that is
%  executable in Matlab.  The file will look like:
%
%    ----------------------------------------------------------------
%    Table2D.X = [1 2 3 4];
%    Table2D.Y = [1 2 3];
%    Table2D.Z = [0 0 0 0;
%    0 0 0 0
%    0 0 0 0];
%    Constant1.X = 2;
%    ----------------------------------------------------------------
%
%  RET will be true if the file was successfully written, false otherwise.
%
%  INFO = M_FILE(OBJ, 'getname') returns a cell array containing the
%  information required for building a list of available output formats. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.3 $  $Date: 2004/02/09 06:49:30 $

if nargin>1 && strcmp(opt,'getname')
    ret = {'*.m', 'M-file Script (*.m)'};
else
    if ~isempty(obj.filename)
        str = cell(0,1);
        if ~isempty(obj.ptrlist)
            data = pveceval(obj.ptrlist, @getcharacteristic);
            for n = 1:length(data)
                this = data{n};
                
                if ~isempty(this.X.values)
                    this_str = [this.name, '.X = [', sprintf('%5.6f ',this.X.values)];
                    str = [str; {[this_str(1:end-1),'];']}];
                end
                
                if isfield(this,'Y') && ~isempty(this.Y.values)
                    this_str = [this.name, '.Y = [', sprintf('%5.6f ',this.Y.values)];
                    str = [str; {[this_str(1:end-1),'];']}];
                end
                
                if isfield(this,'Z') && ~isempty(this.Z.values)
                    S = size(this.Z.values);
                    fmt = repmat('%5.6f ',1,S(2));
                    fmt = [fmt(1:end-1) ';\n']; 
                    this_str = [this.name,'.Z = [' sprintf(fmt,this.Z.values')];
                    this_str(end-1:end) = '];';
                    str = [str; {this_str}];
                end
                str = [str; {''}];
            end   
            
        end
        [fid,message] = fopen(obj.filename,'w');
        if fid == -1
            ret = false;
        else
            ret = true;
            fprintf(fid , '%s\n' , str{:});
            fclose(fid);
        end
    else
        ret = false;
    end
end