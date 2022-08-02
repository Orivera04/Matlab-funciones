function z = malowess(x,y, varargin)
% MALOWESS smoothes microarray data using the Lowess (or Loess) method.
%
%   YSMOOTH = MALOWESS(X,Y) smoothes scatter data X,Y using the Lowess
%   smoothing method. The default window size is 10% of the length of X.
%
%   MALOWESS(...,'ORDER',order) allows you to choose the order of the
%   algorithm. This can be 1 (linear fit) or 2 (quadratic fit). The default
%   order is 1. 
%   Note that the MATLAB Curve Fitting Toolbox refers to Lowess smoothing
%   of order 2 as Loess smoothing. 
%
%   MALOWESS(...,'ROBUST',TF) uses a robust fit when TF is set to true.
%   This option can take a long time to calculate.
%
%   MALOWESS(...,'SPAN',span) allows you to modify the window size for the
%   smoothing function. If span is less than 1, then the window size is
%   taken to be a fraction of the number of points in the data. If span is
%   greater than 1, then the window is of size span. The default value is
%   0.05, which corresponds to a window size equal to 5% of the number of 
%   points in X. 
%
%   Example:
%
%       maStruct = gprread('mouse_a1wt.gpr');
% 		cy3data = maStruct.Data(:,4);
% 		cy5data = maStruct.Data(:,13);
%       [x,y] = mairplot(cy3data, cy5data);
%       drawnow
%       ysmooth = malowess(x,y);
%       hold on;
%       plot(x,ysmooth,'rx');
%       ynorm = y - ysmooth;
%   
%   See also MAIRPLOT, MALOGLOG, MAMADNORM, MAMEANNORM.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.11.6.3 $   $Date: 2004/01/24 09:18:29 $ 


% Reference: "Trimmed resistant weighted scatterplot smooth" by
% Matthew C Hutcheson.


span = .05;
method = 'lowess';
robustFlag = false;

% deal with the various inputs
if nargin > 2
    if rem(nargin,2) == 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'span','order','robust'};
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
                        error('Bioinfo:LowessSpanNumeric','SPAN must be a numeric value');
                    end
                    span = pval;
                    if span < 0 
                        error('Bioinfo:LowessSpanPositive','SPAN must be a positive value');
                    end
                    if span >numel(x)
                        error('Bioinfo:LowessSpanLessThanX','SPAN must be less than the number of elements in X');
                    end
                    
                case 2 %order
                    if isnumeric(pval)
                        switch(pval)
                            case 1
                                method = 'lowess';
                            case 2
                                method = 'loess';
                            otherwise
                                warning('Bioinfo:LowessBadNumericOrder','Order should be 1 or 2. Using 1.');
                        end
                        
                        
                    elseif ischar(pval)
                        pval = lower(pval);
                        if ~isempty(strmatch(pval,'linear'))
                            method = 'lowess';
                        elseif ~isempty(strmatch(pval,'quadratic'))
                            method = 'loess';
                        else
                            warning('Bioinfo:LowessBadCharOrder','Order should be linear or quadratic. Using linear.');
                        end
                    end
                    
                case 3 % robust flag
                    robustFlag = opttf(pval);
                    if isempty(robustFlag)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k)))); 
                    end
                    
            end
        end
    end
end 

if robustFlag
    method = ['r',method];
end

z = masmooth(x,y,span,method);
z = reshape(z,size(x,1),size(x,2));
