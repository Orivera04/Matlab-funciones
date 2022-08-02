function out=get(gr,varargin)
% GRAPH1D/GET   GET interfaace for Graph1d object.
%  Implements get interface for graph1d object
%  Currently supported properties are:
%    'Position'
%    'Visible'
%    'Currentfactor'
%    'Data'
%    'Factors'
%    'Parent'
%    'Histogram'
%    'Histogramcolor'
%    'Histogrambars'
%
%  The following return a handle, allowing you to set handle graphics properties
%  (NOTE - this could break the object if you're not careful!)
%      'background'
%      'axes'
%      'line'
%      'text'
%      'popup'
%      'histogramaxes'
%      'histogrampatch'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:27:58 $

%  Date: 16/9/1999

% Bail if we've not been given a graph1d object
if ~isa(gr,'mvgraph1d')
    error('Cannot set properties: not a mvgraph1d object!')
end


% loop over varargin
for n=1:(nargin-1)
    switch lower(varargin{n})
        case 'position'
            out=get(gr.axes,'userdata');      
        case 'visible'
            out=get(gr.factorsel,'visible'); 
        case {'data','number','value'}
            out=get(gr.line,'userdata'); 
        case 'factors'
            out=get(gr.factorsel,'string');
        case 'currentfactor'
            out=get(gr.factorsel,'value');
        case 'histogram'
            if get(gr.hist.axes,'userdata')
                out='on';
            else
                out='off';
            end
        case 'histogramcolor'
            out=get(gr.hist.patch,'userdata');
            out=out.colours;
        case 'histogrambars'
            out=get(gr.hist.patch,'userdata');
            out=out.numbars;
            if isempty(out)
                out='auto';
            end
        case 'limits'
            out=get(gr.factortext,'userdata');
        case 'frame'
            out={'off','on'};
            ud=get(gr.hist.patch,'userdata');
            out=out{ud.frameon+1};
        case 'background'
            out=gr.patch;
        case 'axes'
            out=gr.axes;
        case 'line'
            out=gr.line;
        case 'text'
            out=gr.factortext;
        case 'popup'
            out=gr.factorsel;
        case 'parent'
            out=get(gr.axes,'parent');
        case 'histogramaxes'
            out=gr.hist.axes;
        case 'histogrampatch'
            out=gr.hist.patch;
        case 'datatags'
            out = 'none';
        case 'customdatatags'
            out = {};
    end
end