function [X,gmean] = mameannorm(X,varargin)
%MAMEANNORM normalizes microarray data by dividing by global mean.
%
%   XNORM = MAMEANNORM(X) divides the values in each column of X by the
%   mean column intensity. 
%
%   [XNORM, COLMEAN] = MAMEANNORM(X) returns the column means used to scale
%   the data.
%
%   MAMEANNORM(...,'PRCTILE',PCT) scales the mean of the PCT percentile of
%   the data. This is useful to prevent large outliers from skewing the
%   normalization.
%
%   MAMEANNORM(...,'GLOBAL',TRUE) divides the values in the data set by the
%   global mean of the data, as opposed to the mean of each column of the
%   data.
%
%   Examples:
%
% 		maStruct = gprread('mouse_a1wt.gpr');
% 		Red = maStruct.Data(:,4);
% 		Green = maStruct.Data(:,13);
%       maloglog(Red,Green,'factorlines',true)
%       figure
%       normRed = mameannorm(Red);
%       normGreen = mameannorm(Green);
%       maloglog(normRed,normGreen,'title','Normalized','factorlines',true)
%
%   See also MALOWESS, MAMADNORM.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.6.4.2 $   $Date: 2004/01/24 09:18:31 $


pct = 100;
globalFlag = false;

% deal with the various inputs
if nargin > 2
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'prctile','global'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % span
                    if ~isnumeric(pval)
                        error('Bioinfo:PrctileMustBeNumeric','PRCTILE must be a numeric value');
                    end
                    pct = pval;
                    if pct < 0 || pct > 100
                        error('Bioinfo:PrctileMustBe0To100','PRCTILE must be in the range 0 to 100.');
                    end
                case 2 % global flag
                    globalFlag = opttf(pval);
                    if isempty(globalFlag)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k)))); 
                    end    
            end
        end
    end 
end   

if globalFlag 
    origSize = size(X);
    X = X(:);
end

% have to deal with prctile differently
if pct <100
    Xtemp = X;
    pctMask = X > repmat(prctile(X,pct),size(X,1),1);
    Xtemp(pctMask) = NaN;
    gmean = nanmean(Xtemp);
else
    gmean = nanmean(X);
end

X = X./repmat(gmean,size(X,1),1);

if globalFlag 
    X = reshape(X,origSize);
end
