%a(selectedoriginrow2:selectedendrow2,selectedorigincol2:selectedendcol2,selectedoriginiteration2:selectedenditeration2)
historystillunchangeable=0;
if currentlyselecting==1;
    run save_undo;
    if strcmp(deletevalue,'iterations');
        if (dimension==1) & (changersafety==0 | ((changersafety==1) & (selectedendrow2-1==completediterations)));
            a(selectedoriginrow2:selectedendrow2,:)=[];
            totaliterationscompleted=totaliterationscompleted-(selectedendrow2-selectedoriginrow2+1);
        elseif (dimension==2) & (changersafety==0 | ((changersafety==1) & (selectedenditeration2-1==completediterations)));
            a(:,:,selectedoriginiteration2:selectedenditeration2)=[];
            totaliterationscompleted=totaliterationscompleted-(selectedenditeration2-selectedoriginiteration2+1);
        else
            historystillunchangeable=1;
        end;
    elseif strcmp(deletevalue,'rows');
        if (dimension==1) & (changersafety==0 | ((changersafety==1) & (selectedendrow2-1==completediterations)));
            a(selectedoriginrow2:selectedendrow2,:)=[];
            totaliterationscompleted=totaliterationscompleted-(selectedendrow2-selectedoriginrow2+1);
        elseif dimension==2 & changersafety==0;
            a(selectedoriginrow2:selectedendrow2,:,:)=[];
        else
            historystillunchangeable=1;
        end;
    elseif strcmp(deletevalue,'columns');
        if changersafety==0;
            a(:,selectedorigincol2:selectedendcol2,:)=[];
        else
            historystillunchangeable=1;
        end;
    end;    
else;
    errordlg('Make Selection','Error');
end;
currentlyselecting=0; run computeiterations; currentiteration=completediterations;
run opening_iteration; run CA_Display;
if historystillunchangeable==1; errordlg('Must Deactivate ''History Unchangeable'' under Settings','Error'); end;
