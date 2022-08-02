function [bestafr, bestspk] = mbcweoptimizer(tq, speed, load, varargin)
%MBCWEOPTIMIZER An example of a user specific optimization
%
%   MBCWEOPTIMIZER solves the problem "max TQ over (AFR, SPK) at a given
%   (N, L) point".  The API for this example function mimics that used by
%   Optimization Toolbox functions.
%
%   [BESTAFR, BESTSPK] = MBCWEOPTIMIZER(TQ,SPEED,LOAD) finds a maximum
%   (BESTAFR, BESTSPK) to the function TQ.  TQ must be a function (or a
%   function handle) with inputs AFR, SPK, SPEED and LOAD only.
%
%   [BESTAFR, BESTSPK] = MBCWEOPTIMIZER(TQ,SPEED,LOAD,AFRRNG,SPKRNG) finds
%   a maximum (BESTAFR, BESTSPK)  to the function TQ.  AFRRNG and SPKRNG
%   are 1-by-2 row vectors containing search ranges for those variables. 
%
%   [BESTAFR, BESTSPK] = MBCWEOPTIMIZER(TQ,SPEED,LOAD,AFRRNG,SPKRNG,RES)
%   finds a maximum (BESTAFR, BESTSPK)  to the function TQ.  This
%   optimization is performed over a RES-by-RES grid of (AFR, SPK)  values.
%   If RES is not specified, the default grid resolution is 100.
%
%   [BESTAFR, BESTSPK] = MBCWEOPTIMIZER(... ,OPTIMSTORE) finds  a maximum
%   (BESTAFR, BESTSPK) to the function TQ within a CAGE optimization
%   script.  OPTIMSTORE is passed to this function when it is called from
%   the evaluation action of your  optimization script.  In this case, TQ
%   must be a function handle that takes the inputs AFR, SPK, SPEED, LOAD
%   and OPTIMSTORE in that order.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:56:35 $

% Set up some defaults
speedvals = [];
loadvals = [];
afrrng = [10 20];
spkrng = [-10 60];
res = 25;
optimstore = [];

% Apply user inputs
if nargin > 2
   speedvals = speed;
   loadvals = load;
else
   error('mbc:mbcweoptimizer:InvalidArgument', 'This function requires at least three inputs.');
end

if nargin > 3
   afrrng = varargin{1};
end

if nargin > 4
   spkrng = varargin{2};
end

if nargin > 5
   res = varargin{3};
end

if nargin > 6
   optimstore = varargin{4};
end

% Initalise outputs
maxfun = -Inf;
bestafr = [];
bestspk = [];

% Create the search grid in (afr, spk)
afrvals = linspace(afrrng(1), afrrng(2), res)';
spkvals = linspace(spkrng(1), spkrng(2), res)';

% Create the following matrix of points to evaluate
%     (afr[1]     spk[1]   speed    load)
%     (afr[2]     spk[1]   speed    load)
%     (  .           .        .        .)
%     (  .           .        .        .)
%     (afr[res]   spk[1]   speed    load)
%     (afr[1]     spk[2]   speed    load)
% X = (afr[2]     spk[2]   speed    load)
%     (  .           .        .        .)
%     (  .           .        .        .)
%     (afr[res]   spk[2]   speed    load)
%     (  .           .        .        .)
%     (  .           .        .        .)
%     (afr[res]   spk[res] speed    load)
temp = zeros(length(afrvals), 1);
temp(:) = spkvals(1);
X = [afrvals temp];
for i=2:length(spkvals)
    temp = zeros(length(afrvals), 1);
    temp(:) = spkvals(i);
    X = [X;[afrvals temp]];
end

% Convert X into a cell array of input 
% vars for the objective function handle TQ.
Y = [];
for i=1:size(X,2)
   Y{i} = X(:,i);
end
Y{3} = speed;
Y{4} = load;

% Evaluate TQ
if nargin > 6
   thiseval = feval(tq, Y{:}, optimstore);
else
   thiseval = feval(tq, Y{:});
end

% Perform a search to find maximum torque
[themax, index] = max(thiseval);

% Translate index to best spk, egr
remainder = rem(index, length(afrvals));
if remainder == 0
    bestafr = afrvals(end);
else
    bestafr = afrvals(remainder);
end
bestspk = spkvals(ceil(index/length(afrvals)));
