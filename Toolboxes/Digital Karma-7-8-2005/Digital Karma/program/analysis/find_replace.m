evaluate_changer;
if exist('changer');
    [changerrows, changercols, changerplanes]=size(changer);
    save_undo;
    
    if changerplanes==1;
        a(selectedoriginrow2:selectedoriginrow2+changerrows-1, selectedorigincol2:selectedorigincol2+changercols-1, end)=changer;
    else;
        a(selectedoriginrow2:selectedoriginrow2+changerrows-1, selectedorigincol2:selectedorigincol2+changercols-1, selectedoriginiteration2:selectedoriginiteration2-changerplanes+1)=flipdim(changer,3);
    end;
    CA_Display;
else;
    errordlg('Enter ''replace with'' value or matrix in Input Box','Error');
end;