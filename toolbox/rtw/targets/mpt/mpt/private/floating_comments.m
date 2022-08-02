function status = floating_comments(modelName)
% FLOATING_COMMENTS enables floating comments to be in the generated code.
% 
%  FLOATING_COMMENTS(MODELNAME)
%        Implements /* <S:  > */ operator to enable floating comments to be included 
%        in the generated code.  
%        The user should put the operator at the insertion point of the diagram and 
%        next to the floating comment.
%
%  INPUT:
%         modelName: name of model to generate code for
%  OUTPUT:
%         status: 0 or -1 
%                -1: the Note format incorrect and code generation will stop.
%                 0: the process will be continued. 

%  Linghui Zhang
%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.8.4.3 $
%  $Date: 2004/04/15 00:28:04 $
ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');
globalComments = ecac.globalComments;
status = 0;

chartsInfo = get_charts_info(modelName);
comments = '';
% process comments in each chart    
for ic =1: length(chartsInfo)
    notes = chartsInfo{ic}.notes;
    for i = 1: length(notes)
        comments{i} = notes{i}.text;
        pat = '<S:\w*>';
        [startI,endI]=regexp(comments{i},pat);
        if ~isempty(startI) & ~isempty(endI)
            if  startI > 1 || endI < startI
                errMsg = 'Error using the Note format of Floating Comments.';
                restore_model(modelName);
                err_disp(modelName,'Error',errMsg);
                status =-1;
                return;
            end
        end    
    end
    comments = [comments, globalComments];
    trans = chartsInfo{ic}.transitions;
    for i = 1 : length(trans)
        labelS = trans{i}.labelString;
        labelS_n = labelS;
        startC = findstr(labelS, '/*');
        endC = findstr(labelS, '*/');
        for jc =1: length(startC)    
            pat = '<S:\w*>';
            [startI,endI]=regexp(labelS(startC(jc):endC(jc)),pat);
            for k = 1: length(startI)
                Scomm = labelS(startI(k)+startC(jc)-1:endI(k)+startC(jc)-1);   
                for j = 1:length(comments)
                    if findstr(comments{j}, Scomm)
                        ScommR = comments{j}(length(Scomm)+1:end);
                        labelS_n = regexprep(labelS_n, Scomm, ScommR);
                        break;
                    end
                end
            end
        end
        sf('set', trans{i}.handle, '.labelString',labelS_n)
     end
end
return;

