function play(infile,instrument,outfile)

%This is a small program that generates wavfiles when provided with the notes 
%that are to be played and the duration of each note.
%
%This information is in tab delimited file of two columns.
%The first column of the input file should be the difference in the note from the previous note. 
%Notes can be in difference on half or one (Other gaps can be used but it might not sound good).
%The first entry of the column will be the difference of the first note with the 'Middle C'
%The second column has the duration in seconds of each note
%
%Example of the major scale from Middle C with equal time duration of 1s will be
%
%   0    1
%   1    1
%   1    1
%   0.5  1
%   1    1
%   1    1
%   1    1
%   0.5  1
%
%The above will write a wave file which will play C for 1s, D for 1s, E for 1s, F for 1s, 
%G for 1s ... till C for 1s
%
%Syntax:
%  play(infile,instrument,outfile);
%
%  infile has to be the txt file of the format mentioned above
%  instrument can be 'sine','flute','oboe','violin' (though it sounds nothing like those instruments)
%  outfile is the file into which the wavfile has to be written.
%
%We can write any sequence of numbers to get any song generated. 
%Nothing useful - but fun
%Working on making the instruments sound more like they should
%
%
%See also WAVAPPEND for writing large wavfiles.
%

%Suresh Joel, June 11,2002

switch(nargin)
case 0
   [filename pathname]=uigetfile('*.txt','Open sequence file');
   infile=strcat(pathname,filename);
   instrument = 'sine';
case 1
   instrument = 'sine';
case 2
case 3   
   %do nothing
end

[n p]=textread(infile,'%f %f');

Fs=11025;
w=261.63;
x=[];
for i=1:length(n)
   t=0:1/Fs:(0.5*p(i));
   if(fix(n(i)))
      for j=1:abs(fix(n(i)))
         if n(i)>=0
            w=w*1.122458;
         else
            w=w/1.122458;
         end
      end
   end
   if(rem(n(i),1))
      if(n(i)>0)
         w=w*1.059465;
      else
         w=w/1.059465;
      end
   end
   switch(instrument)
   case 'sine'
      x1=sin((2*pi*w).*t);
   case 'flute'
      x1=sin((2*pi*w).*t)+ 0.75*sin((2*pi*w*2).*t) + 0.18*sin((2*pi*w*3).*t) + 0.18*sin((2*pi*w*4).*t) + 0.06*sin((2*pi*w*5).*t);
   case 'oboe'
      x1=sin((2*pi*w).*t)+ 1.375*sin((2*pi*w*2).*t) + 0.75*sin((2*pi*w*3).*t) + sin((2*pi*w*4).*t) + 0.45*sin((2*pi*w*5).*t) + 0.375*sin((2*pi*w*6).*t);
   case 'violin'
      x1=sin((2*pi*w).*t)+ 0.5*sin((2*pi*w*2).*t) + 0.43*sin((2*pi*w*3).*t) + 0.48*sin((2*pi*w*4).*t) + 0.55*sin((2*pi*w*5).*t) + 0.76*sin((2*pi*w*6).*t);
   end
   
   %Jump correction
   true=1;
   l=0;
   k=length(x1);
   while(true),
      if(x1(k)>0 & x1(k-1)>0) | (x1(k)<0 & x1(k-1)<0),
         l=l+1;
      else
         true=0;
      end
      k=k-1;
   end
   
   x=[x x1(1:(length(x1)-l))];
end

if(nargin<3)
   sound(x,Fs);
else
   wavwrite(x,Fs,outfile);
end;

