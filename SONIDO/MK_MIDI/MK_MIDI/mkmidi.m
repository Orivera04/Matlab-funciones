function [midifich]=...
    mk2midi(NbTracks, NbNotes, time, pitch, velocity, Compos,...
    NbChangeInst, instchgtime, instchoix,...
    NbPw, LocPw, NbEchPw, XBend, Bend1, Bend2, NxMax)
%Inputs:
%       NbTracks=number of midi tracks
%       Notes
%         NbNotes(NbTracks,1)=Number of notes by tracks
%         time(NbTracks,NbNotesMax)=instant of each notes
%         pitch(NbTracks,NbNotesMax)=pitch of each notes
%         velocity(NbTracks,NbNotesMax)=volume of each notes
%       Compos=Choice between instrumentals and percussions(channel 10).
%       Program change
%         NbChangeInst(NbTracks,1)=number of program change by track 
%         instchgtime(NbTracks,NbChangeInstMax)=instants when program change occure
%         instchoix(NbTracks,NbChangeInstMax)=new instruments
%       Pitch wheel
%         NbPw(NbTracks,1); number of pitchwheel by track
%         LocPw(NbTracks,NbPwMax)=location pitchwheel(indiced with numero note)
%         NbEchPw(NbTracks,NbPwMax)=number of steps of each pitchwheel
%         XBend(NbTracks,NbEchPwMax,NbPwMax)=abscisses of each bend
%         Bend1, bend2(NbTracks,NbEchPwMax,NbPwMax)=Bends themselves
%         NxMax=size array(reservation)
%Output:
%       midifich= midi file
%-----------------------------
%dubois.ml@club-internet.fr
%-----------------------------

Time=time;  Pitch=pitch;  Vol=velocity;
InstChoix=instchoix;  InstChgTime=instchgtime;
%******************************* CALIBRATION ****************************************
%dtime is in ticks
TicksPerBeat=960; %résolution-you can change-
Tempo_msb=500000; %Tempo-you can change-
%Tempo=500.000 =0,5second,  correspond to tempo of 120 in 4/4
IMB=1; %(time average) between two notes (in Beats)---you can RESCALE here-
IntervMoy=IMB*TicksPerBeat; %nbr of ticks moy (ticks average) between two notes
MaxTime=max(Time,[],2); 
Mo=cumsum(MaxTime);
NbNotesReel=cumsum(NbNotes); NbNotesMax=max(NbNotes);
Moy=Mo(NbTracks,1)/(NbNotesReel(NbTracks,1)*NbTracks);
Dilat=IntervMoy/Moy;
Time=Time*Dilat;  
InstChgTime=InstChgTime*Dilat;
%----------------Codes MIDI---------------
NotOn=9*16; NotOf=8*16; PitWl=14*16; InsCh=12*16; %InsCh=Program change

%------------CALCUL of NOTES-------------- 
Evt=zeros(NbTracks,2*NbNotesMax,10); %Event= note on or note off
%we suppose that delta_time size<=5 bytes=3.4360e+010 midi_ticks
ArtVol=11; %Arret Note
Kdur=10; %Coef de duree note
for g=1:NbTracks
    if Compos==1%if1 %Choix ensemble instrumental
        if (g<=16)&(g~=10)%if2
            gch=g-1; %tous instr GM sauf le clavier percus (channel 10)
        elseif (g>16)|(g==10)%if2
            gch=15;
        end%if2
    else%if1  choix percus
        gch=9;  
    end %if1 
    %Time correspond a des note on, on en deduit le note off correspondant a partir
    %de la duree du note on
    for i=1:NbNotes(g,1)
        %Note On
        TimeEvt(g,i)=Time(g,i); %deb note, temps absolu
        Evt(g,i,1)=NotOn+gch;  %code note on
        Evt(g,i,2)=Pitch(g,i);%pitch
        Evt(g,i,3)=Vol(g,i);  %vol
        Evt(g,i,4)=Kdur*Vol(g,i); %duree note- choisir la loi-
        %Note Off
        ni=NbNotes(g,1)+i;  %ni+1;  
        TimeEvt(g,ni)=TimeEvt(g,i)+Evt(g,i,4); %fin note, temps absolu
        Evt(g,ni,1)=NotOf+gch; %code note off
        Evt(g,ni,2)=Pitch(g,i); %pitch
        Evt(g,ni,3)=ArtVol; %vol extinction
        Evt(g,ni,4)=0; %inutilise
    end %i
end %g
%-----------End calcul of notes-------------------------

%----------Calcul des controlleurs-----------------------
%-------------------------Pitch Wheel-----------------------------
TimeEvtTemp=zeros(NbTracks,NxMax); 
EvtTemp=zeros(NbTracks,NxMax,10); 
for g=1:NbTracks
    if Compos==1%if %Choix ensemble instrumental
        if (g<=16)&(g~=10)%if2
            gch=g-1; %ts instr GM sauf le clavier percus (channel 10)
        elseif (g>16)|(g==10)%if2
            gch=15;
        end%if2
    else%if1
        gch=9;  %que des percus
    end %if1
    nxg=0;
    for in=1:NbPw(g,1)   %NbNotes PW 
        nx=NbEchPw(g,in); inn=LocPw(g,in);
        XDepFormt=TimeEvt(g,inn);
        XBend(g,1:nx,in)=XDepFormt + XBend(g,1:nx,in);
        TimeEvtTemp(g,1+nxg:nx+nxg)=XBend(g,1:nx,in);       
        EvtTemp(g,1+nxg:nx+nxg,1)=PitWl+gch; %code pitchwheel
        EvtTemp(g,1+nxg:nx+nxg,2)=Bend1(g,1:nx,in);
        EvtTemp(g,1+nxg:nx+nxg,3)=Bend2(g,1:nx,in);
        nxg=nxg+nx; 
    end %in
end %g
TimeEvt=[TimeEvt, TimeEvtTemp];
Evt=[Evt, EvtTemp];
%----------------------------Instrument Change---------------------------
NbChangeInstMax=max(NbChangeInst);
TimeEvtTemp=zeros(NbTracks,NbChangeInstMax);
EvtTemp=zeros(NbTracks,NbChangeInstMax,10);
for g=1:NbTracks
    if Compos==1%if %Choix ensemble instrumental
        if (g<=16)&(g~=10)%if2
            gch=g-1; %ts instr GM sauf le clavier percus (channel 10)
        elseif (g>16)|(g==10)%if2
            gch=15;
        end%if2
    else%if1
        gch=9;  %que des percus
    end %if1
    for i=1:NbChangeInst(g,1)
        TimeEvtTemp(g,i)=InstChgTime(g,i);
        EvtTemp(g,i,1)=InsCh+gch; %code pitchwheel 
        EvtTemp(g,i,2)=InstChoix(g,i);
    end %i
end %g
TimeEvt=[TimeEvt, TimeEvtTemp];
Evt=[Evt, EvtTemp];
%----------------------------Fin instrument change-------------------------
%--------------------------------------------------------------------------
se=size(Evt);
NbEvts=se(1,2);
%----------Fin calcul des controlleurs-----------------------

%-----------Calcul of timestamp:Delta Time, DT-----------
TimeEvt=round(TimeEvt);
[TimeEvtTrie(:,:),AdrTimeEvtTrie(:,:)]= sort(TimeEvt(:,:),2); 
TimeEvtTrie=round(TimeEvtTrie);

for g=1:NbTracks
    T0=0;
    for ni=1:NbEvts
        ad=AdrTimeEvtTrie(g,ni);
        T1=TimeEvtTrie(g,ni);   DT=round(T1-T0);   
        T0=T1; 
        [DTmidi,DTlong]=IntToMidiBE(DT);
        ad1=6; ad2=6+DTlong-1;
        Evt(g,ad,ad1:ad2)=DTmidi(1,1:DTlong); %les oct DT ds Evt de 6 a 10
        Evt(g,ad,5)=DTlong;%long des DT midi ds Evt 5
    end %ni
end %g
%-------------End calcul of timestamps------------------

%-------------Construction of Tracks-------------------
ChTrackTot=[];
%-----WRITING MASTER TRACK--------------------------
ChMTRACK=[77 84 104 100 0 0 0 6 0 1 0 0 0 0];
%        [Mthd 00 00 00 06(long) 00 01(MIDI_1) 00 00 00 00(TicksPerBeat)]
%-----Nbr of tracks
ChMTRACK(1,12)=1+NbTracks; %track init + sound tracks. 
%You can add more tracks(comments)
%----Ticks per Beat------
v=zeros(1,2);
x=dec2bin(TicksPerBeat,16);
deb=1;fin=8;
for i=1:2
    v(i)=bin2dec(x(deb:fin));
    deb=deb+8; fin=fin+8;
end %i
ChMTRACK(1,13:14)=v(1:2);
%-----END WRITING MASTER TRACK----------------------
ChTrackTot=[ChTrackTot,ChMTRACK];

%-----WRITING TRACK INITIALISATION------------------
ChTrackInit=[77 84 114 107 0 0 0 39  0 255 81 3 0 0 0,...
        0 255 88 4 0 0 24 8  0 255 89 2 0 0,...
        0 255 1 10 39 77 121 32 109 117 115 105 99 39 ,...
        0 255 47 0];
%ChTrackInit=
%[Mtrk 0 0 0 27(long) 00 ff 51 03 xx xx xx (set tempo) 
%00 ff 58 04 xx xx xx xx(time signature) 00 ff 59 02 xx xx (Key signature)
%00 ff 01 0a (text)'My music'
%00 ff 2f 00(end of track)];

%------Tempo----------
%Number of metronome clocks in one minute
%1 clock = 1 beat,  correspond to 1 black (1/4 note)
%tempo is in microseconds per beat (on 3 octets)
v=zeros(1,3);
x=dec2bin(Tempo_msb,24);
deb=1;fin=8;
for i=1:3
    v(i)=bin2dec(x(deb:fin));
    deb=deb+8; fin=fin+8;
end%i
ChTrackInit(1,13:15)=v(1:3);
%-----Mesure------------
MesureN=4; %4/4 -You can change-
ChTrackInit(1,20)=MesureN; % numérateur
MesureD=2; %You can change-
ChTrackInit(1,21)=MesureD; % dénominateur D.   (if D= 2^x, we write x)
%-----Clé---------------
Cle=0; %You can change-
ChTrackInit(1,28)=Cle; %0=key of C
%-----Ton---------------
Ton=0; %You can change-
ChTrackInit(1,29)=Ton; %0=Majeur,1=mineur
%---------END WRITING TRACK INIT------------
ChTrackTot=[ChTrackTot,ChTrackInit];

%WRITING SOUND TRACK:ChTrackNote= 
%ChTrackNoteDeb + ChTrackNoteCorp + ChTrackNoteFin
for g=1:NbTracks
    if Compos==1%if1
        if (g<=16)&(g~=10)%if2
            gch=g-1; %ts instr GM sauf le clavier percus (channel 10)
        elseif (g>16)|(g==10)%if2
            gch=15;
        end%if2
    else%if1
        gch=9;  %que des percus
    end %if1
    %-----Writing ChTrackNoteDeb--------------
    ChTrackNoteDeb=[77 84 114 107  0 0 0 0  0 255 3 20 32 32 32 32 32 32 32 32 32 32 ,... %22
            32 32 32 32 32 32 32 32 32 32 ,...%10, 32
            0 255 32 1 0  0 255 33 1 0  0 176 121 0,... %14, 46
            0 176 0 0  0 176 32 0 ,... %8, 54
            0 176 7 0  0 176 10 0 ,  0 192 0 ,... %11, 65
            0 176 101 0  0 176 100 0  0 176 6 2  0 176 101 127  0 176 100 127 ,... %20, 85
        ]; 
    %ChTrackNoteDeb=[M t r k, 0 0 0 0(long), 0 ff 3 14(text 20 char,track name),
    %0 ff 32 cc(channel),0 ff 33 pp(port), 0 bx 121 0(control reset all),...
    %0 bx 0 0(control bank select MSB), 0 bx 32 0(control bank select LSB),
    %0  bx 7 yy(control vol), 0 bx 10 yy(control pan), 0  cx yy(instrument),...
    %0 bx 101 0(control RPN H), 0, bx 100 0(control RPN L), 0 bx 06 dd(control data=2),
    %0 bx 101 127(control RPN H), 0, bx 100 127(control RPN L),
    %  ]
    s=size(ChTrackNoteDeb);
    SizChTrackNoteDeb=s(1,2)-8;  %Don't count height first bytes
    %--------writing name of Track-----------------
    G=[]; G=int2str(g); %N° track %G=[];
    s=size(G); s2=s(1,2);
    v=zeros(1,s2);
    for i=1:s2
        nt(1,i)=49+str2num(G(1,i))-1; %N° track
    end %i
    Name=[84 114 97 99 107 58];  %Track:  [54 72 61 63 6b 3a]
    TitreTrack=[Name,nt]; %you can change-
    st=size(TitreTrack);  st2=st(1,2);
    ChTrackNoteDeb(1,13:13+st2-1)=TitreTrack(1,1:st2);
    %--------writing Controls----------------------
    %---- choice channel ---------------
    ChTrackNoteDeb(1,37)=gch; %you can change-
    %---- Choice port ------------------
    ChTrackNoteDeb(1,42)=0; %you can change-
    %--------Reset tous les Controls---------------
    ChTrackNoteDeb(1,44)=176+gch;
    %--------Bank Select---
    ChTrackNoteDeb(1,48)=176+gch;
    ChTrackNoteDeb(1,50)=0;  %coarse  you can change-
    ChTrackNoteDeb(1,52)=176+gch;
    ChTrackNoteDeb(1,54)=0; %fine     you can change-
    %--------Vol-----------
    ChTrackNoteDeb(1,56)=176+gch; %
    ChTrackNoteDeb(1,58)=120; %you can change- %
    %--------Pan-----------
    ChTrackNoteDeb(1,60)=176+gch; %
    ChTrackNoteDeb(1,62)=64;  %you can change- %
    %----Choice of the instrument-------------
    ChTrackNoteDeb(1,64)=192+gch; %
    ChTrackNoteDeb(1,65)=fix(127*rand); %you can change- %
    %-----PitchWheel------------------------
    ChTrackNoteDeb(1,67)=176+gch; %
    ChTrackNoteDeb(1,71)=176+gch;%
    ChTrackNoteDeb(1,75)=176+gch;%
    ChTrackNoteDeb(1,79)=176+gch;%
    ChTrackNoteDeb(1,83)=176+gch;%
    %-------End ChTrackNoteDeb-----------
    
    %------Calcul/writing of ChTrackNoteCorp--------
    %Arret=11; %Arbitrary number. You can change.
    ChTrackNoteCorp=[];
    ChTrackNote=[];
    ChTemp=[];
    for ni=1:NbEvts
        ad=AdrTimeEvtTrie(g,ni);
        b=Evt(g,ad,5);  %long DT
        w=zeros(1,b);
        w(1,1:b)=Evt(g,ad,6:6+b-1);
        Code=Evt(g,ad,1);
        switch Code
            case NotOn+gch
                ChTemp=[w,NotOn+gch];
                ChTemp=[ChTemp,Evt(g,ad,2)]; %pitch
                ChTemp=[ChTemp,Evt(g,ad,3)]; %vol
            case NotOf+gch
                ChTemp=[w,NotOf+gch];
                ChTemp=[ChTemp,Evt(g,ad,2)]; %pitch
                ChTemp=[ChTemp,Evt(g,ad,3)]; %vol
            case InsCh+gch
                ChTemp=[w,InsCh+gch]; %Inst  
                ChTemp=[ChTemp,Evt(g,ad,2)];
            case PitWl+gch
                ChTemp=[w,PitWl+gch];   %pw
                w=zeros(1,2); %2 octets data
                w(1,1:2)=Evt(g,ad,2:3);
                ChTemp=[ChTemp,w];
            case 0
                %disp ('Remplissage taille tableau');
            otherwise
                disp ('Other MIDI Instruction code to process:');
                disp(Evt(g,ad,1));
        end %switch
        ChTrackNoteCorp=[ChTrackNoteCorp,ChTemp]; 
        Si=size(ChTrackNoteCorp);
    end %ni
    %------End of ChTrackNoteCorp--------
    
    %-------ChTrackNoteFin---------------
    ChTrackNoteFin=[0 255 47 0]; %[00 ff 2f 00 ]
    SizChTrackNoteFin=4;
    %-------Fin ChTrackNoteFin-----------
    
    ChTrackNote=[ChTrackNoteDeb,ChTrackNoteCorp, ChTrackNoteFin];
    %----Calcul/writing of long Tack------------------
    S=size(ChTrackNoteCorp);
    SizChTrack=SizChTrackNoteDeb+S(1,2)+SizChTrackNoteFin;
    v=zeros(1,4);
    x=dec2bin(SizChTrack,32);
    deb=1;fin=8;
    for i=1:4
        v(i)=bin2dec(x(deb:fin));
        deb=deb+8; fin=fin+8;
    end %i
    ChTrackNote(1,5:8)=v(1:4);
    %---End Calcul/Writing de long Track----------------
    %------END WRITING SOUND TRACK----------------------
    %-------Put in queue in the MIDI fich --------------
    ChTrackTot=[ChTrackTot,ChTrackNote]; 
end %g
%----Fichier Midi complet----------------------------
midifich= ChTrackTot;
%------END MIDI FICH---------------------
%/////////////////////////////////////////////////////////////////////
function [i2m, NbOctets]=IntToMidiBE(DT)
%input:   DT=DeltaTime to convert in MIDI format
%Outputs: i2m= vecteur that contains DT in MIDI format
%         NbOctets= number of bytes in i2m to represent DT

if DT==0
    i2m=0;
    NbOctets=1;
else
    Octet=zeros(1,1);
    NbBits=ceil(log2(DT+1)); %number of bits of DT in binary numeration
    NbBytes=ceil(NbBits/7); %Number of MIDI bytes of DT
    NbBits=7*NbBytes; %Number of MIDI bits of DT
    BB=dec2bin(DT,NbBits);%we decompose DT on NbBits bits
    i=1; fin=NbBits; deb=NbBits-6; % 7 bits LSB of BB
    valeurTotPart=0;
    valeurTot=DT;
    while valeurTot > valeurTotPart
        b=BB(1,deb:fin);
        valeurOctet=bin2dec(b);
        b=strcat('1',b);%bit 8 set to 1 systematicaly
        Octet(1,i)=bin2dec(b); %  midi byte
        fin=fin-7;    deb=deb-7; % next 7 midi bits
        valeurTotPart=valeurTotPart+valeurOctet*fix((128^(i-1)));
        i=i+1;
    end %while
    Octet(1,1)=Octet(1,1)-128; % bit 8 to 0 for the first midi byte
    i=i-1;
    i2m(1,1:i)=Octet(1,i:-1:1);%Big Endian
    sy=size(Octet);
    NbOctets=sy(1,2);
end %if
