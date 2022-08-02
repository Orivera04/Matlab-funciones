function[]=ESSAImkmidi()
%Tutorial restricted to the happy necessary, to probe mkmidi.m
%You can change each parameter, but keep care to respect coherency between them.
%To obtain nice music automaticaly, you have to find a judicious algorithm
%that will produce all the adequates datas: time, pitch, velocity, etc..., 
%and call mkmidi.m with them.
%To inspect your job:
%   Midi File Disassembler/Assembler in www.borg.com/~jglatt
%   Sonar4
%--------------------------
%dubois.ml@club-internet.fr
%--------------------------

%------------param notes---------------------
NbTracks=4;  NbNotesMax=13;          %number of notes by track
NbNotes=ones(NbTracks,1)*NbNotesMax; %here the same for this tutorial
time=1+500*rand(NbTracks,NbNotesMax); %dt des note on
time=cumsum(time,2);
pitch=35+round(46*rand(NbTracks,NbNotesMax));
velocity=50+round(76*rand(NbTracks,NbNotesMax));
Compos=1; %input('Tous les instr?: 1    que des percus?: 0    =');
%------------param inst change---------------    
NbChangeInstMax=2; %number program change by track (changement d'instrument)
NbChangeInst=ones(NbTracks,1)*NbChangeInstMax;%here the same for this tutorial
instchgtime=1+2500*rand(NbTracks,NbChangeInstMax); %dt des inst change (environ 5 notes)
instchgtime=cumsum(instchgtime,2);
instchoix=round(127*rand(NbTracks,NbChangeInstMax));
%--------------param Pitch Wheel-------------
LFm=100; LFM=500; %longueur du formant du pitchwheel
DeltaFormant=50;  
NbPw=zeros(NbTracks,1); %nombre de pitchwheel par track
NbPw(1,1)=1;NbPw(2,1)=2;NbPw(3,1)=1;
NbPwSum=cumsum(NbPw);  NbPwMax=max(NbPw);
LocPw=zeros(NbTracks,NbPwMax); %location pitchwheel
LocPw(1,1)=5;  LocPw(2,1)=1; LocPw(2,2)=2;  LocPw(3,1)=10;%notes affected by pitchwheel
NbEchPwMax=ceil(LFM/DeltaFormant);
NxMax=NbPwSum(NbTracks,1)*NbEchPwMax;
XBend=zeros(NbTracks,NbEchPwMax,NbPwMax);
Bend1=zeros(NbTracks,NbEchPwMax,NbPwMax);    Bend2=zeros(NbTracks,NbEchPwMax,NbPwMax);
NbEchPw=zeros(NbTracks,NbPwMax);


for g=1:NbTracks
    for in=1:NbPw(g,1)   %NbNotes PW  
        LongFormant=fix(LFm+(LFM-LFm+1)*rand);
        [fXBend, fYBend, nx]=FormantMidi(LongFormant, DeltaFormant);
        fBend1=zeros(1,nx); fBend2=zeros(1,nx); %nx=nb ech freq: NbEchPw(g,in)
        NbEchPw(g,in)=nx;
        for n=1:nx
            [fBend1(1,n), fBend2(1,n)]=midibend(fYBend(1,n)); %Conversion midi
        end %n
        Bend1(g,1:nx,in)=fBend1(1,:);      Bend2(g,1:nx,in)=fBend2(1,:);
        XBend(g,1:nx,in)=fXBend(1,1:nx); 
    end %in
end %g
%--------------fin param Pitch Wheel

midifich=...
    mkmidi(NbTracks, NbNotes, time, pitch, velocity, Compos,...
    NbChangeInst, instchgtime, instchoix,...
    NbPw, LocPw, NbEchPw, XBend, Bend1, Bend2, NxMax);

%Save your music:
%You have to create the folder : c:\MusiqCalcMatlab\Midi\Sons\, before using it.
c=clock;
CheminDir='c:\MusiqCalcMatlab\Midi\Sons\';
CheminMusique=strcat(CheminDir,num2str(c(1)),'-',num2str(c(2)),'-',num2str(c(3)),'-',...
    num2str(c(4)),'-',num2str(c(5)),'-',num2str(c(6)),'_',mfilename,'.mid');

fid=fopen(CheminMusique,'w+');
fwrite(fid,midifich);
fclose(fid);

disp('fin');

%//////////////////////////////////////////////////////////////////////////
function [XEnvlop, YEnvlop, NPtF]=FormantMidi(LongFormant, DeltaFormant)
%Input:LongFormant=formant length
%      DeltaFormant=step max
%      NPtF=Number of steps
%      XEnvlop(1,NPtF)=abscisses of step
%      YEnvlop(1,NPtF)=Bend

format compact;
SansEffet=8192;
LongF=LongFormant; Delta=DeltaFormant;
Bm=5000;  BM=12000;    
m=min(BM,Bm); a=abs(BM-Bm);
NPtm=2; NPtM=10; 
NPt=2; %NPtm+fix((NPtM-NPtm+1)*rand); 
NPt2=NPt+2;
Extrx=zeros(1,NPt2);
Extry=zeros(1,NPt2);
for i=1:NPt2
    Extrx(1,i)=LongF*rand(1,1);
    Extry(1,i)=m+a*rand(1,1);
end %i
Extrx(1,1)=0; 
Extrx(1,NPt2)=LongF;   Extry(1,NPt2)=SansEffet;
Extrx=sort(Extrx);
YEnvlop=Extry;         XEnvlop=Extrx;
i=1; NPtF=NPt2;
while i<NPtF %w1
    j=i;          
    while abs(XEnvlop(1,j+1)-XEnvlop(1,j)) > Delta; %w2
        XEnvlopm=min(XEnvlop(1,j),XEnvlop(1,j+1))+1; 
        XEnvlopM=max(XEnvlop(1,j),XEnvlop(1,j+1))-1; 
        x=min(XEnvlopm,XEnvlopM)+abs(XEnvlopM-XEnvlopm)*rand; 
        ym=min(YEnvlop(1,j),YEnvlop(1,j+1));
        yM=max(YEnvlop(1,j),YEnvlop(1,j+1));
        y=min(ym,yM)+fix((1+abs(yM-ym))*rand);        
        XEnvlop(1,j+2:NPtF+1)=XEnvlop(1,j+1:NPtF);
        YEnvlop(1,j+2:NPtF+1)=YEnvlop(1,j+1:NPtF);
        XEnvlop(1,j+1)=x; 
        YEnvlop(1,j+1)=y; 
        NPtF=NPtF+1;
    end %w2
    i=i+1;
end %w1
%//////////////////////////////////////////////////////////////////////////
function [Bend1, Bend2]=midibend(x)
%conversion  Bend to midi format

format compact;
Octet1s='00000000';
Octet2s='00000000';
m=14;
DecMs=dec2bin(x,m);
Octet1s(1,8:-1:2)=DecMs(1,m:-1:m-6);%2 fois 7 bits
Octet2s(1,8:-1:2)=DecMs(1,m-7:-1:1);
Bend1=bin2dec(Octet1s);
Bend2=bin2dec(Octet2s);
