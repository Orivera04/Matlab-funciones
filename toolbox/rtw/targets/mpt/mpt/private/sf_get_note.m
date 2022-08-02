function noteList = sf_get_note(fullChartName)
%SF_GET_NOTE Pulls all notes from a give stateflow diagram.
%
%  NOTELIST = SF_GET_NOTE(FULLCHARTNAME)
%        It will pull notes from the Stateflow diagram specified by the full
%        path name 
%
%  INPUT:  
%        fullChartName: full path name of Stateflow diagram
%
%  OUTPUT:
%        noteList:  list of all notes 

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.9.4.1 $  
%  $Date: 2004/04/15 00:28:53 $

noteList = [];
ch = sf_get(fullChartName,'ChartHandle');
sl = sf('get',ch,'.states');

%
%for all states
% if a "note"
% then get the note text and save it
%
for i=1:length(sl)
    isNoteBox = sf('get',sl(i),'.isNoteBox');
    if isNoteBox == 1
        note.name = sf('get',ch,'.name');
        note.handle = ch;
        note.comment = sf('get',sl(i),'.labelString');
        noteList{end+1}=note;
    end
end


