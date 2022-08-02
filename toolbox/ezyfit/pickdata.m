function [x,y,h] = pickdata(varargin)
%PICKDATA   Picks data from the active curve.
%   [X,Y] = PICKDATA returns the data (X,Y) from the active curve. If
%   several curves are present and none is selected, the first one is
%   picked (see FITPARAM to change this default setting).
%
%   Specific feature for Matlab >= 7.6 : If some data are "brushed", return
%   only those "brushed" data.
%
%   [X,Y] = PICKDATA(H) returns the data (X,Y) of the curve specified by
%   the handle H (eg, GCF, GCO etc). GCF, the current figure, is taken by
%   default.
%
%   For histograms, the X data are taken at the middle of the bins.
%
%   [X,Y,H] = PICKDATA(...) also returns the handle to the current curve.
%
%   See also SELECTDATA, SELECTFIT, SHOWFIT, EZFIT.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.20,  Date: 2008/03/14
%   This function is part of the EzyFit Toolbox

% History:
% 2005/05/31: v1.00, first version.
% 2006/02/23: v1.01, better check if a current figure exists.
% 2006/03/07: v1.02, also works with histogram plots.
% 2006/07/06: v1.03, pick the first or last curve, according to the
%                    variable fp.whichpickdata in fitparam.m
% 2006/10/18: v1.10, new parameter fp ; now takes the mean for x for hist
% 2008/03/14: v1.20 : uses the 'BrushData' field of Matlab 7.6 (for
% EzyFit >=2.30)


hf=get(0,'CurrentFigure');
if isempty(hf)
    error('EzyFit:pickdata:InvalidInput', 'No active figure.');
end

h=gco;
if nargin==1
    if ishandle(varargin{1}),
        h=varargin{1};
    elseif isstruct(varargin{1})
        fp=varargin{1};
    end
elseif nargin==2
    h=varargin{1};
    fp=varargin{2};
end

if ~exist('fp','var')
    % loads the default fit parameters:
    try
        fp=fitparam;
    catch
        error('No fitparam file found.');
    end
end

co=get(h); % search for active curve

% if no active curve, take the 1st curve of the active fig.
if ((isempty(co)) || (~isfield(co,'XData'))),
    ha=get(gcf,'CurrentAxes');
    if ~isempty(ha),
        ca=get(ha);
        if ~isempty(ca.Children),
            if strcmp(fp.whichpickdata,'first'), % new v1.03
                h=ca.Children(end);  % (end) is the first curve
            else
                h=ca.Children(1);  % (1) is the last curve
            end
            co=get(h); 
        else
            error('EzyFit:pickdata:InvalidInput', 'No curve in the active figure.');
        end
    else
        error('EzyFit:pickdata:InvalidInput', 'No axis in the active figure.');
    end
end

x=co.XData;
y=co.YData;
% New v1.20 : uses the 'BrushData' field of Matlab 7.6 (for EzyFit >=2.30)
if isfield(co,'BrushData')
    if any(co.BrushData)
        x=x(co.BrushData==1);
        y=y(co.BrushData==1);
    end
end

%new v1.02: if the data originates from an histogram plot,
%keeps only the 2nd (or 3rd) row:
if size(x,1)~=1,
    x = (x(2,:)+x(3,:))/2;  % changed v1.10
    y=y(2,:);
end

if nargout==0
    x
    y
    clear x y;
end
