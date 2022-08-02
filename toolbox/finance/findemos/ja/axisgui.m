% AXISGUI   AxesHandle で参照される axes の軸パラメータを変更する GUI 
%           の作成
%
% FigureHandle = axisgui(AxesHandle)
%
% AxesHandle で参照される座標軸の axis(と3次元プロットであればview) 
% パラメータを変更するGUIを作成します。AxesHandle は、軸のハンドル、軸の
% タグ、または、左側のブランクです。ブランク、または、タグが設定された
% 場合、カレント軸(gca)が用いられます。軸が存在しない場合、1つの軸を
% 生成します。FigureHangle は、この関数によって生成されるフィギュアの
% ハンドルです。
%
% 参考：axismenu


%       Copyright 1995-2002 The MathWorks, Inc.  
