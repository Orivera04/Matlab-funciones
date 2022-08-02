% print calendar of a year
% written by Coletta Schumacher and Stefan Mueller
year=2003;
%              day   month  textIndex textColumn textColor    backgroundColor
myHolidays=   [
                24    1     21        2          1.0 1.0 1.0  0.9 0.2 0.2;
                 9    8     31        2          1.0 1.0 1.0  0.9 0.2 0.2;
                 8   12     41        2          1.0 1.0 1.0  0.9 0.2 0.2;
                21    6     50        2          1.0 1.0 1.0  0.9 0.2 0.2;
                30    5     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
                20    6     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
                29   12     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
                30   12     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
              ];
myHoliText=   [
               '021gau          ';
               '031ase          ';
               '041bra          ';
               '050mwi          ';
               '080vorgearb.    ';
              ];
%variable holydays
%              day   month  textIndex textColumn textColor    backgroundColor
varHolidays=  [
                 0    0      1        1          1.0 1.0 1.0  0.2 0.7 0.2;
                 1    0      1        1          1.0 1.0 1.0  0.2 0.7 0.2;
                47    0      3        1          1.0 1.0 1.0  0.2 0.7 0.2;
                49    0      4        1          1.0 1.0 1.0  0.2 0.7 0.2;
                50    0      5        1          1.0 1.0 1.0  0.2 0.7 0.2;
                88    0      6        1          1.0 1.0 1.0  0.2 0.7 0.2;
                98    0      7        1          1.0 1.0 1.0  0.2 0.7 0.2;
                99    0      7        1          1.0 1.0 1.0  0.2 0.7 0.2;
               109    0      9        1          1.0 1.0 1.0  0.2 0.7 0.2;
              ];
varHoliText=  [
               '001Fastnacht    ';
               '003Karfreitag   ';
               '004Ostern       ';
               '005Ostern       ';
               '006Chr.Himmelf .';
               '007Pfingsten    ';
               '009Fronleich.   '; 
              ];
% fixed holidays
%              day   month  textIndex textColumn textColor    backgroundColor
fixHolidays=[
                 1    1     10        1          1.0 1.0 1.0  0.2 0.7 0.2;
                 1    5     11        1          1.0 1.0 1.0  0.2 0.7 0.2;
                 3   10     12        1          1.0 1.0 1.0  0.2 0.7 0.2;
                 1   11     13        1          1.0 1.0 1.0  0.2 0.7 0.2;
                25   12     14        1          1.0 1.0 1.0  0.2 0.7 0.2;
                26   12     14        1          1.0 1.0 1.0  0.2 0.7 0.2;
                31   12     16        1          1.0 1.0 1.0  0.2 0.7 0.2;
              ];
fixHoliText=[
               '010Neujahr      ';
               '0111.Mai        ';
               '012Dt. Einheit  ';
               '013Allerheiligen';
               '014Weihnachten  ';
               '016Silvester    ';
              ];
weekday= ['Mo'; 'Di'; 'Mi'; 'Do'; 'Fr'; 'Sa'; 'So'];               
saBgColor=[0.8 0.8 1.0];
suBgColor=[0.7 0.7 1.0];
monthT=['Januar   '; 'Februar  '; 'M\\344rz '; 'April    ';
        'Mai      '; 'Juni     '; 'Juli     '; 'August   ';
        'September'; 'Oktober  '; 'November '; 'Dezember '];
nDaysOfM = [31 28 31 30 31 30 31 31 30 31 30 31];
if ~rem (year,4),nDaysOfM(2)=29;end
nDaysOfY=sum(nDaysOfM);

% sundays of carneval until 2019
cSundays=[ 5 3;25 2;10 2; 2 3;22 2; 6 2;26 2;18 2; 3 2;22 2;...
          14 2; 6 3;19 2;10 2; 2 3;15 2; 7 2;26 2;11 2; 3 3];
cSunday=year-2000+1;
cDay=cSundays(cSunday,1);
cMonth=cSundays(cSunday,2);
dayOfY=rem(cDay+sum(nDaysOfM(1:cMonth-1)),7);              
if dayOfY
  firstDayOfY=7-dayOfY+1;
else
  firstDayOfY=1;
end

% variable holidays   day of the 
for k=1:size(varHolidays,1)
  varDay=cDay+varHolidays(k,1); 
  for i=0:4        
    if varDay>nDaysOfM(cMonth+i) 
      varDay=varDay-nDaysOfM(cMonth+i); 
    else            
      break          
    end             
  end
  varHolidays(k,1)=varDay;
  varHolidays(k,2)=cMonth+i;
end                                    
   
holidays=[myHolidays;varHolidays;fixHolidays];
holitext=[myHoliText;varHoliText;fixHoliText];
[nTextRows nTextCols]=size(holitext);
holiIndex=holidays(:,3);
for i=1:nTextRows
  index=str2num(holitext(i,1:3));
  fresult=find(holiIndex==index);
  holidays(fresult,3)=i*ones(size(fresult,1),1);
end
holitext=holitext(:,4:nTextCols);

% draw table
eopen('demo14.eps');
eglobpar
eWinGridVisible=0;
dayOfY=0;                    
[calX calY]=etabdef(32,6,0,130,180,120);
for month=1:12
  if month==7
    etabgrid(calX,calY);
    [calX calY]=etabdef(32,6,0,0,180,120);
  end
  tabCol=rem(month-1,6)+1;
  etabtext(calX,calY,1,tabCol,monthT(month,:),0,3,100,[1 1 1],[0.5 0.5 0.8]);
  offset=3.8;
  [dayX dayY]=etabdef(32,1,calX(tabCol,1)+offset,calY(32,1),1,120);
  [wdX wdY]=etabdef(32,1,calX(tabCol,1)+0.9*offset,calY(32,1),1,120);
  for dayOfM=1:nDaysOfM(month)
    dayOfW=rem(firstDayOfY-1+dayOfY,7)+1;
    dayOfY=dayOfY+1;
    if dayOfW==6
      etabtext(calX,calY,dayOfM+1,tabCol,'',1,1,100,[1 1 1],saBgColor);
    elseif dayOfW==7
      etabtext(calX,calY,dayOfM+1,tabCol,'',1,1,100,[1 1 1],suBgColor);
    end
    etabtext(dayX,dayY,dayOfM+1,1,sprintf('%d',dayOfM),-1);
    etabtext(wdX,wdY,dayOfM+1,1,sprintf('%s',weekday(dayOfW,:)),1,3,70);
  end
  offset=8;
  [nX nY]=etabdef(32,2,calX(tabCol,1)+offset,calY(32,1),...
                  calX(tabCol,2)-offset,120,[3 1]);
  for notes=find(holidays(:,2)==month)'
    if holidays(notes,4)==1
      etabtext(nX,nY,holidays(notes,1)+1,1,...
               sprintf('%s',holitext(holidays(notes,3),:)),...
               1,1,100,holidays(notes,5:7),holidays(notes,8:10));
    elseif holidays(notes,4)==2
      etabtext(nX,nY,holidays(notes,1)+1,2,...
               sprintf('%s',holitext(holidays(notes,3),:)),...
               1,1,80,holidays(notes,5:7),holidays(notes,8:10));
    end
  end
end
etabgrid(calX,calY);
etext(sprintf('Jahr %d',year),90,122,8,0,3);
eclose;
eview;
