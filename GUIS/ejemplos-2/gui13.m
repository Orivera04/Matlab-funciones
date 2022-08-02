function gui13

  h = figure('ToolBar','none')
  ht = uitoolbar(h)
  a = [.05:.05:0.95];
  b(:,:,1) = repmat(a,19,1)';
  b(:,:,2) = repmat(a,19,1);
  b(:,:,3) = repmat(flipdim(a,2),19,1);
  hpt = uipushtool(ht,'CData',b,'TooltipString','Hello','ClickedCallBack','')
  hpt = uitoggletool(ht,'CData',b,'TooltipString','Hello','OnCallBack','','OffCallBack','')
