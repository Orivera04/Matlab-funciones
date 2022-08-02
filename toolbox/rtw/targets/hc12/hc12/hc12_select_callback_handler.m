function hc12_select_callback_handler(varargin)
% HC12_SELECT_CALLBACK_HANDLER callback handler for hc12 real-time options
% Copyright 2004 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.1.6.2 $
  
  hDlg = varargin{1};
  hSrc = varargin{2};
  % Setup these options as desired and gray them out
  slConfigUISetVal(hDlg, hSrc, 'ProdHWDeviceType','Motorola HC12');
  slConfigUISetEnabled(hDlg, hSrc, 'ProdHWDeviceType',0);
  slConfigUISetVal(hDlg, hSrc, 'ProdEqTarget','on');
  slConfigUISetEnabled(hDlg, hSrc, 'ProdEqTarget',0);
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
  slConfigUISetVal(hDlg, hSrc, 'ERTCustomFileTemplate','hc12_file_process.tlc');
  slConfigUISetEnabled(hDlg, hSrc, 'ERTCustomFileTemplate',0);
  slConfigUISetVal(hDlg, hSrc, 'SupportNonInlinedSFcns','off');
  slConfigUISetEnabled(hDlg, hSrc, 'SupportNonInlinedSFcns',0);
  slConfigUISetVal(hDlg, hSrc, 'UtilityFuncGeneration','Auto');
  slConfigUISetEnabled(hDlg, hSrc, 'UtilityFuncGeneration',0);
