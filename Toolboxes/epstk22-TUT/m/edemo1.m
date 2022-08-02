%%
%% Routine: Simple plot
%% (see demo1.png) 
%%
x1=[-0.5:0.01:2*pi];
x2=[0:0.2:2*pi];


eopen('demo1.eps')                      % open eps-file and write eps-head

% fill area 
eplot(x1,cos(x1)*0.2,'cosfill',-1,[0.8 0.8 0.2])

% plot single lines
eplot([x2;x2],[cos(x2)*0.5;sin(x2)],'diff',0,[0.7 0 0.7],0.5)

% plot red solid line
eplot(x1,sin(x1),'sin',0,[1 0 0],2)

% plot blue dash line
eplot(x1,cos(x1)*0.5,'cosine',[1 2 1],[0 0 1],1) 

% plot errorbar
error=rand(size(x2))/3;
[xm ym]=eerrbar(x2,sin(x2),error);
eplot(xm,ym,'error',0,[0 0.4 0],0.5);
eclose                                  % close eps-file 
newbox=ebbox(5);                        % make new boundingbox with 5mm frame
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
