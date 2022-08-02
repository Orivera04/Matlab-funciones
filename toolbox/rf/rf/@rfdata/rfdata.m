function varargout=rfdata(varargin)
%RFDATA  RF DATA object.
%    Hd = RFDATA.TYPE(input1,...) returns an RFDATA object, Hd, of type
%    TYPE. You must specify a type with RFDATA. Each type takes one or more
%    inputs. When you specify an RFDATA.TYPE with/without inputs, an
%    object with specified/default parameters is created (the defaults
%    depend on the particular RFDATA type).
%
%    RFDATA.TYPE can be one of the following.
%
%    rfdata.data        - Object for RF data
%
%    The following methods are available for RFDATA.DATA object:
%
%      analyze         - Analyze the object in frequency domain  
%      calculate       - Calculate the needed parameters
%      copy            - Copy the object
%      extract         - Extract the specifined network parameters
%      listformat      - List the legitimate formats for the given PARAMETER
%      listparam       - List the legitimate parameters that can be visualized
%      plot            - Plot the data on X-Y plane
%      polar           - Plot the data on polar plane
%      read            - Read RF data in SNP/YNP/ZNP/AMP formats
%      smith           - Plot the data on the Smith chart
%      write           - Write RF data in SNP/YNP/ZNP formats extract.m
%
%    Example:
%
%    % Construct an RFDATA.DATA object with a Touchstone data file
%      data = rfdata.data;
%      filename = 'default.s2p';
%      read(data, filename);
%     
%    % Visualize the RF data
%      plot(data,'s21', 'db');       % Plot dB(S21) in XY plane
%      polar(data, 's21');           % Plot S21 in polar plane
%      smith(data, 'GAMMAIN', 'zy'); % Plot GAMMAIN in ZY Smith chart
%
%    % Common methods 
%      methods(data);                % List all class methods
%      get(data);                    % Get the properties
%      delete(data);                 % Delete the object
%
%  See also RFCKT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.8 $  $Date: 2004/04/12 23:38:48 $

msg = sprintf(['Use RFDATA.TYPE to create an RFDATA object.\n',...
               'For example,\n   Hd = rfdata.data']);
error(msg)
