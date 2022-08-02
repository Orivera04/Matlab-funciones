function MPC555_TFL(cs, tprefs, isoCSupported)
%MPC555_TFL configure floating point math calls using target function library

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/08 20:58:21 $
  
  
  genFloat = get_param(cs,'GenFloatMathFcnCalls');
  switch genFloat
   case 'ISO_C'
    if isoCSupported~=1
      disp('********************************************************************');
      disp('********************************************************************');
      disp(sprintf(['\nThe ISO C math library is not supported for this target. To \n' ...
             'fix this error, please set the target floating point math \n'...
             'environment to ANSI C\n']));
      disp('********************************************************************');
      disp('********************************************************************');
    end
    switch lower(tprefs.ToolChain)
     case 'diab'
      set_param(cs,'TargetFcnLib','diab_tfl_tmw.mat');                      
     case 'codewarrior'
%      set_param(cs,'TargetFcnLib','diab_tfl_tmw.mat');                      
      set_param(cs,'TargetFcnLib','codewarrior_tfl_tmw.mat');                      
     otherwise 
      warning(['A target function is not supported for toolchain, ' tprefs.ToolChain]);
    end
   case 'ANSI_C'
    % no action required
   otherwise
    error(['The option ' genFloat ' for target floating point math environment is not '...
           'supported for this target. Please configure Real-Time Workshop to use a different '...
           'option for the target floating point math environment.']);
  end       
  
  
