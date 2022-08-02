function [RowNames,ColNames] = getrcname(this)
%GETRCNAME  Provides input and output names for display.

%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $  $Date: 2004/04/16 22:21:13 $
RowNames = this.OutputPort;  % Port Handles!
ColNames = this.InputName;
