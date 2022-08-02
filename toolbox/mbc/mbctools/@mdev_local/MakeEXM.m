function [m,mlist]= MakeEXM(mdev,Types)
%MAKEEXM make exportmodel for command-line or CAGE
% 
%  Models= MakeEXM(mdev);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.1.6.3 $  $Date: 2004/04/20 23:19:05 $


if nargin<2
    Types={};
end

if ~iscell(Types)
    Types= {Types};
end

m= BestModel(mdev);
if isempty(m)
    Types= {'switch'};
end


if any(strcmpi(Types,'switch'))
    % use switch model instead of two-stage
    G= model( mdevtestplan(mdev) );
    [LocalMap,OK] = LocalModel(mdev,':');
    [X,Y]= getdata(mdev,'FIT');
    m = xregmodswitch(LocalMap(OK),double(X{end}(OK)),G);
end
    
% boundary model
conModel= BoundaryModel(mdevtestplan(mdev),m);
ModelInfo= exportinfo(info(project(mdev)),address(mdev),{m});
m = xregstatsmodel(m,varname(m),ModelInfo,conModel);


mlist={};
if numChildren(mdev)
    L= model(mdev);
    resp= varname(L);
    mlist={{}};
    for i=1:length(Types)
        switch lower(Types{i})
            case 'switch'
                
            case 'datum'
                if get(L,'datumtype') 
                    pDatum= datumlink(mdev);
                    mlist{i}= {MakeEXM(pDatum.info)};
                    INFO= getinfo(mlist{i}{1});
                    if get(L,'datumtype')==3
                        INFO.DatumOf= 'datum link';
                    else
                        INFO.DatumOf= resp;
                    end
                    mlist{i}{1}= setinfo(mlist{i}{1},INFO);
                end
            case 'global'
                if any(strcmpi(Types,'switch'))
                    % all response features 
                    rfInd= 1:numChildren(mdev);
                else
                    rfInd= mdev.ResponseFeatures(1,:) + RFstart(L);
                end
                if ~RFstart(L) && any(strcmpi(Types,'datum'))
                    % don't get datum model twice
                    rfInd= rfInd(2:end);
                end
                mlist{i}= children(mdev,rfInd,'MakeEXM');
                
                INFO= getinfo(mlist{i}{1});
                INFO.ResponseOf= resp;
                for j=1:length(mlist{i})
                    mlist{i}{j}= setinfo(mlist{i}{j},INFO);
                end

        end
    end
    mlist= [mlist{:}];
end
    
