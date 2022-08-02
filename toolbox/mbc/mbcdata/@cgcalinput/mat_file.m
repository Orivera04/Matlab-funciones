function varargout = mat_file(obj,opt)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.4.3 $  $Date: 2004/04/12 23:34:27 $

ret=[];
if nargin<2
    opt='';
end
if strcmp(opt,'getname')
    varargout{1} = '*.mat';
    varargout{2} = 1;
    return
end
if ~exist(obj.filename,'file')
    % Not a mat file
    varargout{1} = [];
    return
end
try
    data = load(obj.filename,'-mat');
    names = fieldnames(data);
catch
    names = [];
end
if isempty(names)
    errordlg('Calibration file is empty or failed to load','Calibration Import','modal');
    varargout{1} = [];
    return
end
try
    this = struct('name',[],'description',[],'info',[],'data',[],'numaxes',[],'numrows',[],'numcols',[]);
    out = [];
    for i = 1:length(names)
        this.name = names{i};
        this.description = '';
        this.info = ['Filled from mat file ',obj.filename];
        this.data = data.(names{i});
        if ~isstruct(this.data)
            this.data.X = this.data;
        end
        ax = fieldnames(this.data);
        this.numaxes = length(ax);
        switch this.numaxes
        case 1
            this.numrows = 0;
            this.numcols = 0;
            this.data.X = this.data.X.values;
        case 2
            this.numrows = length(this.data.X.values);
            this.data.X = this.data.X.values;
            this.data.Y = this.data.Y.values;
            this.numcols = 1;
        case 3
            this.numrows = length(this.data.Y.values);
            this.numcols = length(this.data.X.values);
            this.data.X = this.data.X.values;
            this.data.Y = this.data.Y.values;
            this.data.Z = this.data.Z.values;
        end
        out = [out this];
    end
    varargout{1} = out;
catch
    errordlg('Couldn''t interpret .mat file','Calibration Import Error','modal');
    varargout{1} = [];
end

function i_assignhere(name,this)
assignin('caller',name,this);
