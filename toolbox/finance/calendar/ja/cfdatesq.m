% CFDATESQ   �m�藘�t�،��̏�(quasi)�N�[�|���x����
%
% ���̊֐��́ANUMBONDS �������݂���m�藘�t�،��ɂ��āA��(quasi)
% �N�[�|���x�����̓��t�s����o�͂��܂��B�A�����鏀�N�[�|�����t�́A�m��
% ���t�،��̕W���N�[�|�����Ԃ̒��������肵�܂��B�������A���N�[�|�����t��
% ���ۂ̃N�[�|���x�����ƕK��������v����Ƃ͌���܂���B���N�[�|�����́A
% ��1�܂��͍ŏI�N�[�|�����Ԃ��ʏ�̒����ł���̂��A����Ƃ��ʏ����
% ����(�܂��͒Z��)���Ԃł���̂��ɂ�����炸�m�肳��܂��B�f�t�H���g
% �ł́A���ϓ��̌�y�сA�������܂��͖��������O�ɓ������鏀�N�[�|������
% �o�͂���܂��B
% 
%   QuasiCouponDates = cfdatesq(Settle, Maturity)
%
%   QuasiCouponDates = cfdatesq(Settle, Maturity, Period, Basis, 
%                               EndMonthRule, IssueDate, FirstCouponDate, 
%                               LastCouponDate, PeriodsBeforeSettle, 
%                               PeriodsAfterMaturity)
% ����: 
%   Settle   - ���ϓ�
%   Maturity - ������
%
% ����(�I�v�V����):
%   Period               - 1�N�ł̃N�[�|���x����; �f�t�H���g��2
%                          (���N����)
%   Basis                - �����̃J�E���g�; �f�t�H���g��0 
%                          (actual/actual)
%   EndMonthRule         - �����K��; �f�t�H���g��1(�����K���͗L��)
%   IssueDate            - �،��̔��s��
%   FirstCouponDate      - �s����܂��͒ʏ�̑�1��N�[�|���x����
%   LastCouponDate       - �s����܂��͒ʏ�̍ŏI�N�[�|���x���� 
%   PeriodsBeforeSettle  - �Z���̑ΏۂƂȂ錈�ϓ��Ɠ������t�ɓ�������
%                          ���N�[�|�����A�܂��́A���ϓ����O�ɓ�������
%                          ���N�[�|�����̐�(�񕉂̐���)�B�f�t�H���g��0
%   PeriodsAfterMaturity - �Z���̑ΏۂƂȂ閞����������ɓ�������
%                          ���N�[�|�����̐�(�񕉂̐���)�B�f�t�H���g��0
%
% �o��: 
%   QuasiCouponDates - �V���A���f�[�g�`���ŕ\�����ꂽ���N�[�|�����t�s��
%     �ł��BQuasiCouponDates�s��̍s�̐��́ANUMBONDS�ŁA��̐��́A��
%     �|�[�g�t�H���I��ۗL���邱�Ƃɂ��v������鏀�N�[�|�������̍ő�l
%     �ɂ���Č��肳��܂��B���N�[�|�����̐����AQuasiCouponDates�s���
%     ��̐��ɂ���Ď������ő�l��菭�Ȃ����ɂ��ẮANaN�l�ɂ����
%     ���������s���܂��B�f�t�H���g�ł́A���ϓ��̌�A�y�сA�������܂���
%     ���������O�ɓ������鏀�N�[�|�������o�͂���܂��B���ϓ�����������
%     �����ɓ������A�������� ���N�[�|�����ƂȂ��Ă���P�[�X�ł́A��������
%     �o�͂���܂��B
%
% ���ӁF[�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂���1�s
%   NUMBONDS��̃x�N�g���܂��̓X�J�������ƂȂ�܂��B�I�v�V�����ƂȂ�
%   �S�Ă̈�����NUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�X�J��
%   �܂��͋�s��̂����ꂩ�ƂȂ�܂��B�l�̎w��̂Ȃ����͂ɂ� NaN �����
%   �x�N�g���Ƃ��Đݒ肵�Ă��������B���t�́A�V���A�����t�ԍ��܂��͓��t
%   ������ł��B
%
%   ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%   'help ftb' + ������(���Ƃ��΁ASettle(���ϓ�)�Ɋւ���w���v�́A
%   "help ftbSettle"�ƃ^�C�v���ē����܂�)�B
%
% �Q�l : CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%        CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES.


% Copyright 1995-2002 The MathWorks, Inc. 
