function [return1,return2] = spparms(arg1,arg2)
%SPPARMS Set parameters for sparse matrix routines.
%
%	SPPARMS('key',value) sets one or more of the "tunable" parameters 
%	used in the sparse linear equation operators, \ and /, and the
%	minimum degree orderings, COLMMD and SYMMMD.
%
%	SPPARMS, by itself, prints a description of the current settings.
%
%	If no input argument is present, values = SPPARMS returns a
%	vector whose components give the current settings.
%	[keys,values] = SPPARMS returns that vector, and also returns
%	a character matrix whose rows are the keywords for the parameters.
%
%	SPPARMS(values), with no output argument, sets all the parameters
%	to the values specified by the argument vector.
%
%	value = SPPARMS('key') returns the current setting of one parameter.
%
%	SPPARMS('default') sets all the parameters to their default settings.
%	SPPARMS('tight') sets the minimum degree ordering parameters to their 
%	"tight" settings, which may lead to orderings with less fill-in, but 
%	which makes the ordering functions themselves use more execution time.
%
%	The parameters with the default and "tight" values are:
%
%	                 keyword       default       tight
%
%	   values(1)     'spumoni'      0
%	   values(2)     'thr_rel'      1.1          1.0
%	   values(3)     'thr_abs'      1.0          0.0
%	   values(4)     'exact_d'      0            1
%	   values(5)     'supernd'      3            1
%	   values(6)     'rreduce'      3            1
%	   values(7)     'wh_frac'      0.5          0.5
%	   values(8)     'autommd'      1            
%	   values(9)     'aug_rel'      0.001      
%	   values(10)    'aug_abs'      0   
%
%	The meanings of the parameters are
%
%	   spumoni:  The Sparse Monitor Flag controls diagnostic output;
%	             0 means none, 1 means some, 2 means too much.
%	   thr_rel,
%	   thr_abs:  Minimum degree threshold is thr_rel*mindegree + thr_abs.
%	   exact_d:  Nonzero to use exact degrees in minimum degree,
%	             Zero to use approximate degrees.
%	   supernd:  If > 0, MMD amalgamates supernodes every supernd stages.
%	   rreduce:  If > 0, MMD does row reduction every rreduce stages.
%	   wh_frac:  Rows with density > wh_frac are ignored in COLMMD.
%	   autommd:  Nonzero to use minimum degree orderings with \ and /.
%	   aug_rel,
%	   aug_abs: Residual scaling parameter for augmented equations is
%	            aug_rel*max(max(abs(A))) + aug_abs.
%	            For example, aug_rel = 0, aug_abs = 1 puts an unscaled
%	            identity matrix in the (1,1) block of the augmented matrix.
%	           
%	See also COLMMD, SYMMMD, SPAUGMENT.

%	John Gilbert and Cleve Moler, 7-21-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% The following are "constants".

allkeys = ['spumoni'
           'thr_rel'
           'thr_abs'
           'exact_d'
           'supernd'
           'rreduce'
           'wh_frac'
           'autommd'
           'aug_rel'
           'aug_abs' ];
nparms = size(allkeys,1);
spuparmrange = 1:1;   % Which parameters pertain to SPUMONI?
mmdparmrange = 2:7;   % Which parameters pertain to minimum degree?
bslparmrange = 8:10;  % Which parameters pertain to sparse backslash?
defaultparms = [0 1.1 1.0 0 3 3 0.5 1 0.001 0]';
tightmmdparms   = [1.0 0.0 1 1 1 0.5]';

% First find out what the current parameters are.

oldvalues = zeros(nparms,1);
oldvalues(spuparmrange) = sparsfun('spumoni');
oldvalues(mmdparmrange) = sparsfun('mmdset');
oldvalues(bslparmrange) = sparsfun('slashset');

% No input args, no output args:  Describe current settings.
if nargin == 0 & nargout == 0
    a = num2str(oldvalues(1));
    if oldvalues(1) 
        disp(['SParse MONItor output level ' a '.'])
    else 
        disp(['No SParse MONItor output.'])
    end
    a = num2str(oldvalues(2));
    b = num2str(oldvalues(3));
        disp(['mmd: threshold = ' a ' * mindegree + ' b ','])
    if oldvalues(4) 
        disp(['     using exact degrees in A''*A,'])
    else 
        disp(['     using approximate degrees in A''*A,'])
    end
    s = int2str(oldvalues(5));
    if oldvalues(5)
        disp(['     supernode amalgamation every ' s ' stages,'])
    else
        disp(['     no supernode amalgamation,'])
    end
    s = int2str(oldvalues(6));
    if oldvalues(6) 
        disp(['     row reduction every ' s ' stages,'])
    else
        disp(['     no row reduction,'])
    end
    a = num2str(100*oldvalues(7));
    if oldvalues(7)
        disp(['     withhold rows at least ' a '% dense in colmmd.'])
    else
        disp(['     no row withholding in colmmd.'])
    end
    if oldvalues(8)
        disp(['Minimum degree orderings used by \ and /.'])
    else
        disp(['No automatic orderings used by \ and /.'])
    end
    a = num2str(oldvalues(9));
    b = num2str(oldvalues(10));
    if oldvalues(9) & oldvalues(10)
        disp(['Residual scale parameter = ' a ' * max(abs(A)) + ' b '.']);
    elseif oldvalues(9)
        disp(['Residual scale parameter = ' a ' * max(abs(A)).']);
    else
        disp(['Residual scale parameter = ' b '.'])
    end
    return;

% No input args, one or two output args:  Return current settings.
elseif nargin == 0 & nargout > 0
    if nargout <= 1
        return1 = oldvalues;
    else
        return1 = allkeys;
        return2 = oldvalues;
    end
    return;

% One input arg of suitable size:  Reset all parameters.
elseif nargin == 1 & max(size(arg1)) == nparms & min(size(arg1)) == 1
    if nargout > 0 
        error ('Too many output arguments.')
    end
    sparsfun('spumoni',arg1(spuparmrange));
    sparsfun('mmdset',arg1(mmdparmrange));
    sparsfun('slashset',arg1(bslparmrange));
    return;

% Input arg 'tight':  Reset minimum degree parameters.
elseif nargin == 1 & strcmp(lower(arg1),'tight')
    if nargout > 0
        error ('Too many output arguments.')
    end
    newvalues = oldvalues;
    newvalues(mmdparmrange) = tightmmdparms;
    spparms(newvalues);
    return;

% Input arg 'default':  Reset all parameters.
elseif nargin == 1 & strcmp(lower(arg1),'default')
    if nargout > 0
        error ('Too many output arguments.')
    end
    spparms(defaultparms);
    return;

% One input arg:  Return one current setting.
elseif (nargin == 1)
    if ~isstr(arg1)
        error ('Option argument must be a string.')
    end
    if nargout > 1
        error ('Too many output arguments')
    end
    if size(arg1,1) > 1
        error ('Must query one parameter by keyword at a time')
    end
    key = lower(arg1);
    for i = 1:nparms
        if strcmp (key, allkeys(i,:))
            return1 = oldvalues(i);
            return;
        end
    end
    error (['Unknown keyword parameter "' key '"']);

% Two input args:  Reset some parameters.
elseif (nargin == 2)
    if ~isstr(arg1)
        error ('Option argument must be a string.')
    end
    if nargout > 0
        error ('Too many output arguments.')
    end
    if size(arg1,1) ~= max(size(arg2))
        error ('Number of parameters and keywords must agree')
    end
    newvalues = oldvalues;
    for k = 1:size(arg1,1)
        key = lower(arg1(k,:));
        value = arg2(k);
        found = 0;
        for i = 1:nparms
            if strcmp (key, allkeys(i,:))
                newvalues(i) = value;
                found = 1;
                break
            end
        end
        if ~found
            disp (['Warning:  Unknown keyword parameter "' key '" in SPPARMS.']);
        end
    end
    spparms(newvalues);
    return;
   
% No error is possible here.
else
    error ('Invalid arguments')
end
