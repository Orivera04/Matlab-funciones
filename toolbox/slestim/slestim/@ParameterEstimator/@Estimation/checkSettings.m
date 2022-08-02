function [hasTunedParams,hasTunedStates,hasExperiments] = checkSettings(this)
% CHECKSETTINGS Checks project settings

% Author(s): P. Gahinet, Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/03/10 21:54:12 $

hasTunedParams = ~isempty(this.Parameters) && ...
    ~isempty( find(this.Parameters,'-function','Estimated',@(x) any(x(:))) );

hasTunedStates = ~isempty(this.States) && ...
    ~isempty( find(this.States,'-function','Estimated',@(x) any(x(:))) );

hasExperiments = ~isempty(this.Experiments);
