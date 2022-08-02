function [X,Y,DataOK]= FitData(mdev,SNo);
% MODELDEV/

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:04:01 $

if nargin==1
	SNo=1;
end

if mdev.IsLinearised && isfield(mdev.MLE,'Model')
    [X, Y] = getdata( mdev, 'FIT' );
    X{1}= X{1}(:,:,SNo);
    X{2}= X{2}(:,:,SNo);
    Y= Y(:,:,SNo);
    TS= mdev.MLE.Model;
    [Xc,Yc,OK,BadData] = lincheckdata(TS,X,Y); 
    DataOK= ~BadData;
    
    [X, Y] = getdata( mdev, 'FIT',0);
    X= X{1}(:,:,SNo);
    Y= Y(:,:,SNo);
else
    mdev.IsLinearised= false;
    % get data with outliers 
    [X,Y]= getdata(mdev,'X',1);
    X= X(:,:,SNo);
    Y= Y(:,:,SNo);
    % find good data
    [Xc,Yc,OK,BadData]=checkdata(model(mdev),X,Y);
    DataOK= ~BadData;
    % get with no outliers
    [X,Y]= getdata(mdev,'X',0);
    X= X(:,:,SNo);
    Y= Y(:,:,SNo);
end