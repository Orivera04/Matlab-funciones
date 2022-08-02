function nn = nlfit(nn, x, y)
% NLFIT initialise and train neural network

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:56:27 $


% initialise network
nn.param = init(nn.param);

% begin training
%temp = figure; %create figure for displaying performance
[nn.param, tr] = train(nn.param, x, y);

%close(temp) %close temporary figure
