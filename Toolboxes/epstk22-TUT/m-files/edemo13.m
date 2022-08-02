% create a image list with ejpglist()
eglobpar
einit

% read  eps file list
list=etxtread([ePath 'epsFileList']);
jList=' ';
[lPos n]=etxtlpos(list);

% make jpeg-files and a list of jpeg-files
for i=1:n
  eFileName=list(lPos(i,1):lPos(i,2)); 
  if exist(eFileName)
    jFileName=ebitmap(1,100); % eps-file to jpeg-file
    jList=[jList jFileName eTextLimitPara];
  end
end
jList=jList(2:size(jList,2));
etxtwrit(jList,'demo_jFileList');

% create image list by ejpglist()
ejpglist('demo_jFileList',[50 40],0,'demo13');
eview
