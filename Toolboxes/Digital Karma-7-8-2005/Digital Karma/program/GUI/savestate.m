if (savingvalue==1) | (savingvalue==2) | ((savingvalue==3) & (currentlyselecting==1));
    savingpath=uigetdir;
    timenow=num2str(datestr(now,30));
    current_time_date = ['Saved_State_',num2str(timenow(1,10:11)),'.', num2str(timenow(1,12:13)),'.', num2str(timenow(1,14:15)),'__', num2str(timenow(1,5:6)),'.', num2str(timenow(1,7:8)),'.', num2str(timenow(1,1:4)),'.','mat'];
    current_time_date = {current_time_date}; %changes current_time_date to a cell for inputdlg
    savingname=(inputdlg('','Save As',1,current_time_date));
    savingname=savingname{1}; %converts savingname from a cell to a variable for Save
    savingname=[savingpath,'\',savingname];
end;

if savingvalue==1;
    save(savingname,'a'); %saves variable A with the string in savingname
elseif savingvalue==2;
    saving_temp=a;
    a=b;
    save(savingname,'a');
    a=saving_temp;
elseif savingvalue==3;
    if currentlyselecting==1;
        saving_temp=a;
        a=aselection;
        save(savingname,'a');
        a=saving_temp;
    else;
        errordlg('Select Area to be saved','Error');
    end;
end;
