clc;
if displaytotaliterations==1;
    disp(['Total Iterations run since last ''Start New'''])
    disp(totaliterationscompleted)
    disp(' ')
end;

if displayselectionvalues==1 & currentlyselecting==1;
    disp(['Selection'])
    disp(aselectionstructurenumberstring);
    disp(selectioncoordinates);
    if dimension==1;
        disp(num2str(aselection))
    elseif dimension==2;
        % This is to format the layers properly for display
        for layer=(selectedenditeration2-(selectedoriginiteration2-1)):-1:(selectedoriginiteration2-(selectedoriginiteration2-1));
            disp(num2str(aselection(:,:,layer)))
            disp(' ')
        end;
    end;
    disp(' ')
end;

if  bytevalueson==1 & exist('byteselection');
    disp(['Byte Values'])
    disp(byteselectionstructurenumberstring);
    disp(bytecoordinates);
    if dimension==1;
        disp(num2str(byteselection))
    elseif dimension==2;
        % This is to format the layers properly for display
        for layer=(byteendplane-(byteoriginplane-1)):-1:(byteoriginplane-(byteoriginplane-1));
            disp(num2str(byteselection(:,:,layer)))
            disp(' ')
        end;
    end;    
    disp(' ')
end;

if displaygraphvalues==1;
    disp(['Graphed Values'])
    disp(num2str(b))
    disp(' ')
end;

if displayallvalues==1;
    disp(['Entire Matrix'])
    if dimension==1;
        disp(num2str(a))
    elseif dimension==2;
        % This formats the layers properly for display
        for layer=completediterations+1:-1:1;
            disp(['Iteration  ',num2str(layer-1)])
            disp(num2str(a(:,:,layer)))
            disp(' ')
        end;
    end;
end;
