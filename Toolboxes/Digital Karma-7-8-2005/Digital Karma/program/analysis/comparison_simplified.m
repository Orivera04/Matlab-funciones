% This file doesn't use the analysisarea since it needs multiple
% selections.  It uses the analysisarealabel to set what it needs

if strcmp(analysisarealabel,'matrix') | strcmp(analysisarealabel,'selection');
    
run save_undo;
numberofstatescomparing=(inputdlg('Number to Compare'));
numberofstatescomparing=str2num(numberofstatescomparing{1});
if dimension==1;
    if strcmp(analysisarealabel,'matrix');
        [loadingname, loadingpath]=uigetfile('*.mat','Select First State',5,5); load([loadingpath,loadingname]);
        aoriginal=a; totalcomparing=a; btotal=a; b1=btotal;
    elseif strcmp(analysisarealabel,'selection');
        aoriginal=acopiedselection{end}; totalcomparing=acopiedselection{end};
        btotal=acopiedselection{end}; b1=btotal;
    end;
    compare_any_successful=1;
    for j=1:numberofstatescomparing-1
        if strcmp(analysisarealabel,'matrix');
            [loadingname, loadingpath]=uigetfile('*.mat','Load Next State',5,5); load([loadingpath,loadingname]);
            currentlycomparing=a;
        elseif strcmp(analysisarealabel,'selection');
            currentlycomparing=acopiedselection{end-j}; end;
        [currentlycomparingrows,currentlycomparingcols,currentlycomparingiterations]=size(currentlycomparing);
        [aoriginalrows,aoriginalcols,aoriginaliterations]=size(aoriginal);
        if currentlycomparingrows==aoriginalrows & currentlycomparingcols==aoriginalcols & currentlycomparingiterations==aoriginaliterations;
            totalcomparing=cat(3,totalcomparing,currentlycomparing);
            sorta=sort(sort(sort(totalcomparing),3),2); highestavalue=sorta(end); lowestavalue=sorta(1,1,1); arange=(highestavalue-lowestavalue+1);
            
            [changedrow, changedcolumn]=find(b1==currentlycomparing==0);
            [changedrowsize,changedcolumnssize]=size(changedrow);
            totalchanged=[changedrow,changedcolumn];
            for checking=1:changedrowsize
                b1(totalchanged(checking,1),totalchanged(checking,2))=NaN;
            end;
            btotal=b1;
        else;
            compare_any_successful=0;
            errordlg('All States Must Be Same Size','Error');
        end;
    end;
elseif dimension==2
    if strcmp(analysisarealabel,'matrix');
        [loadingname, loadingpath]=uigetfile('*.mat','Select First State',5,5); load([loadingpath,loadingname]);
        aoriginal=a; totalcomparing=a; btotal=a;
    elseif strcmp(analysisarealabel,'selection');
        currentlycomparing=acopiedselection{end};
        aoriginal=currentlycomparing; totalcomparing=currentlycomparing; btotal=currentlycomparing; end;
    compare_any_successful=1;
    for j=1:numberofstatescomparing-1
        if strcmp(analysisarealabel,'matrix');
            [loadingname, loadingpath]=uigetfile('*.mat','Load Next State',5,5); load([loadingpath,loadingname]);
            currentlycomparing=a; atotal=currentlycomparing;
        elseif strcmp(analysisarealabel,'selection');
            currentlycomparing=acopiedselection{end-j};
            atotal=currentlycomparing; end;
        [currentlycomparingrows,currentlycomparingcols,currentlycomparingiterations]=size(currentlycomparing);
        [aoriginalrows,aoriginalcols,aoriginaliterations]=size(aoriginal);
        if currentlycomparingrows==aoriginalrows & currentlycomparingcols==aoriginalcols & currentlycomparingiterations==aoriginaliterations;
            totalcomparing=cat(3,totalcomparing,atotal);
            run computeiterations;
            sorta=sort(sort(sort(totalcomparing),3),2); highestavalue=sorta(end); lowestavalue=sorta(1,1,1); arange=(highestavalue-lowestavalue+1);
            for currentchecking=1:aoriginaliterations
                b1=btotal(:,:,currentchecking); a1=atotal(:,:,currentchecking);
                [changedrow, changedcolumn]=find(b1==a1==0);
                [changedrowsize,changedcolumnssize]=size(changedrow);
                totalchanged=[changedrow,changedcolumn];
                for checking=1:changedrowsize
                    b1(totalchanged(checking,1),totalchanged(checking,2))=NaN;
                end;
                btotal(:,:,currentchecking)=b1;
            end;
        else;
            compare_any_successful=0;
            errordlg('All States Must Be Same Size','Error');
        end;
    end;
end;
btotal(find(isnan(btotal)))=lowestavalue+arange;

if compare_any_successful==1;
    if strcmp(analysisarealabel,'matrix');
        a=btotal;
    elseif strcmp(analysisarealabel,'selection');
        acopiedselection{end+1}=btotal; paste_selection; acopiedselection=acopiedselection(1:end-1,:);
    end;
    
    % I didn't run colorsetmine because that pulls the rangescale from the box
    high=(lowestavalue+arange);
    set(findobj('Tag','highinput'), 'string',num2str(high));
% blanked since created autoscale    rangescale=(arange+1); set(findobj('Tag','rangescaleinput'), 'string',num2str(rangescale));
    if colorchosen==1; colordisplay=jet(rangescale); elseif colorchosen==2; colordisplay=flipud(gray(rangescale)); end;
    
    startingstatus=['none']; load_State;
    errordlg('Compare Successful','Error');
end;

elseif strcmp(analysisarealabel,'graphed');
    errordlg('Compare is not valid for Analysis Area ''Currently Graphed''','Error');
end;