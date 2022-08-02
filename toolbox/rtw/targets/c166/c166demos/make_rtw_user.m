function make_rtw_user(varargin)
% MAKE_RTW_USER make command including additional sources

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.2.4.2 $
%   $Date: 2004/04/19 01:18:44 $
  
user_srcs_arg = [ 'USER_SRCS="' matlabroot ...
                  '/toolbox/rtw/targets/c166/c166demos/user_src/user_io.c"'];
user_includes_arg = [ 'USER_INCLUDES="-I' matlabroot ...
                    '/toolbox/rtw/targets/c166/c166demos/user_src"'];

make_rtw(varargin{:}, user_srcs_arg, user_includes_arg);
