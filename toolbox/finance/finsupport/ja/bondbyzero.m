% BONDBYZERO   �^����ꂽ1�g�̃[���Ȑ�����|�[�g�t�H���I���\���������
%              ���i���o��
%
%   Price = bondbyzero(RateSpec, CouponRate, Settle, Maturity)
%
%   Price = bondbyzero(RateSpec, CouponRate, Settle, Maturity,     ...
%                     Period,     Basis,           EndMonthRule,   ...
%                     IssueDate,  FirstCouponDate, LastCouponDate, ...
%                     StartDate,  Face)
%
% ����(�K�{): 
% ���̊֐��̓��͂́A���Ɏw�肪�Ȃ�����A�S�ăX�J���A�܂��́ANINST�s1���
% �x�N�g���ł��B���t�́A�V���A�����t�ԍ��A�܂��́A���t������ł��B�I�v
% �V�����̈����́A��s��[]��ݒ肵�āA�f�t�H���g�l���g�p���邱�Ƃ��ł�
% �܂��B
%
%   RateSpec        - �N�����Z���ꂽ�[�������\���̂ł��B
%   CouponRate      - �����^�œ��͂��ꂽ�N�[�|������(�N��)
%   Settle          - ���ϓ�
%   Maturity        - ������
%
% Optional Inputs:
%   Period          - �P�N������̃N�[�|���x�����񐔁B�f�t�H���g��2�ł��B
%   Basis           - �����̃J�E���g��B�f�t�H���g�͂O(actual/actual)
%                     �ł��B
%   EndMonthRule    - �����K���B�f�t�H���g��1 (�L��)�ł��B
%   IssueDate       - ���̔��s��
%   FirstCouponDate - �s����̑���N�[�|����
%   LastCouponDate  - �s����̍ŏI�N�[�|����
%   StartDate       - �x���������炩���߃X�^�[�g�������
%   Face            - �z�ʉ��l�B�f�t�H���g��100�ł��B
%
% �o��:
%
%   Price           - �N���[�������i��NINST�sNUMCURVES��̍s��ł��B�s
%                     ��̊e�񂪁A���ꂼ��A1�̃[���Ȑ��ɑΉ����Ă���
%                     ���B
%
%
% �Q�l : CFBYZERO, FIXEDBYZERO, FLOATBYZERO, SWAPBYZERO.


%   Author(s): J. Akao, 11-29-1997, 10-15-98, M. Reyes-Kattar
%   Copyright 1995-2002 The MathWorks, Inc. 
