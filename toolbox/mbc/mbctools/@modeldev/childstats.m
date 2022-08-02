function [Stats,List,Width]= childstats(mdev)
% MODELDEV/CHILDSTATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:10:03 $



Stats= children(mdev,'statistics');
ch= children(mdev);

N= numChildren(mdev);

% find out whether comparisons are ok
DataType= i_FindDataType(mdev);

switch N
    case 0
        % no submodels
        List={};
        s= zeros(N,0);
        Width=s;
    case 1
        % only 1 submodel
        [List,Width]= colhead( info( ch(1) ) );
        s= Stats{1};
    otherwise
        % more than 1 subnodels
        
        
        % Set up Summary stats for the first child
        [List,Width]= colhead( info(ch(1)) );
        [List,ind]= i_StatsList(info(ch(1)),DataType);
        if isempty(Stats{1})
            % stats is wrong size so make everything NaN
            s= NaN*zeros(size(List));
        else
            s= Stats{1}(ind);
        end
        Width= Width(ind);
        
        for i=2:N
            % List for current submodel
            [CurrentList,ind]= i_StatsList(info(ch(i)),DataType);
            
            % stats for current model (could exclude some stats for data)
            if isempty(Stats{i})
                % stats is wrong size so make everything NaN
                sCurrent= NaN*zeros(size(CurrentList));
            else
                sCurrent= Stats{i}(ind);
            end
            % check if used in previous lists
            [ok,loc]= ismember(List,CurrentList);
            
            % keep common List and Width Items
            List= List(ok);
            Width= Width(ok);
            % concantenate stats
            s= [s(:,ok) ; sCurrent(loc(loc~=0))];
        end
        
        % Normalise Width
        Width= Width/sum(Width);
end

Stats= s;




function [List,ind]= i_StatsList(mdev,Type);
%STATSLIST

if nargin<2
    Type= 'summary';
end



if nargout>1 && ~strcmp(Type,'summary');
    List= StatsList(mdev.Model,Type);
    SummaryList= StatsList(mdev.Model,'summary');
    [Comon,ia,ind]= intersect(SummaryList,List);
    ind= sort(ind);
else
    List= colhead(mdev);
    ind= 1:length(List);
end




function DataType= i_FindDataType(mdev)

N= numChildren(mdev);
if N>1 && any(strcmp(class(mdev),{'modeldev','mdevmlerf'}) ) && ~isa(mdev.Model,'xregtwostage')
    
    Ydata= children(mdev,'getdata','Y');
    Stats= children(mdev,'statistics');
    bc=Stats{1}(3); 
    % check if outliers the same  
    ga = getGuids(Ydata{1}(isbad(Ydata{1})));
    i= 2;
    while i<=N && ...
            isequal( ga, getGuids( Ydata{i}(isbad(Ydata{i})) ) ) && ... % Same outliers
            Stats{i}(3)==bc  % box-cox transform is the same
        i= i+1;
    end
    SameData= i>N;
else
    SameData= true;
end
    
if SameData
    DataType= 'summary';
else    
    DataType= 'data';
end
