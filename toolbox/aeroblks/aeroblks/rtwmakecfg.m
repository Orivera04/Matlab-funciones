function makeInfo=rtwmakecfg
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

% Copyright 1995-2003 The MathWorks, Inc.
% $Revision $ $Date: 2004/04/06 01:04:20 $
  
makeInfo.includePath = { ...
    fullfile(matlabroot,'toolbox','aeroblks','aeroblks')};

makeInfo.sourcePath = { ...
    fullfile(matlabroot,'toolbox','aeroblks','aeroblks')};

% [EOF] rtwmakecfg.m