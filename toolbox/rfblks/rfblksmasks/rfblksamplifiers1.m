function varargout = rfblksamplifiers1(block, action)
%RFBLKSAMPLIFIERS1 Mask function for the blocks of the Amplifiers Library

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.16 $  $Date: 2004/05/08 03:15:42 $

% If it is library, call the default setting
if strcmpi(get_param(gcs, 'Name'), 'rfamplifiers1')
%    setdefaultplotmask(block);
    return; 
end

% Get the block parameters
En    = get_param(block, 'MaskEnables');
Vis   = get_param(block, 'MaskVisibilities');
Vals  = get_param(block, 'MaskValues');
Udata = get_param(block, 'UserData');

% Set index to mask parameters
setblockfieldindexes(block);

% Create User Data
if isempty(Udata)
    Udata.Version = 1.0;
    Udata.Ckt = [];
    Udata.Tag = gcb;
    Udata.Parameters = {};
    Udata.NumParameters = 0;
    Udata.PlotType = '';
    Udata.PlotFormat = '';
    Udata.XAxisName = '';
    set_param(block, 'UserData', Udata);
end

% Get the ckt 
ckt = Udata.Ckt;

% Get the inputs
DisplayData = Vals{idxDisplayData};
PlotType = Vals{idxAllPlotType};
if strcmpi(Vis{idxPlotFreq}, 'on')
    FreqData = Vals{idxPlotFreq};
else
    FreqData = Vals{idxPlotFreqNoSim};
end

% Set the tags for the figures of this block
tag_cp = strcat(gcb, '/','CompositePlot');

%**************************************************************************
% Action switch -- Determines which of the callback functions is called
%**************************************************************************
switch(action)
case 'rfInit'
    mStr.emsg = '';
    mStr.wmsg = '';
    lasterr('');
    lastwarn('');
    DoPlot = false;

    try 
        % Check the status 
        DoPlot = strcmpi(get_param(bdroot, 'SimulationStatus'), 'stopped')&& ...
            strcmpi(DisplayData, 'on')&& strcmpi(gcb, Udata.Tag);
        % Create ckt 
        ckt = createrfcktfromblk(block);
        if DoPlot
            freq = [];
            if strcmp(FreqData, 'User specified')
                allparams = get_param(block,'MaskWsVariables');
                freq = allparams(idxFreq).Value;
            elseif (strcmp(FreqData, 'Same as the Frequency parameter') || ...
                    strcmp(FreqData, 'Extracted from RFDATA object'))
                if isa(ckt.RFdata.Reference.NetworkData, 'rfdata.network')
                    freq = ckt.RFdata.Reference.NetworkData.Freq;
                end
                if isempty(freq) && isa(ckt.RFdata.Reference.NoiseData, 'rfdata.noise')
                    freq = ckt.RFdata.Reference.NoiseData.Freq;
                end
                if isempty(freq) && isa(ckt.RFdata.Reference.PowerData, 'rfdata.power')
                    freq = ckt.RFdata.Reference.PowerData.Freq;
                end
            else
                freq = ckt.SimulationFreq;
            end
            % Analyze ckt
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
                elseif strcmpi(Vis{idxPowerData}, 'on')
                    parameter = Vals{idxPowerData};
                end
                plotformat = '';
                if strcmpi(Vis{idxNoneFormat}, 'on')
                    plotformat = Vals{idxNoneFormat};
                elseif strcmpi(Vis{idxDBFormat}, 'on')
                    plotformat = Vals{idxDBFormat};
                elseif strcmpi(Vis{idxComplexFormat}, 'on')
                    plotformat = Vals{idxComplexFormat};
                elseif strcmpi(Vis{idxPowerFormat}, 'on')
                    plotformat = Vals{idxPowerFormat};
                elseif strcmpi(Vis{idxPhaseFormat}, 'on')
                    plotformat = Vals{idxPhaseFormat};
                end
                if ~isempty(parameter) && ~isempty(plotformat)
                    xname = xaxisname(rfdata, parameter);
                    Udata = collectdata(Udata, parameter, plotformat, ...
                        PlotType, xname, gcb);
                    fig = singleplot(rfdata, PlotType, Udata.Parameters, ...
                        Udata.NumParameters, plotformat);
                    set(fig, 'Tag', gcb);
                    set(rfdata, 'FigureTag', gcb);
                    Udata.PlotType = PlotType;
                end
            end
        end
        Udata.Ckt = ckt;
        Udata.Tag = gcb;
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

    % Get the subclass name
    classname = get_param(block,'SubClassName');
    % update the mask, if needed
    if strcmpi(classname,'general-amplifier')
        rfblksamplifiers1(block,'rfDataObject');
    end
    
case 'rfUpdateBlockMask'
    % Set visibilities/enables
    idxFreqOn = [];
    idxFreqOff = [];
    idxMoreEnabOff = [];
    classname = get_param(block,'SubClassName');
    % update the mask, if needed
    if strcmpi(classname,'general-amplifier')
        ckt = Udata.Ckt;
        if isempty(ckt); return; end;
        rfdata = get(ckt, 'RFdata');
        if isempty(rfdata); return; end;
        DataInfo = datainfo(rfdata);
        switch DataInfo
        case {'All Data' 'Power Data with Network Parameters' ...
                'Power Data with Noise Data' 'Power Data Only'}
            [idxParamOn, idxParamOff] = getparamindex(PlotType, idxSmithData, ...
            idxPolarData, idxNetworkData, idxPowerData, true);
        otherwise
            [idxParamOn, idxParamOff] = getparamindex(PlotType, idxSmithData, ...
            idxPolarData, idxNetworkData, idxPowerData, false);
        end
        parameter = Vals{idxParamOn};
        [idxMoreOn,idxMoreOff,idxEnabOn,idxEnabOff]=getformatindex(parameter,...
            PlotType, idxComplexFormat, idxDBFormat, idxNoneFormat, [], [], ...
            idxPowerFormat, idxPhaseFormat);
    else
        [idxParamOn, idxParamOff] = getparamindex(PlotType, idxSmithData, ...
        idxPolarData, idxNetworkData);
        parameter = Vals{idxParamOn};
        [idxMoreOn,idxMoreOff,idxEnabOn,idxEnabOff]=getformatindex(parameter,...
            PlotType, idxComplexFormat, idxDBFormat, idxNoneFormat);
    end
    if ~isa(ckt, 'rfckt.rfckt') || isempty(ckt.SimulationFreq)
        idxOn = [idxParamOn idxDisplayData idxPlotFreqNoSim idxFreq idxAllPlotType];
        idxOff = [idxParamOff idxPlotFreq];
    else
        idxOn = [idxParamOn idxDisplayData idxPlotFreq idxFreq idxAllPlotType];
        idxOff = [idxParamOff idxPlotFreqNoSim];
    end
    if strcmp(FreqData, 'User specified')
        idxFreqOn = [idxFreq];
    else
        idxFreqOff = [idxFreq];
    end
    % More unpdate of visibilities/enables
    if strcmpi(PlotType,'Composite data')
        idxMoreEnabOff = [idxParamOn idxEnabOn];
    end   
    if strcmpi(DisplayData, 'off') || strcmpi(Vis{idxDisplayData}, 'off')
        idxMoreEnabOff = [idxAllPlotType idxPlotFreq idxPlotFreqNoSim idxFreq ...
            idxParamOn idxMoreOn idxEnabOn idxFreqOn];
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

case 'rfDataObject'
    ckt = Udata.Ckt;
    if isempty(ckt); return; end;
    rfdata = get(ckt, 'RFdata');
    if isempty(rfdata); return; end;
    DataInfo = datainfo(rfdata);
    idxOn = [];
    idxOff = [];
    switch DataInfo
    case 'All Data'
        idxOff = [idxIP3Type idxIIP3 idxOIP3 idxNF];
    case 'Power Data with Network Parameters'
        idxOn = [idxNF];
        idxOff = [idxIP3Type idxIIP3 idxOIP3];
    case 'Power Data with Noise Data'
        idxOff = [idxIP3Type idxIIP3 idxOIP3 idxNF];
    case 'Network Parameters With Noise Data'
        ip3type = Vals{idxIP3Type};
        switch ip3type
        case 'IIP3'
            idxOn = [idxIP3Type idxIIP3];
            idxOff = [idxOIP3 idxNF];
        case 'OIP3'
            idxOn = [idxIP3Type idxOIP3];
            idxOff = [idxIIP3 idxNF];
	    end
    case 'Power Data Only'
        idxOn = [idxNF];
        idxOff = [idxIP3Type idxIIP3 idxOIP3];
    case 'Network Parameters Only'
        ip3type = Vals{idxIP3Type};
        switch ip3type
        case 'IIP3'
            idxOn = [idxIP3Type idxIIP3 idxNF];
            idxOff = [idxOIP3];
        case 'OIP3'
            idxOn = [idxIP3Type idxOIP3 idxNF];
            idxOff = [idxIIP3];
	    end
    case 'Noise Data Only'
        ip3type = Vals{idxIP3Type};
        switch ip3type
        case 'IIP3'
            idxOn = [idxIP3Type idxIIP3];
            idxOff = [idxOIP3 idxNF];
        case 'OIP3'
            idxOn = [idxIP3Type idxOIP3];
            idxOff = [idxIIP3 idxNF];
	    end
    end

    if ~isempty(idxOn) 
        [En{idxOn}, Vis{idxOn}] = deal('on');
    end
    if ~isempty(idxOff) 
        [En{idxOff}, Vis{idxOff}] = deal('off');
    end
    set_param(block, 'MaskVisibilities', Vis, 'MaskEnables', En);
                        
case 'rfIP3Type'
    % Get the IP3 type
    if strcmpi(En{idxIP3Type}, 'on')
        ip3type = Vals{idxIP3Type};
        switch ip3type
        case 'IIP3'
            idxOn = [idxIIP3];
            idxOff = [idxOIP3];
        case 'OIP3'
            idxOn = [idxOIP3];
            idxOff = [idxIIP3];
	    end
    else
        idxOn = [];
        idxOff = [idxIIP3 idxOIP3];
    end

    if ~isempty(idxOn) 
        [En{idxOn}, Vis{idxOn}] = deal('on');
    end
    if ~isempty(idxOff) 
        [En{idxOff}, Vis{idxOff}] = deal('off');
    end
    set_param(block, 'MaskVisibilities', Vis, 'MaskEnables', En);
                        
case 'rfDelete' 
    fig = findobj('Tag', gcb);
    delete(fig);
    fig = findobj('Tag', tag_cp);
    delete(fig);
    if ~isempty(Udata)
        if isa(Udata.Ckt, 'rfckt.rfckt'); delete(Udata.Ckt); end;
    end
    
case 'rfDefault'
    setdefaultplotmask(block);
end
