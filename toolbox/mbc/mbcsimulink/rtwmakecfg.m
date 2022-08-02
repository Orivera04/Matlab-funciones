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

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

makeInfo.includePath = { fullfile( mbcpath, 'mbcsimulink') };
makeInfo.sourcePath  = { fullfile( mbcpath, 'mbcsimulink') };
makeInfo.library     = { };
disp('### Include Model-Based Calibration Toolbox directories');