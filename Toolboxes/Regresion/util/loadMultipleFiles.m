function [indicatorDataOnOff indicatorData indexReturns dates indicatorNames indicatorTickers]=loadMultipleFiles(fileNameArray,sheetNameArray, MAT_FILE_IO, deleteExtraRowsFlag)

    fprintf('BEGIN LOADING DATA\n');

    if nargin<4, deleteExtraRowsFlag=true; end
    if nargin<3, MAT_FILE_IO=0; end
    
    numfiles =getStrSize(fileNameArray);
    numWorksheets = getStrSize(sheetNameArray);
    
    if numfiles<1 || numWorksheets<1, error('There should be atleast one spreadsheet and one worksheet'); end 
    numDatabases = numfiles * numWorksheets;

    for i=1:numDatabases
        [i1 i2]=getIndexes(i, numWorksheets);
        singleFileName =getStrName(fileNameArray,i1);
        singleSheetName = getStrName(sheetNameArray,i2); 
        
        lastDatabaseFlag = (i==numDatabases);
        
        if i==1
            [indicatorDataOnOff indicatorData indicatorTickers indicatorNames dates]=LoadIndicatorData(singleFileName,singleSheetName,lastDatabaseFlag, MAT_FILE_IO);
        else
            [indicatorDataOnOffTemp indicatorDataTemp indicatorTickersTemp indicatorNamesTemp datesTemp]=LoadIndicatorData(singleFileName,singleSheetName,lastDatabaseFlag, MAT_FILE_IO);
            if size(dates) ~= size(datesTemp), error(' Dates Size mismatch across sheets. Multiple sheets must have exactly same dates'); end
            indicatorDataOnOff = [indicatorDataOnOff indicatorDataOnOffTemp]; 
            indicatorTickers = [indicatorTickers indicatorTickersTemp];
            indicatorData = [indicatorData indicatorDataTemp];
            indicatorNames = [indicatorNames indicatorNamesTemp];
        end
        
    end
    
    indexReturns = indicatorData(:,end);
    indicatorData(:,end)=[];
    indicatorDataOnOff(:,end)=[];
    
    fprintf('  Final Number Of Indicators (All Sheets Combined) Switched ON: %d\n',size(indicatorData,2));
    
    % Delete all the rows which don't have return data
    if nargin<3 || deleteExtraRowsFlag == true
        redundantDates = isnan(indexReturns);
        redundantDatesLastElem = find(redundantDates,1,'last');
        redundantDates(redundantDatesLastElem)=false;
        if (sum(redundantDates)>0)
            fprintf('  Deleting First %d rows of indicatorData as Return numbers dont exist\n',sum(redundantDates));
            indexReturns(redundantDates,:)=[];
            indicatorData(redundantDates,:)=[];
            dates(redundantDates,:)=[];      
        end
    end
    
    fprintf('  Finished Loading Data\n\n');
end

function [i1 i2]=getIndexes(i, l2)
    i2 = rem(i,l2);
    if i2==0, i2 = l2; end
    i1 = (i-i2) / l2;
    i1 = i1+1;
end
