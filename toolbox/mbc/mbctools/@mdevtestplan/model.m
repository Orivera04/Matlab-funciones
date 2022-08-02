function m= model(tp);
% MODEL  Testplan overloaded model
%
%  This overloaded version updates the base design

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:04 $

% The tesplan models cannot be set through this interface
% See the DesignDev object for doing this

m= tp.DesignDev.BaseModel;
