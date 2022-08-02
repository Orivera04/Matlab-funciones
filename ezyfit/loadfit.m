function [fit1, fit2] = loadfit(opt)
%LOADFIT   Load the predefined and the user-defined fitting functions.
%   [DEFAULTFIT, USERFIT] = LOADFIT loads the predefined and the user-
%   defined fitting functions.
%   DEFAULTFIT = LOADFIT('default') loads only the predefined fits.
%   USERFIT = LOADFIT('user') loads only the user-defined fits.
%
%   DEFAULTFIT and USERFIT are structure arrays, that contain two fields,
%   'name' and 'eq'.
%
%   If the file(s) for the predefined and/or the user-defined fits do(es)
%   not exist, LOADFIT creates it (them).
%
%   See also EDITFIT, EFMENU.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2006/02/02
%   This function is part of the EzyFit Toolbox

% History:
% 2006/02/02: v1.00, first version.

if nargin==0, opt='defaultuser'; end;

user=0;
default=0;

% directory where the ezyfit toolbox is installed:
efroot=fileparts(mfilename('fullpath'));

if strfind(lower(opt),'default'),
    default=1;
    % load the predefined fits:
    defaultfitfile=[efroot filesep 'defaultfit.mat'];
    if exist(defaultfitfile,'file'),
        load(defaultfitfile);
    else
        defaultfit(1).name = 'linear';          defaultfit(1).eq = 'm*x';
        defaultfit(2).name = 'affine';          defaultfit(2).eq = 'a*x+b';
        defaultfit(3).name = 'power';           defaultfit(3).eq = 'c*x^n';
        defaultfit(4).name = 'exp';             defaultfit(4).eq = 'a*exp(b*x)';
        defaultfit(5).name = 'log';             defaultfit(5).eq = 'a*log(b*x)';
        defaultfit(6).name = 'sin';             defaultfit(6).eq = 'a*sin(b*x)';
        defaultfit(7).name = 'cos';             defaultfit(7).eq = 'a*cos(b*x)';
        defaultfit(8).name = 'cngauss';         defaultfit(8).eq = 'exp(-(x^2)/(2*sigma^2))/(2*pi*sigma^2)^(1/2)';
        defaultfit(9).name = 'cfgauss';         defaultfit(9).eq = 'a*exp(-(x^2)/(2*sigma^2));a=100';
        defaultfit(10).name = 'ngauss';         defaultfit(10).eq = 'exp(-((x-x_0)^2)/(2*sigma^2))/(2*pi*sigma^2)^(1/2)';
        defaultfit(11).name = 'fgauss';         defaultfit(11).eq = 'a*exp(-((x-x_0)^2)/(2*sigma^2));a=100';
        defaultfit(12).name = 'gauss';          defaultfit(12).eq = 'a*exp(-((x-x_0)^2)/(2*sigma^2));a=100';
        
        save(defaultfitfile,'defaultfit');
    end;
end;


if strfind(lower(opt),'user');
    user=1;
    % load the user-defined fits:
    userfitfile=[efroot filesep 'userfit.mat'];
    if exist(userfitfile,'file'),
        load(userfitfile);
    else
        userfit(1).name = 'fit1';       userfit(1).eq = 'a*exp(-x/tau); a=1; tau=10';
        userfit(2).name = 'fit2';       userfit(2).eq = 'c+(x/x_0)^n';

        save(userfitfile,'userfit');
    end;
end;



% output arguments:
if user && ~default,
    fit1=userfit;
    fit2=[];
elseif default && ~user,
    fit1=defaultfit;
    fit2=[];
elseif default && user,
    fit1=defaultfit;
    fit2=userfit;
end;
