function [OK,MD]= fitmodel(MD,ChangeModel)
%FITMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.5 $  $Date: 2004/04/04 03:31:52 $

% Get Data
[X,Y]= getdata(MD);

% Fit Model
[MD.Model,OK,S]= fitmodel(MD.Model,X,Y);
MD.Statistics= S;

% Update dynamic memory
pointer(MD);

% Convert OK to 0/1 for using as the status#
statusOK = OK;
statusOK(OK<0) = 0;
statusOK(OK>0) = 1;
MD= status(MD, statusOK);
