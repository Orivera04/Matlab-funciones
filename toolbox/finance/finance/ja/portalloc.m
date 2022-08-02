% PORTALLOC   有効ポートフォリオに対する資産配分を出力
%
% [RiskyRisk, RiskyReturn, RiskyWts, RiskyFraction, OverallRisk, ....
%             OverallReturn] = portalloc(PortRisk, PortReturn, ...
%                      PortWts,RisklessRate, BorrowRate, RiskAversion)
% は、ユーザ設定の有効ポートフォリオの標準偏差、期待収益、加重値を
% 使って、最適リスクポートフォリオを出力します。安全利子率、調達金利、
% 投資家のリスク回避の程度が与えられると、この関数は、最適総合ポート
% フォリオ、リスクポートフォリオとリスクフリーポートフォリオ間の投資
% 最適配分を計算します。
%
% 入力:
% PortRisk は、各ポートフォリオの分散を示す NPORTS 行1列ベクトルです。
% 
% PortReturn は、各ポートフォリオの期待収益を示す NPORTS 行1列ベクトル
% です。
% 
% PortWts は、各資産に配分される加重値の NPORTS 行 NASSETS 列の行列です。
% 行列の各行は、それぞれ別のポートフォリオを表しています。ポートフォリオ
% の加重値の総和 は1です。
%
% RisklessRate は、10進数表記で入力された安全利子率です。
%
% BorrowRate は、10進数表記で入力された調達金利です。調達を望まず、また、
% 調達がオプションでもないケースでは、この引数の値はデフォルトの NaN に
% 設定してください。
%
% RiskAversion は、投資家のリスク回避の程度を示す係数です。この値が高け
% れば高いほど、投資家は、よりリスク回避を志向するようになります。リスク
% 回避係数の通常の範囲は、2.0から4.0 となっています。なお、デフォルトの
% 値は3です。
%
% 出力:
% RiskyRisk は、最適リスクポートフォリオの分散です。
%
% RiskyReturn は、最適リスクポートフォリオの期待収益です。
%
% RiskyWts は、最適リスクポートフォリオに対して配分される加重値の1 行
% NASSETS 列のベクトルです。ポートフォリオの加重値の総和は1です。
% 
% RiskyFraction は、リスクポートフォリオに配分される完全なポートフォリオ
% の端数(fraction)です。
%
% OverallRisk は、最適総合(overall)ポートフォリオの分散です。
%
% OverallReturn は、最適総合ポートフォリオの期待収益率です。
%
% 注意：
% 出力引数なしで、この関数を呼び出した場合、臨界点を表示するグラフが表示
% されます。
%
% 参考 : PORTSTATS, EWSTATS, FRONTCON.
%
% 参考文献: Bodie, Kane, and Marcus, Investments, Chapters 6 and 7. 


%  Author(s): M. Reyes-Kattar, 02/15/98
%  Copyright 1995-2002 The MathWorks, Inc.  
