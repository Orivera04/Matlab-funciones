function makecmd = mpc555rt_wrap_make_cmd_hook(args)
%
% Function: mpc555rt_wrap_make_cmd_hook ========================================================
% Abstract:
%   Make wrap command hookfile

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2003/07/31 18:09:46 $
    makecmd = setup_make_for_mpc555dk(args);
