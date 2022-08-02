function makeInfo=rtwmakecfg()
%RTWMAKECFG Add include and source directories to RTW make files.
%  makeInfo=RTWMAKECFG returns a structured array containing
%  following fields:
%
%     makeInfo.includePath - cell array containing additional include
%                            directories. Those directories will be 
%                            expanded into include instructions of rtw 
%                            generated make files.
%     
%     makeInfo.sourcePath  - cell array containing additional source
%                            directories. Those directories will be
%                            expanded into rules of rtw generated make
%                            files.
%
%     makeInfo.library     - structure containing additional runtime library
%                            names and module objects.  This information
%                            will be expanded into rules of rtw generated make
%                            files.

% Copyright 1994-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/19 01:30:06 $

% CAN blocks rely on the CAN_FRAME struct defined in can_msg.h
% Add rt/blockset/tlc_c for ccp_mpc555_utils.h
makeInfo.includePath = { fullfile(matlabroot,'toolbox','rtw','targets',...
                                  'common', 'can','datatypes'), ...
                    fullfile(matlabroot,'toolbox','rtw','targets','mpc555dk',...
                             'drivers','src','libsrc','standard','include'),...
                    fullfile(matlabroot, 'toolbox', 'rtw', 'targets', 'mpc555dk',...
                             'rt', 'blockset', 'tlc_c')};

% Add rt/blockset/tlc_c for ccp_mpc555_utils.c
makeInfo.sourcePath{1} = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', 'mpc555dk',...
                             'rt', 'blockset', 'tlc_c');
