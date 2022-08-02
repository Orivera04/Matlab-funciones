function out = mbcloadrecorder(action,data)
%MBCLOADRECORDER  Load-time action recorder
%
%  h = mbcloadtimerecorder('new')
%  h = mbcloadtimerecorder('current')
%  h = mbcloadtimerecorder('clear')
%
%  h is an mbcfoundation.actionlist which is kept persistent within this
%  function so that loadobj routines can access it and register post-load
%  operations to be run.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:48:57 $

persistent hRecord RefMap

switch action
    case 'new'
        hRecord = mbcfoundation.actionlist;
        RefMap=[];
        out=hRecord;
    case 'current'
        if isempty(hRecord)
            hRecord = mbcfoundation.actionlist;
        end
        out=hRecord;
    case 'clear'
        clear hRecord RefMap
        out=[];
    case 'setRefMap'
        RefMap=data;
        out=1;
    case 'getRefMap'
        out=RefMap;
end