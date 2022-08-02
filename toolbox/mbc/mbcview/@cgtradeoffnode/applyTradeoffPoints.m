function obj = applyTradeoffPoints(obj, pInputs, Data, varargin)
%APPLYTRADEOFFPOINTS Save and apply a set of tradeoff inputs
%
%  OBJ = APPLYTRADEOFFPOINTS(OBJ, PINPUTS, DATA, ROWS, COLS) saves the
%  given list of input points as traded-off values, applies the appropraite
%  filling values to the tables and adds the appropriate table cells to the
%  extrapolation mask.  PINPUTS is a pointer vector containing a list of
%  pointers to inputs.  DATA is a matrix of input values with each column
%  corresponding to an entry in PINPUTS.  ROWS and COLS are table cell
%  indices indicating which table cell the corresponding row of DATA should
%  be linked to.  If an entry in ROWS or COLS is zero, that tradeoff point
%  will not be linked to a table cell.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:10 $ 














