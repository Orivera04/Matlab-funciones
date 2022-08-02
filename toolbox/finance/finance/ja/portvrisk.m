% PORTVRISK   ポートフォリオのValue-At-Risk
%
% ValueAtRisk = portvrisk(PortReturn, PortRisk, RiskThreshold, PortValue)
% は、損失確率レベル RiskThreshold をもとに、ある1期間におけるポートフォ
% リオの価値の潜在的損失を出力します。 
%
% 入力:
% PortReturn は、当該期間にわたって期待できる各ポートフォリオの期待収益
% を示す NPORTS 行1列のベクトル、または、スカラ値です。
%
% PortRisk は、当該期間における各ポートフォリオの標準偏差を示す NPORTS 
% 行1列のベクトル、または、スカラ値です。
%            
% RiskThreshold は、損失の生じる確率を指定する NPORTS 行1列ベクトル、
% または、スカラ値です。デフォルトは0.05 (5%)となっています。
%
% PortValue は、資産ポートフォリオの総価値を指定する NPORTS 行1列ベクト
% ル、または、スカラ値です。デフォルト値は1です。
% 
% 出力:
% ValueAtRisk は、1-RiskThreshold の信頼確率をもって予測された、推定最大
% 損失を示す NPORTS 行1列ベクトルです。
%
% 1-RiskThresholdの確率で、 ValueAtRisk、または、それよりも小さい損失が
% 生じ、RiskThreshold の確率で、ValueAtRisk、または、それよりも大きい
% 損失がもたらされます。
%
% 注意： 
% PortValueに入力を設定しない場合、ValueAtRisk は単位あたりベースで表示
% されます。ゼロ値は損失が何ら生じないことを意味しています。
%    
% PortReturn 及び PortRisk がドル単位の場合、 PortValue は1とします。
% PortReturn と PortRisk が百分率ベースの場合、PortValue にはポートフォ
% リオの総価値を入力してください。
% 
% 参考 : PORTOPT, FRONTCON.


%  Author(s): M. Reyes-Kattar, 05/11/98
%  Copyright 1995-2002 The MathWorks, Inc.  
