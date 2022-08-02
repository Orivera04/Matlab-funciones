function showhmmprof(model,varargin)
%SHOWHMMPROF shows a profile HHM model graphically.
%
%   SHOWHMMPROF(MODEL) shows a profile Hidden Markov Model described by the
%   structure MODEL.
%
%   SHOWHMMPROF(MODEL,'DOMAIN',str) specifies whether to use
%   log-probabilities (str='logprob'), probabilities (str='prob'), or
%   log-odd ratios (str='logodds'). To compute the log-odd ratios the Null
%   Model Probabilities are used for symbol emission, and equally
%   distributed transitions are used for the null transition probabilities. 
%   The default DOMAIN is 'logprob'.
%
%   Example:
%
%       % Load a model example.
%       load('hmm_model_examples','model_7tm_2')
%       showhmmprof(model_7tm_2,'scale','logodds')
%
%   See also GETHMMPROF, HMMPROFALIGN, HMMPROFESTIMATE, HMMPROFGENERATE,
%   HMMPROFSTRUCT, PFAMHMMREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.22.6.6 $   $Date: 2004/04/01 15:58:55 $

% Validate HMM model:
try   
    model = checkhmmprof(model);
catch 
    rethrow(lasterror);
end

% default varargin
scale = 1; % logprob

% check varargin
if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments','Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'scale'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName','Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbigousParameterName','Ambiguous parameter name: %s.',pname);
        else
            switch(lower(pval))
                case 'logprob'
                    scale = 1;% logprob
                case 'prob'
                    scale = 2;% probs
                case 'logodds'
                    scale =3;% logodds
                otherwise
                    error('Bioinfo:Incorrectdomain','Can not interpret the domain: %s.',pval);
            end %switch
        end %if k==1
    end % for all varargin
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reading in model structure

profLength=model.ModelLength;
switch upper(model.Alphabet)
    case 'AA', alphaLength=20;
        symbols=int2aa(1:20)';
    case 'NT', alphaLength=4;
        symbols=int2nt(1:4)';
end

%% NULL MODEL EMISSION LOG-PROB (nelp)
nep=model.NullEmission;
woff=warning('off');
nelp=log2(nep);
warning(woff);

%% MATCH EMISSION LOG-PROB (melp)
mep=model.MatchEmission;
woff=warning('off');
melp=log2(mep);
warning(woff);
%% MATCH EMISSION LOG-ODDS RATIO (melor)
melor=melp-repmat(nelp,profLength,1);

%% INSERT EMISSION LOG-PROB (ielp)
iep=model.InsertEmission;
woff=warning('off');
ielp=log2(iep);
warning(woff);
%% INSERT EMISSION LOG-ODDS RATIO (ielor)
ielor=ielp-repmat(nelp,profLength,1);

%% MATCH TRANSITION LOG-PROB (mxlp)
mxp=[model.MatchX; 0 0 0 1];
woff=warning('off');
mxlp=log2(mxp);
warning(woff);
%% MATCH TRANSITION LOG-ODDS RATIO (mxlor)
mxlor=mxlp+2;

%% INSERT TRANSITION LOG-PROB (ixlp)
ixp=[model.InsertX; 0 0];
woff=warning('off');
ixlp=log2(ixp);
warning(woff);
%% INSERT TRANSITION LOG-ODDS RATIO (ixlor)
ixlor=ixlp+1;

%% DELETE TRANSITION LOG-PROB (dxlp)
dxp=[model.DeleteX; 0 0];
woff=warning('off');
dxlp=log2(dxp);
warning(woff);
%% DELETE TRANSITION LOG-ODDS RATIO (dxlor)
dxlor=dxlp+1;

%% BEGIN-[DEL_1-MATCH_X] TRANSITION LOG-PROB (bxlp)
%% [xBD1, xBM1, xBM2, xBM3, xBM4 ... ]
bxp=model.BeginX;
woff=warning('off');
bxlp=log2(bxp);
warning(woff);
%% BEGIN-[DEL_1-MATCH_X] TRANSITION LOG-ODDS RATIO (bxlor)
bxlor=bxlp+log2(profLength+1);


%% LEFT-INSERT TRANSITIONS LOG-PROB (lixlp)
%% [xNB, xNN ]
% commented since they are not used
%lixp=model.FlankingInsertX(:,1);
%lixlp=log2(lixp);

%% RIGTH-INSERT TRANSITIONS LOG-PROB (rixlp)
%% [xCC, xTT]
% commented since they are not used
%rixp=model.FlankingInsertX(:,2);
%rixlp=log2(rixp);

% reading in model structure (end)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numXState=9;
StateAlpha=('MIDBE')';
StateXMap =[1 1;1 2;1 3;1 5;2 1;2 2;3 1;3 3;4 1];
StateXLabels=repmat(' -> ',numXState,1);
StateXLabels(:,[1 4])=StateAlpha(StateXMap);

% Match Emission Probabilities
hFig = figure('Position',[100 270 1000 400],'renderer','zbuffer');
if scale==1 %logprog
    clim=max(max(abs(melp(~isinf(melp)))));
    cLimits = [-clim 0];
    ud.hImage=imagesc(melp',cLimits);
    colormap(privateColorMap(1));
    title('Symbol emission log-probabilities for match states')
elseif scale==2 %prob    
    cLimits = [0 1]; 
    ud.hImage=imagesc(mep',cLimits);
    colormap(privateColorMap(2));
    title('Symbol emission probabilities for match states')
else %scale==3 logodds
    clim=max(max(abs(melor(~isinf(melor)))));
    cLimits = [-clim clim];
    ud.hImage=imagesc(melor',cLimits);
    colormap(privateColorMap(3));
    title('Symbol emission log-odd ratios for match states')
end

hca = gca;
set(hca,'Position',[0.05,0.05,0.90,0.85]);
set(hca,'ytick',1:alphaLength,'yticklabel',symbols)
colorbar
set(hFig,'WindowButtonDownFcn',@localImageButtonCallback)
[ud.hVis,ud.hPos,ud.hDat,ud.hTip] = putAxisForHistandDataTip(symbols,cLimits);
ud.Tag = 'Bioinfo:MatchEmissionProbability';
set(hFig,'userdata',ud)

% Insert Emission Probabilities
hFig = figure('Position',[150 250 1000 400],'renderer','zbuffer');
if scale==1 %logprog
    %clim=max(max(abs(ielp(~isinf(ielp)))));
    %should scale be the same as ielp to avoid confusion ?
    cLimits = [-clim 0];
    ud.hImage=imagesc(ielp',cLimits);
    colormap(privateColorMap(1));
    title('Symbol emission log-probabilities for insert states')
elseif scale==2 %prob
    cLimits = [0 1];
    ud.hImage=imagesc(iep',cLimits);
    colormap(privateColorMap(2));
    title('Symbol emission probabilities for insert states')
else %dscale==3 logodds
    %clim=max(max(abs(ielor(~isinf(ielor)))));
    %should scale be the same as ielp to avoid confusion ?
    cLimits = [-clim clim];
    ud.hImage=imagesc(ielor',cLimits);
    colormap(privateColorMap(3));
    title('Symbol emission log-odd ratios for insert states')
end
hca = gca;
set(hca,'Position',[0.05,0.05,0.90,0.85]);
set(hca,'ytick',1:alphaLength,'yticklabel',symbols)
colorbar
set(hFig,'WindowButtonDownFcn',@localImageButtonCallback)
[ud.hVis,ud.hPos,ud.hDat,ud.hTip] = putAxisForHistandDataTip(symbols,cLimits);
ud.Tag = 'Bioinfo:InsertEmissionProbability';
set(hFig,'userdata',ud)

% Transition probabilities
hFig = figure('Position',[200 230 1000 400],'renderer','zbuffer');
if scale==1 %logprog
    XLP=[mxlp ixlp dxlp bxlp(2:end)]';
    clim=max(max(abs(XLP(~isinf(XLP)))));
    cLimits = [-clim 0];
    ud.hImage=imagesc(XLP,cLimits);
    colormap(privateColorMap(1));
    title('Transition log-probabilities')
elseif scale==2 %prob
    cLimits = [0 1];
    ud.hImage=imagesc( [mxp ixp dxp bxp(2:end)]' ,cLimits);
    colormap(privateColorMap(2));
    title('Transition probabilities')
else %scale==3 logodds
    XLOR=[mxlor ixlor dxlor bxlor(2:end)]';
    clim=max(max(abs(XLOR(~isinf(XLOR)))));
    cLimits = [-clim clim];
    ud.hImage=imagesc(XLOR,cLimits);
    colormap(privateColorMap(3));
    title('Transition log-odd ratios')
end
hca = gca;
set(hca,'Position',[0.05,0.05,0.90,0.85]);
set(gca,'ytick',1:numXState,'yticklabel',StateXLabels)
colorbar
hold on
hSeparators=plot(repmat([0.5,profLength+.5 NaN],1,3),...
    [8.5,8.5,NaN,6.5,6.5,NaN,4.5,4.5,NaN],'linewidth',6,'color',[.8 .8 .8]);
set(hFig,'WindowButtonDownFcn',@localImageButtonCallback)
    %'UserData',hSeparators)
[ud.hVis,ud.hPos,ud.hDat,ud.hTip] = putAxisForHistandDataTip(StateXLabels,cLimits);
ud.Tag = 'Bioinfo:TransitionProbability';
set(hFig,'userdata',ud)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localImageButtonCallback(h,varargin)
% localImageButtonCallback
% shows model info at at selected point.

hFig=gcbf;
ud = get(hFig,'userdata');
buttonType = get(hFig,'SelectionType');

% search for handle info
imageHandle = ud.hImage;
imageTag = ud.Tag;
imageAxes = get(ud.hImage,'parent');

% get current axis information
XLim = get(imageAxes,'XLim');
YLim = get(imageAxes,'YLim');
vLabels = get(imageAxes,'YTickLabel');

% Cdata is the actual values of the image
cdata = get(imageHandle,'Cdata');

% get the position on the image.
cpAct = get(imageAxes,'CurrentPoint');

% check for Limits
cpAct(1,1)=max([cpAct(1,1), 1, XLim(1)]);
cpAct(1,1)=min([cpAct(1,1), size(cdata,2), XLim(2)]);
cpAct(1,2)=max([cpAct(1,2), 1, YLim(1)]);
cpAct(1,2)=min([cpAct(1,2), size(cdata,1), YLim(2)]);

% round position to index Cdata
cp = round(cpAct);

% find in which region of the plot the cursor is
quadrant=cpAct(1,[1 2])<mean([XLim;YLim]');

switch buttonType
    case 'normal'
        set(hFig,'pointer','cross')
        switch imageTag
            case 'Bioinfo:TransitionProbability'
                val = num2str(cdata(cp(1,2),cp(1,1)));
                State=cp(1,1);
                textid=vLabels(cp(1,2),1);
                if textid~='B'
                    textid=[textid num2str(State)];
                    fromB=false;
                else
                    fromB=true;
                end
                textid=[textid vLabels(cp(1,2),[2,3,4])];
                switch textid(end)
                    case 'I', textid=[textid num2str(State)];
                    case 'E',
                    otherwise, if fromB
                            textid=[textid num2str(State)];
                        else
                            textid=[textid num2str(State+1)];
                        end
                end
                set(ud.hTip,'string',{val;textid})
            otherwise %
                val = num2str(cdata(cp(1,2),cp(1,1)));
                State=cp(1,1);
                Symbol=vLabels(cp(1,2),:);
                set(ud.hTip,'string',{val;Symbol;num2str(State)})
        end

        % position is affected by font size, empty lines etc. so reposition
        % based on calculated values.

         offsets=sign(quadrant-0.5).*diff([XLim;YLim]')/50;
        if quadrant(1)
            set(ud.hTip,'HorizontalAlignment','Left')
        else
            set(ud.hTip,'HorizontalAlignment','Right')
        end
        if quadrant(2)
            set(ud.hTip,'VerticalAlignment','Top')
        else
            set(ud.hTip,'VerticalAlignment','Bottom')
        end
        set(ud.hTip,'position',cpAct(1,[1 2])+offsets);
        set(ud.hTip,'Visible','on')

        % toggle callback functions to preprare mouse motion and button
        % release 
        set(hFig,'WindowButtonDownFcn','');
        set(hFig,'WindowButtonMotionFcn',@localImageButtonCallback);
        set(hFig,'WindowButtonUpFcn',@localToggleOff);
    case 'alt'
        set(hFig,'pointer','cross')
        %correct cdata before bar
        neginfcdata=cdata==-inf;
        posinfcdata=cdata==inf;
        cdata(neginfcdata)=min(min(cdata(~neginfcdata)));
        cdata(posinfcdata)=max(max(cdata(~posinfcdata)));

        set(ud.hDat,'ydata',cdata(end:-1:1,cp(1,1)))
        set(ud.hPos(2),'YLim',fliplr(size(cdata,1)+1-YLim))
        
        if quadrant(1)
            set(ud.hPos(1),'Position',[0.80,0,0.20,0.95])
            set(ud.hPos(2),'Position',[0.85,0.05,0.14,0.85])
        else
            set(ud.hPos(1),'Position',[0,0,0.20,0.95])
            set(ud.hPos(2),'Position',[0.05,0.05,0.14,0.85])
        end
        
        set(ud.hVis,'Visible','on')
        
        % toggle callback functions to preprare mouse motion and button
        % release
        set(hFig,'WindowButtonDownFcn','');
        set(hFig,'WindowButtonMotionFcn',@localImageButtonCallback);
        set(hFig,'WindowButtonUpFcn',@localToggleOff);
    case 'extend'
        %other mouse buttons: do nothing for now
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hFig = localToggleOff(h,varargin)
%LOCALTOGGLEOFF callback function to remove disable dragging of labels

hFig = gcbf;
ud = get(gcbf,'userdata');
set([ud.hVis ud.hTip],'Visible','off')

% toggle callback functions back to the "waiting" state
set(hFig,'WindowButtonDownFcn',@localImageButtonCallback);
set(hFig,'WindowButtonUpFcn','');
set(hFig,'WindowButtonMotionFcn','');
set(hFig,'pointer','arrow')

% delete the old labels if it exists
delete(findobj(hFig,'Tag','ImageDataTip'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hVis,hPos,hDat,hTip]=putAxisForHistandDataTip(yTickLab,cLimits)
% Helper function to create the histogram-tip, later the gui will only turn
% it on-off, move it, or change the data as required
% .... also creates in this function the datatip
hTip = text(0,0,'','BackgroundColor', [1 1 0.933333],'Color', [0 0 0],...
            'EdgeColor', [0.8 0.8 0.8],'Visible','off');
n = size(yTickLab,1);
% creates an always invisible axis ...
h=axes('Position',[0,0,0.20,0.95],'visible','off');
% and puts a patch in the whole axis ...
hp=patch([0 0 1 1],[0 1 1 0],[1 1 0.933333]);
set(hp,'EdgeColor',[0.8 0.8 0.8],'LineWidth',2)
% then create another axis to put over the patch ...
g=axes('Position',[0.05,0.05,0.14,0.85],'Xlim',cLimits,'Ylim',[0,n],'Ydir','reverse');
% and draws the bar plot
hb=barh(1:n,zeros(1,n),'w');
set(g,'ytick',1:n,'yticklabel',yTickLab(end:-1:1,:))
hPos = [h g];
hVis = [hp g hb];
hDat = hb;
set(hVis,'Visible','off')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pcmap = privateColorMap(selection)
%PRIVATECOLORMAP returns a custom color map
switch selection
    case {1,2}, pts = [0 0 .2 28;
            .2 0 1 36;
            1 1 1 0];
    case 3, pts = [0 .3 0 18;
            0 .9 0 14;
            .9 .9 .9 14
            .9 0 0 18;
            .3 0 0 0];
    otherwise, pts = [0 0 0 128;
            1 1 1 0];
end
xcl=1;
for i=1:size(pts,1)-1
    xcl=[xcl,i+1/pts(i,4):1/pts(i,4):i+1];
end
pcmap = interp1(pts(:,1:3),xcl);
