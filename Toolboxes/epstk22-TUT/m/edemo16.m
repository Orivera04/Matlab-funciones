%%
%% Routine: Character image
%% (see demo16.png) 
%%
[im cm]=eimgread;
text=eimg2txt(im,cm);
[rows cols]=size(text);
eopen('demo16.eps');
eglobpar
etitle('Character Image',25,9);
headSpace=30;
lineSpace=1.2;
fontSize=1.5;
for i=1:rows
  y=eWinHeight-headSpace-i*fontSize*lineSpace;
  etext(text(i,:),0+eps,y,fontSize,1,11);
end
eclose
ebbox(5);
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
