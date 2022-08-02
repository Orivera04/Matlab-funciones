function val=getrtwmakecmd(modelname,opt)
%GETRTWMAKECMD gets an MAKE_RTW option for a Simulink model
%   VALUE = GETRTWMAKECMD(MODELNAME, OPT) returns the VALUE of the RTW 
%   option OPT for Simulink model MODELNAME.

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

  opts = get_param(modelname,'RTWSystemTargetFile');
  if isempty(opts)
      val = 'We_Can_Not_Find_The_Value';
      return
  end
  
  if isempty(findstr(opts,['-a' opt '=']))
    %val = 'We_Can_Not_Find_The_Value';
    val = 0;
    return
  end
  
  [s,f,t] = regexp(opts, ['-a' opt '=\"([^"]*)\"']);
  
  isNumeric=0;
  if isempty(s)
    % Numeric values are not double quoted
    [s,f,t] = regexp(opts, ['-a' opt '=(\d*)']);
    isNumeric=1;
  end
  
  t1 = t{1};
  
  if isempty(t1)
    val = '';
  else
    if isNumeric==0
      val = opts(t1(1):t1(2));
    else
      eval(['val = ' opts(t1(1):t1(2)) ';']);
    end
  end 
