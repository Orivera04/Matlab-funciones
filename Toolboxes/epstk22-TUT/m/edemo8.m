%%
%% Routine: Symbols list
%% (see demo8.png) 
%%
eopen('demo8.eps')                      % open eps-file and write eps-head

eglobpar                                % get access to global parameters
%eWinGridVisible=1;
etext('Symbols ',eWinWidth/2,eWinHeight-10,10,0)
sFiles=['oplus.psd ';'plus.psd  ';'star.psd  ';'ring.psd  ';...
        'fring.psd ';'rect.psd  ';'frect.psd ';'triaC.psd ';...
	'ftriaC.psd';'tria.psd  ';'ftria.psd ';'spire.psd ';...
	'farrow.psd';'needle.psd';'euro.psd  ';'feuro.psd '];
sColors=[0.7 0.6 0.5;1 0 0;0 1 0;0 0 1;0.7 0.5 0;1 0 1;...
         0 0.5 1;0.5 0 1;0.6 0.3 0.2;0.8 0.5 0.7;...
         1 0.8 0.3;0.6 0.3 0.4;0.6 0.4 0.8;0.8 0.3 0.3;...
	 0.6 0.6 0.3;1 0.7 0];

%define symbols
nSym=16;
for i=1:nSym
  edsymbol(sprintf('s%d',i),sFiles(i,:),... % define symbol
           1,1,0,0,0,sColors(i,:));
end

%draw symbols
nPos=40;
randPos=rand(nPos,2);
xPos(:,1)=randPos(:,1)*eWinWidth*0.7+eWinWidth*0.1;
yPos(:,2)=randPos(:,2)*eWinHeight*0.35+eWinHeight*0.56;
for i=1:nPos
  symbol=sprintf('s%d',rem(i,nSym)+1);
  esymbol(xPos(i,1),yPos(i,2),symbol,randPos(i,1)+0.4,...
  randPos(i,2)+0.3,(randPos(i,1)-randPos(i,2))*360);% draw symbol
end

etext('Table of Symbols ',eWinWidth/2,115,10,0);

%body of table
[tabx,taby]=etabdef(nSym,3,40,0,100,100,[1 3 2]);
for i=1:nSym
  etabtext(tabx,taby,i,1,sprintf('%d.',i),-1);
  etabtext(tabx,taby,i,2,sFiles(i,:),1,1,80,[0 0 0],sColors(i,:));
  esymbol(tabx(3,1)+tabx(3,2)/2,...
          taby(i,1)+taby(i,2)/2,...
          sprintf('s%d',i),0.5,0.5);
          
end
etabgrid(tabx,taby); 

%head of table
[htabx htaby]=etabdef(1,3,40,100,100,8,[1 3 2],1);
etabtext(htabx,htaby,1,1,'No',0,3);
etabtext(htabx,htaby,1,2,'Filename',0,3);
etabtext(htabx,htaby,1,3,'Symbol',0,3);
eclose                                  % close eps-file
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
