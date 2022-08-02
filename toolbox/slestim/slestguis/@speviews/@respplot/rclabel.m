function rclabel(this,varargin)
%RCLABEL  Maps InputName and OutputName to axes' row and column labels.
 
%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $  $Date: 2004/04/16 22:21:14 $

% Pass labels to @axesgrid object
this.AxesGrid.ColumnLabel = this.InputName;
this.AxesGrid.RowLabel = this.OutputName;
