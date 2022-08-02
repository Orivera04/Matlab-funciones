% ZERO2PYLD   �^����ꂽ�[���Ȑ�����z�ʗ����Ȑ��𓱏o
%
%     [ParRates, CurveDates] = zero2pyld(ZeroRates, CurveDates, ....
%        Settle, OutputCompounding, OutputBasis, InputCompounding,....
%        InputBasis)
%
% �ڍׁF 
% �[���Ȑ��y�ш�g�̖����������͂Ƃ��ė^������ƁA���̊֐��͓��͂��ꂽ
% �������ɂ���Ď�����鏊�L���Ԃɂ��Ċz�ʗ����Ȑ����o�͂��܂��B
%
% ����: 
%   ZeroRates         
%      (�K�{)�N�����Z���ꂽ�[������10�i���Ŏ��� N �s1 ��̃x�N�g��
%   CurveDates        
%      (�K�{)���͂��ꂽ�[�����ɑΉ����閞�������V���A�����t�ԍ��Ŏ���N�s
%       1��̃x�N�g��
%   Settle            
%      (�K�{)���Y���̌��ϓ����V���A�����t�ԍ��Ŏ����X�J���l
%   OutputCompounding  
%      (�I�v�V����)�z�ʔ������̃N�[�|���p�x�������X�J���l
%
%      ���͂ł���l�́A���̒ʂ�ł��B
%              OutputCompounding =   1 - 1�N�����v�Z�A�܂��́A�N1�񕥂�
%              OutputCompounding =   2 - (�f�t�H���g)���N�����v�Z
%              OutputCompounding =   3 - �N3�񕡗��v�Z
%              OutputCompounding =   4 - �N4�񕡗��v�Z
%              OutputCompounding =   6 - �u�������v�Z
%              OutputCompounding =  12 - ��1�񕡗��v�Z
%
%   OutputBasis       
%      (�I�v�V����)�z�ʔ������̓����J�E���g��������X�J���l�B
% �@�@�@
%       ���͂ł���l�́A���̒ʂ�ł��B
%              1)Basis = 0 - actual/actual(�f�t�H���g)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%   InputCompounding  
%      (�I�v�V����)���͂��ꂽ�[������N���Ɋ��Z����Ƃ��ɁA�ǂ̂��炢��
%       �����ŕ����v�Z���s�����������X�J���l�B�f�t�H���g�l�́A
%       OutputCompounding �ƂȂ��Ă��܂��B
%   InputBasis        
%       (�I�v�V����)���͂��ꂽ�[������N���Ɋ��Z����Ƃ��ɁA�ǂ̓����J�E
%       ���g���p���邩�������X�J���l�B�f�t�H���g�l�́AOutputBasis 
%       �ƂȂ��Ă��܂��B
%
% �o��: 
%    ParRates         
%        �z�ʔ������̃N�[�|�����[�g(�z�ʗ����)������ N �s1��̗�x�N
%        �g��
%    CurveDates       
%        �e�z�ʔ������̖��������V���A�����t�ԍ��Ŏ��� N �s1��̗�x�N
%        �g��
%
% �Q�l : PYLD2ZERO, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, 
%        ZERO2DISC, DISC2ZERO.


%Author: J. Akao and C. Bassignani, 11-25-97
%   Copyright 1995-2002 The MathWorks, Inc. 
