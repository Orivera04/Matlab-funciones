% 4 Lines setup aselection while saving oringinal points
sortingselectedrow=sort([selectedoriginrow,selectedendrow]); selectedoriginrow2=sortingselectedrow(1); selectedendrow2=sortingselectedrow(2);
sortingselectedcol=sort([selectedorigincol,selectedendcol]); selectedorigincol2=sortingselectedcol(1); selectedendcol2=sortingselectedcol(2);
sortingselectediteration=sort([selectedoriginiteration,selectedenditeration]); selectedoriginiteration2=sortingselectediteration(1); selectedenditeration2=sortingselectediteration(2);
aselection=a(selectedoriginrow2:selectedendrow2,selectedorigincol2:selectedendcol2,selectedoriginiteration2:selectedenditeration2);
if dimension==1; selectioncoordinates=['[',num2str(selectedoriginrow2-1),',',num2str(selectedorigincol2),']--[',num2str(selectedendrow2-1),',',num2str(selectedendcol2),']'];
elseif dimension==2; selectioncoordinates=['[',num2str(selectedoriginrow2),',',num2str(selectedorigincol2),',',num2str(selectedenditeration2-1),']--[',num2str(selectedendrow2),',',num2str(selectedendcol2),',',num2str(selectedoriginiteration2-1),']'];
end;

if structurenumbersizelimit==1; [aselectionstructurenumber, aselectionstructurenumberstring]=structure_number(aselection,'on');
else; [aselectionstructurenumber, aselectionstructurenumberstring]=structure_number(aselection); end

% defines drawing points
if dimension==1;
    selectedoriginrowgraph=rows-(currentiteration-selectedoriginrow)-1; selectedendrowgraph=rows-(currentiteration-selectedendrow)-1;    
    sortingselectedrowgraph=sort([selectedoriginrowgraph,selectedendrowgraph]); selectedoriginrowgraph=sortingselectedrowgraph(1); selectedendrowgraph=sortingselectedrowgraph(2);
    % Rounds ends so it doesn't waste time drawing abunch of points off the graph
    if selectedoriginrowgraph<1; selectedoriginrowgraph=0; end;
    if selectedendrowgraph>rows; selectedendrowgraph=rows+1; end;
elseif dimension==2;
    selectedoriginrowgraph=selectedoriginrow-firstrow+1; selectedendrowgraph=selectedendrow-firstrow+1;    
    sortingselectedrowgraph=sort([selectedoriginrowgraph,selectedendrowgraph]); selectedoriginrowgraph=sortingselectedrowgraph(1); selectedendrowgraph=sortingselectedrowgraph(2);
    % Rounds ends so it doesn't waste time drawing abunch of points off the graph
    if selectedoriginrowgraph<1; selectedoriginrowgraph=0; end;
    if selectedendrowgraph>rowsshown; selectedendrowgraph=rowsshown+1; end;
end;
selectedorigincolgraph=selectedorigincol-firstcolumn+1; selectedendcolgraph=selectedendcol-firstcolumn+1;
sortingselectedcolgraph=sort([selectedorigincolgraph,selectedendcolgraph]); selectedorigincolgraph=sortingselectedcolgraph(1); selectedendcolgraph=sortingselectedcolgraph(2);
% Rounds ends so it doesn't waste time drawing abunch of points off the graph
if selectedorigincolgraph<1; selectedorigincolgraph=0; end;
if selectedendcolgraph>columnsshown; selectedendcolgraph=columnsshown+1; end;

%Draws selection
if (dimension==1) | ((selectedoriginiteration2-1<=currentiteration) & (currentiteration<=selectedenditeration2-1)); %When to draw, allows out of box since line self-cancels outside I think
    for y=selectedoriginrowgraph:selectedendrowgraph;
        for x=selectedorigincolgraph:selectedendcolgraph;
            if dimension==1; zvalue=1; colorofy=(currentiteration-rows+1+y); % Drawing Points
            elseif dimension==2; zvalue=currentiteration+1; colorofy=y+firstrow-1; end;
            if (a(colorofy,x+firstcolumn-1,zvalue)/high)<0.5; selectioncolorvariable=colordisplay(end,:); else; selectioncolorvariable=colordisplay(1,:); end; % Color of the selection X
            line([x-0.5:0.01:x+0.5],[y+0.5:-0.01:y-0.5],'Color',selectioncolorvariable);
            line([x-0.5:0.01:x+0.5],[y-0.5:0.01:y+0.5],'Color',selectioncolorvariable);
        end;
    end;
end;
