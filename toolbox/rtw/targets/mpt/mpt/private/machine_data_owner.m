function fileName = machine_data_owner(machineDataElement,ChartsDataSets,filePackage)
%MACHINE_DATA_OWNER Returns the list of files associated with the machine data passed in
%
%
%    [FILENAME]=MACHINE_DATA_OWNER(MACHIENDATAELEMENT,CHARTSDATSETS,FILEPACKAGE)
%    This function associated machine dataq with the charts that use the data and
%    then associates the charts withe the file packjaging they have beed assigned to.
%      
%    Inputs:
%              machineDataElement : machine data object
%              chartsDataSets     : chart to machine data mapping structure
%              filePackage        : file packaging data structure
%
%   Outputs:
%              fileName           : Array of all files that the data is associated with.  
%


%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2004/04/15 00:28:21 $
%   $ Date:  $
%   $ Revision:  $



fileName  = [];
chartName = [];

%
% First find the chart or charts where the data element is used
%

for i=1:length(ChartsDataSets),
    for ix=1:length(ChartsDataSets(i).data)
       if strcmp(machineDataElement.name,ChartsDataSets(i).data(ix).symbolName)==1,
         chartName{end+1} = ChartsDataSets(i).name;      
       end
   end
end

%
% Second we find the file that that chart now belongs to and associate the
% file with the data element.
%


for i=1:length(chartName),
    for ix=1:length(filePackage),
        for ic=1:length(filePackage{ix}.chart),
            if strcmp(chartName{i},filePackage{ix}.chart{ic}.chart.name)==1,
                fileName{end+1} = filePackage{ix}.fileName;
            end
        end
    end      
end       

%
% Return the cell array of files to associate this variable with.
%

return