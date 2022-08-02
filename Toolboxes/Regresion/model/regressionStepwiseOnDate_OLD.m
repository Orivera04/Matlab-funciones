function [inPoolIndicators str]=regressionStepwiseOnDate_OLD(testIndicators, testReturns, inPoolIndicators, outPoolIndicators, permPoolIndicators, regressionParams)
    str='';
    stepWiseIndicatorFit = regressionParams.stepWiseIndicatorFit;
  
    pEnter = stepWiseIndicatorFit(1,2);
    pRemove = stepWiseIndicatorFit(1,3);
    
    minNumInd = max(1,stepWiseIndicatorFit(1,4));
    maxNumInd = stepWiseIndicatorFit(1,5);
    considerationIndicators = logical(inPoolIndicators+outPoolIndicators+permPoolIndicators);
    tempPermPoolIndicators= logical(permPoolIndicators(:,considerationIndicators));
    
    if isempty(maxNumInd) || maxNumInd<1 || maxNumInd<minNumInd
        maxNumInd =sum(inPoolIndicators)+sum(outPoolIndicators);
    end
    
    warning off all;
    inPoolIndicators = zeros(size(considerationIndicators));
    inPoolIndicators(1,considerationIndicators)=1;
    if sum(considerationIndicators)>minNumInd
        if sum(considerationIndicators)>minNumInd
            [betas,se,pval,inmodel]=stepwisefit(testIndicators(:,considerationIndicators),testReturns,'penter',pEnter, 'premove',pRemove,'keep',tempPermPoolIndicators,'display','off');
            if size(inmodel,1)>1, inmodel = inmodel'; end
            if size(pval,1)>1, pval = pval'; end
            inmodel=projectMatrix(considerationIndicators,inmodel);
            pval=projectMatrix(considerationIndicators,pval);
            pval(~considerationIndicators)=1;
            str=sprintf('%sRan MatLabStepwise, Got %d Indicator: ',str,sum(inmodel));
        end
        if sum(inmodel)<minNumInd
            considerationSetNew = logical(considerationIndicators-inmodel);
            [betas,se,pvalNew,inmodelNew]=stepwisefit(testIndicators(:,considerationSetNew),testReturns,'penter',pEnter, 'premove',pRemove,'display','off');
            if size(inmodelNew,1)>1, inmodelNew = inmodelNew'; end
            if size(pvalNew,1)>1, pvalNew = pvalNew'; end
            str=sprintf('%sRan MatLabStepwise Again, Got %d Indicator: ',str,sum(inmodelNew));
            inmodelNew = projectMatrix(considerationSetNew,inmodelNew);
            pvalNew = projectMatrix(considerationSetNew,pvalNew);
            pvalNew(~considerationSetNew)=1;
            if sum(inmodelNew)>=minNumInd
                str=sprintf('%sDumped first, Accepted Second Run: ',str);
                inmodel = inmodelNew;
                pval = pvalNew;
            else
                str=sprintf('%sPooling Indicators of two Runs: ',str);
                if sum(inmodelNew)+sum(inmodel)<minNumInd
                    requiredNum = minNumInd-sum(inmodelNew)-sum(inmodel);
                    temp = 1:size(inmodelNew,2);
                    temp(2,:)=(pval+pvalNew)/2;
                    temp(:,logical(inmodelNew+inmodel))=[];
                    temp = temp';
                    temp = sortrows(temp,2);
                    temp(requiredNum+1:end,:)=[];
                    inmodel=logical(inmodelNew+inmodel);
                    inmodel(temp(:,1))=1;
                    str=sprintf('%sStill Added %d Indicator: ',str,requiredNum);
                else
                    pval(1,~logical(inmodel))=0;
                    pvalNew(1,~logical(inmodelNew))=0;
                    inmodel = inmodel + inmodelNew;
                    pval = pval + pvalNew;
                end
            end
        end
        temp = sortPValues(inmodel,pval);
        if size(temp,1)>maxNumInd
            str=sprintf('%sDropped %d Indicator: ',str,size(temp,1)-maxNumInd);
            temp(maxNumInd+1:end,:)=[];
        end
        inPoolIndicators = zeros(size(considerationIndicators));
        inPoolIndicators(1,temp(:,1))=1;
    end
    warning on all;
end

function [output]=sortPValues(inmodel, pvalues)
    output = inmodel .* (1:size(inmodel,2));
    output(2,:) = pvalues;
    output = output';
    output(output(:,1)==0,:)=[];
    output = sortrows(output,2);
end

function [projectionRowLogical]=projectMatrix(considerationSet, smallsubSet)
    considerationSet = logical(considerationSet);
    if size(smallsubSet,2)~=sum(considerationSet)
        error('projectMatrix: Code corrupted somewhere, Input Matrix sizes dont match');
    end
    projectionRowLogical =zeros(size(considerationSet));
    projectionRowLogical(1,considerationSet)=smallsubSet;
end
