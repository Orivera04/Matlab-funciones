savingpath=uigetdir;
timenow=num2str(datestr(now,30));
current_time_date = ['Pic_',num2str(timenow(1,10:11)),'.', num2str(timenow(1,12:13)),'.', num2str(timenow(1,14:15)),'__', num2str(timenow(1,5:6)),'.', num2str(timenow(1,7:8)),'.', num2str(timenow(1,1:4)),'.','jpg'];
current_time_date = {current_time_date}; %changes current_time_date to a cell for inputdlg
savingname=(inputdlg('','Save As',1,current_time_date));
savingname=savingname{1}; %converts savingname from a cell to a variable for Save
savingname=[savingpath,'\',savingname];
saveas(gca,savingname,'jpg');
