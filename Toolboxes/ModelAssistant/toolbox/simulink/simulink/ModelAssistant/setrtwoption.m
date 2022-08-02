function setrtwoption(modelname,opt,val,create)
%SETRTWOPTION sets an RTW option for a Simulink model
%   OPT=SETRTWOPTION(MODELNAME, OPT, VALUE, CREATE) sets the RTW option OPT to VALUE for 
%   Simulink model MODELNAME. If CREATE = 1 the option is created if necessary, otherwise
%   an error is thrown if the option does note exist.

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:16 $

  if nargin < 4
    create=0;
  end
  
  if isstr(val)
      val = ['"' val '"'];
  end
  
  opts = get_param(modelname,'RTWOptions');
  
  if isempty(findstr(opts,['-a' opt '=']))
    if create~=1
      error(['Error setting RTW Option for model ' modelname '. '...
             'The option ' opt ' does not exist.'])
    else
      if isstr(val)
        newopts = [ opts ' -a' opt '=' val ];
      else
        newopts = [ opts ' -a' opt '=' num2str(val)];
      end      
    end
  else
    if isstr(val)
      newopts = regexprep(opts,...
                          ['-a' opt '="[^"]*"'],...
                          ['-a' opt '=' val]);
    else
      newopts = regexprep(opts,...
                          ['-a' opt '=\d*'],...
                          ['-a' opt '=' num2str(val)]);
    end   
  end
  
  set_param(modelname,'RTWOptions',newopts)
