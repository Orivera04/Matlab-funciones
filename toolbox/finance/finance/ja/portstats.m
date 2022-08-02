% PORTSTATS   ポートフォリオの期待収益とリスクを出力
%
% [PortRisk, PortReturn] = portstats (ExpReturn, ExpCovariance, Wts) は、
% 資産ポートフォリオの期待収益率とリスクを出力します。
%
% 入力: 
% ExpReturn は、各資産の期待(平均)収益を指定する1行 NASSETS 列のベクトル
% です。
% 
% ExpCovariance は、資産収益の共分散を指定する NASSETS 行 NASSETS 列の行
% 列です。
% 
% Wts は、各資産に配分される加重値の NPORTS 行 NASSETS 列の行列です。
% この行列の各行は、ポートフォリオ内の資産の様々な加重値の組み合わせを
% 示しています。Wts に入力を設定しない場合、各有価証券には加重値 
% 1/NASSETS が割り当てられます。
% 
% 出力:             
% PortRisk は、各ポートフォリオの収益の標準偏差を示す NPORTS 行1列のベク
% トルです。
%            
% PortReturn は、各ポートフォリオの期待収益を示す NPORTS 行1列のベクトル
% です。
% 
% 参考 : EWSTATS, FRONTCON, PORTOPT, PORTALLOC.
%
% 参考文献 Bodie, Kane, and Marcus, Investments, Chapter 7..


%    Author(s): M. Reyes-Kattar, 03/07/98
%    Copyright 1995-2002 The MathWorks, Inc. 
