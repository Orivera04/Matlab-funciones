function [nds,cheaders,vals,numcol,colsize,recurse] = listinfo(T,tpfilter)
%LISTINFO  return headers and values for node in a list
%
%   [NDs,HDRs,VALs,NUMCOLs,COLSIZEs,DOCHILDREN] = LISTINFO(ND,tpfilter)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.2 $  $Date: 2004/02/09 08:24:28 $

if matchtype(typeobject(T),tpfilter)
    nds = address(T);
    cheaders = {'Type','Inputs','Lower Output Limit', 'Upper Output Limit', 'Description'};
    colsize = [85 200 100 100 200];
    numcol = [false, false, true, true, false];
    
    this = info(getdata(T));
    inputs = getinputs(this);
    if isempty(inputs)
        inputstr = '';
    else
        input_strings = pveceval(inputs, @getname);
        inputstr = sprintf('%s, ', input_strings{:});
        inputstr(end-1:end) = [];
    end
    
    clips = get(this, 'clips');
    clipmin = clips(1);
    clipmax = clips(2);
    if isnan(clipmin)
        clipmin = 'NaN';
    elseif isinf(clipmin)
        clipmin = '-Inf';
    end
    if isnan(clipmax)
        clipmax = 'NaN';
    elseif isinf(clipmax)
        clipmax = 'Inf';
    end
    
    vals = {get(this, 'type'), inputstr, clipmin, clipmax, description(get(this, 'model'))};
else
    nds = [];
    cheaders = {};
    vals = {};
    numcol = false(0);
    colsize = [];
end
recurse=1;
