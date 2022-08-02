function varargout = rfblkspassives1(block, action)
%RFBLKSPASSIVES1 Mask function for the passive RF blocks

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.13 $  $Date: 2004/05/08 03:15:46 $

% If it is library, call the default setting
if (strcmpi(get_param(gcs, 'Name'), 'rftxlines1') || ...
    strcmpi(get_param(gcs, 'Name'), 'rfladderfilters1') || ...
    strcmpi(get_param(gcs, 'Name'), 'rfblackbox1'))
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
            if strcmp(FreqData, 'User specified')
                allparams = get_param(block,'MaskWsVariables');
                freq = allparams(idxFreq).Value;
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
                end
                plotformat = '';
                if strcmpi(Vis{idxNoneFormat}, 'on')
                    plotformat = Vals{idxNoneFormat};
                elseif strcmpi(Vis{idxDBFormat}, 'on')
                    plotformat = Vals{idxDBFormat};
                elseif strcmpi(Vis{idxComplexFormat}, 'on')
                    plotformat = Vals{idxComplexFormat};
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

case 'rfUpdateBlockMask'
    % Set visibilities/enables
    idxFreqOn = [];
    idxFreqOff = [];
    idxMoreEnabOff = [];
    [idxParamOn, idxParamOff] = getparamindex(PlotType, idxSmithData, ...
    idxPolarData, idxNetworkData);
    parameter = Vals{idxParamOn};
    [idxMoreOn,idxMoreOff,idxEnabOn,idxEnabOff]=getformatindex(parameter,...
        PlotType, idxComplexFormat, idxDBFormat, idxNoneFormat);
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

case 'rfTxlineStub'
    load('txlineicon.mat')
    stubmode = Vals{idxStubMode};
    termination = Vals(idxTermination);
    % Set visibilities/enables
    if strcmp(stubmode, 'Not a stub')
        idxOn = [];
        idxOff = [idxTermination];
    else
        idxOn = [idxTermination];
        idxOff = [];
    end
    if ~isempty(idxOn)
        [Vis{idxOn}] = deal('on');
    end
    if ~isempty(idxOff)
        [Vis{idxOff}] = deal('off');
    end
    set_param(block, 'MaskVisibilities', Vis);
    % Update icons
    switch stubmode
        case {'Not a stub'}
            x = x_none;
            y = y_none;

        case {'Shunt'}
            x = x_shunt;
            y = y_shunt;
            if strcmpi(termination, 'Short')
                x = [x NaN x_shunt_short];
                y = [y NaN y_shunt_short];
            end
        case {'Series'}
            x = x_series;
            y = y_series;
            if strcmpi(termination, 'Short')
                x = [x NaN x_series_short];
                y = [y NaN y_series_short];
            end
    end
    aDisp = ['plot([-100,NaN,100],[-100,NaN,100]);plot([',...
        removeSpace(x),'],[',removeSpace(y),'])'];
    % Update text on the icon
    switch upper(strtok(get_param(block, 'MaskType')))
        case {'TRANSMISSION'}
            aDisp = strcat(aDisp, ['text(0,-80,''Transmission Line'',',...
                '''horizontalAlignment'',''center'');']);
        case {'COAXIAL'}
            aDisp = strcat(aDisp, ['text(0,-80,''Coaxial'',',...
                '''horizontalAlignment'',''center'');']);
        case {'MICROSTRIP'}
            aDisp = strcat(aDisp, ['text(0,-80,''Microstrip'',',...
                '''horizontalAlignment'',''center'');']);
        case {'PARALLEL-PLATE'}
            aDisp = strcat(aDisp, ['text(0,-80,''Parallel-Plate'',',...
                '''horizontalAlignment'',''center'');']);
        case {'TWO-WIRE'}
            aDisp = strcat(aDisp, ['text(0,-80,''Two-Wire'',',...
                '''horizontalAlignment'',''center'');']);
        case {'COPLANAR'}
            aDisp = strcat(aDisp, ['text(0,-80,''CPW'',',...
                '''horizontalAlignment'',''center'');']);
    end
    set_param(block, 'MaskDisplay', aDisp)
    
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

%--------------
function x_string = removeSpace(x)
x_string = '';
for k = 1:length(x)
    x_string = strcat(x_string, num2str(x(k)), ', ');
end
