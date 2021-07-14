%% �����Ż�ͼ



%% ѡ�����

strategysn = 7;
strategyname_cell = {  'breakH'  'breakL'  'MAcross1'  'MAcross2'  'CL'  'crossB'  'DT'  '...'  '...'   };
strategyname = strategyname_cell{ strategysn };


%% ѡ��ʱ���

begintime = 20100104; % YYYYMMDD or YYYYMMDDHHMM
endtime = 20190522; % YYYYMMDD or YYYYMMDDHHMM



%% ��ȡ���ݣ�ȷ����ʼʱ�������ʱ���Ӧ����

% ѡ����Ʒ��
sn = 3; % ѡ��Ʒ�����к�
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
load( filename );

% �˶�ʱ���ᣬ�ҵ�������ʼʱ�������ʱ���Ӧ������
beginidx = find( TOHLCV(:,1) == begintime );
endidx = find( TOHLCV(:,1) == endtime );



%% �ز����

% ��ʾƷ��
disp(  [  '����Ʒ��: '  pname  ]  );

% ���ݿ�ʼ�����ʱ��Ķ�Ӧ�����ȡ����
TOHLCV = TOHLCV( beginidx : endidx , : );
innan = find( ~isnan(TOHLCV(:,5)) ,1 );
TOHLCV = TOHLCV( innan : end , : );
begintime = TOHLCV(1,1); % ����begintime

% ģ�⽻��
inicash = 10^7;
SI = TOHLCV(:,5) / TOHLCV(1,5);

N1 = 0.1:0.05:0.5; % �����ź�̽�ⴰ������
N2 = 0.1:0.05:0.5; % �����ź�̽�ⴰ������
b_a = 1; % �ź�̽��ʹ�øߵ͵� (ȡֵ1)�����̼� (ȡֵ2)

AR = nan( numel(N1) , numel(N2) ); % �껯�ر��ʾ���
Sharpe = nan( numel(N1) , numel(N2) ); % ���ձȾ���
Calmar = nan( numel(N1) , numel(N2) ); % ����Ⱦ���

for i = 1 : numel(N1)
    for j = 1 : numel(N2)
        paramcell = parameters_DayTrade_Search(strategyname,N1(i),N2(j));
        %paramcell =  { [N1(i) N2(j) b_a]  [N1(i) N2(j) b_a] };
        [ Capital , H ]  =  feval( [ 'Strategy_' strategyname ] , TOHLCV , paramcell );
        Eqty  =  Capital(:,1) / inicash; % ��ֵ����
        equitypfm  =  performmetrics( Capital(:,1)' , 1 , SI' );
        AR(i,j) = equitypfm(1);
        Sharpe(i,j) = equitypfm(1) / equitypfm(5);
        Calmar(i,j) = equitypfm(1) / equitypfm(2);
        
    end
    disp(i)
end

X=N1;
Y=N2;
Z = AR;
%Z = (AR+Sharpe+Calmar) / 3;
surf(X',Y',Z)
xlabel('K1')
ylabel('K2')
hold on
[row col]=find(max(max(Z))==Z)
k1=N1(row)
k2=N2(col)
z=Z(row,col)
