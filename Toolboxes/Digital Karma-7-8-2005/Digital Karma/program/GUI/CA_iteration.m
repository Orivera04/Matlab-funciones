clc; format short; stopiteration=0; set(findobj('Tag','sliderbar'),'value',0);
computeiterations; iterationsremaining=iterations-completediterations;
currentiteration=completediterations;
c=1; run opening_iteration; run CA_Display;
run save_undo;
for c = 1:iterationsremaining %starts from zero to show initial state
   totaliterationscompleted=totaliterationscompleted+1;
   pause(delay);
   if dimension==2 %copies last iteration state to end
      a(:,:,end+1)=a(:,:,end);
   elseif dimension==1 %copies last iteration state to end
      a(end+1,:)=a(end,:);
   end
   if casizelimit==1;
       if dimension==1;
           [currentcasize,casize1]=size(a);
           if currentcasize>casizelimitvalue;
               a=a((end-(casizelimitvalue-1)):end,:); end; % Discards top rows when size limit on & over limit
       elseif dimension==2;
           [casize1,casize2,currentcasize]=size(a);
           if currentcasize>casizelimitvalue;
               a=a(:,:,(end-(casizelimitvalue-1)):end); end; % Discards earliest iteration when size limit on & over limit
       end;
   end;

   eval([rule]);  %Iteration rule execution
  
   % Updates graph
   computeiterations; currentiteration=completediterations;
   if suppressdisplay==0;
       CA_Display;
   else;
       gui_display_set;
   end;
   
   %stops iteration after pressing quit
   if (stopiteration==1)
       break
   end
end
stopiteration=1;