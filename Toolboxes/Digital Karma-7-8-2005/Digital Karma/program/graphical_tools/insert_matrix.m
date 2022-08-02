evaluate_changer;
if exist('changer');
[changerrows, changercols, changerplanes]=size(changer);
    
clear acolumnsinserttemp;
run computeiterations; historystillunchangeable=0;
if currentlyselecting==1;
    run save_undo;
    if strcmp(insertvalue,'iterations');
        if dimension==1 & changersafety==0;
            insertedrows=zeros(selectedendrow2-selectedoriginrow2+1,columns);
            insertedrows(1:end,1:end)=changer;
            a=cat(1,a(1:selectedoriginrow2,:),insertedrows,a(selectedoriginrow2+1:end,:));
            totaliterationscompleted=totaliterationscompleted+(selectedendrow2-selectedoriginrow2+1);
        elseif dimension==2 & changersafety==0
            computeiterations;
            insertediteration=zeros(totalrows,columns);
            insertediteration(1:end,1:end)=changer;
            a=cat(3,a(:,:,1:selectedoriginiteration2),insertediteration,a(:,:,selectedoriginiteration2+1:end));
            computeiterations;
            totaliterationscompleted=totaliterationscompleted+(selectedoriginiteration2-selectedoriginiteration2+1);
        else
            historystillunchangeable=1;
        end;
    elseif strcmp(insertvalue,'rows');
        if dimension==1 & changersafety==0;
            insertedrows=zeros(selectedendrow2-selectedoriginrow2+1,columns);
            insertedrows(1:end,1:end)=changer;
            a=cat(1,a(1:selectedoriginrow2,:),insertedrows,a(selectedoriginrow2+1:end,:));
            totaliterationscompleted=totaliterationscompleted+(selectedendrow2-selectedoriginrow2+1);
        elseif dimension==2 & changersafety==0
            computeiterations;
            insertedrows=zeros(selectedendrow2-selectedoriginrow2+1,columns);
            insertedrows(1:end,1:end)=changer;
            for currentplane=1:completediterations+1
                acolumnsinserttemp(:,:,currentplane)=cat(1,a(1:selectedoriginrow2,:,currentplane),insertedrows,a(selectedoriginrow2+1:end,:,currentplane));
            end;
            a=acolumnsinserttemp; computeiterations;
        else
            historystillunchangeable=1;
        end;
    elseif strcmp(insertvalue,'columns');
        if dimension==1 & changersafety==0;
            insertedcolumns=zeros(completediterations+1,(selectedendcol2-selectedorigincol2+1));
            insertedcolumns(1:end,1:end)=changer;
            a=cat(2,a(:,1:selectedorigincol2),insertedcolumns,a(:,selectedorigincol2+1:end));
        elseif dimension==2 & changersafety==0
            computeiterations;
            insertedcolumns=zeros(totalrows,(selectedendcol2-selectedorigincol2+1));
            insertedcolumns(1:end,1:end)=changer;
            for currentplane=1:completediterations+1
                acolumnsinserttemp(:,:,currentplane)=cat(2,a(:,1:selectedorigincol2,currentplane),insertedcolumns,a(:,selectedorigincol2+1:end,currentplane));
            end;
            a=acolumnsinserttemp; computeiterations;
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

else;
    errordlg('Enter new row value in Input Box','Error');
end;
