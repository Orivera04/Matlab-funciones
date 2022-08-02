function pr_graphlim(gr)
%GRAPH2d/PRIVATE/PR_GRAPHLIM
%  Private function for sorting out correct limits on axes and colorbar.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:22 $


ud = get(gr.axes,'userdata');
data=get(gr.xtext,'userdata');

minmax=ud.limits;

xval=get(gr.xfactor,'value');
% x limits
if ~isempty(data)
    % check minmax for correct size
    if length(minmax)<size(data,2)
        minmax(end+1:size(data,2))={0};
    elseif length(minmax)>size(data,2)
        minmax(size(data,2)+1:end)=[];
    end
    
    if ud.xypossible
        % Sort out special case
        xval = max(1,xval-1);
    end
    if ischar(minmax{xval}) & strcmp(minmax{xval},'auto')
        xmn=[];
        xmx=[];
    elseif all(minmax{xval}==0)
        xmn=min(data(:,xval));
        xmx=max(data(:,xval));
    else
        xmn=min(minmax{xval});
        xmx=max(minmax{xval});
    end
else
    xmn=0;xmx=1;
end

% Check type - may be using different data and limits on y axis
switch ud.type
case 'table'
    % use same data for y axis
    % y limits
    if ~isempty(data)
        
        yval=get(gr.yfactor,'value');
        if ischar(minmax{yval}) & strcmp(minmax{yval},'auto')
            ymn=[];
            ymx=[];
        elseif all(minmax{yval}==0)
            ymn=min(data(:,yval));
            ymx=max(data(:,yval));
        else
            ymn=min(minmax{yval});
            ymx=max(minmax{yval});
        end
        
    else
        ymn=0;ymx=1;
    end
    
    % Ensure table axes come within limits, if current factor corresponds
    %  to table axis, and table is present.
    tud = get(gr.xfactor,'userdata');
    if ~isempty(tud)
        % Check whether table value is being plotted; include values
        if yval==length(minmax)
            ymn = min([ymn;tud.values(:)]);
            ymx = max([ymx;tud.values(:)]);
        elseif xval==length(minmax)
            xmn = min([xmn;tud.values(:)]);
            xmx = max([xmx;tud.values(:)]);
        end
        if tud.tfactor_i(xval)
            axlim = tud.axes{tud.tfactor_i(xval)};
            xmn = min([xmn;axlim(:)]);
            xmx = max([xmx;axlim(:)]);
            if size(axlim, 1) > 1
                axlim = axlim';
            end
            set(gr.axes,'xtick',axlim,...
                'xticklabel',cellstr(num2str(axlim','%3.2f')));
        else
            set(gr.axes,'xtickmode','auto','xticklabelmode','auto');
        end
        if tud.tfactor_i(yval)
            axlim = tud.axes{tud.tfactor_i(yval)};
            ymn = min([ymn;axlim(:)]);
            ymx = max([ymx;axlim(:)]);
            if size(axlim, 1) > 1
                axlim = axlim';
            end
            set(gr.axes,'ytick',axlim,...
                'yticklabel',cellstr(num2str(axlim','%3.2f')));
        else
            set(gr.axes,'ytickmode','auto','yticklabelmode','auto');
        end
    else
        set(gr.axes,'xtickmode','auto','xticklabelmode','auto',...
            'ytickmode','auto','yticklabelmode','auto');
    end
    
case 'single'
    % use same data for y axis
    % y limits
    if ~isempty(data)
        
        yval=get(gr.yfactor,'value');
        if ischar(minmax{yval}) & strcmp(minmax{yval},'auto')
            ymn=[];
            ymx=[];
        elseif all(minmax{yval}==0)
            ymn=min(data(:,yval));
            ymx=max(data(:,yval));
        else
            ymn=min(minmax{yval});
            ymx=max(minmax{yval});
        end
        
    else
        ymn=0;ymx=1;
    end
    set(gr.axes,'xtickmode','auto','xticklabelmode','auto',...
        'ytickmode','auto','yticklabelmode','auto');
    
case {'multi','multinoerror'}
    % use different data and limits
    data = get(gr.ytext,'userdata');
    minmax = ud.ylimits;
    if ~isempty(data)
        
        if ischar(minmax) & strcmp(minmax,'auto')
            ymn=[];
            ymx=[];
        elseif length(minmax)~=2 | all(minmax==0)
            ymn=min(data(:));
            ymx=max(data(:));
            if ud.xypossible
                % May be X-Y selection
                yval = get(gr.yfactor,'value');
                switch yval
                case 1
                    % ok like this
                case 2
                    xmn = ymn;
                    xmx = ymx;
                otherwise
                    % Error - set to auto
                    ymn = [];
                    ymx = [];
                end
            end
        else
            ymn=min(minmax);
            ymx=max(minmax);
        end
        
    else
        ymn=0;ymx=1;
    end
    set(gr.axes,'xtickmode','auto','xticklabelmode','auto',...
        'ytickmode','auto','yticklabelmode','auto');
end

% do sanity check on min,max

if ~isempty(xmn) & xmn>=xmx
   if xmn==0
      xmn=-0.01;
      xmx=0.01;
   else
      xmn=(1-sign(xmn).*0.01)*xmx;
      xmx=(1+sign(xmx).*0.01)*xmx;
   end
end
if ~isempty(ymn) & ymn>=ymx
   if ymn==0
      ymn=-0.01;
      ymx=0.01;
   else
      ymn=(1-sign(ymn).*0.01)*ymx;
      ymx=(1+sign(ymx).*0.01)*ymx;
   end
end

% check for NaN's
if ~any(isnan([xmn,xmx]))
   if ~isempty(xmn)
      % push min and max apart a smidgeon to fix an R12 axes bug
      delt=(xmx-xmn).*1e-10;
      xmn=xmn-delt;
      xmx=xmx+delt;
      set(gr.axes,'xlim',real([xmn xmx]));
   else
      set(gr.axes,'xlimmode','auto');
   end
end
if ~any(isnan([ymn,ymx]))
   if ~isempty(ymn)
      % push min and max apart a smidgeon to fix an R12 axes bug
      delt=(ymx-ymn).*1e-10;
      ymn=ymn-delt;
      ymx=ymx+delt;
      set(gr.axes,'ylim',real([ymn ymx]));
   else
      set(gr.axes,'ylimmode','auto');
   end
end


return
