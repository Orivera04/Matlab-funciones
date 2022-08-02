% FRONTCON   ポートフォリオ制約を伴う平均分散有効フロンティアを出力
%
% ユーザが指定した資産制約、共分散、収益から平均分散有効フロンティアを
% 出力します。NASSETS の数だけのリスク資産の集合が与えられると、期待収益
% の所与の価値に対して、リスクを最小化するような重み付けを行った資産投資
% のポートフォリオを計算します。ポートフォリオのリスクは、資産の加重値、
% または、資産の加重値の集合に課せられた制約に従って最小化されます。
%
% [PortRisk, PortReturn, PortWts] = frontcon(ExpReturn, .....
%      ExpCovariance, NumPorts, PortReturn, AssetBounds, ....
%      Groups, GroupBounds)
%
% 入力: 
% ExpReturn は、各資産の推定(平均)収益の1行NASSETS列のベクトルです。
%     
% ExpCovariance は、資産収益の共分散を示すNASSETS行NASSETS列の行列です。
%    
% NumPorts は、有効ポートフォリオの数 NPORTS です。NumPorts に空行列 [] 
% が入力されたり、何も指定がなされなかったときのデフォルト値は10です。
% PortReturn が、入力された場合、NumPorts には、空行列 [] を入力して
% ください。
%
% PortReturn は、フロンティア上の対象となる収益値を含む長さ NPORTS の
% ベクトルです。ユーザは、2つの方法でポートフォリオの収益値を指定すること
% ができます。PortReturn に、何ら入力しなかったり、入力を空にした場合、
% 使用可能な最小値と最大値の間で、NumPorts 個の等間隔の値を出力します。
%
% AssetBounds は、ポートフォリオ内の各資産に割り当てられた加重値の下限
% 及び上限を含む2 行 NASSETS 列の行列です。デフォルトの下限は全てゼロ
% (カラ売りなし)で、デフォルトの上限は、全て1(いかなる資産も完全なポート
% フォリオからなる)です。
%    
% Groups は、資産集合、または、資産クラスを指定するNGROUPS行NASSETS列の
% 行列です。この行列の各行は、集合を指定しています。Groups(i,j)= 1 の
% 場合、j 番目の資産は、i 番目の集合に属しています。 Groups(i,j)= 0 の
% 場合、j 番目の資産は、i 番目の集合に属していません。
%    
% GroupBounds は、各集合について、当該集合の全資産の総加重値の下限、上限
% を指定するNGROUPS行2列の行列です。デフォルトの下限値は全てゼロ、上限値は
% 全て1となっています。
%
% 出力: 
% PortRisk は、各ポートフォリオの収益の標準偏差を示すNPORTS行1列のベク
% トルです。
%    
% PortReturn は、各ポートフォリオの期待収益を示すNPORTS行1列のベクトル
% です。
% PortWts は、各資産に配分された加重値のNPORTS行NASSETS列の行列です。
% この行列のそれぞれの行は、別々のポートフォリオを表しています。ポート
% フォリオ内の全加重値の総和は1です。         
%
% 注意： 
%   関数が出力引数なしで呼び出された場合、有効フロンティアのプロットが
%   出力されます。
%
% 資産収益は共通して正常な収益で、ExpReturn の期待平均収益、ExpCovariance
% の収益共分散を伴うと仮定されます。1 行 NASSET 列の加重値 PortWts を伴う
% ポートフォリオの分散は、つぎの式によって計算されます。
% 
%    PortVar = PortWts*ExpCovariance*PortWts'
% 
% ここでポートフォリオの期待収益は、PortReturn = dot(ExpReturn, PortWts)
% となります。
%
% 参考 : PORTSTATS, PORTOPT, EWSTATS.


%   Author(s): D. Eiler, M. Reyes-Kattar, 01/30/98
%   Copyright 1995-2002 The MathWorks, Inc. 
