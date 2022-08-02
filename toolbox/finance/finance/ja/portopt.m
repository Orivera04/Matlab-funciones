% PORTOPT   ����t����ꂽ�L���t�����e�B�A��̃|�[�g�t�H���I���o��
%
% ���̊֐��́A���Y�����y�у��[�U���w�肵���|�[�g�t�H���I�Ɋւ��鏔�����
% �W��(ConSet)���^������ƁA���ϕ��U�L���t�����e�B�A��̃|�[�g�t�H���I
% ���o�͂��܂��B
% 
% NASSETS �̑��݂��郊�X�N���Y�̏W���ԂŁA�^����ꂽ���Ҏ��v�̉��l��
% �΂��ă��X�N���ŏ�������悤�ȏd�ݕt�������������Y�����̃|�[�g�t�H���I��
% �v�Z���܂��B���̃|�[�g�t�H���I�̉��d�l�́A���`�ꎟ�s�����Ɏw�肳�ꂽ
% ������𖞂������̂ł��B�|�[�g�t�H���I�̏�����̐����ɂ��ẮA�֐� 
% PORTCON ���Q�Ƃ��Ă��������B
%
%  [PortRisk, PortReturn, PortWts] = ....
%      portopt(ExpReturn, ExpCovariance, NumPorts, PortReturn, ConSet)
%
%  ����: 
%     ExpReturn �́A�e���Y�̊���(����)���v���w�肷��1 �s NASSETS ���
%        �x�N�g���ł��B
%     ExpCovariance �́A���Y���v�̋����U���w�肷�� NASSETS �s NASSETS ��
%        �̍s��ł��B
%     ExpCovariance �́A�񕉂̌ŗL�l(������)�����Ώ̍s��łȂ���΂Ȃ�
%        �܂���B
%     NumPorts�A�܂��́APortReturn �̂����ꂩ���A�v�Z�����L���|�[�g
%        �t�H���I�̏W�����w�肵�܂��B
%     NumPorts �́A����̃|�[�g�t�H���I���v�l���v������Ȃ������ꍇ�ɁA
%        �L���t�����e�B�A�ɉ����Đ��������|�[�g�t�H���I�̐���\���܂��B
%        �f�t�H���g�͍ŏ����X�N�y�эő�\���v�̊Ԃɋϓ��ɊԊu��������
%        ����10�̃|�[�g�t�H���I�ƂȂ��Ă��܂��BPortReturn ���w�肷��Ƃ�
%        �́ANumPorts �͋�s�� [] �Ƃ��ē��͂��Ă��������B
%     PortReturn �́A�t�����e�B�A��̋��߂悤�Ƃ���ڕW���v�l���܂ޒ���
%        NPORTS�̃x�N�g���ł��BPortReturn �����͂���Ȃ��ꍇ�A�܂��́A��
%        �Ƃ��ē��͂��ꂽ�ꍇ�A�ŏ��y�эő�\�l�̊Ԃɓ��Ԋu�� NumPorts
%        �̐������̎��v�l���o�͂���܂��B
%     ConSet �́A���Y�����|�[�g�t�H���I�̐���s��ł��B���Y�z���̉��d�l 
%        PortWts �̓K������1 �s NASSETS ��̃x�N�g���́A�s���� 
%        A*PortWts' <= b �𖞂����܂��B�����ŁAA = ConSet(:,1:end-1)�y�� 
%        b = ConSet(:,end) �ł��BConSet �́A���Ȃ��Ƃ��|�[�g�t�H���I��
%        �����l�������Ő���������������܂�ł��܂��B
% 
% �|�[�g�t�H���I�̐���^�C�v�y�ъ֘A������Z�p�����[�^�ɂ��ẮA�֐� 
% PORTCONS ���Q�Ƃ��Ă��������B
%
% �ϐ� ConSet ���w�肵�Ȃ��ꍇ�A�f�t�H���g�̐���Z�b�g���g�p����܂��B
% �f�t�H���g�̐���́A�|�[�g�t�H���I�̑����l��1�ɒ������A�J�������h��
% ���߂ɑS���Y�̍ŏ����d�l��0�ɐݒ肵�܂��B
%
% �o��: 
% PortRisk �́A�e�|�[�g�t�H���I�̎��v�̕W���΍������� NPORTS �s1��̃x�N
%    �g���ł��B
% PortReturn �́A�e�|�[�g�t�H���I�̊��Ҏ��v������ NPORTS �s1��̃x�N�g��
%    �ł��B
% PortWts �́A�e���Y�ɔz���������d�l�� NPORTS �s NASSETS ��̍s��ł��B
%    �e�s�́A�ʁX�̃|�[�g�t�H���I���w�������Ă��܂��B
%
% ���ӁF
% �o�͈����Ȃ��ł��̊֐����Ăяo���ꂽ�ꍇ�A�L���t�����e�B�A�̃v���b�g��
% �o�͂���܂��B
%        
% �Q�l : PORTCONS, PORTSTATS, EWSTATS, FRONTCON.


%  Author(s): D. Eiler, M. Reyes-Kattar, 03/26/98
%  Copyright 1995-2002 The MathWorks, Inc. 
