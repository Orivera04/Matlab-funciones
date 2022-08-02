if currentlyselecting==1;
    if exist('acopiedselection');
        acopiedselection{end+1,:}=aselection;
    else; acopiedselection={aselection}; end;
    
    if exist('cuton');
        if changersafety==0 | ((dimension==2 & completediterations==selectedoriginiteration2-1 & completediterations==selectedenditeration2-1)...
                | (dimension==1 & currentiteration==selectedoriginrow2-1 & currentiteration==selectedendrow2-1));
            evaluate_changer;
            if exist('changer');
                [changerrows, changercols, changerplanes]=size(changer);
                run save_undo;
                a(selectedoriginrow2:selectedendrow2,selectedorigincol2:selectedendcol2,selectedoriginiteration2:selectedenditeration2)...
                    =changer;
                clear cuton;
            else; errordlg('Input Value must be a Number or Variable','Error');
            end;
        else; errordlg('Must Deactivate ''History Unchangeable'' under Settings','Error');
        end;
    end;
    matrixpaste=aselection;
else; errordlg('Make a Selction','Error');
end;


    
