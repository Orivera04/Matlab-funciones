function garchplot(varargin)
%GARCHPLOT Plot matched univariate innovations, volatility, and return series.
%   GARCHPLOT is a plotting function designed for visual comparison of matched 
%   innovations, conditional standard deviations, and returns. This function 
%   provides a convenient way to compare simulated (via GARCHSIM) or estimated
%   (via GARCHFIT) innovations series with companion conditional standard 
%   deviations, and/or returns series. It can also be used to plot forecasts
%   (via GARCHPRED) of conditional standard deviations and returns.
%
%   garchplot(Innovations)
%   garchplot(Innovations , Sigma , Series)
%
%   Optional Inputs: Sigma, Series
%
% Input:
%   Innovations - Vector or matrix of innovations. As a vector, Innovations 
%     represents a single realization of a univariate time series in which the
%     first element contains the oldest observation and the last element the 
%     most recent. As a matrix, each column of Innovations represents a single 
%     realization of a univariate time series in which the first row contains 
%     the oldest observation of each realization and the last row the most 
%     recent. If Innovations is empty ([]), then Innovations is not displayed.
%
% Optional Inputs:
%   Sigma - Vector or matrix of conditional standard deviations. In general, 
%     Innovations and Sigma are the same size, and form a matching pair of 
%     arrays. If Sigma is empty ([]) or missing, then Sigma is not displayed.
%
%   Series - Vector or matrix of asset returns. In general, Series is the same 
%     size as Innovations and Sigma, and is organized in exactly the same 
%     manner. If Series is empty ([]) or missing, then Series is not displayed.
%
% Output:
%   In general, GARCHPLOT produces a tiered plot of matched time series. Any 
%   empty or missing input array will not be displayed (i.e., is not allocated 
%   space in the tiered figure window). Valid (i.e., non-empty) Innovations, 
%   Sigma, and Series arrays are displayed in the top, center, and bottom 
%   plots, respectively. Since each plot is titled and labeled, empty matrices
%   ([]) serve as placeholders and are important for correct plot annotation.
%   Note that corresponding realizations of each input array are color-coded, 
%   so that several realizations of each array may be plotted simultaneously. 
%   However, the plots will become very cluttered if more than a few 
%   realizations of each input series are displayed at a time.
%
% Examples:
%   Assume Innovations, Sigma, and Series are not empty.
%
%   garchplot(Innovations)                  % Plot Innovations only.
%   garchplot(Innovations ,   []  , Series) % Plot Innovations and Series only.
%   garchplot([]          , Sigma , Series) % Plot Sigma and Series only.
%   garchplot(Innovations , Sigma , Series) % Plot all 3 vectors.
%   garchplot(Innovations , Sigma , [])     % Plot Innovations and Sigma only.
%   garchplot(Innovations , Sigma)          % Plot Innovations and Sigma only.
%
% See also GARCHSIM, GARCHFIT, GARCHPRED.

% Copyright 1999-2003 The MathWorks, Inc.   
% $Revision: 1.8.2.1 $   $Date: 2003/05/08 21:45:28 $

%
% Find the number of plots to make (i.e., the number of
% non-empty cells in the VARARGIN cell array).
%

nPlots  =  length(varargin) - sum(cellfun('isempty' , varargin));

if nPlots <= 0
   warning('GARCH:garchplot:NoPlots' , ' No valid input data found.')
   return
end

%
% Create titles and y-axis labels.
%

Titles   = {'Innovations' 
            'Conditional Standard Deviations' 
            'Returns'};
Ylabels  = {'Innovation' 
            'Standard Deviation'
            'Return'};
%
% Make the matched plots.
%

iPlot =  1;   % Initialize the sub-plot number.

for i = 1:min(length(varargin),3)
    if ~isempty(varargin{i})
       if iPlot == 1 , figure , end
       subplot(nPlots , 1 , iPlot)
       plot   (varargin{i})
       grid   ('on')
       title  (Titles{i})
       ylabel (Ylabels{i})
       iPlot  =  iPlot + 1;
    end
end
