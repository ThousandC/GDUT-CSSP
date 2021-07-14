%% ���������



%% ѡ�����

strategysn =1;
strategyname_cell = {  'breakH'  'breakL'  'MAcross1'  'MAcross2'  'CL'  'crossB'  '...'  '...'  '...'   };
strategyname = strategyname_cell{ strategysn };
disp(strategyname)



%% �����Ӻ�����ȡ���Բ���

paramcell  =  parameters_TSstrategy( strategyname );



%% ѡ��ʱ���

begintime = 20100104; % YYYYMMDD or YYYYMMDDHHMM
endtime = 20200611; % YYYYMMDD or YYYYMMDDHHMM



%% ��ȡ���ݣ�ȷ����ʼʱ�������ʱ���Ӧ����

% ѡ����Ʒ��
sn = 1; % ѡ��Ʒ�����к�
Codescell  =  { 
    '000001.SH'; '000016.SH'; '000300.SH'; '000905.SH'; '399005.SZ'; '399006.SZ';
    'RBFI.WI'; 'HCFI.WI'; 'JFI.WI'; 'JMFI.WI'; 'IFI.WI'; 'ZCFI.WI';
    'RUFI.WI'; 'SPFI.WI'; 'FGFI.WI';
    'CUFI.WI'; 'NIFI.WI'; 'ALFI.WI'; 'ZNFI.WI';
    'FUFI.WI'; 'BUFI.WI'; 'SCFI.WI';
    'AUFI.WI'; 'AGFI.WI';
    'APFI.WI'; 'SRFI.WI'; 'CFFI.WI'; 'JDFI.WI'; 'PFI.WI'; 'MFI.WI'; 'RMFI.WI'; 'YFI.WI'; 'OIFI.WI';
    'MAFI.WI'; 'PPFI.WI'; 'LFI.WI'; 'VFI.WI';  'TAFI.WI'; 'EGFI.WI' }; % Ʒ�ִ����������ݿ⣩
code = Codescell{sn,:}    % �������кŲ��õ�Ʒ�ִ���
pname = code(1:end-3);

% ��ȡ�����ļ�
if begintime > 10^8
    filename = [ 'Data/Min/'  pname  '.mat' ]; % ����Ƶ����
else
    filename = [ 'Data/Daily/'  pname  '.mat' ]; % ��Ƶ����
end
load( filename );%�ڲ����ݼ�����ΪTOHLCV

% �˶�ʱ���ᣬ�ҵ�������ʼʱ�������ʱ���Ӧ������
beginidx = find( TOHLCV(:,1) == begintime );
endidx = find( TOHLCV(:,1) == endtime );



%% �ز����

% ��ʾƷ��
disp(  [  '����Ʒ��: '  pname  ]  );

% ���ݿ�ʼ�����ʱ��Ķ�Ӧ�����ȡ����
TOHLCV = TOHLCV( beginidx : endidx , : );
innan = find( ~isnan(TOHLCV(:,5)) ,1 );%����ֻȡ��һ��ʱ��㣺NaN���ֵĳ�������Ϊ��һ�껹û��ʼ��������Ʒ��
TOHLCV = TOHLCV( innan : end , : );
begintime = TOHLCV(1,1); % ����begintime

% ģ�⽻��
inicash = 10^7;
[ Capital , H ]  =  feval( [ 'Strategy_' strategyname ] , TOHLCV , paramcell , inicash );

    
    
Eqty  =  Capital / inicash; % ��ֵ����
SI = TOHLCV(:,5) / TOHLCV(1,5);

plot( Eqty )
hold on
plot( SI,':' )
hold off
xlabel('������')
ylabel('���Ծ�ֵ')
legend( '��ʱ����' , '�̶�����' )
title( {  [ 'Strategy - ' strategyname ]; [ pname ': ' num2str(begintime) '--' num2str(endtime) ]  } )

equitypfm  =  performmetrics( Eqty , 1 , SI' )
tpfm  =  trademetrics( Capital , H(1,:)>0 )


