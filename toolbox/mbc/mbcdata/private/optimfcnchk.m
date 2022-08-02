function [allfcns,msg] = optimfcnchk(funstr,caller,lenVarIn,gradflag,hessflag,constrflag)
% OPTIMFCNCHK Pre- and post-process function expression for FUNCHK.
%   [ALLFCNS,MSG] = OPTIMFCNCHK(FUNSTR,CALLER,lenVarIn,GRADFLAG) takes
%   the (nonempty) function handle or expression FUNSTR from CALLER with 
%   LenVarIn extra arguments, parses it according to what CALLER is, then 
%   returns a string or inline %   object in ALLFCNS.  If an error occurs, 
%   this message is put in MSG.
%
%   ALLFCNS is a cell array: 
%    ALLFCNS{1} contains a flag 
%    that says if the objective and gradients are together in one function 
%    (calltype=='fungrad') or in two functions (calltype='fun_then_grad')
%    or there is no gradient (calltype=='fun'), etc.
%    ALLFCNS{2} contains the string CALLER.
%    ALLFCNS{3}  contains the objective (or constraint) function
%    ALLFCNS{4}  contains the gradient function
%    ALLFCNS{5}  contains the hessian function (not used for constraint function).
%  
%    NOTE: we assume FUNSTR is nonempty.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/04/04 03:26:22 $

% Initialize
if nargin < 6
    constrflag = 0;
    if nargin < 5
        hessflag = 0;
        if nargin < 4
            gradflag = 0;
        end,end,end

if constrflag
    graderrmsg = 'Constraint gradient function expected (OPTIONS.GradConstr=''on'') but not found.';
    warnstr = ...
        sprintf('%s\n%s\n%s\n','Constraint gradient function provided but OPTIONS.GradConstr=''off'';', ...
        '  ignoring constraint gradient function and using finite-differencing.', ...
        '  Rerun with OPTIONS.GradConstr=''on'' to use constraint gradient function.');
else
    graderrmsg = 'Gradient function expected (OPTIONS.GradObj=''on'') but not found.';
    warnstr = ...
        sprintf('%s\n%s\n%s\n','Gradient function provided but OPTIONS.GradObj=''off'';', ...
        '  ignoring gradient function and using finite-differencing.', ...
        '  Rerun with OPTIONS.GradObj=''on'' to use gradient function.');
    
end
msg='';
if isequal(caller,'fseminf')
    nonlconmsg =  ['SEMINFCON must be a function.'];    
else
    nonlconmsg =  ['NONLCON must be a function.'];
end
allfcns = {};
funfcn = [];
gradfcn = [];
hessfcn = [];
if gradflag & hessflag 
    calltype = 'fungradhess';
elseif gradflag
    calltype = 'fungrad';
else % ~gradflag & ~hessflag,   OR  ~gradflag & hessflag: this problem handled later
    calltype = 'fun';
end

% {fun}
if isa(funstr, 'cell') & length(funstr)==1
    % take the cellarray apart: we know it is nonempty
    if gradflag
        error(graderrmsg)
    end
    [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
    if ~isempty(msg)
        if constrflag % Constraint, not objective, function, so adjust error message
            msg = nonlconmsg;
        end
        error(msg)
    end
    % {fun,[]}      
elseif isa(funstr, 'cell') & length(funstr)==2 & isempty(funstr{2})
    if gradflag
        error(graderrmsg)
    end
    [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end  
    
    % {fun, grad}   
elseif isa(funstr, 'cell') & length(funstr)==2 % and ~isempty(funstr{2})
    
    [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end  
    [gradfcn, msg] = fcnchk(funstr{2},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg =nonlconmsg;
        end
        error(msg);
    end
    calltype = 'fun_then_grad';
    if ~gradflag
        warning(warnstr);
        calltype = 'fun';
    end
    % {fun, [], []}   
elseif isa(funstr, 'cell') & length(funstr)==3 ...
        & ~isempty(funstr{1}) & isempty(funstr{2}) & isempty(funstr{3})
    if gradflag
        error(graderrmsg)
    end
    if hessflag
        error('Hessian function expected but not found.')
    end
    [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end  
    % {fun, grad, hess}   
elseif isa(funstr, 'cell') & length(funstr)==3 ...
        & ~isempty(funstr{2}) & ~isempty(funstr{3})
    [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end  
    [gradfcn, msg] = fcnchk(funstr{2},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end
    [hessfcn, msg] = fcnchk(funstr{3},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end
    calltype = 'fun_then_grad_then_hess';
    if ~hessflag & ~gradflag
        hwarnstr = sprintf('%s\n%s\n%s\n','Hessian and gradient functions provided ', ...
            '  but OPTIONS.HEssian=''off'' and OPTIONS.GradObj=''off''; ignoring Hessian and gradient functions.', ...
            '  Rerun with OPTIONS.Hessian=''on'' and OPTIONS.GradObj=''on'' to use derivative functions.');
        warning(hwarnstr)
        calltype = 'fun';
    elseif hessflag & ~gradflag
        warnstr = ...
            sprintf('%s\n%s\n%s\n','Hessian and gradient functions provided ', ...
            '  but OPTIONS.GradObj=''off''; ignoring Hessian and gradient functions.', ...
            '  Rerun with OPTIONS.Hessian=''on'' and OPTIONS.GradObj=''on'' to use derivative functions.');
        warning(warnstr)
        calltype = 'fun';
    elseif ~hessflag & gradflag
        hwarnstr = ...
            sprintf('%s\n%s\n%s\n','Hessian function provided but OPTIONS.Hessian=''off'';', ...
            '  ignoring Hessian function,', ...
            '  Rerun with OPTIONS.Hessian=''on'' to use Hessian function.');
        warning(hwarnstr);
        calltype = 'fun_then_grad';
    end
    
    % {fun, grad, []}   
elseif isa(funstr, 'cell') & length(funstr)==3 ...
        & ~isempty(funstr{2}) & isempty(funstr{3})
    if hessflag
        error('Hessian function expected but not found.')
    end
    [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end  
    [gradfcn, msg] = fcnchk(funstr{2},lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end
    calltype = 'fun_then_grad';
    if ~gradflag
        warning(warnstr);
        calltype = 'fun';
    end
    
    % {fun, [], hess}   
elseif isa(funstr, 'cell') & length(funstr)==3 ...
        & isempty(funstr{2}) & ~isempty(funstr{3})
    error('Hessian function given without gradient function.')
    
elseif ~isa(funstr, 'cell')  %Not a cell; is a string expression, function name string or inline object
    [funfcn, msg] = fcnchk(funstr,lenVarIn);
    if ~isempty(msg)
        if constrflag
            msg = nonlconmsg;
        end
        error(msg);
    end   
    if gradflag % gradient and function in one function/M-file
        gradfcn = funfcn; % Do this so graderr will print the correct name
    end  
    if hessflag & ~gradflag
        hwarnstr = ...
            sprintf('%s\n%s\n%s\n','OPTIONS.Hessian=''on''', ...
            '  but OPTIONS.GradObj=''off''; ignoring Hessian and gradient functions.', ...
            '  Rerun with OPTIONS.Hessian=''on'' and OPTIONS.GradObj=''on'' to use derivative functions.');
        warning(hwarnstr)
    end
    
else
    errmsg = sprintf('%s\n%s', ...
        'FUN must be a function or an inline object;', ...
        ' or, FUN may be a cell array that contains these type of objects.');
    error(errmsg)
end

allfcns{1} = calltype;
allfcns{2} = caller;
allfcns{3} = funfcn;
allfcns{4} = gradfcn;
allfcns{5} = hessfcn;

