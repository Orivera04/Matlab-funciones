function Udata = collectdata(Udata, parameter, plotformat, plottype, xname, tag)
%COLLECTDATA Collect data for the plot of RF block
%   UDATA = COLLECTDATA(UDATA, PARAMETER, PLOTFORMAT, PLOTTYPE, XNAME, TAG)

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:40:15 $

% The default max number of traces
MaxNumTraces = 4;
fig = findobj('Tag', tag);

% Check the number of traces
if Udata.NumParameters > MaxNumTraces
    for k=1:MaxNumTraces
        parameters{k} = Udata.Parameters{k};
    end
    Udata.Parameters = parameters;
    Udata.NumParameters = MaxNumTraces;
end

parameters = Udata.Parameters;
numbtraces = Udata.NumParameters;

% Collect the data for a figure
if (numbtraces == 0 || isempty(Udata.PlotFormat) || isempty(Udata.PlotType) || ...
        isempty(Udata.XAxisName) || ~strcmpi(Udata.PlotFormat, plotformat) || ...
        ~strcmpi(Udata.PlotType, plottype) || ~strcmpi(xname, Udata.XAxisName) || ...
        isempty(fig))
    parameters = {};
    parameters{1} = parameter;
    numbtraces = 1;
else 
    addnewone = true;
    for k = 1:numbtraces
        if strcmpi(parameters{k}, parameter)
            addnewone = false;
        end
    end
    if addnewone
        if k < MaxNumTraces
            parameters{k+1} = parameter;
            numbtraces = numbtraces + 1;
        else
            tempresp = parameters{k};
            for k = 2:numbtraces
                parameters{k-1} = parameters{k};
            end
            parameters{numbtraces} = parameter;
        end
    end
end

% Update the user data
Udata.Parameters = parameters;
Udata.NumParameters = numbtraces;
Udata.PlotFormat = plotformat;
Udata.PlotType = plottype;
Udata.XAxisName = xname;
