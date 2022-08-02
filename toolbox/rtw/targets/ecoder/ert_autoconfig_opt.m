function status = ert_autoconfig_opt(model)
% Return true if RTWMakeCommand is configured for auto configuration
% for optimized fixed- or floating-point code, and false otherwise
  
% Copyright 1996-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2003/12/31 19:42:54 $

  str = get_param(model,'RTWMakeCommand');
  
  val1 = ~isempty(findstr(str,'optimized_fixed_point=1'));
  val2 = ~isempty(findstr(str,'optimized_floating_point=1'));
  
  if val1 | val2
    status = true;
  else
    status = false;
  end