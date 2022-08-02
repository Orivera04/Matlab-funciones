function cycleplot(data,period)
%  make a cycleplot of data
%  cycleplot(data,period)
%  if data is a matrix, the period is determined as size(data,1)
%  if data is a vector, period is used to break it into "seasons"

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  reshape data if needed
if min(size(data))>1
   dataBlock = data;
   period = size(data,1);
   nSubseries = size(data,2)
else
   nSubseries = floor(length(data)/period);
   dataBlock = reshape(data,period,nSubseries);
end

%  make time scale array
time = repmat((1:period)',1,nSubseries);
seriesTime = repmat(linspace(-0.4,0.4,nSubseries),period,1);
time = time+seriesTime;
%  uses seasonal means for reference lines
meanPart = repmat(mean(dataBlock,2),1,nSubseries);

%  plot data
plot(time',dataBlock','b-');
hold on
%  plot reference lines
plot(time',meanPart','c:');
hold off
set(gca,'XTick',1:period)

if nSubseries>1
%  set aspect ratio
for ii = 1:period
aspectRatio(ii) = aspect45(time(ii,:),dataBlock(ii,:));
end
averageAspectRatio = mean(aspectRatio);
set(gca,'DataAspectRatio',[1 1/averageAspectRatio 1])
axis tight
end
