function [indicatorDataOnOff indicatorData indicatorTickers indicatorNames dates]=LoadIndicatorData(fileName,sheetName, lastSheetFlag, MAT_FILE_IO)

    if nargin<4, MAT_FILE_IO=0; end
    if nargin<3, lastSheetFlag=1; end
    
    fprintf('  Load file: "%s"\n',fileName);
    if ~MAT_FILE_IO
        fprintf('  Load Sheet: "%s"\n',sheetName); 
    end
    
    indicatorTickersFlag =0;

    % reads spreadsheet in numerical and string formats
    if MAT_FILE_IO
        load(fileName);
    else
        [database,txt] = xlsread(fileName,sheetName);
    end
    
    %Parsing different file formats
    if strcmp(txt{1,2},'BUCKET')
        %BUCKET File format
        fprintf('    BUCKET File Format\n');
        database(:,[1 2])=[];
        txt(:,1)=[];
        txt(1,:)=[];
        addColumnValue=2;
    elseif strcmp(txt{1,1},'THREE_MODEL')
        %Three Model File format
        fprintf('    THREE_MODEL File Format\n');
        indicatorTickersFlag =1;
        indicatorTickers = txt(1,2:end);
        txt(1,:)=[];
        addColumnValue=1;
    else
        %Standard File format
        fprintf('    STANDARD File Format\n');
        addColumnValue=1;
    end
    
    %Extract Data to relevant arrays
    indicatorData=database(2:end,1:end);
    indicatorDataOnOff=database(1,1:end);
    dates=txt(3:end,1);   
    indicatorNames=txt(1,2:end);
    excelColumnNames = getExcelColumnNames((1:size(indicatorDataOnOff,2))+addColumnValue);
    
    if ~indicatorTickersFlag, indicatorTickers= indicatorNames; end
    
    %Check that indicatorOnoff Switch has no nans
    if any(isnan(indicatorDataOnOff))
        fprintf('  ===============================================================================\n');
        fprintf('  DATA ERROR: IndicatorOnOff switch not provided for following indicators/index returns:\n ExcelColumns: ');
        disp(excelColumnNames(isnan(indicatorDataOnOff)));
        fprintf('  ===============================================================================\n');                  
        error('IndicatorOnOff switch not supplied (see above for detail)');
    end
    
    if ~indicatorDataOnOff(end) && lastSheetFlag
        fprintf('  ===============================================================================\n');
        fprintf('  DATA ERROR: IndicatorOnOff is switchedOff for last Column presumeably Index returns:\n ExcelColumns: ');
        temp = find(~indicatorDataOnOff);
        disp(excelColumnNames(temp(end)));
        fprintf('  ===============================================================================\n');                  
        error('IndicatorOnOff switchedOff for last Column presumeably Index returns)');
    end
    
    fprintf('    Indicator Loaded (All Indicators) = %d\n',size(indicatorDataOnOff,2));
    fprintf('    Removing Switched off Indicators\n');
     
    %Chuck Out the Switched-off Indicators
    indicatorData(:,indicatorDataOnOff==0)=[];
    indicatorNames(:,indicatorDataOnOff==0)=[];
    indicatorTickers(:,indicatorDataOnOff==0)=[];
    excelColumnNames(:,indicatorDataOnOff==0)=[];
    indicatorDataOnOff(indicatorDataOnOff==0)=[];
    
    fprintf('    Indicator Loaded (Indicators Switched On) = %d\n',size(indicatorData,2));       

    % check DATA sizes right away
    if size(indicatorDataOnOff,1)~=1 || size(indicatorNames,1)~=1 || size(indicatorTickers,1)~=1 
        error('Loading Error: IndicatorOnOff OR IndicatorNames OR IndicatorTickers seems to have more than 1 row');
    end
    if size(dates,2)~=1
         error('Loading Error: Dates seems to have more than 1 column');    
    end
    if size(indicatorData,2)~=size(indicatorNames,2) || size(indicatorDataOnOff,2)~=size(indicatorNames,2) || size(indicatorTickers,2)~=size(indicatorNames,2)
         error('Loading Error: Size of IndicatorNames/Tickers and actual Indicator number seem to be different');
    end
    if size(dates,1)~=size(indicatorData,1) || size(indicatorData,1)<1  
         error('Loading Error: Number of dates and number of indicator points are different. Maybe Sheet has extra useless data/date at the bottom.');
    end

    % check if date data is in right format
    dateTest=dates{1,1};
    if length(dateTest)<10 || datenum(dateTest,'dd/mm/yyyy')<=0 || size(dates,1)==0 ||  size(dates,2)==0 
       error('Loading Error: Data sheet dates must be in date format dd/mm/yyyy and should not be missing');
    end
    
    %here do complete data check
    foundData = isnan(indicatorData);
    foundData = foundData(1:end-1,:) - foundData(2:end,:);
    [foundData_r foundData_c]=find(foundData==-1);
    
    if size(foundData_r,1)>0
        if size(foundData_c,1)>1, foundData_c=foundData_c'; end
        fprintf('  ===============================================================================\n');
        fprintf('  DATA ERROR: Invalid data found for the following indicators/index returns:\n ExcelColumns: ');
        disp(excelColumnNames(foundData_c));
        fprintf('  ===============================================================================\n');                  
        error('Some indicators and/or index returns have invalid data (see above for detail)');
    end
    
    if any(foundData(end,:))
        foundData_c = find(foundData(end,:));
        if size(foundData_c,1)>1, foundData_c=foundData_c'; end
        fprintf('  ===============================================================================\n');
        fprintf('  DATA ERROR: Following indicators/index returns have No Data at All.\n ExcelColumns: ');
        disp(excelColumnNames(foundData_c));
        fprintf('  ===============================================================================\n');   
        error('One or more Indicator had no data: Look above for details');
    end
    fprintf('    Finsihed Load Worksheet\n');
end


