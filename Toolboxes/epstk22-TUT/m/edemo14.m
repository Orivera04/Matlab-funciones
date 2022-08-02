%%
%% Routine: Calendar 
%% (see demo14.png) 
%%
% print calendar of a year
% written by Coletta Schumacher and stefan.mueller@fgan.de (C) 2007
year=2007;
%              day   month  textIndex textColumn textColor    backgroundColor
myHolidays=   [
                 6    1     28        2          0.0 0.0 0.0  0.9 0.9 0.0;
                29    1     01        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 8    2     02        2          0.0 0.0 0.0  0.9 0.9 0.0;
                23    2     03        2          0.0 0.0 0.0  0.9 0.9 0.0;
                13    3     04        2          0.0 0.0 0.0  0.9 0.9 0.0;
                15    3     05        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 3    5     06        2          0.0 0.0 0.0  0.9 0.9 0.0;
                12    5     07        2          0.0 0.0 0.0  0.9 0.9 0.0;
                15    5     29        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 9    6     08        2          0.0 0.0 0.0  0.9 0.9 0.0;
                21    6     09        2          0.0 0.0 0.0  0.9 0.9 0.0;
                23    6     10        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 3    7     11        2          0.0 0.0 0.0  0.9 0.9 0.0;
                12    7     12        2          0.0 0.0 0.0  0.9 0.9 0.0;
                13    7     13        2          0.0 0.0 0.0  0.9 0.9 0.0;
                14    7     14        2          0.0 0.0 0.0  0.9 0.9 0.0;
                24    7     15        2          0.0 0.0 0.0  0.9 0.9 0.0;
                25    7     16        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 5    8     30        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 9    8     18        2          0.0 0.0 0.0  0.9 0.9 0.0;
                13    8     17        2          0.0 0.0 0.0  0.9 0.9 0.0;
                13    8     19        1          0.0 0.0 0.0  0.9 0.9 0.0;
                14    9     20        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 8   10     21        2          0.0 0.0 0.0  0.9 0.9 0.0;
                22   10     23        2          0.0 0.0 0.0  0.9 0.9 0.0;
                26   10     24        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 1   11     25        2          0.0 0.0 0.0  0.9 0.9 0.0;
                13   11     22        2          0.0 0.0 0.0  0.9 0.9 0.0;
                 8   12     26        2          0.0 0.0 0.0  0.9 0.9 0.0;
                11   12     27        2          0.0 0.0 0.0  0.9 0.9 0.0;
                18    5     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
                 8    6     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
                 2   11     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
                27   12     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
                28   12     80        1          0.0 0.0 0.0  0.9 0.8 0.5;
              ];
myHoliText=   [
               '001pro          ';
               '002stm          ';
               '003rsc          ';
               '004tbr          ';
               '005do           ';
               '006mab          ';
               '007gle          ';
               '008krm          ';
               '009mwi          ';
               '010kos          ';
               '011jsh          ';
               '012mue          ';
               '013wor          ';
               '014us           ';
               '015wal          ';
               '016bal          ';
               '017mar          ';
               '018hec          ';
               '019sch          ';
               '020mat          ';
               '021js           ';
               '022rus          ';
               '023kus          ';
               '024fle          ';
               '025stk          ';
               '026bra          ';
               '027ros          ';
               '028thr          ';
               '029tma          ';
               '030moe          ';
               '080vorgearb.    ';
              ];
%variable holydays
%              day   month  textIndex textColumn textColor    backgroundColor
varHolidays=  [
                 0    0     101       1          1.0 1.0 1.0  1.0 0.0 0.0;
                 1    0     101       1          1.0 1.0 1.0  1.0 0.0 0.0;
                47    0     103       1          1.0 1.0 1.0  1.0 0.0 0.0;
                49    0     104       1          1.0 1.0 1.0  1.0 0.0 0.0;
                50    0     105       1          1.0 1.0 1.0  1.0 0.0 0.0;
                88    0     106       1          1.0 1.0 1.0  1.0 0.0 0.0;
                98    0     107       1          1.0 1.0 1.0  1.0 0.0 0.0;
                99    0     107       1          1.0 1.0 1.0  1.0 0.0 0.0;
               109    0     109       1          1.0 1.0 1.0  1.0 0.0 0.0;
              ];
varHoliText=  [
               '101Fastnacht    ';
               '103Karfreitag   ';
               '104Ostern       ';
               '105Ostern       ';
               '106Chr.Himmelf .';
               '107Pfingsten    ';
               '109Fronleich.   '; 
              ];
% fixed holidays
%              day   month  textIndex textColumn textColor    backgroundColor
fixHolidays=[
                 1    1     210       1          1.0 1.0 1.0  1.0 0.0 0.0;
                 1    5     211       1          1.0 1.0 1.0  1.0 0.0 0.0;
                 3   10     212       1          1.0 1.0 1.0  1.0 0.0 0.0;
                 1   11     213       1          1.0 1.0 1.0  1.0 0.0 0.0;
                25   12     214       1          1.0 1.0 1.0  1.0 0.0 0.0;
                26   12     214       1          1.0 1.0 1.0  1.0 0.0 0.0;
                31   12     216       1          1.0 1.0 1.0  1.0 0.0 0.0;
              ];
fixHoliText=[
               '210Neujahr      ';
               '2111.Mai        ';
               '212Dt. Einheit  ';
               '213Allerheiligen';
               '214Weihnachten  ';
               '216Silvester    ';
              ];
weekday= ['Mo'; 'Di'; 'Mi'; 'Do'; 'Fr'; 'Sa'; 'So'];               
saBgColor=[0.8 0.8 1.0];
suBgColor=[0.7 0.7 1.0];
monthT=['Januar   '; 'Februar  '; 'März     '; 'April    ';
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
  etabtext(calX,calY,1,tabCol,monthT(month,:),0,3,100,[1 1 1],[0.0 0.5 0.0]);
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
etext(sprintf('ANNO %d',year),90,122,8,0,3);
eclose;
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
