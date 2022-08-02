function varargout = rfblksanalyze1(block, action)
%RFBLKSANALYZ1 Mask function for Input and Output Port blocks

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.14 $  $Date: 2004/05/08 03:15:43 $

% For the library
if strcmpi(get_param(gcs, 'Name'), 'rfphysmodels1') || ...
        strcmpi(get_param(gcs, 'Name'), 'rfports1')
    switch(action)
    case 'rfInitInput'
        mStr.emsg = '';
        mStr.wmsg = '';
        varargout{1} = mStr;  
    case 'rfInitOutput'
        mStr.emsg = '';
        mStr.wmsg = '';
        varargout{1} = mStr;  
        varargout{2} = {};  
    end
    return;
end

switch(action)
case 'rfInitInput'
    varargout{1} = rfblksinputport(block, action);
case 'rfNoiseOn'
    rfblksinputport(block, action);
case 'rfDeleteInput' 
    rfblksinputport(block, action);
case 'rfInitOutput'
    [varargout{1}, varargout{2}, varargout{3}] = rfblksoutputport(block, action);
case {'rfUpdateBlockMask' 'rfDeleteOutput'} 
    rfblksoutputport(block, action);
end


function varargout = rfblksinputport(block, action)
% Get the UserData
Udata = get_param(block, 'UserData');
if isempty(Udata)
    Udata.Version = 1.0;
    Udata.System = [];
    Udata.Tag = get_param(block,'GoToTag');
    Udata.Ckt = [];
    Udata.Parameters = {};
    Udata.NumParameters = 0;
    Udata.PlotType = '';
    Udata.PlotFormat = '';
    Udata.XAxisName = '';
    set_param(block, 'UserData', Udata);
end
sys = Udata.System;

%**************************************************************************
% Action switch -- Determines which of the callback functions is called
%**************************************************************************
switch(action)
case 'rfInitInput'
    mStr.emsg = '';
    mStr.wmsg = '';
    lasterr('');
    lastwarn('');
    if ~isa(sys, 'rfmodel.system')
        sys = rfmodel.system;
    end
    try 
        % Get parameters values 
        setblockfieldindexes(block);
        allparams = get_param(block,'MaskWsVariables');
        maxlen = allparams(idxMaxLength).Value;
        fc = allparams(idxFc).Value;
        ts = allparams(idxTs).Value;
        zs = allparams(idxZs).Value;
        seed = allparams(idxSeed).Value;
        noiseflag = get_param(block, 'NoiseFlag');
        set(sys, 'MaxLength', maxlen, 'Fc', fc, 'Ts', ts, 'ZS', zs, ...
            'NoiseFlag', noiseflag, 'Seed', seed);
        set(sys, 'InputFreq', frequency(sys));
        Udata.System = sys;
    catch
        mStr.emsg = lasterr;
        if (strcmpi(get_param(bdroot, 'SimulationStatus'), 'stopped') && DoPlot)
          errordlg(mStr.emsg,'RF Blockset Error');
        end
    end
    mStr.wmsg = lastwarn;
    if strcmpi(get_param(bdroot, 'SimulationStatus'), 'stopped') && (~isempty(mStr.wmsg))
        warndlg(mStr.wmsg,'RF Blockset Warning');
    end
    varargout{1} = mStr;  
    set_param(block, 'UserData', Udata);
   
case 'rfNoiseOn' 
    setblockfieldindexes(block);
    % Get the block parameters
    En    = get_param(block, 'MaskEnables');
    Vis   = get_param(block, 'MaskVisibilities');
    idxOn = [];  idxOff = []; 
    if strcmp(get_param(block, 'NoiseFlag'), 'on')
        idxOn = [idxSeed];
    else
        idxOff = [idxSeed];
    end
    if ~isempty(idxOn) 
        [En{idxOn}, Vis{idxOn}] = deal('on');
    end
    if ~isempty(idxOff) 
        [En{idxOff}, Vis{idxOff}] = deal('off');
    end
    set_param(block, 'MaskVisibilities', Vis, 'MaskEnables', En);

case 'rfDeleteInput' 
    if ~isempty(Udata)
        if isa(sys, 'rfmodel.system'); delete(sys); end;
        set_param(block, 'UserData', []);
    end

end

function varargout = rfblksoutputport(block, action)
% Get the block parameters
En    = get_param(block, 'MaskEnables');
Vis   = get_param(block, 'MaskVisibilities');
Vals  = get_param(block, 'MaskValues');
Udata = get_param(block, 'UserData');

% Set index to mask parameters
setblockfieldindexes(block);

% Get the inputs
DisplayData = Vals{idxDisplayData};
if strcmpi(Vis{idxAllPlotType}, 'on')
    PlotType = Vals{idxAllPlotType};
else
    PlotType = Vals{idxNoBudgetPlot};
end

% Set the tags for the figures of this block
tag = get_param(block,'GoToTag');
tag_cp = strcat(tag, '/','CompositePlot');

MAX_NUMBER_OFMODELS = 9;

%**************************************************************************
% Action switch -- Determines which of the callback functions is called
%**************************************************************************
switch(action)
case 'rfInitOutput'
    mStr.emsg = '';
    mStr.wmsg = '';
    lasterr('');
    lastwarn('');
    DoPlot = false;
    models = {};
    sys = [];

    % Get the UserData
    for j=1:MAX_NUMBER_OFMODELS
        models{j} = [];
    end

    try 
        if ~isempty(Udata)
            sys = Udata.System;
            status = get_param(bdroot, 'SimulationStatus');
            if strcmpi(status, 'initializing')
                % Process the rfsystem
                if isa(sys, 'rfmodel.system')
                    u_models = get(sys, 'Models');
                    num_models = length(u_models);
                    if num_models > MAX_NUMBER_OFMODELS
                        num_models = MAX_NUMBER_OFMODELS;
                    end
                    for j=1:num_models
                        models{j} = u_models{j};
                    end
                end
            elseif strcmpi(status, 'stopped')
                % Get ckt 
                if isa(sys, 'rfmodel.system')
                    ckt = sys.OriginalCkt;
                    if isa(ckt, 'rfckt.cascade')
                        setflagindexes(ckt);
                        updateflag(ckt, indexOfTheBudgetAnalysisOn, 1, MaxNumberOfFlags);
                        % Check the status 
                        DoPlot = isa(ckt, 'rfckt.rfckt') && strcmpi(DisplayData, 'on') ...
                            && strcmpi(tag, Udata.Tag);
                        if DoPlot
                            % Get parameters values 
                            if strcmp(Vals{idxPlotFreq}, 'User specified')
                                allparams = get_param(block,'MaskWsVariables');
                                freq = allparams(idxFreq).Value;
                            else
                                freq = ckt.SimulationFreq;
                            end
                            % Update ckt
                            rfdata = getdata(ckt);
                            set(rfdata, 'DataSource', block);
                            analyze(ckt, freq);
                            rfdata = getdata(ckt);

                            % Plot the data
                            if  strcmpi(PlotType, 'Composite data')
                                fig = compositeplot(rfdata, tag_cp);
                                set(fig, 'Tag', tag_cp);
                            else
                                % Get the parameter and the format
                                parameter = '';
                                if strcmpi(Vis{idxNetworkData}, 'on')
                                    parameter = Vals{idxNetworkData};
                                elseif strcmpi(Vis{idxSmithData}, 'on')
                                    parameter = Vals{idxSmithData};
                                elseif strcmpi(Vis{idxPolarData}, 'on')
                                    parameter = Vals{idxPolarData};
                                end
                                plotformat = '';
                                if strcmpi(Vis{idxNoneFormat}, 'on')
                                    plotformat = Vals{idxNoneFormat};
                                elseif strcmpi(Vis{idxDBFormat}, 'on')
                                    plotformat = Vals{idxDBFormat};
                                elseif strcmpi(Vis{idxDBMFormat}, 'on')
                                    plotformat = Vals{idxDBMFormat};
                                elseif strcmpi(Vis{idxComplexFormat}, 'on')
                                    plotformat = Vals{idxComplexFormat};
                                end

                                if ~isempty(parameter) && ~isempty(plotformat)
                                    xname = xaxisname(rfdata, parameter);
                                    Udata = collectdata(Udata, parameter, plotformat, ...
                                        PlotType, xname, tag);
                                    fig = singleplot(rfdata, PlotType, Udata.Parameters, ...
                                        Udata.NumParameters, plotformat);
                                    set(fig, 'Tag', tag);
                                    set(rfdata, 'FigureTag', tag);
                                    Udata.PlotType = PlotType;
                                end
                            end
                        end
                        Udata.Tag = tag;
                    end
                end
            end
        end
    catch
        mStr.emsg = lasterr;
        if (strcmpi(get_param(bdroot, 'SimulationStatus'), 'stopped') && DoPlot)
          errordlg(mStr.emsg,'RF Blockset Error');
        end
    end
    mStr.wmsg = lastwarn;
    if strcmpi(get_param(bdroot, 'SimulationStatus'), 'stopped') && (~isempty(mStr.wmsg))
      warndlg(mStr.wmsg,'RF Blockset Warning');
    end
    varargout{1} = mStr;   
    varargout{2} = models;
    varargout{3} = sys;
    set_param(block, 'UserData', Udata);

case 'rfUpdateBlockMask'
    idxOn = [];     
    idxMoreOn = [];  
    idxMoreOff = [];  
    idxEnabOn = [];   
    idxEnabOff = [];
    idxMoreEnabOff = [];
    idxFreqOn = [];
    idxFreqOff = [];
    idxEnabOff = [];
    idxOff = [idxDisplayData, idxPlotFreq, idxFreq, idxAllPlotType, idxNoBudgetPlot, idxNetworkData, ...
        idxSmithData, idxPolarData, idxComplexFormat, idxDBFormat, idxDBMFormat, idxNoneFormat];
    if ~isempty(Udata)
        sys = Udata.System;
        if isa(sys, 'rfmodel.system')
            ckt = sys.OriginalCkt;
            if isa(ckt, 'rfckt.cascade')
                % Set visibilities/enables
                [idxParamOn, idxParamOff] = getparamindex(PlotType, idxSmithData, ...
                idxPolarData, idxNetworkData);
                parameter = Vals{idxParamOn};
                [idxMoreOn,idxMoreOff,idxEnabOn,idxEnabOff]=getformatindex(parameter,...
                    PlotType, idxComplexFormat, idxDBFormat, idxNoneFormat, idxDBMFormat);
                if length(ckt.Ckts) > 1
                    idxOn = [idxParamOn idxDisplayData idxPlotFreq idxFreq idxAllPlotType];
                    idxOff = [idxParamOff idxNoBudgetPlot];
                else
                    idxOn = [idxParamOn idxDisplayData idxPlotFreq idxFreq idxNoBudgetPlot];
                    idxOff = [idxParamOff idxAllPlotType];
                end

                if strcmp(Vals{idxPlotFreq}, 'User specified')
                    idxFreqOn = [idxFreq];
                else
                    idxFreqOff = [idxFreq];
                end
                % More unpdate of visibilities/enables
                if strcmpi(PlotType,'Composite data')
                    idxMoreEnabOff = [idxParamOn idxEnabOn];
                end   
                if strcmpi(DisplayData, 'off') || strcmpi(Vis{idxDisplayData}, 'off')
                    idxMoreEnabOff = [idxAllPlotType idxNoBudgetPlot idxPlotFreq ...
                        idxFreq idxParamOn idxMoreOn idxEnabOn idxFreqOn];
                end
            end
        end
    end
    if ~isempty(idxOn) 
        [En{idxOn}, Vis{idxOn}] = deal('on');
    end
    if ~isempty(idxOff) 
        [En{idxOff}, Vis{idxOff}] = deal('off');
    end
    if ~isempty(idxMoreOn) 
        [En{idxMoreOn}, Vis{idxMoreOn}] = deal('on');
    end
    if ~isempty(idxMoreOff) 
        [En{idxMoreOff}, Vis{idxMoreOff}] = deal('off');
    end
    if ~isempty(idxFreqOn) 
        [En{idxFreqOn}, Vis{idxFreqOn}] = deal('on');
    end
    if ~isempty(idxFreqOff) 
        [En{idxFreqOff}, Vis{idxFreqOff}] = deal('off');
    end
    if ~isempty(idxEnabOn) 
        [En{idxEnabOn}] = deal('on');
    end
    if ~isempty(idxEnabOff) 
        [En{idxEnabOff}] = deal('off');
    end
    if ~isempty(idxMoreEnabOff) 
        [En{idxMoreEnabOff}] = deal('off');
    end
    set_param(block, 'MaskVisibilities', Vis, 'MaskEnables', En);

case 'rfDeleteOutput' 
    fig = findobj('Tag', tag);
    delete(fig);
    fig = findobj('Tag', tag_cp);
    delete(fig);
end

