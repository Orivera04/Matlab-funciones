% ZERO2DISC   �^����ꂽ�[���Ȑ����犄���Ȑ��𓱏o
%
%   [DiscRates, CurveDates] = zero2disc(ZeroRates, CurveDates, .....
%      Settle, InputCompounding, InputBasis)
%
% �ڍׁF
% �[���Ȑ��Ɩ������̃Z�b�g�����͂Ƃ��ė^������ƁA���̊֐��́A1�g��
% �����t�@�N�^�A�܂��́A�����Ȑ�����͂��ꂽ�������ɂ���Ď�����鏊�L
% ���Ԃɂ��Đ������܂��B
%
% ����: 
%   ZeroRates        
%     (�K�{)�^����ꂽ���L���Ԃ̃[���Ȑ��𑍑̓I�Ɏ����[����(10�i���\�L)
%      �� N �s1��̃x�N�g��
%   CurveDates       
%     (�K�{)���͂��ꂽ�[�����ɑΉ����閞�������V���A�����t�ԍ��Ŏ���N�s
%      1��̃x�N�g��
%   MSettle          
%      (�K�{)���͂��ꂽ�[���Ȑ��̖��������V���A�����t�ԍ��Ŏ����X�J���l
%      (���Ƃ��΁A�[���Ȑ����u�[�g�X�g���b�v�������̖�����)
%   InputCompounding 
%      (�I�v�V����)���͂��ꂽ�[������N���Ɋ��Z����Ƃ��ɁA�ǂ̂��炢��
%      �����ŕ����v�Z���s�����������X�J���l
% 
%      ���͂ł���l�́A���̒ʂ�ł��B
%           InputCompounding =   1 - 1�N�����v�Z�A�܂��́A�N������1���
%                                    �x����
%           InputCompounding =   2 - (�f�t�H���g)���N�����v�Z
%           InputCompounding =   3 - �N3�񕡗��v�Z
%           InputCompounding =   4 - �N4�񕡗��v�Z
%           InputCompounding =   6 - �u�������v�Z
%           InputCompounding =  12 - ��1�񕡗��v�Z
%           InputCompounding = 365 - ���������v�Z
%           InputCompounding =  -1 - �A�������v�Z
%
%   InputBasis       
%       (�I�v�V����)���͂��ꂽ�[������N���Ɋ��Z����Ƃ��ɁA�ǂ̓����J�E
%       ���g���p���邩�������X�J���l�B���͂ł���l�́A���̒ʂ�ł��B
%            1)Basis = 0 - actual/actual(�f�t�H���g)
%            2)Basis = 1 - 30/360
%            3)Basis = 2 - actual/360
%            4)Basis = 3 - actual/365
%
% �o��:    
%   DiscRates       - 10�i���ŕ\���ꂽ�����t�@�N�^�� N �s1��̗�x�N�g��
%   CurveDates      - DiscRates���\������e�����t�@�N�^�̖��������V���A
%                     �����t�ԍ��Ŏ��� N �s1��̗�x�N�g���ł��B
%
% �Q�l : DISC2ZERO, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, 
%        PYLD2ZERO, ZERO2PYLD.


%Author(s): C. Bassignani, 11/21/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
