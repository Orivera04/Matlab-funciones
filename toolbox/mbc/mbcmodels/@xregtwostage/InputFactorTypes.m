function types = InputFactorTypes(m)
%% model method to find out the nature of model inputs.
%% types = [1 2 2 1 1 1 1]
%% implies 3 local factors, 4 global
%% eg. dynamic models require 2 input vectors for eval to work

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:13 $

types = InputFactorTypes(m.Local);
types = [types,InputFactorTypes(m.Global{1})];
