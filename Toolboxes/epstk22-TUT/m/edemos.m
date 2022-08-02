noDemoShow=1;
disp('Demos are running ...');
if exist('matlabpath')~=5
  more off
end
tic
edemo1
edemo2
edemo3
edemo4
edemo5
edemo6
edemo7
edemo8
edemo9
edemo10
edemo11
edemo12
edemo13
edemo14
edemo15
edemo16
edemo17
edemo18
t=toc;
text=sprintf('done in %d sec.',t);
disp(text);
clear noDemoShow
ehelp
