% FRONTIER   有効フロンティア
%
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS,TARGET) は、与えられたポート
% フォリオの有効フロンティアを構成する標準偏差 RISK と収益率 ROR の他に、
% フロンティアの各点に対する各資産の加重値 WTS を出力します。ASSET は
% 時系列データからなる M 行 N 列の行列で、各列が1つの資産を表します。PTS
% は計算する有効フロンティアのポイント数を指定します。デフォルトは 
% PTS = 10です。TARGET は、ASSET と RET のデータに基づいて希望する収益率
% を指定します。TARGET の収益率を入力するときには、PTS は空行列として
% 入力します。RISK と RORは PTS 行1列のベクトルで、WTS はPTS行(資産数)列
% の行列です。
% 
% FRONTIER(ASSET,RET) は、MATLABのワークスペースにデータを出力せずに有効
% フロンティアをプロットします。
%        
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS) は、有効フロンティアの各点の
% 標準偏差、収益率、加重値を出力します。
% 
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,[],TARGET) は、フロンティア上の特定
% の収益率と関連した有効フロンティアのデータを出力します。
% 
% 参考 : PORTRAND, PORTVAR, PORTROR.
%
% 参考文献: Bodie, Kane, and Marcus, Investments, Chapter 7. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
