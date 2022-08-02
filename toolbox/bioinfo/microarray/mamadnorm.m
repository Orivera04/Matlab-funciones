function [X,gemad] = mamadnorm(X,varargin)
%MAMADNORM normalizes microarray data by median absolute deviation (MAD).
%
%   XNORM = MAMADNORM(X) divides the values in each column of X by the
%   median absolute deviation of the column. 
%
%   [XNORM, XMAD] = MAMADNORM(X) returns the median absolute deviation.
%
%   MAMADNORM(...,'GLOBAL',true) divides the values in the data set by the
%   global median absolute deviation, as opposed to the median absolute
%   deviation of each column of the data.
%
%   Examples:
%
% 		maStruct = gprread('mouse_a1wt.gpr');
% 		Red = maStruct.Data(:,4);
% 		Green = maStruct.Data(:,13);
%       maloglog(Red,Green,'factorlines',true)
%       figure
%       normRed = mamadnorm(Red);
%       normGreen = mamadnorm(Green);
%       maloglog(normRed,normGreen,'title','Normalized','factorlines',true)
%
%   See also MALOWESS, MAMEANNORM.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.6.4.3 $   $Date: 2004/01/24 09:18:30 $

globalFlag = false;

% deal with the various inputs
if nargin > 2
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'global',''};
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
                case 1  % global flag
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
% MAD(X,1) is median absolute deviation.
gemad = mad(X,1);

X = X./repmat(gemad,size(X,1),1);

if globalFlag 
    X = reshape(X,origSize);
end
