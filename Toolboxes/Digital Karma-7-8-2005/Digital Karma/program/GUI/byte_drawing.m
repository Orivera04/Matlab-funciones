% defines drawing points
%byteoriginrow, byteendrow, byteorigincol, byteendcol, byteoriginplane, byteendplane
if dimension==1;
    byteoriginrowgraph=rows-(currentiteration-byteoriginrow)-1; byteendrowgraph=rows-(currentiteration-byteendrow)-1;    
    sortingbyterowgraph=sort([byteoriginrowgraph,byteendrowgraph]); byteoriginrowgraph=sortingbyterowgraph(1); byteendrowgraph=sortingbyterowgraph(2);
elseif dimension==2;
    byteoriginrowgraph=byteoriginrow-firstrow+1; byteendrowgraph=byteendrow-firstrow+1;    
    sortingbyterowgraph=sort([byteoriginrowgraph,byteendrowgraph]); byteoriginrowgraph=sortingbyterowgraph(1); byteendrowgraph=sortingbyterowgraph(2);
end;
byteorigincolgraph=byteorigincol-firstcolumn+1; byteendcolgraph=byteendcol-firstcolumn+1;
sortingbytecolgraph=sort([byteorigincolgraph,byteendcolgraph]); byteorigincolgraph=sortingbytecolgraph(1); byteendcolgraph=sortingbytecolgraph(2);

%Draws selection
if (dimension==1) | (byteoriginplane-1==currentiteration); %When to draw, allows out of box since line self-cancels outside I think
    for y=byteoriginrowgraph:byteendrowgraph;
        for x=byteorigincolgraph:byteendcolgraph;
            if dimension==1; zvalue=1; colorofy=(currentiteration-rows+1+y); % Drawing Points
            elseif dimension==2; zvalue=currentiteration+1; colorofy=y+firstrow-1; end;
            if (a(colorofy,x+firstcolumn-1,zvalue)/high)<0.5; selectioncolorvariable=colordisplay(end,:); else; selectioncolorvariable=colordisplay(1,:); end; % Color of the selection X
            line([x-0.5:0.01:x+0.5],[y+0.5:-0.01:y-0.5],'Color',selectioncolorvariable);
            line([x-0.5:0.01:x+0.5],[y-0.5:0.01:y+0.5],'Color',selectioncolorvariable);
        end;
    end;
end;
