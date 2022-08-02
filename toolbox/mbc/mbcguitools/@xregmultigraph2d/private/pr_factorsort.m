function pr_factorsort(gr)
%GRAPH2D/PRIVATE/PR_FACTORSORT
%  Private function for sorting out any mismatch between data length and number
%  of given factors

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:32:21 $

%  Updated by: Mungo Stacy
%              28/6/01

ud = get(gr.axes,'userdata');
data=get(gr.xtext,'userdata');
sd=size(data,2);
factors=ud.xfactors;
labels=get(gr.xfactor,'string');
clbls = [];

if isempty(factors)
    factors={};
end

% get current factor selection values
vals=get([gr.xfactor;gr.yfactor],{'value'});

% check values
vals=cat(1,vals{:});
actvals = vals;
if strcmp(labels,' ') & all(vals==1)
    % assume a new-graph case: initialise factor numbers sequentially
    vals(:)=sd;
    vals(1:sd)=[1:sd];
    vals=vals(1:2);
    set(gr.xfactor,'string',{' '});
else
    vals(vals>sd)=sd;
end
vals=num2cell(vals);

ud.xypossible = 0;
switch ud.type
case {'single','table'}
    if ~isempty(data)
        % sort out labels to match data
        if length(factors)>=sd
            lbls=factors(1:sd);
        elseif length(factors)<sd
            lbls=cellstr([repmat('col',sd,1) num2str([1:sd]')]);
            lbls(1:length(factors))=factors;
        end
        if ud.yseltype~=1
            vals{2} = 2;
            vals{1} = i_MatchFactor(lbls,gr.xfactor);
        end
        if vals{2}==vals{1} & ud.exclusive
            if vals{1}==1, vals{2} = 2;
            else, vals{2} = 1;
            end
        end
        clbls = lbls;
        lbls=repmat({lbls},[2 1]);
        set([gr.xfactor;gr.yfactor],{'string','value'},[lbls,vals]);
        ydata = data;
    end
    ud.yseltype = 1;
    
    % Done the standard case.  Now consider multi plot
case {'multi','multinoerror'}
    labels=get(gr.yfactor,'string');
    ydata = get(gr.ytext,'userdata');
    if ~isempty(ydata) & ~isempty(data)
        % Check same size as data
        if size(ydata,1)>size(data,1)
            ydata = ydata(1:size(data,1),:);
            set(gr.ytext,'userdata',ydata);
        elseif size(data,1)>size(ydata,1)
            set(gr.xtext,'userdata',data(1:size(ydata,1),:));
        end
    end
    if ~isempty(data)
        if length(factors)>=sd
            xlbls=factors(1:sd);
        elseif length(factors)<sd
            xlbls=cellstr([repmat('col',sd,1) num2str([1:sd]')]);
            xlbls(1:length(factors))=factors;
        end
    end    
    if isempty(ydata)
        clbls = [];
        ud.checkedyfactors = [];
    else
        clbls = xlbls;
        sd2 = size(ydata,2);
        if length(ud.yfactors)>=sd2
            yfacs = ud.yfactors(1:sd2);
        elseif length(ud.yfactors)<sd2
            yfacs=cellstr([repmat('item',sd2,1) num2str([1:sd2]')]);
            yfacs(1:length(ud.yfactors))=ud.yfactors;
        end
        ud.checkedyfactors = yfacs;
        if ~isempty(ud.yunitstring)
            us = [' (' ud.yunitstring ')'];
        else
            us = '';
        end
        
        if strcmp(ud.type,'multi') & size(ydata,2)==2
            % sort out labels to match data
            ylbls = {['<Selection>' us] ['<X-Y Selection>' us] ...
                    ['Error' us] ['Absolute Error' us] 'Relative Error (%)' ...
                    'Absolute Relative Error (%)'};
            xlbls = {['<X-Y Selection>' us] xlbls{:}};
            if ud.yseltype~=2
                actvals(2)=1;
                [actvals(1),matched] = i_MatchFactor(xlbls,gr.xfactor);
                if ~matched, actvals(1) = 2; end
            end
            ud.yseltype = 2;
            ud.xypossible = 1;
        else
            if ud.yseltype~=3
                [actvals(1),matched] = i_MatchFactor(xlbls,gr.xfactor);
                if ~matched, actvals(1) = 1; end
            end
            ud.yseltype = 3;
            ylbls = {['<Selection>' us]};
        end
        if actvals(2)>length(ylbls)
            actvals(2)=length(ylbls);
        end
        set(gr.yfactor,'string',ylbls,'value',actvals(2));
        
        if ~isempty(data)
            if actvals(1)>length(xlbls)
                actvals(1)=length(xlbls);
            end
            set(gr.xfactor,'string',xlbls,'value',actvals(1));
        end
    end
    
end
% Set colorbar factors
if ud.colorbar & ~isempty(data)
    cdata = get(gr.yfactor,'userdata');
    if all(size(cdata)==size(ydata))
        if isempty(ud.colorfactor)
            cfac = 'Point data';
        else 
            cfac = ud.colorfactor;
        end
        clbls = [{cfac};clbls];
        cbardata = repmat(min(cdata(:)),size(data,1),1);
        cbardata(1) = max(cdata(:));
        cbardata = [cbardata data];
        ud.colordatavalid = 1;
    else
        cbardata = data;
        ud.colordatavalid = 0;
    end

    if ~isempty(clbls)
        set(gr.colorbar,'factors',clbls,'data',cbardata);
        ud.colorbarvalid = 1;
    else
        set(gr.colorbar,'factors',[],'data',[]);
        ud.colorbarvalid = 0;
        ud.colordatavalid = 0;
    end
end


set(gr.axes,'userdata',ud);
return


%-----------------------------------------------------------------------
function [fac,matched] = i_MatchFactor(factors,hndl);
%-----------------------------------------------------------------------
% check currently display x-factor; match up to new one if possible.
fac = get(hndl,'value');
oldfactors = get(hndl,'string');
ind = [];
if iscell(oldfactors) & ismember(fac,1:length(oldfactors))
    name = oldfactors{fac};
    ind = strmatch(name,factors,'exact');
end
if length(ind)==1
    fac = ind;
    matched = 1;
else
    fac = 1;
    matched = 0;
end
