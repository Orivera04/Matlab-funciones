% FRONTIER   有効フロンティア
%
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS,TARGET) は、ポートフォリオの
% 有効フロンティアを構成する標準偏差 Risk および収益率 ROP、また、フロン
% ティア上の各点における各資産の加重 WTS を出力します。ASSET は、各行が
% ひとつの資産を示す時系列データのM行N列の行列です。RET は資産の収益率を
% 示す1行N列のベクトルです。PTS は、計算される有効フロンティア上の点の
% 数を指定します。デフォルトでは、PTS = 10 です。TARGET は、ASSET および
% RET データをもとにしたターゲットとする収益率を設定します。ターゲットの
% 収益率を入力する際には、PTS は空行列として入力します。RISK と ROR は、
% PTS行1列のベクトルで、WTS は PTS行(資産数)列の行列です。
% 
% FRONTIER(ASSET,RET) は、MATLAB ワークスペースにデータを送ることなく
% 有効フロンティアをプロットします。
%        
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS) は、有効フロンティア上の
% 標準偏差、収益率、加重を計算します。
% 
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,[],TARGET) は、フロンティア上の特定
% の収益率に関連した有効フロンティアデータを出力します。
% 
% 参考 : PORTRAND, PORTVAR, PORTROR. 
% 
% 参考文献: Bodie, Kane, and Marcus, Investments, Chapter 7. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
