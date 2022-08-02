function fout = selectfit(varargin)
%SELECTFIT  Fit part of the data from the active curve (remove outliers)
%   SELECTFIT displays the fit specified in a dialog box for the data
%   selected from the active curve by drawing a lasso. Use the left mouse
%   button to draw the lasso. Use UNDOFIT or RMFIT to remove the fit.
%   The default display settings are defined in the file FITPARAM.
%
%   *** Note: This function is not fully stable.
%       If you use Matlab >= 7.6, it is encouraged to use
%       SHOWFIT with the "Data Brushing" mode instead of SELECTFIT.
%       SELECTFIT will be removed in future releases of EzyFit. 
%
%   By default, the first curve in the active figure is used (see FITPARAM
%   to change this default behavior). To fit another curve, select it
%   before calling SELECTFIT.
%
%   SELECTFIT(FUN) specifies the fitting string FUN. FUN may be either a
%   default fit (eg, 'exp', 'power'), a user-defined fit (see EDITFIT),
%   or directly a fit equation (eg, 'c+a*exp(-x/x0)'). See EZFIT for the
%   syntax of FUN. FUN may also be any valid interpolation method string
%   (eg 'spline', 'cubic'... excepted 'linear'). See INTERP1 for the valid
%   interpolation methods.
%
%   SELECTFIT(F) use the equation defined in the fit structure F.
%
%   SELECTFIT(..., 'PropertyName','PropertyValue',...) specifies the 
%   properties of the fit (e.g., fit colors, line width etc.). See the
%   default values in the file FITPARAM.
%
%   F = SELECTFIT(...) also returns the fit structure F. F has the same
%   content as the fit structure returned by EZFIT (see EZFIT for details),
%   and also contains a handle to the equation box and to the curve.
%
%   Note that if the option 'lin' or 'log' is not specified in the string
%   FUN, SELECTFIT checks the Y-scale of the current figure to determine
%   whether Y or LOG(Y) has to be fitted.
%
%   Examples:
%      plotsample power
%      selectfit('power; log');
%
%      plotsample poly2
%      f = selectfit('z(v) = poly3','fitcolor','red','fitlinestyle',':');
%      editcoeff(f);
%
%   See also SHOWFIT, EZFIT, UNDOFIT, RMFIT, PLOTSAMPLE, SELECTDATA, INTERP1.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 2.30,  Date: 2007/09/11
%   This function is part of the EzyFit Toolbox

% History:
% 2005/10/17: v1.00, first version.
% 2005/10/18: v1.01, no display if no output arg.
% 2005/10/31: v1.10, also displays R. text is displayed in an annotation
%                    box. now uses pickdata. also accepts interpolation.
% 2005/11/03: v1.20, use the file 'fitparam.m' for the fit default values.
% 2005/11/05: v1.21, also displays the lin/log mode
% 2005/12/06: v1.30, opens a dialog box if the fitting function string is
%                    not specified.
% 2005/12/12: v1.31, display a message after each fit
% 2005/12/13: v1.32, starts with the dialog box if the order for the
%                    polynomial fit is not specified.
% 2005/12/20: v1.33, display the message box only if fp.selectfitmsgbox is 
%                    'on' in fitparam.
% 2006/01/28: v1.34, first check if a curve is present.
% 2006/02/08: v2.00, new syntax. now works with the fit structure F.
% 2006/02/10: v2.01, displays the legend.
% 2006/02/16: v2.02, use evalfit
% 2006/02/27: v2.03, bug fixed for lin/log.
% 2006/03/08: v2.04, idem v1.32
% 2006/09/04: v2.10, temporarilly hide the legend (drawpolygon is buggy
%                    when a legend is present).
%                    '$' and '!' accepted instead of ';'
% 2006/09/06: v2.11, bug fixed when f.hdata is an invalid handle
% 2006/10/18: v2.20, accepts additional input parameters to chnage the
%                    default settings.  new option 'selectfitloopmode'
% 2007/09/11: v2.30, now uses John D'Errico's "selectdata" (File 13857)
%                    instead of Ezyfit's originals drawpolygon/selectdata



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit parameters:  (new v2.20)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% loads the default fit parameters:
try
    fp=fitparam;
catch
    error('No fitparam file found.');
end


% change the default values of the fit parameters according to the
% additional input arguments:
for nopt=1:(nargin-1)
    if any(strcmp(varargin{nopt},fieldnames(fp))) % if the option string is one of the fit parameter
        fp.(varargin{nopt}) = varargin{nopt+1};
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input arguments:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0,
    efroot=fileparts(mfilename('fullpath'));   % directory where the ezyfit toolbox is installed
    prevfitfile=[efroot filesep 'prevfit.mat'];
    if exist(prevfitfile,'file'),
        load(prevfitfile);
    else
        fun='a*exp(-x/x_0); a=10; x_0=0.1';
    end
    fun=inputdlg('Enter a default fit, a user-defined fit or directly a fit equation',...
        'General Curve Fit Definition',1,{fun});
    if ~isempty(fun)
        fun=fun{1};
        fun=strrep(fun,'$',';');  % new v2.10
        fun=strrep(fun,'!',';');
        save(prevfitfile,'fun');
        % if the option 'lin' or 'log' is not specified, use the Y-scale of
        % the current figure:
        if (isempty(findstr(strrep(fun,' ',''),';lin'))) && (isempty(findstr(strrep(fun,' ',''),';log'))),
            mode=get(gca,'YScale');
            fun=strrep([fun ';' mode(1:3)],';;',';');
        end
        f=ezfit(fun); % fit the whole data
    else
        return;
    end
elseif nargin>=1,
    if isstruct(varargin{1}), % if argument is a structure
        f=varargin{1};
    elseif ischar(varargin{1}), % if argument is a string
        fun=varargin{1};
        fun=strrep(fun,'$',';');  % new v2.10
        fun=strrep(fun,'!',';');
        if sum(strcmp(fun,{'nearest','spline','pchip','cubic','v5cubic'})),
            f.name=fun;
            [f.x, f.y, f.hdata]=pickdata(fp);
        else  % if the string is not an interpolation  
            if strcmp(fun,'poly'), % new v2.04
                str_ord=inputdlg('Order of the polynomial fit','Polynomial order',1,{'2'});
                if ~isempty(str_ord),
                    fun=['poly' str_ord{1}];
                else
                    return;
                end
            end
            % if the option 'lin' or 'log' is not specified, use the Y-scale of
            % the current figure:
            if (isempty(findstr(strrep(fun,' ',''),';lin'))) && (isempty(findstr(strrep(fun,' ',''),';log'))),
                mode=get(gca,'YScale');
                fun=strrep([fun ';' mode(1:3)],';;',';');
            end
            f.name=fun;
            [f.x, f.y, f.hdata]=pickdata(fp);
        end
    else
        error('Use selectfit with a string or a fit structure.');
    end
end


% output fit structure: idem as f, but with additional information.
fout=f;



% determines the fit color:
if ischar(fp.fitcolor) || length(fp.fitcolor)==3
    fitcolor=fp.fitcolor; % fixed color
else
    fitcolor=[0 0 0]; % default color if no data in the figure
    if isfield(f,'hdata')
        if ishandle(f.hdata)
            co=get(f.hdata); % object properties of the data
            if isfield(co,'Color'),
                fitcolor=max(0,min(1,co.Color*fp.fitcolor)); % color indexed from that of the data
            end
        end
    end
end

% size of the markers during the fit procedure:
if ishandle(f.hdata)
    co=get(f.hdata); % object properties of the data
    if isfield(co,'MarkerSize'),
        sizeselectpt=min(3,co.MarkerSize-1); % size of selected points, slightly smaller than data
    else
        sizeselectpt=3;
    end
else
    sizeselectpt=3;
end


if strcmp(fp.selectfitmsgbox,'on'),
    % new v1.31, changed v1.33
    hmsg=annotation('textbox',[.2 .35 .4 .1],'BackgroundColor',[1 .95 .95],...
        'EdgeColor','red','Color','red','String',...
        {'Make a selection,','or click right mousebutton to exit.'});
    pause(1);
    delete(hmsg);
end

if isempty(legend)  % new v2.10
    islegend = false;
else
    islegend = true;
    legend off
end


contfit = true;

while contfit
    
    contfit = strcmp(fp.selectfitloopmode,'on');  % new v2.20
    
    try
        % newv2.30: uses D'Errico's selectdata
         listhandle=get(gca,'Children');
        [dummy,xs,ys] = selectdata('Ignore',listhandle(listhandle~=f.hdata));
    catch
        xs = [];
    end
    
    if ~isempty(xs)   % non-empty selection
        fout.xs=xs;
        fout.ys=ys;
        % deletes the previous fit (if any):
        if isfield(fout,'hfit'), delete(fout.hfit); end
        if exist('hfit','var'), delete(hfit); end
        if exist('hsel','var'), delete(hsel); end
        if exist('heqbox','var'), delete(heqbox); end
        switch f.name
            case {'nearest','spline','pchip','cubic','v5cubic'},

                % determines the X points used to compute and display the
                % fitted curve (an interpolation cannot be extrapolated!)
                if strcmp(get(gca,'XScale'),'log'),
                    xfit=logspace(log10(min(xs)),log10(max(xs)),fp.npt);
                else
                    xfit=linspace(min(xs),max(xs),fp.npt);
                end

                yfit = interp1(xs,ys,xfit,fout.name);
                
                % makes the equation box:
                if strcmp(fp.dispeqboxmode,'on')
                    if strcmp(fp.selectfitloopmode,'on')
                        heqbox = showeqbox(fout,fp,'transparent');
                    else
                        heqbox = showeqbox(fout,fp);
                    end                
                end
                
            otherwise
               
                fun = fout.name;
                if nargin<=1,
                    fout=ezfit(xs,ys, fun);
                else
                    fout=ezfit(xs,ys, fun, varargin{2:end});
                end
                fout.hdata = f.hdata;

                % determines the X points used to compute and display the fitted curve
                switch(fp.extrapol),
                    case 'none',
                        xminfit=min(xs);  xmaxfit=max(xs);
                    case 'data'
                        xminfit=min(fout.x);  xmaxfit=max(fout.x);
                    case 'fig',
                        icg=get(gca);
                        xminfit=icg.XLim(1);  xmaxfit=icg.XLim(2);
                end
                if strcmp(get(gca,'XScale'),'log'),
                    xfit=logspace(log10(xminfit),log10(xmaxfit),fp.npt);
                else
                    xfit=linspace(xminfit,xmaxfit,fp.npt);
                end
                
                % evaluate the fit function:
                yfit = evalfit(fout, xfit);

                % makes the equation box:
                if strcmp(fp.dispeqboxmode,'on')
                    if strcmp(fp.selectfitloopmode,'on')
                        heqbox = showeqbox(fout,fp,'transparent');
                    else
                        heqbox = showeqbox(fout,fp);
                    end                
                end
        end

        % plots the interpolated / fitted curve:
        hold on;
        fout.hfit=plot(xfit,yfit,'Color',fitcolor,'LineStyle',fp.fitlinestyle,'LineWidth',fp.fitlinewidth);
        set(fout.hfit,'UserData', 'fit'); % this tag is useful to delete the fit later
        if ~isempty(fp.markerselectpt)
            hsel=plot(xs,ys,'Color',fitcolor,'Marker',fp.markerselectpt,'LineStyle','none','MarkerSize',sizeselectpt);
            set(hsel,'UserData','seldata');
        end
        hold off;
        
        if strcmp(fp.selectfitmsgbox,'on') && strcmp(fp.selectfitloopmode,'on')
            % new v1.31, changed v1.33
            hmsg=annotation('textbox',[.2 .35 .4 .1],'BackgroundColor',[1 .95 .95],...
                'EdgeColor','red','Color','red','String',...
                {'Make another selection,','or click right mousebutton to confirm this one.'});
            pause(1);
            delete(hmsg);
        end
        
    else  % empty polygon => end of fitting process
        contfit=false;
        % at the end of the fitting process the box is no more transparent:
        if exist('heqbox','var'),
            set(heqbox,'BackgroundColor','white');
        end
    end

end


if isfield(fout,'hfit'); % if a fit has been done
    % output fit structure
    fout.heqbox = heqbox;
    delete(hsel);
    
    % give a 'DisplayName' to the fit:
    if length(fout.name)>10,
        fitname='fit';
    else
        fitname=greekize(fout.name);
    end
    setautodisplayname; % give a name to all the data in the figure (if they don't have one yet)
    if ishandle(fout.hdata)
         try
            dataname = get(fout.hdata,'DisplayName');
        catch
            dataname = 'data';
        end
        fitname=[fitname ' (' dataname ')'];
    end
    set(fout.hfit,'DisplayName',fitname);

    if islegend
        legend show   % put back the legend (new v2.10)
    end
                
    % updates the legend:
    if strcmp(fp.dispfitlegend,'on')
        legend off  % refresh the legend
        legend show
    end
    
    % opens the Array Editor with the fit coefficients:
    if (strcmp(fp.editcoeffmode,'on') && (isfield(fout,'m'))),
        editcoeff(fout);
    end
    
    % displays the fit equation in the command window if no output
    % argument:
    if ~nargout
        if isfield(fout,'m'),
            if strcmp(fp.dispeqmode,'on') % new v2.30
                dispeqfit(fout,fp);
            end
        end
        clear fout
    end
else
    if islegend
        legend show;   % put back the legend (new v2.10)
    end
    if ~nargout
        clear fout
    else
        fout=[];
    end
end
