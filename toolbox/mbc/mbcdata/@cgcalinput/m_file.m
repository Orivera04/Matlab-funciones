function varargout = m_file(obj,opt)
% M_FILE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.4.4 $  $Date: 2004/04/12 23:34:26 $


out=[];
if nargin<2
    opt='';
end
if strcmp(opt,'getname')
    varargout{1}='*.m';
    varargout{2}=1;
    return
end

out = [];
[p,n,e] = fileparts(obj.filename);
if strcmp(lower(e),'.m') & exist(p,'dir') & exist(obj.filename,'file')
    try
        curdir = pwd;
        cd(p);
        data = i_loadm(n);
        cd(curdir);
        if isempty(data)
            errordlg('Calibration file is empty or failed to load','Calibration Import','modal');
        else
            names = fieldnames(data);
            this = struct('name',[],'description',[],'info',[],'data',[],'numaxes',[],'numrows',[],'numcols',[]);
            for i = 1:length(names)
                thisdata = data.(names{i});
                % Check for empty variables and do not include these in the
                % import
                DO_IMPORT = false;
                if isstruct(thisdata)
                    if ~isempty(thisdata.X)
                        DO_IMPORT = true;
                        this.data = thisdata;
                    end
                else
                    if ~isempty(thisdata)
                        DO_IMPORT = true;
                        this.data.X = thisdata;
                    end
                end
                
                if DO_IMPORT
                    this.name = names{i};
                    this.info = ['Filled from m file ',opt];
                    ax = fieldnames(this.data);
                    this.numaxes = length(ax);
                    switch this.numaxes
                        case 1
                            this.numrows = 0;
                            this.numcols = 0;
                        case 2
                            this.numrows = length(this.data.X);
                            this.numcols = 1;
                        case 3
                            this.numrows = length(this.data.Y);
                            this.numcols = length(this.data.X);
                    end
                    out = [out this];
                end
            end
        end
    catch
        errordlg('Couldn''t interpret .m file','Calibration Import Error','modal');
        out = [];
    end
else
    errordlg('Calibration file does not exist or is of the wrong type','Calibration Import Error','modal');
end
varargout{1} = out;


% --------------------------------------------------------
function data__TO_Be_CollECteD = i_loadm(Mfile__NaMe)
% --------------------------------------------------------
try
    eval(Mfile__NaMe);
    feval('clear','Mfile__NaMe');
    NaMes_FoR__CollECtioN = feval('who');
    data__TO_Be_CollECteD = [];
    for LooP_VariABLe__ = 1:feval('length',NaMes_FoR__CollECtioN)
        data__TO_Be_CollECteD.(NaMes_FoR__CollECtioN{LooP_VariABLe__}) = eval(NaMes_FoR__CollECtioN{LooP_VariABLe__});
    end
catch
    data__TO_Be_CollECteD = [];
end