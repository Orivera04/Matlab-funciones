% DISC2ZERO   �^����ꂽ�����Ȑ�����[���Ȑ����o��
%
% [ZeroRates, CurveDates] = disc2zero(DiscRates, CurveDates, Settle,...
%      OutputCompounding, OutputBasis)
%
% �ڍׁF 
% �����Ȑ���1�g�̖���������͂Ƃ��ė^����ƁA���̊֐��͖������ɂ����
% ������鏊�L���Ԃɑ΂��āA�[���Ȑ��𐶐����܂��B�[�������Ƃ́A���_���
% �[���N�[�|���̖������̗����̂��Ƃł��B
%
% ����: 
%    DiscRates          
%       (�K�{)�^����ꂽ���L���Ԃɑ΂��銄���Ȑ���S�̓I�Ɏ��������t�@�N�^
%       (10�i���\��)��N�s1��̃x�N�g��
%    CurveDates        
%       (�K�{)�����t�@�N�^�ɑΉ����閞�������V���A�����t�Ŏ���N�s1���
%       �x�N�g��
%    MSettle           
%       (�K�{)�����t�@�N�^�ɑ΂��Č��ϓ����V���A�����t�`���ŕ\������
%       �X�J���l
%    OutputCompounding 
%       (�I�v�V����)�o�͂����[��������N���Ɋ��Z����Ƃ��ɂǂ̂��炢
%       �̊����ŕ����v�Z���s�����������X�J���l�B���͉\�Ȓl�́A����
%       �ʂ�ł��B
%            OutputCompounding = 1   -   ��N�����v�Z
%            OutputCompounding = 2   -   (�f�t�H���g)���N�����v�Z
%            OutputCompounding = 3   -   �N3�񕡗��v�Z
%            OutputCompounding = 4   -   �N4�񕡗��v�Z
%            OutputCompounding = 6   -   �u�������v�Z
%            OutputCompounding = 12  -   ��1�񕡗��v�Z
%            OutputCompounding = 365 -   ��������v�Z
%            OutputCompounding = -1  -   �A�������v�Z
%
%     OutputBasis       
%       (�I�v�V����)�o�͂����[��������N���Ɋ��Z����Ƃ��ɂǂ̓����J�E��
%       �g���p���邩�������X�J���l�B���͉\�Ȓl�́A���̒ʂ�ł��B
%            1)Basis = 0 - actual/actual(�f�t�H���g)
%            2)Basis = 1 - 30/360
%            3)Basis = 2 - actual/360
%            4)Basis = 3 - actual/365
%
% �o��: 
%     ZeroRates  - 10�i�@�\�L�̃[���������܂�N�s1��̗�x�N�g��
%     CurveDates - ZeroRates �Ɋ܂܂��e�[�������̖��������V���A��
%                  ���t�`���Ŏ������������̓��t�ō\������� N �s1���
%                  ��x�N�g��
%
% �Q�l : ZERO2DISC, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, 
%        PYLD2ZERO, ZERO2PYLD.


%Author(s): C. Bassignani, 11/21/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
