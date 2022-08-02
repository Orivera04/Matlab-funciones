function osek_select_callback_handler(varargin)
% Copyright 2003 The MathWorks, Inc.
%   $File: $
%   $Revision $
  
  hDlg = varargin{1};
  hSrc = varargin{2};

  % Setup these options as desired, leave them enabled
  slConfigUISetVal(hDlg, hSrc, 'ProdHWDeviceType','Motorola PowerPC');
  slConfigUISetVal(hDlg, hSrc, 'ProdEqTarget','on');

  % Setup these options as desired and gray them out
  slConfigUISetVal(hDlg, hSrc, 'GenerateSampleERTMain', 'off');
  slConfigUISetEnabled(hDlg, hSrc, 'GenerateSampleERTMain',0);
  slConfigUISetVal(hDlg, hSrc, 'SuppressErrorStatus', 'on');
  slConfigUISetEnabled(hDlg, hSrc, 'SuppressErrorStatus',0);
  slConfigUISetVal(hDlg, hSrc, 'GenerateErtSFunction','off');
  slConfigUISetEnabled(hDlg, hSrc, 'GenerateErtSFunction',0);
  slConfigUISetVal(hDlg, hSrc, 'MatFileLogging','off');
  slConfigUISetEnabled(hDlg, hSrc, 'MatFileLogging',0);
  slConfigUISetVal(hDlg, hSrc, 'GRTInterface','off');
  slConfigUISetEnabled(hDlg, hSrc, 'GRTInterface',0);
  slConfigUISetVal(hDlg, hSrc, 'ERTCustomFileTemplate','osek_file_process.tlc');
  slConfigUISetEnabled(hDlg, hSrc, 'ERTCustomFileTemplate',0);
