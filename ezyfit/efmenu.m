function efmenu(opt)
%EFMENU   Ezyfit menu
%   EFMENU adds the Ezyfit menu for the current figure and for all new
%   figures.
%   EFMENU OFF removes the menu from all the figures and for all new
%   figures.
%
%   If you want to always have the EzyFit menu in your figures, type
%   EFMENU INSTALL. This will create or update the 'startup.m' file in the
%   directory /toolbox/local of your Matlab installation. In addition, at
%   each Matlab restart, this will check the last version of the EzyFit
%   toolbox on the web (see CHECKUPDATE_EF).
%
%   See also PLOTSAMPLE, SHOWFIT, SELECTFIT, FIT, UNDOFIT, RMFIT, EDITFIT, LOADFIT,
%   CHECKUPDATE_EF.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.44,  Date: 2006/09/26
%   This function is part of the EzyFit Toolbox

% History:
% 2005/12/06: v1.00, first version.
% 2005/12/16: v1.01, works with all new figures.
% 2006/01/12: v1.10, User defined fits improved.
% 2006/01/19: v1.20, User defined fits improved again.
% 2006/01/30: v1.21, bug fixed with selectfit. New fit fgauss.
% 2006/02/08: v1.30, use a new mat-file for user defined fits.
%                    polynomial orders as a submenu. New 'Edit Fit Coeff'.
%                    Check for update when launched from startup.m
% 2006/02/16: v1.31, item 'Show Fit Residual' added
% 2006/02/27: v1.40, option 'install' added.
% 2006/03/07: v1.41, option 'install' improved (append to startup.m), and
%                    bug fixed for check of the ml version
% 2006/04/10: v1.42, toobox renamed 'EzyFit'
% 2006/04/24: v1.43, bugs in option 'install' fixed (did not correctly
%                    recognize if the toolbox was already installed)
% 2006/09/06: v1.44, submenu for 'PlotSample'


% check the matlab version:
if str2double(version('-release'))<14,
    error('EzyFit requires Matlab 7 (R14) or higher.');
end;

% if efmenu is called from the file startup.m, then calls
% the Check Update for the Ezyfit Toolbox:
st=dbstack;
if length(st)>=2
    if strcmp(st(2).name,'startup'),
        checkupdate_ef;
    end;
end;


if ~exist('opt','var'), opt='on'; end;

% new v1.30:
userfit=loadfit('user');

switch lower(opt),
    case 'off',
        set(0,'DefaultFigureCreateFcn','');
        delete(findobj('Label','Ezyfit')); % delete the menu from all the figures.
    case 'install',
        install_ef;
    case 'on',
        set(0,'DefaultFigureCreateFcn','efmenu');
        if get(0,'CurrentFigure')
            delete(findobj(gcf,'Label','EzyFit')); % delete the menu only from the current figure
            h=uimenu('Label','EzyFit');
            uimenu(h,'Label','Undo fit','Callback','undofit','Accelerator','Z');
            uimenu(h,'Label','Remove all fits','Callback','rmfit');

            %submenus showfit and selectfit:
            hm(1)=uimenu(h,'Separator','on','Label','Show Fit');
            menuname{1}='showfit';
            hm(2)=uimenu(h,'Label','Select Fit');
            menuname{2}='selectfit';
            for i=1:2,
                uimenu(hm(i),'Label','Linear','Callback',['lastfit=' menuname{i} '(''linear'');']);
                hpol=uimenu(hm(i),'Label','Polynomial');
                for or=1:6,
                    uimenu(hpol,'Label',['Order ' num2str(or)],...
                        'Callback',['lastfit=' menuname{i} '(''poly' num2str(or) ''');']);
                end;
                uimenu(hpol,'Label','Other...','Separator','on','Callback',['lastfit=' menuname{i} '(''poly'');']);
                uimenu(hm(i),'Label','Exponential','Callback',['lastfit=' menuname{i} '(''exp'');']);
                uimenu(hm(i),'Label','Logarithmic','Callback',['lastfit=' menuname{i} '(''log'');']);
                uimenu(hm(i),'Label','Power','Callback',['lastfit=' menuname{i} '(''power'');']);
                uimenu(hm(i),'Label','Gaussian','Callback',['lastfit=' menuname{i} '(''fgauss'');']);

                uimenu(hm(i),'Label','Nearest','Separator','on','Callback',[menuname{i} '(''nearest'');']);
                uimenu(hm(i),'Label','Spline','Callback',[menuname{i} '(''spline'');']);
                uimenu(hm(i),'Label','Cubic','Callback',[menuname{i} '(''cubic'');']);
                
                for j=1:length(userfit)
                    if j==1,
                        uimenu(hm(i),'Label',['#' num2str(j) ': ' userfit(j).name],...
                            'Separator','on','Callback',['lastfit=' menuname{i} '(''' userfit(j).eq ''');']);
                    else
                        uimenu(hm(i),'Label',['#' num2str(j) ': ' userfit(j).name],...
                            'Callback',['lastfit=' menuname{i} '(''' userfit(j).eq ''');']);
                    end;
                end;
                uimenu(hm(i),'Label','Other...','Separator','on','Callback',[menuname{i} ';']);
            end;

            %submenu edit fit:
            hef=uimenu(h,'Label','Edit User Fit');
            for j=1:length(userfit)
                uimenu(hef,'Label',['#' num2str(j) ': ' userfit(j).name],'Callback',['editfit(' num2str(j) ')']);
            end;
            uimenu(hef,'Label','New User Fit...','Separator','on','Callback','editfit');
            uimenu(hef,'Label','Reset','Separator','on','Callback',...
                'if strcmp(questdlg(''Are you sure you want to reset the user defined fits?'',''Reset User Fits'',''No''),''Yes''), delete(''userfit.mat''); efmenu; end;');


            % remainder of the menu:
            uimenu(h,'Label','Edit Fit Coefficients','Callback','editcoeff');
            uimenu(h,'Label','Show Fit Residuals','Callback','showresidual');

            uimenu(h,'Label','Get Slope','Separator','on','Callback','getslope(''eqdialog'')','Accelerator','G');
            uimenu(h,'Label','Show Slope...','Callback','showslope');

            hps=uimenu(h,'Label','Plot Sample','Separator','on');            
            uimenu(hps,'Label','Linear','Callback','plotsample linear');
            uimenu(hps,'Label','Constant','Callback','plotsample cste');
            uimenu(hps,'Label','3 polynomial curves','Callback','plotsample poly2');
            uimenu(hps,'Label','Damped oscillations','Callback','plotsample damposc');            
            uimenu(hps,'Label','Exponential decay','Callback','plotsample exp');
            uimenu(hps,'Label','Histogram with one peak','Callback','plotsample hist');
            uimenu(hps,'Label','Histogram with two peaks','Callback','plotsample hist2');
            uimenu(hps,'Label','Power law','Callback','plotsample power');
            uimenu(hps,'Label','Power law with a cutoff','Callback','plotsample powco');          
            
            hqc=uimenu(h,'Label','Scales','Separator','on');
            uimenu(hqc,'Label','Swap X-axis lin <-> log','Callback','swx');
            uimenu(hqc,'Label','Swap Y-axis lin <-> log','Callback','swy');
            uimenu(hqc,'Label','Swap both X- and Y- axis','Callback','sw','Accelerator','B');

            uimenu(h,'Label','Default Settings...','Separator','on','Callback','edit fitparam');
            uimenu(h,'Label','Help EzyFit','Callback','doc ezyfit');
            uimenu(h,'Label','Check for update','Callback','checkupdate_ef(''dialog'')');
            uimenu(h,'Label','EzyFit Home Page','Callback','web http://www.fast.u-psud.fr/ezyfit -browser');
            uimenu(h,'Label','About EzyFit','Callback','about_ef(''dialog'')');
        end;
    otherwise
        error('Unknown option');
end;


% -----------------------------------------
% Subfunction 'efmenu install'


function install_ef

sufile = fullfile(matlabroot,'toolbox','local','startup.m');
ft = [];
if exist(sufile,'file'),
    try
        ft = textread(sufile,'%s');
    catch
        ft = [];
    end;
end;
if length(ft),
    for num = 1:length(ft),
        if strfind(ft{num},'efmenu'),
            disp('The EzyFit menu is already installed in your startup.m file:');
            disp(sufile);
            return;
        end;
    end;
    copyfile(sufile,fullfile(matlabroot,'toolbox','local','startup_previous.m'));
    fid=fopen(sufile,'a');
    fprintf(fid,'%s\n',' ');
    fprintf(fid,'%s\n',['%   These lines have been added by ''efmenu install'' (' datestr(now) '):']);
    fprintf(fid,'%s\n','efmenu;   % Includes the EzyFit menu for all new figure.');
    fprintf(fid,'%s\n\n','fprintf('' To get started with the EzyFit toolbox, select <a href="matlab:doc ezyfit">EzyFit</a> from the Help browser.\n\n'');');    
    fclose(fid);
    
    disp('The EzyFit menu has been correctly installed.');
    disp('To get started, select <a href="matlab:doc ezyfit">EzyFit</a> from the Help browser.');

else % creates a new startup.m file and re-calls install_ef:
    fid=fopen(sufile,'w');
    fprintf(fid,'%s\n','%STARTUP   Startup file');
    fprintf(fid,'%s\n','%   This file is executed when MATLAB starts up.');
    fprintf(fid,'%s\n',' ');
    fclose(fid);
    install_ef;
end;
