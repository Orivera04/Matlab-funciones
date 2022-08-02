function [View]= view(mdev,mbH,View);
%VIEW

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.10.4.3 $  $Date: 2004/02/09 08:11:06 $




switch mdev.ViewIndex
case 'global'
	[View]= viewGlobal(mdev,mbH,View);
case 'twostage'
	[View]= viewTS(mdev,mbH,View);
end


function [View]= viewTS(mdev,mbH,View);

hFig= double(mbH.Figure);
p= address(mdev);

ax= View.AxHand;
PageNo=View.PageNo;

viewH = findobj(View.menus.view,'tag','View');
nextH = findobj(View.menus.view,'tag','Next');
backH = findobj(View.menus.view,'tag','Back');

%% get local and global data. Note: need to catch if no best model here.
[X,Y]= getdata(p.info,'FIT');

XG= X{2};  % Global Input  Data

% set all axes vis=on since some may have been off in last view
% (will do necessary turn vis off below)
set(ax,'visible','on');
% Find out the loop size...depends if we are on last page
if PageNo== View.NumPages;	% we are on the last page...
   N=size(XG,3) - (View.NumPages-1)*View.SperPage;
   %% do not necessarily want to display all axes
   AxH=ax(N+1:end);
   set(findobj(AxH),'visible','off');
   set(backH,'enable','on');
   set(nextH,'enable','off');

elseif PageNo==1
   N=View.SperPage;
   set(backH,'enable','off');
   set(nextH,'enable','on');
else
   N=View.SperPage;   
   set([backH,nextH],'enable','on');
end

% select the sweeps for this page
SNos= (PageNo-1)*View.SperPage+1:(PageNo-1)*View.SperPage+N;

TS= p.model;
VarSym= char(get(TS,'symbol'));
VarSym = VarSym(nlfactors(TS)+1:end,:);

XG= XG(:,:,SNos);  % Global Input  Data
X = X{1};            % Local Input Data


% Clear axes, if already drawn...
h1=get(ax(1:end),{'children'});
ph=[cat(1,h1{:})];
delete(ph);

PlotOpts= num2cell(strcmp(get(View.Context,'checked'),'on'));
if PlotOpts{3} %% get the requested confidence interval IF it is checked
   PlotOpts{3} = get(View.CILevel,'value');
end

TS= p.model;
bm = p.bestmdev;
supp = p.MBsupport;
if supp.validate
   set(View.menus.Select,'enable','on');
else
   set(View.menus.Select,'enable','off');
end
if bm==0 | p.numChildren==0%% no best TS model or no more children
   set(View.cardLyt,'currentcard',2);
   set(View.Controls,'enable','off');
   set(View.Comments,'enable','inactive','string','');
   set(View.SweepClick,'enable','off');
   set(View.CILevel,'enable','off');
   set(ax,'visible','off');
   set([viewH,nextH,backH, View.menus.Evaluate],'enable','off');
   set(View.Comments,'string','');
   return
else
   set(View.cardLyt,'currentcard',1);
   set(View.Controls,'enable','on');
   set(View.Comments,'enable','on');
   set(View.SweepClick,'enable','on');
   set(View.CILevel,'enable','on');
   
   %% context menus
   utr = findobj(View.Context,'flat','tag','ytrans_units');
   if isempty(get(TS,'ytrans')) & isempty(get(get(TS,'local'),'ytrans'))
       set(utr, 'enable','off');
   else
       set(utr, 'enable','on');
   end
   %% turn view menu on
   set([viewH, View.menus.Evaluate],'enable','on');
   
   for k=1:N												% N=1,2 or 3;

      Xs= X(:,:,SNos(k));
      Ys= Y(:,:,SNos(k));
      
      % Display Experimental Point (Natural and Code values)
      % data to display Experimental Point (Natural and Coded values)
      Xg_nat= XG{k};
      globVarStr= [VarSym, blanks(size(Xg_nat,2))',...
            num2str(Xg_nat','%10.4g')];
      
      % plot results  (Blue points real data , blue line Local regression fit
      % Green Line TS fit)
      
      set(hFig,'CurrentAxes',ax(k))
      set(ax(k),...
         'XLimMode','auto','YLimMode','auto',...
         'nextplot','add')
      set(get(ax(k),'zlabel'),'userdata',[]);
      
      %% call twostage/sweep_plot
      sNumStr = sweep_plot(TS,{Xs,XG(:,:,k)},Ys,ax(k),PlotOpts);
      
      %%create info str for tooltip patch
      numBlankLines = size(globVarStr,1)-2;
      if numBlankLines<0
         %% globVarStr is only one line! pad this upto 2 lines
         globVarStr = strvcat(globVarStr,' ');
         infoStr = strvcat(sprintf('%10s','s'),sNumStr);
      else %% pad statStr upto size of globVarStr
         blnks = repmat(' ',[size(globVarStr,1)-2,1]);
         infoStr= strvcat(sprintf('%10s','s'),sNumStr,blnks);
      end
      infoStr = cat(2,globVarStr, infoStr);
      dataPatchFcnHandle = dataPatch(ax(k),infoStr,1);
      
      set(get(ax(k),'title'),'string',sprintf('Test %1d',testnum(XG(:,:,k))))   
      
      %% whole area for showing info-patch is 
      lyt = View.printLayout;
      set(ax(k),'NextPlot','ReplaceChildren',...
         'buttonDownFcn',{@i_AxButtonDown, dataPatchFcnHandle, infoStr,lyt});
   end
   
   xlh=get(ax,{'xlabel'});
   if ~isempty(xlh)
      set([xlh{:}]','visible','off');
   end
   xlh=get(ax(max(1,N-1):N),{'xlabel'});
   set([xlh{:}]'   ,'visible','on','fontsize',8);
   
   set(View.Comments,'string',comments(TS));
   
end







function [View]= viewGlobal(mdev,mbH,View);

hFig= mbH.Figure;
% get pointer
p= address(mdev);
% update the plots
diagnosticPlots(mdev,'updateview',hFig);

hFig= mbH.Figure;

% update outlier list displayed
list=OutlierList(mdev);
X= testnum(getdata(mdev));
X= X(outliers(mdev));
Lstr= cell(size(list));
if ~isempty(list)
   for i=1:length(list)
      if ~any(list(i)==X)
         Lstr{i} = sprintf('%d*',list(i));
      else
         Lstr{i} = sprintf('%d',list(i));
      end
   end
end
set(View.OutlierList,'string',Lstr,'value',min(length(list),1))

% ----------- model dependent view --------------
%% get model
m= model(mdev);


hModView= mvf('mvModelView');
if status(mdev) %% the model has been fittted so we do have something to display
	
	if strcmp(class(mdev),'modeldev')
		gui_diagstats(m,'display',View.Diagnostics);
	end
	
	
   if ~isempty(hModView);
      % update model view
      view(m,fullname(mdev));
   end
   st= statistics(mdev);
	% does this happen
   if size(View.SummaryStats,1)< length(st)
      st= st(1:size(View.SummaryStats,1));
   elseif size(View.SummaryStats,1)> length(st)
      st = [st repmat(NaN,1,size(View.SummaryStats,1)-length(st))];
   end
   View.SummaryStats(:,1)= st;
   
   %% if Ytransform, set the text to describe it
   bxcx=get(m,'boxcox');
   if bxcx==1
       set(View.BoxCoxText,'string','');
   else
       set(View.BoxCoxText,'string',['Box Cox = ' sprintf('%0.5g',bxcx) ]);
   end   
else
	% disable pane
   gui_diagstats(m,'nofit',View.Diagnostics);
   if ~isempty(hModView);
      % delete model view text
      delete(get(get(hModView,'CurrentAxes'),'child'))
   end
   View.SummaryStats(:,1)= NaN;
   set(View.BoxCoxText,'string','');
end


GlobalReg(m,'view',hFig,View,p);
set(View.Comments,'string',comments(m));

set(View.ModelString,'string',['{\bfModel type:} \fontsize{10}', str_func(m,1)],...
	'verticalalignment','bottom',...
	'fontname',get(0,'defaultuicontrolfontname'),...
	'fontsize',get(0,'defaultuicontrolfontsize'));





% ---------------------------------------------------------------------------------------
% 													function i_AxButtonDown
% ---------------------------------------------------------------------------------------
function i_AxButtonDown(ax, null, dataPatchFcnHandle, str, lyt)

downtype=get(gcbf ,'SelectionType');
switch downtype
case {'extend','open'}
   mv_zoom;
case 'normal'
   %% max area for data info
   maxA = get(lyt,'position');

   feval(dataPatchFcnHandle,ax,[],str,maxA);
end






