function osek_choose_imp(stf)
%OSEK_CHOOSE_IMP  Helper function to switch between OSEK implementations.

% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.6.4.2 $

  if strcmp(get_param(bdroot,'simulationstatus'),'stopped')
    hdl = get_param(bdroot,'simparamhandle');
    if hdl ~= -1
      delete(hdl);
    end
    cs = getActiveConfigSet(bdroot);
    csCopy = cs.copy;
    switch lower(stf)
     case 'proosek.tlc'
      % Set OSEKWorks specific options, preserve ERT specific settings
      cs.switchTarget(stf,[]);
      cs.assignFrom(csCopy,true);
      set_param(bdroot,'RTWSystemTargetFile',stf)
      set_param(cs,'TimeInNS','Auto');
      set_param(cs,'basePriority',20);
      set_param(cs,'bspname','PHYCORE555');
      set_param(cs,'stackSize',512);
     case 'osekworks.tlc'
      % Set OSEKWorks specific options, preserve ERT specific settings
      cs.switchTarget(stf,[]);
      cs.assignFrom(csCopy,true);
      set_param(bdroot,'RTWSystemTargetFile',stf)
      set_param(cs,'basePriority',20);
      set_param(cs,'bspName','phycore555');
      set_param(cs,'stackSize',512);
      set_param(cs,'systemStackSize',1024);
      set_param(cs,'ticksPerBase','Auto');
     otherwise
      disp(['Unrecognized System Target file: ', stf]);
      return;
    end
    set_param(bdroot,'rtwtemplatemakefile','osek_default_tmf');
  end
