function ert_unspecified_hardware(modelName)
% MISSING_ERT_RTW_INFO_HOOK - Provide information about how
% to address unspecified hardware information.

% Copyright 1996-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/15 00:27:46 $

% open the sim param dialog

  cs = getActiveConfigSet(modelName);
  
  unknownState = rtw_is_hardware_state_unknown(modelName);
  unspecifiedTarget = strcmp(get_param(cs,'ProdHWDeviceType'),...
                             '32-bit Generic');
  
  if unknownState | unspecifiedTarget
    
      errTxt = ['You have specified to generate optimized code, however, ' ...
                'insufficient information is available for the target hardware ' ...
                'device.  First, go to the Hardware Implementation page of the ', ...
                'Configuration Parameters.'];
    
      if unknownState
        errTxt = [errTxt,'  Next, press the ''Configure current ',...
                  'execution hadware device'' button, and specify the ', ...
                  'appropriate emulation hardware information.'];
      end
      
      if unspecifiedTarget
        errTxt = [errTxt,'  Next, specify the appropriate embedded ',...
                  'hardware information.'];
      end
      
      slCfgPrmDlg(modelName, 'Open');
      slCfgPrmDlg(modelName, 'TurnToPage', 'Hardware Implementation');
      
      error(errTxt);
      
  end
