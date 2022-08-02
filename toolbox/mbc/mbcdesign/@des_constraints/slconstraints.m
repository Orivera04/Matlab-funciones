function blk=slconstraints(c,sys,lb,ub)
% SLCONSTRAINTS  Create a simulink model of the design constraints
%
%  BLK=SLCONSTRAINTS(C,SYS,lb,ub) creates a simulink block BLK in the 
%  system SYS.  The block takes a vector of factor levels and returns 
%  the values 0/1 depending on whether the point is within the
%  constrained volume or not.
%  The optional parameters lb and ub are upper and lower constraints to 
%  include in the output.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:02:42 $

bname='Constraints';
loop=1;
while loop
   if isempty(find_system(sys,'SearchDepth',1,'Name',bname))
      loop=0;
   else
      bname=['Constraints(' num2str(loop) ')'];
      loop=loop+1;
   end
end

% First create block as subsystem
blk=[sys '/' bname];
add_block('built-in/Subsystem',blk,'position',[10 20 90 60]);

inprt=[blk '/Factors'];
add_block('built-in/Inport',inprt,'position',[10 20 35 45]);

% add a line stump
add_line(blk,[40 35;65 35]);

Ncons=length(c);
NVars=length(c.Factors);

DoLims=0;
if nargin>2
   DoLims=1;
end

if Ncons==0 & ~DoLims;
   % open the constraints library
   load_system('constraints');
   lastblk=[blk '/Constraint1'];
   % Insert a zero constraints block and link up backwards
   add_block('constraints/Zero constraint', lastblk,...
      'position',[100 20 155 50],'linkstatus','none');
   add_line(blk,[65 35; 100 35]);
   posbar=155;
   vpos=32;
   lastblk='Constraint1';
else
   % add a mux block
   MUXblk=[blk '/mux'];
   add_block('built-in/mux',MUXblk, 'position',[200 20 205 30+Ncons*15],'inputs',sprintf('%d',Ncons+2*DoLims),...
      'DisplayOption','bar');
   vpos=round(0.5*(50+Ncons*15));
   pos=[100 20 155 50];
   incr=[0 50 0 50];
   % nms=cellstr(char(c));
   % loop over constraints adding new ones
   n=0;
   if ~isempty(c)
      for n=1:Ncons
         nm=slblock(c.Constraints{n},blk);
         set_param([blk '/' nm],'position',pos);
         
         % add connecting lines
         add_line(blk,[65 35;100 0.5*(pos(2)+pos(4))]);
         add_line(blk,[nm '/1'],['mux/' sprintf('%d',n)]);
         
         pos=pos+incr;
      end
   end
   % add upper/lower constraints if necessary
   if DoLims
      % open the constraints library
      load_system('constraints');
      % lower limits
      n=n+1;
      nm=['Constraint' sprintf('%d',n)];
      add_block('constraints/Lower Limit constraint',[blk '/' nm],...
         'position',pos,'linkstatus','none');
      set_param([blk '/' nm],'LB',['[' sprintf('%g ',lb) ']']);
      add_line(blk,[65 35;100 0.5*(pos(2)+pos(4))]);
      add_line(blk,[nm '/1'],['mux/' sprintf('%d',n)]);
      pos=pos+incr;
      % upper limits
      n=n+1;
      nm=['Constraint' sprintf('%d',n)];
      add_block('constraints/Upper Limit constraint',[blk '/' nm],...
         'position',pos,'linkstatus','none');
      set_param([blk '/' nm],'UB',['[' sprintf('%g ',ub) ']']);
	  % Round added to make points R12 compatable
      add_line(blk,round([65 35;100 0.5*(pos(2)+pos(4))]));
      add_line(blk,[nm '/1'],['mux/' sprintf('%d',n)]);
      pos=pos+incr;
   end
   
   posbar=210;
   lastblk='mux';
end

% Add a constant
Consblk=[blk '/Zero'];
add_block('built-in/constant',Consblk,'position',[posbar+50 vpos+20 posbar+70 vpos+40],'value','0',...
   'showname','off');

% Add an inequality
Ineqblk=[blk '/Compare'];
add_block('built-in/RelationalOperator',Ineqblk,'position',[posbar+100 vpos posbar+120 vpos+20],...
   'showname','off','operator','<=');

% link up bits
add_line(blk,[lastblk '/1'],'Compare/1');
add_line(blk,'Zero/1','Compare/2');

if Ncons>1
   % add an AND block
   ANDblk=[blk '/AND'];
   add_block('built-in/logic',ANDblk,'position',[posbar+140 vpos posbar+160 vpos+20],...
      'showname','off','inputs','1');
   add_line(blk,'Compare/1','AND/1');
   
   % add an outport
   outprt=[blk '/Status'];
   add_block('built-in/Outport',outprt, 'position',[posbar+180 vpos-5 posbar+205 vpos+20]);
   add_line(blk, 'AND/1', 'Status/1');
else
   % just add the outport
   outprt=[blk '/Status'];
   add_block('built-in/Outport',outprt, 'position',[posbar+180 vpos-5 posbar+205 vpos+20]);
   add_line(blk, 'Compare/1', 'Status/1');
end


% add another outport
outprt=[blk '/Distances'];
add_block('built-in/Outport',outprt, 'position',[posbar+180 vpos+50 posbar+205 vpos+75]);
add_line(blk, [posbar+20 vpos+3; posbar+20 vpos+63; posbar+175 vpos+63]);

return
