%MATRIXMAPS HELP
s0=' ';
hmenu=['1. REFLECTIONS in homogeneous coordinates. ';
       '2. SCALING in homogeneous coordinates.     ';
       '3. ROTATIONS in homogeneous coordinates.   ';
       '4. TRANSLATIONS in homogeneous coordinates.';
       '5. SHEARS in homogeneous coordinates.      ';
       '0. QUIT the help.                          '];
helpover='N';
clc,disp(mathead)
while helpover=='N' 
   disp(s0)
   disp('To see help on a topic enter the corresponding number:')
   disp(s0)
   disp(hmenu),disp(s0)
   ch=input('ENTER your choice: ==>  ');
   if ch==0,helpover='Y';end
   if ch==1,disp(refhelp),end
   if ch==2,disp(sclhelp),end
   if ch==3,disp(rothelp),end
   if ch==4,disp(tranhelp),end
   if ch==5,disp(shearhelp),end
end
disp(s0),disp(cont),pause
return


