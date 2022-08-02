function s = make_new_label_string(p)
%MAKE_NEW_LABEL_STRING makes transition label comments inside $ signs 
%
%   [S]=MAKE_NEW_LABEL_STRING(P)
%   This function processes label strings to preserve commenst in the
%   action statements of the stateflow diagram generated code.
%
%   INPUTS:
%             p : label string from the stateflow diagram
%
%   OUTPUTS:
%             s : string processed to be inserted back into teh stateflow
%                 diagram.


%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $  $Date: 2004/04/15 00:28:23 $

s = [];

cr = sprintf('\n');

%for each comment prior to the guard
%  include it in the label string
for i=1:length(p.precomment)
    s = [s,'/* ',p.precomment{i},' */',cr];
end

%if the guard text is preent
%  then include it
if isempty(p.gaurd) == 0
    s = [s,'[ ',p.gaurd,' ]',cr];
end

%if the action text is present
% then build the action string commment
%   for each of the comments before the action and after the guard
%    insert them into the label string
%   include the action text
%   for each comment after the action
%    insert them into the label string
% else
%   insert remaining comments

if isempty(p.action) == 0
    s = [s,'{ ',cr];
    
    for i=1:length(p.commentsMiddle)
        s = [s,'$/* ',p.commentsMiddle{i},' */$',cr];

    end
    s = [s,p.action,cr];
    for i=1:length(p.commentsAfterAction)
        s=[s,'$/* ', p.commentsAfterAction{i},' */$',cr];
    end
    s = [s,' }'];
else
    for i=1:length(p.commentsMiddle)
        s = [s,'/*',p.commentsMiddle{i},'*/',cr];
    end
end


%DONT USE
function rs = handle_multiline_comments(cString, s, margin)
        cr = sprintf('\n');
        cLen = length(cString);
        if cLen < margin
            s = [s,'$/* ',cString,' */$',cr];
        else
            cIndexStart = 1;
            cIndexEnd = 50;
            s=[s,'$/* '];
            
            while cIndexStart < cLen
                cIndexEnd = cIndexStart + margin;
                if cIndexEnd > cLen
                    cIndexEnd = cLen;
                end
                s=[s,cString(cIndexStart:cIndexEnd),cr];
                cIndexStart = cIndexStart + margin;
            end
            s=[s,' */$',cr];
        end
        rs = s;