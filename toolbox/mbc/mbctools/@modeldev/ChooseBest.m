function OK= ChooseBest(mdev,Criteria)
%CHOOSEBEST choose best model from sub-models
% 
% OK= ChooseBest(mdev,Criteria)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:09:27 $

OK= true;
if numChildren(mdev)>0
    chstatus= children(mdev,'status'); 
    chstatus=[chstatus{:}];
    mi= children(mdev,1,'model');
    mi=mi{1};
    
    % choose best model based on Criteria if possible otherwise RMSE
    if any(chstatus)
        [S,Chead]= childstats(mdev);
        ind= find(strcmp(Criteria,Chead));
        if isempty(ind)
            % use RMSE by default
            Criteria= 'RMSE';
            ind= find(strcmp(Criteria,Chead));
        end
        
        if isa(mi,'localmod')
            [sm,BestInd]=min(S(:,ind));
        else
            % determine whether to minimize or maximize selection criteria
            [List,Width,SummStatsType,MinIsBest]= StatsList(mi);
            if MinIsBest(strcmp(Chead{ind},List))
                [sm,BestInd]=min(S(:,ind));
            else
                [sm,BestInd]=max(S(:,ind));
            end
        end
        % select best model
        BestModel(mdev,children(mdev,BestInd));
        % turn status back to 0 after bestmodel 
        % bestmodel normally requires status to be 1 or 2
        children(info(mdev),chstatus==0,'status',0);
        
        OK= true;
    else
        OK= false;
    end
    
    mdev= info(mdev);
end