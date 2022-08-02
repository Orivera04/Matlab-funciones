function [bct, bclambda] = boxcox(varargin)
%BOXCOX transforms non-normally distributed data to normally distributed data.
%
%   [TRANSDAT, LAMBDA] = boxcox(DATA) transforms the data vector DATA using
%   the Box-Cox Transformation method into the vector TRANSDAT.  It also 
%   calculates the transformation parameter LAMBDA.  DATA must be positive.
%   The Box-Cox Transformation is the family of power transformation:
%
%      DATA(LAMBDA) = ((DATA^LAMBDA) - 1) / LAMBDA;     if LAMBDA ~= 0,
%
%   or
%
%      DATA(LAMBDA) = log(DATA);                        if LAMBDA == 0.
%
%   Here, 'log' is the natural logarithm (log base e).  The algorithm calls
%   for finding the LAMBDA value that maximizes the Log-Likelihood Function
%   (LLF).  The search is conducted using FMINSEARCH.
%
%   TRANSDAT = boxcox(LAMBDA, DATA) transforms the data vector DATA using
%   a certain specified LAMBDA for the Box-Cox Transformation.  This syntax
%   does not find the optimum LAMBDA that maximizes the LLF.  DATA must be 
%   positive.
%
%   Example:   load disney.mat
%              dis_CloseBC = boxcox(dis_CLOSE);
%              hist(dis_CloseBC);
%
%   See also FMINSEARCH.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:27:58 $

% Input checks.
switch nargin
case 1      % Syntax:  BCT = boxcox(DATA);
    flag = 0;
case 2      % Syntax:  BCT = boxcox(LAMBDA, DATA);
    flag = 1;
case 3      % Syntax:  BCT = boxcox(LAMBDA, DATA, FLAG);
    flag = varargin{3};
otherwise   % Error if number of input arguments is not 1, 2, or 3.
    error('Ftseries:ftseries_boxcox:TooManyInputArguments', ...
       'Too many input arguments. Maximum of 3 inputs.');
end

% SWITCH yard for function calls.
switch flag
case 0  % The gateway; this is where this function starts.
    % Get the data vector.
    x = varargin{1};
    if size(x, 1) ~= 1 & size(x, 2) ~= 1
        error('Ftseries:ftseries_boxcox:InputMustBeVector', ...
           'Input DATA must be a vector.');
    end
    if any(x < 0)
        error('Ftseries:ftseries_boxcox:DataMustBePositive', ...
           'Input DATA must be positive.');
    end
    
    % Find the lambda that minimizes of the Log-Likelihood function;
    % FMINSEARCH is used here so that we don't need to provide a set
    % of boundary initial conditions.  We only need a number as the 
    % starting point of search.
    options = optimset('MaxFunEvals', 2000, 'Display', 'off');
    bclambda = fminsearch('boxcox', 0, options, x, 2);
    
    % Generate the transformed data using the optimal lambda.
    bct = boxcox(bclambda, x, 1);
case 1   % Calculates the Box-Cox Transformation of data vector.
    % Get the lambda and data vectors.
    lambda = varargin{1};
    x = varargin{2};
    
    % Get the length of the data vector.
    n = length(x);
    
    % Make sure that the lambda vector is a column vector.
    lambda = lambda(:);
    
    % Pre-allocate the matrix for the transformed data vector, xhat.
    xhat = zeros(length(x), length(lambda));
    
    % Find where the non-zero and zero lambda's are.
    nzlambda = find(lambda ~= 0);
    zlambda = find(lambda == 0);
    
    % Create a matrix of the data by replicating the data vector 
    % columnwise.
    mx = x * ones(1, length(lambda));
    
    % Create a matrix of the lambda by replicating the lambda vector 
    % rowwise.
    mlambda = (lambda * ones(length(x), 1)')';
    
    % Calculate the transformed data vector, xhat.
    bct(:, nzlambda) = ((mx(:, nzlambda).^mlambda(:, nzlambda))-1) ./ ...
        mlambda(:, nzlambda);
    bct(:, zlambda) = log(mx(:, zlambda));
case 2   % The Log-Likelihood function (LLF) to be minimized.
    % Get the lambda and data vectors.
    lambda = varargin{1};
    x = varargin{2};
    
    % Get the length of the data vector.
    n = length(x);
    
    % Transform data using a particular lambda.
    xhat = boxcox(lambda, x, 1);
    
    % The algorithm calls for maximizing the LLF; however, since we have
    % only functions that minimize, the LLF is negated so that we can 
    % minimize the function instead of maximixing it to find the optimum
    % lambda.
    bct = -(n/2).*log(std(xhat', 1, 2).^2) + (lambda-1)*(sum(log(x)));
    bct = -bct;
end

% [EOF]