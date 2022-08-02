%Problem 8-19

%Consider Mobility Model 3 as described in Subsection 8.5.2 and an anchoring 
%region with 9 agents as illustrated in Fig. 8.20. User movements are modeled by 
%bound-ary crossings between serving areas. The residence time of the mobile in
%each serving area is an exponentially distributed random variable with mean
%alpha minutes. Calls to the mobiles are modeled as a Poisson arrival
%process with a mean rate Beta calls per minute. Calls are generated for
%randomly selected serving areas. Each call duration is an expeonentially 
%dis-tributed random variable with mean equal to Gamma minutes. Assume that the
%network has enough resources to accept all the calls. Given Psame and Pback
%(see Fig. 8.18), determine
%(a) the probabilities that an active mobile stays in the service areas A, B,
%and C, respectively (see Fig. 8.20);

function chap8_func (action)
%Get input parameters
handle = findobj(gcbf, 'Tag', 'alpha');
alpha = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'gamma');
gamma = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'Psame');
Psame = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'Pback');
Pback = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'N');
N = eval(get(handle, 'String'));

Pother = 1 - Psame - Pback;

%the 9 numbers represent the 9 regions that we are dealing with.
region_num = zeros(5);
region_num (2, 2:4) = [1:3];
region_num (3, 2:4) = [4:6];
region_num (4, 2:4) = [7:9];

%time_reg(1) is used for collecting time outside of the 9 regions and the rest
%of the 9 elements are used to collect times in the 9 regions.
time_reg = zeros(1, 10);

%    1 2 3 4 5
%    - - - - - 
% 1| 0 0 0 0 0
% 2| 0 1 2 3 0
% 3| 0 4 5 6 0
% 4| 0 7 8 9 0
% 5| 0 0 0 0 0

for i= 1:N
   %PreRegNum keeps track of the previous region number.
   PreRegNum = 0;
   %RegNum keeps track of the cuurent region number.
   RegNum = 0;
   %The call can be originated from anywhere in the 9 regions with a uniform
   %distribution.
   region = ceil(9 * rand(1));
   
   %From the region number, generate it's coordinate based on the diagram above.
   switch region
      case 1
         curr_reg = [2, 2];
      case 2
         curr_reg = [2, 3];
      case 3
         curr_reg = [2, 4];
      case 4
         curr_reg = [3, 2];
      case 5
         curr_reg = [3, 3];
      case 6
         curr_reg = [3, 4];
      case 7
         curr_reg = [4, 2];
      case 8
         curr_reg = [4, 3];
      case 9 
         curr_reg = [4, 4];
   end
      
   HoldTime = exprnd(gamma);   %exponential distribution with mean gamma minutes   
   TimeLeft = HoldTime;
   
   count = 0;
   %initially set previous move to an illegal value 
   prev_move = 6;% 0 - up, 1-right, 2-down, 3-left
   
   %repeat until the call is over.
   while(TimeLeft ~= 0)
      ResTime = exprnd(alpha);  %exponential distribution = alpha minutes
      
      %if the mobile user goes out of bound then assume that it stayed in the
      %region with RegNum = 0;  The mobile user can only go out of bound if he
      %or she was in one of the region 0 previously therefore no need to update
      %RegNum
      if (curr_reg(1)> 0 & curr_reg(1) < 6 & curr_reg(2)> 0 & curr_reg(2)<6)
         PreRegNum = RegNum;
         %get region based on coordinates
         RegNum = region_num(curr_reg(1), curr_reg(2)); 
      end

      if ( TimeLeft > ResTime) %need to find out where the user go next
         %if going into region B, need to store the time depending on the previous 
         %region.  time_reg(3) saves A->B , time_reg(5) saves C->B and time_reg(7)
         %saves the remaining cases.
         if((RegNum == 2) | (RegNum == 4) | (RegNum == 6) | (RegNum == 8))
            if (PreRegNum == 5)
               time_reg(3) = time_reg(3) + ResTime;
            elseif (PreRegNum == 0)
               time_reg(5) = time_reg(5) + ResTime;
            else
               time_reg(7) = time_reg(7) + ResTime;
            end
         else
            time_reg(RegNum+1) = time_reg(RegNum+1) + ResTime;
         end

         TimeLeft = TimeLeft - ResTime;
         
         %find next region that the mobile user is heading toward.
         temp = rand(1); %toss a coin
         
         if (count == 0) %no previous move, all 4 directions are equally probable
            move = floor(temp*4);
         else %directions depends on the previous move.
            if (temp <= Psame)
               move = prev_move
            elseif (temp > Psame & temp <= (Psame + Pback))
               move = mod(prev_move + 2, 4);
            elseif (temp > (Psame + Pback) & temp <= (Psame + Pback + Pother/2))
               move = mod(prev_move + 1, 4);
            else
               move = mod(prev_move + 3, 4);
            end
         end
         
         prev_move = move;
         %given the move, update the current region coordinates.
         switch move
         case 0
            curr_reg(1) = curr_reg(1) - 1;
         case 1
            curr_reg(2) = curr_reg(2) + 1;
         case 2
            curr_reg(1) = curr_reg(1) + 1;
         case 3
            curr_reg(2) = curr_reg(2) - 1;
         end
    
      else %this is the last region before the call ends.
         if((RegNum == 2) | (RegNum == 4) | (RegNum == 6) | (RegNum == 8))
            if (PreRegNum == 5)
               time_reg(3) = time_reg(3) + TimeLeft;
            elseif (PreRegNum == 0)
               time_reg(5) = time_reg(5) + TimeLeft;
            else
               time_reg(7) = time_reg(7) + TimeLeft;
            end
         else   
            time_reg(RegNum+1) = time_reg(RegNum+1) + TimeLeft;
         end

         TimeLeft = 0;
      end 
   end
   
end

%Calculate total time.
Ttot = 0;
for i = 1:10
   Ttot = Ttot + time_reg(i);
end

%Calculate probabilities
ProbA   = time_reg(6)/Ttot;
ProbB   = (time_reg(3) + time_reg(5) + time_reg(7))/Ttot;
%time_reg(3) is used to collect all the times of B where previously the user was in A
ProbBa  = time_reg(3)/Ttot;
%time_reg(3) is used to collect all the times of B where previously the user was in C
ProbBc  = time_reg(7)/Ttot;
ProbC   = (time_reg(2) + time_reg(4) + time_reg(8) + time_reg(10))/Ttot;
%time_reg(1) contains all the times that the users spend outside of the 9 regions
ProbOut = time_reg(1)/Ttot;

 
%Set Ouput
handle = findobj(gcbf, 'Tag', 'Sa');
set(handle,'String', ProbA);
handle = findobj(gcbf, 'Tag', 'Sb');
set(handle,'String', ProbB);
handle = findobj(gcbf, 'Tag', 'Sc');
set(handle,'String', ProbC);
handle = findobj(gcbf, 'Tag', 'Sout');
set(handle,'String', ProbOut);




return;
