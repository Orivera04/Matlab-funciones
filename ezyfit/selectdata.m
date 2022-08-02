function [xs ys]=selectdata(h,opt)
%SELECTDATA  Select data on the current figure
%   [XS YS] = SELECTDATA selects part of the current curve by drawing a
%   polygon. Double click to exit.
%
%   [XS YS] = SELECTDATA(H) allows to select part of the curve specified by
%   the handle H (eg, GCF, GCO etc). GCF, the current figure, is taken by
%   default, so that the first curve of the figure is used.
%
%   [XS YS] = SELECTDATA(H,'show') also shows the data selected.
%
%   SELECTDATA(H,'keep') deletes the data outside the polygon.
%   SELECTDATA(H,'del') deletes the data inside the polygon.
%   (these two operations are not reversible).
%
%   See also PICKDATA, SELECTFIT, DRAWPOLYGON.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2006/03/07
%   This function is part of the EzyFit Toolbox

% History:
% 2005/10/15: v1.00, first version.
% 2005/10/17: v1.01, minor change.
% 2005/10/31: v1.02, uses pickdata and myginput. waits a pause only if a
%                    polygon is drawn.
% 2005/11/03: v1.10, uses drawpolygon.
% 2006/03/07: v1.11, bug fixed with option 'show'


if ~exist('h','var'), h=gco; end;
if ~exist('opt','var'), opt=''; end;

[x,y,h]=pickdata(h);
co=get(h);
ca=get(gca); % current axe

[xv,yv,hp]=drawpolygon;

if length(xv)>2, % if the polygon has been correctly drawn,
    hold on;
    hpf=patch(xv,yv,[.97 .97 .97]); % fills the polygon
    hold off;
    %drawnow;
    pause(.2);

    % finds the data points which are inside the polygon
    % in log or lin coordinates:
    if isequal(ca.XScale,'log') && isequal(ca.YScale,'log'),
        in=inpolygon(log(co.XData), log(co.YData), log(xv), log(yv));
    elseif isequal(ca.XScale,'log') && isequal(ca.YScale,'linear'),
        in=inpolygon(log(co.XData), co.YData, log(xv), yv);
    elseif isequal(ca.XScale,'linear') && isequal(ca.YScale,'log'),
        in=inpolygon(co.XData, log(co.YData), xv, log(yv));
    elseif isequal(ca.XScale,'linear') && isequal(ca.YScale,'linear'),
        in=inpolygon(co.XData, co.YData, xv, yv);
    end;

    xs=co.XData(in);
    ys=co.YData(in);

    switch lower(opt),
        case 'show',   % creates a new data set, defined as 'fit',
            % which can be deleted by undofit or rmfit.
            try
                fp=fitparam;
            catch
                error('No fitparam file found.');
            end
            if ischar(fp.fitcolor) || length(fp.fitcolor)==3,
                fitcolor=fp.fitcolor; % fixed color
            else
                fitcolor=max(0,min(1,co.Color*fp.fitcolor)); % color indexed from that of the data
            end;
            if length(fp.markerselectpt)
                hold on;
                hsel=plot(xs,ys,'Color',fitcolor,'Marker',fp.markerselectpt,'LineStyle','none','MarkerSize',3);
                hold off;
                set(hsel,'UserData','fit');
            end;
        case 'keep',  % deletes the data not selected
            set(h,'XData',xs);
            set(h,'YData',ys);
        case 'del',  % deletes the data selected
            set(h,'XData',co.XData(~in));
            set(h,'YData',co.YData(~in));
    end;

    delete(hpf); % deletes the filled polygon
    delete(hp); % deletes the contours of the polygon
    %drawnow;

else  % the polygon is not correct (not enough points)
    if exist('hp','var'), delete(hp); end; % deletes the point(s) of the unfinished polygon
    %drawnow;
    xs=[];   ys=[];
end;

% new v1.02:
if nargout==0,
    clear xs ys;
end;
