function mdev= mle(mdev,InitVal,LinAlg,TolFun,ProgressTable,PredMode);
%MLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:04:45 $



FixLocal= 1;

ModelNo= BMIndex(mdev);

%mdev= mleinit(mdev,ModelNo,1,PredMode);


[Xg,Yrf,Sigma] = mledata(mdev,ModelNo,PredMode);
if size(Xg,1)>1000 & ~isempty(ProgressTable);
   opts.Default= 'No';
   opts.Interpreter= 'none';
   opts.CreateMode= 'modal';
   resp= questdlg(['This MLE process is extremely computationally intensive. ',...
         'It could take several hours to complete. Do you wise to continue?'],...
      'MLE Warning','Yes','No',opts);
   drawnow
   if strcmp(resp,'No')
      return
   end
end
if strcmp(lower(InitVal),'univariate')
   ModelNo= 1;
   mdev= InitStore(mdev,ModelNo);
   TS= mdev.TwoStage{ModelNo};
   TS= covinit(TS,[]);
else
   ModelNo= 2;
   mdev= InitStore(mdev,ModelNo);
   TS= mdev.TwoStage{ModelNo};
end

[TS,alg]=mle_Algorithm(TS);
[TS,OK]= pevinit(TS,Xg,Yrf,Sigma);
if OK
	[TS,OK,xfinal]= fitmodel(TS,Xg,Yrf,Sigma,ProgressTable,LinAlg,TolFun);
	% initialise PEV calcs
	TS= pevinit(TS,Xg,Yrf,Sigma);
	
	mdev.MLE.Solution= [1;xfinal];
	mdev.MLE.Model= TS;
	
	% Store MLE Modes
	mdev.MLE.Modes= [FixLocal,PredMode, strcmp(LinAlg,'mle_ExpMaxim')+1,TolFun];
	
	% make MLE model best
	[s,Models,mdev]= mle_validate(mdev);
	% make mle model the best model
    [mdev,msg]= mle_best(mdev,1);
    if ~isempty(ProgressTable) && ~isempty(msg)
        hFig= msgbox(msg,...
            'Model','modal');
        uiwait(hFig);
    end
	% make mle rf models
	mdev= makemlerf(mdev);
	mdev= status(mdev,1);
elseif ~isempty(ProgressTable)
	errordlg('There is insufficient data available to run MLE','MLE Error','modal')
end
p= pointer(mdev);


