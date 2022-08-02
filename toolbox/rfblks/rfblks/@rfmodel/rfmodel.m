function varargout=rfmodel(varargin)
%RFMODEL  RF Model object.
%    Hd = RFMODEL.TYPE(input1,...) returns an RFMODEL object, Hd, of type
%    TYPE. You must specify a type with RFMODEL. Each type takes one or
%    more inputs. When you specify an RFMODEL.TYPE with/without inputs, an
%    object with specified/default parameters is created (the defaults
%    depend on the particular RFMODEL type).
%
%    RFMODEL.TYPE can be one of the following.
%
%    rfmodel.data                  data object for rf behavioral model
%    rfmodel.filter                behavioral model for RF filter
%    rfmodel.linear                behavioral model for RF linear system
%    rfmodel.nonlinear             behavioral model for RF nonlinear system
%    rfmodel.system                behavioral model for RF system
%
%    For more information, enter
%      doc rfmodel
%    at the MATLAB command line.
%

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:40:07 $

msg = sprintf(['Use RFMODEL.TYPE to create an RFMODEL object.\n',...
               'For example,\n   Hd = rfmodel.linear']);
error(msg)