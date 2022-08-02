function solve_lr

symmdir='./matrices/symm';
unsymmdir='./matrices/unsymm';
owndir='./matrices/eigene';

symmhandle=findobj(gcf,'Tag','Symmflag');
matrixhandle=findobj(gcf,'Tag','PopupMenu1');
texthandle=findobj(gcf,'Tag','StaticText1');

smatrix=get(matrixhandle,'String');
vmatrix=get(matrixhandle,'Value');
mat=smatrix{vmatrix};

symmflag=get(symmhandle,'Value');

if strcmp(mat,'Eigene');
   mat=inputdlg('Matrix-Name','Eigene Matrix eingeben');
   mat=mat{1}
   mat=strcat(owndir,'/',lower(mat),'.mtx');
elseif symmflag==1
   mat=strcat(symmdir,'/',lower(mat),'.mtx');
else
   mat=strcat(unsymmdir,'/',lower(mat),'.mtx');
end


mat=mmread(mat);
n=size(mat);
n=n(1);
flops(0);
erg=mat\ones(n,1);
count=flops;

sstring={'Anzahl der FLOPS für die LR-Zerlegung';sprintf('%E',count)};

set(texthandle,'String',sstring);
