function f = fit(varargin)
%FIT   Fit data with arbitrary fitting function
%   FIT(FUN) fits the active curve with the function FUN. See below for the
%   syntax of FUN. If FUN is not specified, 'linear' is used.
%
%   FIT(X,Y,FUN) or FIT(Y,FUN) fit the data (X,Y) (or Y) with the function
%   FUN (see below for the syntax of FUN). X and Y must be vectors of
%   equal length. If X is not specified, X=[1, 2, 3...] is used.
%
%   Note that FIT only computes the coefficients, but does not display the
%   fit. Use SHOWFIT to display the fit, or SELECTFIT to fit only a part of
%   the current curve.
%
%   By default, the first curve in the active figure is used (see FITPARAM
%   to change this default behavior). To fit another curve, select it
%   before calling FIT. 
%
%   The function string FUN can be:
%      - the name of a predefined fitting function (see below).
%      - the name of a user-defined fitting function (see EDITFIT).
%      - an equation, in the form 'y(x)=...', where 'x' represents the
%        X-data, and all the other variables are parameters to be fitted
%        ('a', 'x_0', 'tau', ...). If the left-hand-side 'y(x)' is not
%        specified, 'x' is taken for the X-Data. All the parameter names
%        are accepted, except Matlab reserved strings ('sin', 'pi', ...)
%
%   The predefined fitting functions are:
%      - linear             y = m * x
%      - affine or poly1    y = a*x + b
%      - poly{n}            y = a0 + a1 * x + ... + an * x^n
%      - power              y = c*x^n
%      - sin                y = a * sin (b * x)
%      - cos                y = a * cos (b * x)
%      - exp                y = a * exp (b * x)
%      - log                y = a * log (b * x)
%      - cngauss            y = exp(-x^2/(2*s^2))/(2*pi*s^2)^(1/2)
%      - cfgauss            y = a*exp(-x^2/(2*s^2))
%      - ngauss             y = exp(-(x-x0)^2/(2*s^2))/(2*pi*s^2)^(1/2)
%      - gauss              y = a*exp(-(x-x0)^2/(2*s^2))
%   ('ngauss' is a 2-parameters normalized Gaussian, and 'gauss' is a
%   3-parameters non-normalized (free) Gaussian. 'cngauss' and 'cfgauss'
%   are centered normalized/free Gaussian.)
%
%   By default, all the starting guesses for the coefficients are taken as 1.
%   However, nonlinear fits often require to specify the starting guesses
%   (it is sufficient to choose values that have the correct sign and correct
%   order of magnitude, eg 0.01, 1, 100...). The starting guesses for the
%   coefficients of the fit may be specified in two ways:
%     - directly in the string FUN, after the fit definition, eg:
%          'c0 + a*sin(pi*x/lambda); c0=1; a=0.1; lambda=100'
%          ('!' or '$' may also be used instead of ';').
%     - by specifying them as an additional input argument for FIT, eg:
%          FIT(x,y,'c0 + a*sin(pi*x/lambda)',[0.1 1 100]);
%       (note that in this case the parameters must be ordered alphabetically).
%
%   By default, Y is fitted in linear mode. If you want to fit LOG(Y)
%   instead, you must specify the option 'log' to the string FUN, separeted
%   by the symbol ';' or '$' or '!' (eg, FUN='a*x^n;log'). This is
%   specially useful to fit power laws with equally weighted points in a
%   log scale.  If nothing specified, the option 'lin' is used.
%
%   Example:   plotsample('power'), and compare
%              fit('power;lin')  and  fit('power;log')
%
%   F = FIT(...) does the same, but also returns a structure F having the
%   following fields:
%      - name       name of the fit
%      - eq         equation of the fit
%      - param      cell array of strings: names of the parameters
%      - m          values of the coefficients
%      - m0         initial guess for the coefficients
%      - r          correlation coefficient R (Pearson's correlation)
%      - fitmode    'lin' (y is fitted) or 'log' (log(y) is fitted) mode
%
%   This structure F can be further used with SHOWFIT, SELECTFIT, DISPEQFIT,
%   SHOWEQBOX, MAKEVARFIT and EDITCOEFF.
%
%   From F, you can get the values of the fitted parameters. If you want to
%   create in the current Matlab workspace the variables associated to
%   these parameters, use MAKEVARFIT (or see the option 'automakevarfit' in
%   FITPARAM).
%
%   The correlation coefficient R is defined as (SSR/(SSE+SSR))^(1/2), where
%      SSR = sum ((y_fit - mean(y)).^2)   % sum of squared residuals
%      SSE = sum ((y_fit - y).^2)         % sum of squared errors
%   (see http://mathworld.wolfram.com/CorrelationCoefficient.html)
%
%   Examples:
%     plotsample('damposc');
%     f = fit('u(t) = c + u_a * sin(2*pi*t/T) * exp(-t/tau); T=5; tau=20');
%     showfit(f);
%     
%     plotsample('poly2');
%     [x,y] = pickdata;
%     f = fit(x, y, 'z(v) = poly3');
%     editcoeff(f);
%
%     plotsample('poly2');
%     f = fit('beta(z) = poly2');
%     showfit(f, 'fitcolor', 'red', 'fitlinewidth', 2);
%
%   See also SELECTFIT, SHOWFIT, PLOTSAMPLE, DISPEQFIT, EDITCOEFF,
%   FMINSEARCH, MAKEVARFIT, FITPARAM.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 2.30,  Date: 2006/10/18
%   This function is part of the EzyFit Toolbox


% History:
% 2005/05/12: v1.00, first version.
% 2005/05/20: v1.10, Use 'eval', with generic functions
% 2005/05/21: v1.11, added the 'lin','log' options.
% 2005/05/24: v1.12, option 'log' by default for 'power' and 'exp'.
% 2005/07/27: v1.13, cosmetics.
% 2005/09/03: v1.14, check arg.
% 2005/10/07: v1.15, gaussian fits added (ngauss and fgauss, centered/not)
% 2005/10/20: v1.16, help text changed.
% 2005/10/31: v1.20, also returns R. cste and poly{n} fits added. Initial
%                    guess defined within the fitting function string. The
%                    order of the output parameters is changed.
% 2005/11/05: v1.21, evaluate strings for initial guess in FUN
% 2005/12/06: v1.22, opens a dialog box if the polynomial order is not
%                    specified.
% 2006/01/13: v1.24, check for negative data in log mode
% 2006/01/19: v1.25, bug fixed from 1.24
% 2006/01/25: v1.26, check the matlab version
% 2006/02/08: v2.00, new syntax. The output argument is now a fit
%                    structure, and the fitting equation string accepts
%                    arbitrary parameter names.
% 2006/02/14: v2.10, lhs 'y(x)=...' now accepted. Now case sensitive
% 2006/03/07: v2.11, bug fixed from v1.25
% 2006/03/09: v2.20, weigthed chi-square criterion (ie: error bars accepted
%                    for y).
% 2006/09/04: v2.21, '!' and '$' may be used instead of ';' in the FUN
%                    string: this allows to pass the argument like:
%                    fit power!log
% 2006/09/28: v2.22, 'x^1' replaced by 'x' for 1st order polynomial
% 2006/10/18: v2.30, input raw and column vectors accepted. accepts
%                    additional input parameters to chnage the default settings.


% new v1.26, changed v2.11
if str2double(version('-release'))<14,
    error('EzyFit requires Matlab 7 (R14) or higher.');
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit parameters:  (new v2.30)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% loads the default fit parameters:
try
    fp=fitparam;
catch
    error('No fitparam file found.');
end;


% change the default values of the fit parameters according to the
% additional input arguments:
for nopt=1:(nargin-1)
    if any(strcmp(varargin{nopt},fieldnames(fp))) % if the option string is one of the fit parameter
        fp.(varargin{nopt}) = varargin{nopt+1};
    end;
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input arguments:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0, % if no input argument: do a linear fit of the current curve
    [x,y,h] = pickdata(fp);
    inputstr='linear';
elseif nargin==1
    if ischar(varargin{1}),    %    FIT('a*x+b')
        inputstr=varargin{1};
        [x,y,h] = pickdata(fp);
    else                       %    FIT(y)
        y=varargin{1};
        x=1:length(y);
        inputstr='linear';
    end;
else   % 2 or more input arguments
    if ~isnumeric(varargin{1})           % FIT('fun',...)
        inputstr=varargin{1};
        [x,y,h] = pickdata(fp);
        if isnumeric(varargin{2})    % FIT('fun',m0,...)
            m0=varargin{2};
        end;
    elseif (isnumeric(varargin{1}) && ~isnumeric(varargin{2}))       % FIT(y,'a*x+b',...)
        [y,inputstr]=deal(varargin{1:2});
        x=1:length(y);
        if nargin>2
            if isnumeric(varargin{3})   % FIT(y,'a*x+b',m0,...)    
                m0=varargin{3};       
            end;
        end;
    elseif (isnumeric(varargin{1}) && isnumeric(varargin{2}))   % FIT(x,y,...)
        [x,y]=deal(varargin{1:2});      
        if nargin>2
            if ischar(varargin{3})
                inputstr=varargin{3};      % FIT(x,y,'fun',...)
                if nargin>3
                    if isnumeric(varargin{4})      % FIT(x,y,'fun',m0,...)
                        m0=varargin{4};
                    end;
                end;
            else
                error('Syntax error. 3rd paramater of FIT should be a string.');
            end;
        end;
    end;
end;               



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some checks about x and y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% turn all input vectors into row (1xN) vectors (new v2.30):
if size(x,1)>size(x,2),
    x=x';
end;
if size(y,1)>size(y,2),
    y=y';
end;

% check for error bars for y (new v2.20):
if size(y,1)>1
    y = y(1,:);   % first line = data
    dy = y(2,:);  % second line = error bars (1/weight)
else
    dy = ones(1,length(y));
end;

if length(x)~=length(y),
    error('X and Y dimensions must agree.');
end;







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% processing of the string FUN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cleans the input string:
inputstr = strrep(inputstr,' ','');
inputstr = strrep(inputstr,'!',';');
inputstr = strrep(inputstr,'$',';');
inputstr = strrep([inputstr ';'],';;',';'); % ensures that fun is terminated by a ';'.

% the name of the fit is by default the first part of the input string
p=findstr(inputstr,';'); p=p(1);
f.name = inputstr(1:(p-1));

% separates the first part (fitting function itself) and the remainder:
p = strfind(inputstr,';'); p=p(1);
fun = inputstr(1:(p-1));
remfun = inputstr((p+1):end);


% search for predefined fit or user-defined fit
[defaultfit, userfit] = loadfit;
for i=1:length(defaultfit),
    if strcmp(fun, defaultfit(i).name);
        fun = defaultfit(i).eq;
    end;
end;
for i=1:length(userfit),
    if strcmp(fun, userfit(i).name),
        fun = userfit(i).eq;
    end;
end;


% separates again the first part (fitting function itself) and the remainder:
% (because the predefined/user-defined part may itself contain ';')
fun = [strrep(fun,' ','') ';' remfun];
p=strfind(fun,';'); p=p(1);
remfun = fun((p+1):end);
fun = fun(1:(p-1));


% recognize if a lhs is present
peq = strfind(fun,'=');
if length(peq),
    lhs = fun(1:(peq-1));    % left-hand side
    rhs = fun((peq+1):end);  % right-hand side
else
    lhs = '';
    rhs = fun;
end;


% process the lhs (if present)
if length(lhs),
    pob = strfind(lhs,'('); % position of opening bracket
    pcb = strfind(lhs,')'); % position of closing bracket
    if length(pob)
        if pob==1,
            f.yvar = 'y';
        else
            f.yvar = lhs(1:(pob-1));
        end;
        f.xvar = lhs((pob+1):(pcb-1));
    else
        f.yvar = lhs;
        f.xvar = 'x';
    end;
else % if no lhs present:
    f.xvar='x';
    f.yvar='y';
end;


% process the 'poly' (polynomial fit) in the rhs
if strfind(rhs,'poly'),   % polynomial fit:
    order=str2double(rhs(5:end));
    if ~length(order), % new v1.22
        str_ord=inputdlg('Order of the polynomial fit','Polynomial order',1,{'2'});
        if length(str_ord),
            order=str2double(str_ord{1});
            f.name=['poly' str_ord{1}];
        else
            clear f;
            return;
        end;
    end;
    if order>20,
        error('Invalid polynom degree.');
    end;
    rhs = [fp.polynom_coeffname '0'];
    for i=1:order,
        if i>1
            rhs = [rhs '+' fp.polynom_coeffname num2str(i) '*' f.xvar '^' num2str(i)];
        else
            rhs = [rhs '+' fp.polynom_coeffname num2str(i) '*' f.xvar];   % new v2.22
        end;
    end;
end;


% search for option 'lin' or 'log':
% (if several are present, use the last one)
% (if none is present, check the Y-scale of the current figure)
% (if no figure present, take 'lin').
fun = strrep([rhs ';' remfun], ';;', ';');
f.fitmode='';
plin=strfind(fun,';lin');
if length(plin), plin=plin(end); else plin=1; end;
plog=strfind(fun,';log');
if length(plog), plog=plog(end); else plog=1; end;
plast=max(plin,plog);
if plast==1, % if nothing specified
    f.fitmode='lin'; % use 'lin'
else
    f.fitmode=fun((plast+1):(plast+3));
end;
fun=strrep(fun,';lin','');
fun=strrep(fun,';log','');


% check for negative data in log mode (new v1.23, fixed 1.24):
if (strcmp(f.fitmode,'log') && sum(y<=0)>0)
    disp('Warning: Zero or negative data ignored');
    nonzero=find(y>0);
    x=x(nonzero);
    y=y(nonzero);
end;


% separates again the first part (fitting function itself) and the
% remainder:
p = strfind(fun,';'); p=p(1);
f.eq = fun(1:(p-1));
remfun = fun((p+1):end);


 % convert the equation in the matlab syntax (parameters named m(1),
 % m(2)...)
[eqml,param] = eq2ml(f.eq, f.xvar);
maxm = length(param); % number of parameters
if maxm==0  % new v2.20
    error('No parameter to be fitted.');
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% processing the initial guess
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initial guess for the m(i) by default (all m(i)=1):
if ~exist('m0','var'), m0=ones(1,maxm); end;

% search for initial guess defined into remfun
remfun = strrep([remfun ';'], ';;', ';'); % adds a final ';'
while strfind(remfun,'='),
    peq=strfind(remfun,'='); peq=peq(1);
    pc=strfind(remfun,';'); pc=pc(1);
    if pc>peq,   % if ';' after '='
        par=remfun(1:(peq-1));
        for i=1:maxm,
            if strcmp(param{i},par),
                m0(i)=eval(remfun((peq+1):(pc-1)));
            end;
        end;
    else
        error('Invalid syntax');
    end;
    remfun=remfun((pc+1):end); % removes the processed i.g. and loops back
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fitting itself
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch f.fitmode,
    case 'lin',
        x__ref = x;
        try
            m=fminsearch(@fitlin, m0);
        catch
            error('Fit: error during the fminsearch procedure');
        end;        
        y_fit = eval(eqml);
        ssr = sum(abs(y_fit-mean(y)).^2);
        sse = sum(abs(y_fit-y).^2);
        f.r=sqrt(ssr/(sse+ssr));
    case 'log',
        x__ref = x;
        try
            m=fminsearch(@fitlog, m0);
        catch
            error('Fit: error during the fminsearch procedure');
        end;
        y_fit = eval(eqml);
        ssr = sum(abs(log(y_fit)-mean(log(y))).^2);
        sse = sum(abs(log(y_fit)-log(y)).^2);
        f.r=sqrt(ssr/(sse+ssr));
    otherwise
        error('Unknown lin/log fit mode');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% fills the output structure:
f.param = param;
f.m = m;
f.m0 = m0;
f.x = x;
f.y = y;
if sum(dy-1) % store the error bars only if defined
    f.dy = dy;
end;
if exist('h','var'), f.hdata=h; end;  % handle to the data

% stores the fit in the variable 'lastfit' in the 'base' workspace:
assignin('base','lastfit',f);

if strcmp(fp.automakevarfit,'on')
    makevarfit;
end;

% ending displays (if no output argument):
if ~nargout
    if strcmp(fp.dispeqmode,'on') % new v2.30
        dispeqfit(f,fp);
    end;
    clear f;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of the main function FIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Nested functions that evaluate the fit for prescribed parameters m(i),
% and return the chi2 (sum of the squared difference between the input
% curve and the fit), in lin or log mode:

    function chi2 = fitlin(m)
        y_fit = eval(eqml);
        chi2 = sum(((y_fit - y).^2)./(dy.^2));
    end

    function chi2 = fitlog(m)
        y_fit = eval(eqml);
        chi2 = sum((log(y_fit)-log(y)).^2);
    end
end
