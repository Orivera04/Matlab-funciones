% CFDATES   �m�藘�t�̃L���b�V���t���[���t
%
% ���̊֐��́ANUMBONDS �������݂���m�藘�t���ɂ��āA�L���b�V���t���[
% ���t�s����o�͂��܂��B���̊֐��́A��1���ԋy�эŏI���Ԃ��ʏ킩������
% �Z�����Ɋւ�炸���Y���̑S�ẴL���b�V���t���[���t���o�͂��܂��B
%
%   CFlowDates = cfdates(Settle, Maturity)
%
%   CFlowDates = cfdates(Settle, Maturity, Period, Basis, 
%                        EndMonthRule, IssueDate, FirstCouponDate, 
%                        LastCouponDate)
% ����: 
%   Settle   - ���ϓ�
%   Maturity - ������
%
% ����(�I�v�V����):
%   Period          - 1�N�ł̃N�[�|���x����; �f�t�H���g��2(���N����)
%   Basis           - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%   EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%   IssueDate       - ���̔��s��
%   FirstCouponDate - ���ۂ̑�1��N�[�|���x����
%   LastCouponDate  - ���ۂ̍ŏI�N�[�|���x���� 
%
% �o��: 
%   CFlowDates      - �V���A�����t�`���ŕ\�����ꂽ���ۂ̃L���b�V���t���[
%     �x����������Ȃ�s��ł��B CFlowDates�s��̍s�̐��́ANUMBONDS �ŁA
%     ��̐��́A���|�[�g�t�H���I��ۗL���邱�Ƃɂ��v�������L���b
%     �V���t���[�x���������̍ő�l�ɂ���Č��肳��܂��B�L���b�V���t���[
%     �x�����̐����ACFlowDates�s��̍s���ɂ���Ď������ő�l��菭�Ȃ�
%     ���ɂ��ẮANaN�l�ɂ���Č��������s���܂��B
%
% ���ӁF[�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂��́A
%   1�sNUMBONDS��̃x�N�g���܂��̓X�J�������łȂ���΂Ȃ�܂���B�I�v
%   �V�����ƂȂ�S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�sNUMBONDS���
%   �x�N�g���A�X�J���܂��͋�s��łȂ���΂Ȃ�܂���B�l�̎w��̂Ȃ�
%   ���͂ɂ� NaN ����̓x�N�g���Ƃ��Đݒ肵�Ă��������B���t�́A�V���A��
%   ���t�ԍ��܂��͓��t������ł��B
%
%   ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%   'help ftb' + ������(���Ƃ��΁ASettle(���ϓ�)�Ɋւ���w���v�́A
%   "help ftbSettle"�ƃ^�C�v���ē����܂��B 
%
% �Q�l : CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN,
%        CPNDAYSP, CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES


% Copyright 1995-2002 The MathWorks, Inc. 
