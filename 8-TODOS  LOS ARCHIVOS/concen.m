function [r1,r2] = concen(toxtest); 

% Try the following:
%
% test(1).lead = .007; 
% test(2).lead = .031; 
% test(3).lead = .019; 
% test(1).mercury = .0021; 
% test(2).mercury = .0009; 
% test(3).mercury = .0013; 
% test(1).chromium = .025; 
% test(2).chromium = .017; 
% test(3).chromium = .10; 
%
% [r1,r2] = concen(test)

k = length(toxtest); 			
% Create two vectors. r1 contains the ratio of mercury to lead 
% at each observation. r2 contains the ratio of lead to chromium. 
for i = 1:k 
  r1 = [toxtest.mercury]./[toxtest.lead]; 
  r2 = [toxtest.lead]./[toxtest.chromium]; 
end 					

% Plot the concentrations of lead, mercury, and chromium 
% on the same plot, using different colors for each. 
for j = 1:k 
  lead = [toxtest.lead]; 
  mercury = [toxtest.mercury]; 
  chromium = [toxtest.chromium]; 
end 
plot(lead,'r'); 
hold on 
plot(mercury,'b') 
plot(chromium,'y'); 
hold off 


