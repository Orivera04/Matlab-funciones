function OK = UpdateModel(mdev,KeepOutliers,UnChangedTests)
%UPDATEMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.4 $  $Date: 2004/02/09 08:04:18 $

OK=1;
if nargin==1
   KeepOutliers=0;
end
if nargin<3
    UnChangedTests= zeros(0,2);
end

OldUnChanged= UnChangedTests(:,1);
NewUnChanged= UnChangedTests(:,2);


% change size of RFData 
% note data is retrieved WITHOUT outliers set to NaN as indices can change
X= getdata(mdev,'FIT',0); 
XG=X{end};
D= mdev.RFData.info;

[X1,Y]= getdata(mdev,'X');
Ns= size(Y,3);
D= [XG(:,~1) [D(~1,:); zeros(size(XG,1),size(D,2))] ]; 

% Partial update if there are unchanged tests
PartialUpdate= ~isempty(NewUnChanged);
    

if ~KeepOutliers
   % clear the notes
   mdev.Notes = {};
   % clear outliers
   mdev= info(outliers(mdev,[]));
else
   % augment notes to be the correct size
   if ~isempty(mdev.Notes) && size(mdev.Notes,2)==2
       NewNotes= cell(Ns,2);
       NewNotes(:,1)= {''};
       NewNotes(:,2)= {[0 0 0]};
       NewNotes(NewUnChanged,:)= mdev.Notes(OldUnChanged,:);
       mdev.Notes= NewNotes;
   else
       mdev.Notes= {};
   end
end

L= model(mdev);
if PartialUpdate && isempty( covmodel(L) ) && ~mdev.IsLinearised
    % refit model only refit tests which have changed

    % test fitted
    s= false(1,Ns);
    s(NewUnChanged)= mdev.FitOK(OldUnChanged);
    mdev.FitOK= s(:)';
    % model parameters 
    s= zeros(size( mdev.AllModels,1),Ns);
    % parameters need initialising
    s(:)= NaN;
    s(:,NewUnChanged)= mdev.AllModels(:,OldUnChanged);
    mdev.AllModels= s;    

    % response feature covariance
    [N1,N2,N3]= size(mdev.MLE.Sigma);
    s= zeros(N1,N2, Ns);
    s(:,:,NewUnChanged)= mdev.MLE.Sigma(:,:,OldUnChanged);
    mdev.MLE.Sigma = s;
    % natural sse
    s= zeros(Ns,1);
    s(NewUnChanged)= mdev.MLE.SSE_nat(OldUnChanged);
    mdev.MLE.SSE_nat= s;
    % sse (possibly transformed)
    s= zeros(Ns,1);
    s(NewUnChanged)= mdev.MLE.SSE(OldUnChanged);
    mdev.MLE.SSE = s;
    % degrees of freedom for each test
    s= ones(Ns,1);
    s(NewUnChanged)= mdev.MLE.df(OldUnChanged);
    mdev.MLE.df      = s;
    

    if size(D,2)>0
        % response features
        D(NewUnChanged,:)=  double(mdev.RFData.info(OldUnChanged,:));
    end
    mdev.RFData.info = D;
    
    ChangedTests = setdiff(1:Ns, NewUnChanged);
    % only refit changed tests
    if ~isempty(ChangedTests)
        [OK,mdev]= fitmodel(mdev,ChangedTests(:)');
    end
else
    % refit all tests if using a covariance model linearised or all changed
    
    
    % response features
    mdev.RFData.info = D;
    
    % empty results stores
    mdev.MLE=[];
    mdev.FitOK=[];
    mdev.AllModels=[];
    % refit all
    [OK,mdev]= fitmodel(mdev);
end    

% update mdev on heap
xregpointer(mdev);