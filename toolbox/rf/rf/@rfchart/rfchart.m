function varargout=rfchart(varargin)
%RFCHART  RFCHART object.
%    Hd = RFCHART.TYPE(input1,...) returns an RFCHART object, Hd, of type
%    TYPE. You must specify a type with RFCHART. Each type takes  one or
%    more inputs. When you specify an RFCHART.TYPE with/without inputs,  an
%    object with specified/default parameters is created (the defaults
%    depend on  the particular RFCHART type).
%
%    RFCHART.TYPE can be one of the following.
%
%    rfchart.smith    - Object for Smith chart
%
%    The following methods are available for rfchart.smith object:
%
%    smith/smith      - Constructor  
%    smith/destroy    - Destroy Smith object
%
%  See also RFDATA, RFCKT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/12 23:36:05 $

msg = sprintf(['Use RFCHART.TYPE to create an RFCHART object.\n',...
               'For example,\n   Hd = rfchart.smith']);
error(msg)
