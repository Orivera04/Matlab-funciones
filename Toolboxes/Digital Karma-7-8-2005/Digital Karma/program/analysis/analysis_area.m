clear analysisarea;
if strcmp(analysisarealabel,'matrix');
    analysisarea=a;
elseif strcmp(analysisarealabel,'graphed');
    if dimension==1;
        if agraphingrows<=rows;
            analysisarea=a(1:currentiteration+1,firstcolumn:firstcolumn+columnsshown-1);
        else;
            analysisarea=a(currentiteration-rows+2:currentiteration+1,firstcolumn:firstcolumn+columnsshown-1);
        end;
    elseif dimension==2;
        analysisarea=a(firstrow:firstrow+rowsshown-1,firstcolumn:firstcolumn+columnsshown-1,(currentiteration+1));
    end;
elseif strcmp(analysisarealabel,'selection');
    if currentlyselecting==1;
        analysisarea=a(selectedoriginrow2:selectedendrow2,selectedorigincol2:selectedendcol2,selectedoriginiteration2:selectedenditeration2);
    else; % means analysisarea is empty
    end;
end;
