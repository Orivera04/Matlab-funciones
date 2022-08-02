function  [abstract, history, notes, otherSym, otherTxt]...
                        = ec_mp_global_comments(modelName)
%  This function will detect notes in Stateflow and register them in 
%  globalComments and symbols database. It also finds all annotations 
%  and registers them in globalCommentsand, further it registers 
%  annotations which names start with "note" (case insensitive) and 
%  notes in stateflow which names start with "note" (case insensitive)
%  into symbols database.
%  
%  In order to have note or annotation information appear in "NOTES"
%  section of generated code, you need to name the notes or annotation in 
%  the following pattern:
%             <S:NoteIdentifier>
%  where  "NoteIdentifier" (without quotes) has to start with "note" (without 
%         quotes and case insensitive) followed by any combination of letters, 
%         digits or underscores.  
%  Example of note or annotation name: 
%   <S:Note1> or <S:note2> or <S:NOTE3> or <S:note_MY>
%  Example of note or annotation: 
%   <S:Note1> Here is my note for the model
%
%  If there is note name collision, a warning message will show up and all the 
%  name collision notes will be put together and listed as (1), (2), ..., in the 
%  generated code. 
% 

%   Linghui Zhang
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/15 00:27:57 $


mpmResult = rtwprivate('rtwattic', 'AtticData', 'mpmResult');
if isempty(mpmResult) | isfield(mpmResult,'warning')==0
    mpmResult.warning = {};
end

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');
if isfield(ecac, 'globalComments') == 0
    ecac.globalComments = {};
end
allTsym = '';
allPcomment = '';
fileName = '';

% Detect notes in Stateflow and register them in ecac.globalComments and 
% register_object_with_sym (the latter for registered template symbols)
sfb = find_system(modelName,'BlockType','SubSystem','MaskType','Stateflow');
if isempty(sfb) == 0
    for i = 1:length(sfb)
        noteList = sf_get_note(sfb{i});
        for q = 1 : length(noteList)
            comment = noteList{q}.comment;
            [pcomment, tsym, csym] = parse_comment_string(comment);
            if isempty(tsym) == 0
                ecac.globalComments{end+1} = comment;
                allTsym{end+1} = fliplr(deblank(fliplr(deblank(tsym))));
                %allPcomment{end+1} = fliplr(deblank(fliplr(deblank(pcomment))));
								allPcomment{end+1} = fliplr(deblank(fliplr(deblank(pcomment))));
                object.name = pcomment;
                status = register_object_with_sym(fileName, tsym ,object);
            end
        end
    end
end

% Detect annotation in simulink model and register them in ecac.globalComments 
cr = sprintf('\n');

anno = find_system(modelName, 'FindAll', 'on', 'type', 'annotation');
if isempty(anno) == 0
    for i = 1:length(anno)
        comment = get_param(anno(i),'Name');
        if isempty(comment) == 1,continue;end;
        [pcomment, tsym, csym] = parse_comment_string(comment);
        if isempty(tsym) == 0
            ecac.globalComments{end+1} = comment;
            allTsym{end+1} = fliplr(deblank(fliplr(deblank(tsym))));
            %allPcomment{end+1} = fliplr(deblank(fliplr(deblank(pcomment))));
						allPcomment{end+1} = pcomment;
            object.name = pcomment;
        end
    end
end

%Sort notes and annotations
[temp,indx] = sort(allTsym);
tempComment = allPcomment(indx);
len = [];
for j= 1:length(temp)
    len = [len,length(temp{j})];
end
maxlen = max(len);

if length(temp) > 1
    % Check if there is name collision of notes or anno
    rep='';
    msg='   The list of note or annotation name collision:';
    newList{1} = temp{1};
    newpcomment{1} = tempComment{1};
    tempc = '';
    cc = 0;
    for nn = 1:length(temp)-1
        if isequal(temp{nn}, temp{nn+1}) == 1
            cc = cc + 1;
            rep{end+1} = temp{nn};
            tempc = [tempc,'      (',num2str(cc+1),'): ',...
                    blanks(maxlen-length(num2str(cc+1))-5),tempComment{nn+1},cr];
        else
            if nn > 1
                newList{end+1} = temp{nn}; 
                if cc == 0
                    newpcomment{end+1} = tempComment{nn};
                else
                    newpcomment{end+1} = [cr,'      (1): ', ...
                            blanks(maxlen-6),tempComment{nn-cc},cr tempc];
                end
                cc = 0;
                tempc = '';
            end
        end
    end
    %  for the case of nn = length(temp) 
    nn = length(temp);
    newList{end+1} = temp{nn}; 
    if cc == 0
        newpcomment{end+1} = tempComment{nn};
    else
        newpcomment{end+1} = [cr,'      (1): ', tempComment{nn-cc},cr tempc];
    end
    rep = unique(rep);
    if isempty(rep) == 0
        for pp = 1:length(rep)
            msg = [msg,cr,'          <S:',rep{pp},'>'];
        end
%         err_disp(modelName, 'Warning','Note or Annotation Name Collision',msg);
        if isempty(mpmResult.warning) == 1 | isequal(mpmResult.warning{end}.detailMsg,msg) == 0
           disp(['*** Warning: ',msg]);
           mpmResult.warning{end+1}.detailMsg = msg;
           mpmResult.warning{end}.msg = 'Note or Annotation Name Collision';
           mpmResult.warning{end}.type = 'Warning';
        end
    end
    % endofcheck
else
    newList = temp;
    newpcomment = tempComment;
end
rtwprivate('rtwattic', 'AtticData', 'mpmResult',mpmResult);
% find and register annotations which names start with 
% "note" (case insensitive) and notes in stateflow 
% which names start with "note" (case insensitive)
noteSym = {};
noteTxt = {};
abstractSym = {};
abstractTxt = {};
historySym = {};
historyTxt = {};
otherSym = {};
otherTxt = {};

abstract = '';
history = '';
notes = '';

for k = 1:length(newList)
    tsym = newList{k};
    pcomment = newpcomment{k};
    tsymC = upper(tsym);
    object.name = pcomment;
    if strcmp(tsymC, 'ABSTRACT') == 1
%        status = register_object_with_sym(fileName, 'Abstract' ,object);
        abstractSym{end+1} = 'Abstract';
        abstractTxt{end+1} = pcomment;
    elseif strcmp(tsymC, 'HISTORY') == 1
 %       status = register_object_with_sym(fileName, 'History' ,object);
        historySym{end+1} = 'History';
        historyTxt{end+1} = pcomment;
    elseif  (isempty(regexp(tsymC,'^NOTE')) == 0)
        noteSym{end+1} = tsym;
        noteTxt{end+1} = pcomment;
    else
        otherSym{end+1} = tsym;
        otherTxt{end+1} = pcomment;
    end
end

if ~isempty(abstractSym)
    abstract = order_doc_text('Abstract', abstractSym, abstractTxt, fileName) ;
end
if ~isempty(historySym)
    history = order_doc_text('History', historySym, historyTxt, fileName) ;
end
if ~isempty(noteSym)
    notes = order_doc_text('Notes', noteSym, noteTxt, fileName) ;
end

%Find DocBlocks
docSym = {};
docTxt = {};
docList = find_system(modelName,'FollowLinks','on','LookUnderMasks','all','MaskType','DocBlock');
for i = 1:length(docList)
    try
        o = get_param(docList{i},'Object');
        tagName = o.ECoderFlag;
%         rtwData = o.RTWData;
%         tagText = rtwData.document_text01;
%         tagText = strrep(tagText,rr,'');
        tagText = (o.UserData)';
        tagText = strrep(tagText,sprintf('\r'),'');
        docSym{end+1} = fliplr(deblank(fliplr(deblank(tagName))));
%        docTxt{end+1} = fliplr(deblank(fliplr(deblank(tagText))));
        docTxt{end+1} = tagText;
				otherSym{end+1} = docSym{end};
				otherTxt{end+1} = docTxt{end};				
        comment = [tagName,tagText];
        ecac.globalComments{end+1} = comment;
		catch
			disp(lasterr);
    end
end
rtwprivate('rtwattic', 'AtticData', 'ecac',ecac);
return

%------------------------------------------------------------------------
function [resolvedSymbol] = order_doc_text(symbol,noteSym,noteTxt,fileName) 

cr = sprintf('\n');

objTemp = '';
if  length(noteSym) > 1
    len = [];
    for j= 1:length(noteSym)
        len = [len,length(noteSym{j})];
    end
    maxlen = max(len);
    for i = 1:length(noteSym)
        objTemp = [objTemp,noteSym{i},': ',blanks(maxlen-length(noteSym{i})),noteTxt{i},cr,'   '];
    end
    object.name = objTemp;
    status = register_object_with_sym(fileName, symbol ,object);
    resolvedSymbol = objTemp;
elseif length(noteSym) == 1
    object.name = noteTxt{1};
    status = register_object_with_sym(fileName, symbol ,object);
    resolvedSymbol = noteTxt{1};
end

