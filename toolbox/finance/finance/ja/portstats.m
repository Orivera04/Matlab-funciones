% PORTSTATS   �|�[�g�t�H���I�̊��Ҏ��v�ƃ��X�N���o��
%
% [PortRisk, PortReturn] = portstats (ExpReturn, ExpCovariance, Wts) �́A
% ���Y�|�[�g�t�H���I�̊��Ҏ��v���ƃ��X�N���o�͂��܂��B
%
% ����: 
% ExpReturn �́A�e���Y�̊���(����)���v���w�肷��1�s NASSETS ��̃x�N�g��
% �ł��B
% 
% ExpCovariance �́A���Y���v�̋����U���w�肷�� NASSETS �s NASSETS ��̍s
% ��ł��B
% 
% Wts �́A�e���Y�ɔz���������d�l�� NPORTS �s NASSETS ��̍s��ł��B
% ���̍s��̊e�s�́A�|�[�g�t�H���I���̎��Y�̗l�X�ȉ��d�l�̑g�ݍ��킹��
% �����Ă��܂��BWts �ɓ��͂�ݒ肵�Ȃ��ꍇ�A�e�L���،��ɂ͉��d�l 
% 1/NASSETS �����蓖�Ă��܂��B
% 
% �o��:             
% PortRisk �́A�e�|�[�g�t�H���I�̎��v�̕W���΍������� NPORTS �s1��̃x�N
% �g���ł��B
%            
% PortReturn �́A�e�|�[�g�t�H���I�̊��Ҏ��v������ NPORTS �s1��̃x�N�g��
% �ł��B
% 
% �Q�l : EWSTATS, FRONTCON, PORTOPT, PORTALLOC.
%
% �Q�l���� Bodie, Kane, and Marcus, Investments, Chapter 7..


%    Author(s): M. Reyes-Kattar, 03/07/98
%    Copyright 1995-2002 The MathWorks, Inc. 
