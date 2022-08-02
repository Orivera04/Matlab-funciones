function queueEvent(obj, event)
%SWEEPSETFILTER/QUEUEEVENT public interface to event queueing in sweepsetfilter
%
%  QUEUEEVENT(OBJ, EVENT)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:12:02 $ 

if ~isempty(obj.dataMessageService)
    if ischar(event)
        switch lower(event)
            case 'allsweepsetevents'
                event = {'ssDataChanged' 'ssRecordsChanged' 'ssNamesChanged' 'ssUnitsChanged' 'ssTestsChanged' 'ssFilenameChanged'};                
        end 
    end
    if ~iscell(event)
        event = {event};
    end
    obj.dataMessageService.queueEvent(event{:});
end