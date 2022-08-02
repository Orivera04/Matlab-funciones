function hLib = make_diab_tfl
%MAKE_DIAB_TFL create an instance of the Target Function Library for Diab
%   MAKE_DIAB_TFL creates an instance of the Target Function Library for 
%   use with the Diab compiler.
  
%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $
%   $Date: 2004/03/15 22:23:46 $

  hLib = make_ansi_tfl;
  hLib.matFileName = 'diab_tfl_tmw.mat';

  %% Unsupported functions in Diab inherited from make_ansi_tfl: fmin/fmax
  
  updateMathFcn(hLib,'fix'     , 'double', 1, 0, 1, 'trunc',  'double', '<math.h>');
  updateMathFcn(hLib,'rem'     , 'double', 1, 0, 2, 'fmod',   'double', '<math.h>');
  updateMathFcn(hLib,'hypot'   , 'double', 1, 0, 2, 'hypot',  'double', '<math.h>');
  %%
  %% --- single datatype
  %% 
  %% Unsupported functions in Diab inherited from make_ansi_tfl: fminf/fmaxf/asinhf/acoshf/atanhf
  
  updateMathFcn(hLib,'sqrt'    , 'single', 1, 0, 1, 'sqrtf',  'float',  '<mathf.h>');
  updateMathFcn(hLib,'floor'   , 'single', 1, 0, 1, 'floorf', 'float',  '<mathf.h>');
  updateMathFcn(hLib,'fmod'    , 'single', 1, 0, 2, 'fmodf',  'float',  '<mathf.h>');
  updateMathFcn(hLib,'ceil'    , 'single', 1, 0, 1, 'ceilf',  'float',  '<mathf.h>');  
  updateMathFcn(hLib,'round'   , 'single', 1, 0, 1, 'roundf', 'float',  '<mathf.h>'); 
  updateMathFcn(hLib,'fix'     , 'single', 1, 0, 1, 'truncf', 'float',  '<mathf.h>'); 
  updateMathFcn(hLib,'abs'     , 'single', 1, 0, 1, 'fabsf',  'float',  '<mathf.h>'); 
  updateMathFcn(hLib,'pow'     , 'single', 1, 0, 2, 'powf',   'float',  '<mathf.h>'); 
  updateMathFcn(hLib,'power'   , 'single', 1, 0, 2, 'powf',   'float',  '<mathf.h>'); 
  updateMathFcn(hLib,'exp'     , 'single', 1, 0, 1, 'expf',   'float',  '<mathf.h>'); 
  updateMathFcn(hLib,'ln'      , 'single', 1, 0, 1, 'logf',   'float',  '<mathf.h>');
  updateMathFcn(hLib,'log'     , 'single', 1, 0, 1, 'logf',   'float',  '<mathf.h>');
  updateMathFcn(hLib,'log10'   , 'single', 1, 0, 1, 'log10f', 'float',  '<mathf.h>');
  updateMathFcn(hLib,'rem'     , 'single', 1, 0, 2, 'fmodf',  'float',  '<mathf.h>');
  updateMathFcn(hLib,'hypot'   , 'single', 1, 0, 2, 'hypotf', 'float',  '<mathf.h>');
  updateMathFcn(hLib,'sin'     , 'single', 1, 0, 1, 'sinf',   'float',  '<mathf.h>');
  updateMathFcn(hLib,'cos'     , 'single', 1, 0, 1, 'cosf',   'float',  '<mathf.h>');
  updateMathFcn(hLib,'tan'     , 'single', 1, 0, 1, 'tanf',   'float',  '<mathf.h>');
  updateMathFcn(hLib,'asin'    , 'single', 1, 0, 1, 'asinf',  'float',  '<mathf.h>');
  updateMathFcn(hLib,'acos'    , 'single', 1, 0, 1, 'acosf',  'float',  '<mathf.h>');
  updateMathFcn(hLib,'atan'    , 'single', 1, 0, 1, 'atanf',  'float',  '<mathf.h>');
  updateMathFcn(hLib,'atan2'   , 'single', 1, 0, 2, 'atan2f', 'float',  '<mathf.h>');
  updateMathFcn(hLib,'raw_atan2','single', 1, 0, 2, 'atan2f', 'float',  '<mathf.h>');
  updateMathFcn(hLib,'sinh'    , 'single', 1, 0, 1, 'sinhf',  'float',  '<mathf.h>');
  updateMathFcn(hLib,'cosh'    , 'single', 1, 0, 1, 'coshf',  'float',  '<mathf.h>');
  updateMathFcn(hLib,'tanh'    , 'single', 1, 0, 1, 'tanhf',  'float',  '<mathf.h>');



function status = updateMathFcn(libH, RTWName, RTWType, nu1, nu2, NumInputs, ImplName, FcnType, HdrFile)

    implH = libH.getFcnImplement(RTWName, RTWType);   
     
    if isempty(implH)
        implH = Simulink.RtwFcnImplementation;
        implH.InDataType = RTWType;
        if  isempty(implH)    
            error('Could not create the implementation');
            return;
        end
        libH.addImplementation(RTWName,implH);        
    end
                         
    implH.ImplementName = ImplName;
    implH.OutDataType = FcnType;
    implH.HeaderFile = HdrFile;
    implH.NumInputs = NumInputs;







