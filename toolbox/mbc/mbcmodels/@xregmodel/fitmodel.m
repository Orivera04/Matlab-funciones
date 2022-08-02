function [m,OK,S,varargout]=fitmodel(m,X,Y,varargin)
%FITMODEL Obtain least squares estimate of model
%
% [m,OK]= FITMODEL(M0,X,Y)
%  fit of model. The main tasks of fitmodel are
%    convert data to double
%    remove bad data
%    perform X and Y transformations
%
% Inputs    M0        Initial Model
%           X         column-wise X data matrix
%           Y         column-wise Y data vector
%
% Outputs   M     estimate of model
%           OK    solution found
%           S     summary statistics (labels in colhead(m))
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.4 $  $Date: 2004/04/04 03:30:17 $

% transform and Remove Bad Data
if length(varargin)>0
    [x,y,varargin{:},OK]= checkdata(m,X,Y,varargin{:});
else
    [x,y]= checkdata(m,X,Y);
end

% call the fit method
[m,OK,varargout{1:nargout-3}]= runfit(m,x,y,varargin{:});

if OK>0
    % summary stats
    S = FitSummary(m,x,y);
else
    % set all stats to NaN
    S = repmat(NaN,size(StatsList(m)));
end
