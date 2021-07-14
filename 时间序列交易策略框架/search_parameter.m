%% 参数优化图



%% 选择策略

strategysn = 7;
strategyname_cell = {  'breakH'  'breakL'  'MAcross1'  'MAcross2'  'CL'  'crossB'  'DT'  '...'  '...'   };
strategyname = strategyname_cell{ strategysn };


%% 选择时间段

begintime = 20100104; % YYYYMMDD or YYYYMMDDHHMM
endtime = 20190522; % YYYYMMDD or YYYYMMDDHHMM



%% 读取数据；确定开始时间与结束时间对应坐标

% 选择交易品种
sn = 3; % 选择品种序列号
Codescell  =  { 
    '000001.SH'; '000016.SH'; '000300.SH'; '000905.SH'; '399005.SZ'; '399006.SZ';
    'RBFI.WI'; 'HCFI.WI'; 'JFI.WI'; 'JMFI.WI'; 'IFI.WI'; 'ZCFI.WI';
    'RUFI.WI'; 'SPFI.WI'; 'FGFI.WI';
    'CUFI.WI'; 'NIFI.WI'; 'ALFI.WI'; 'ZNFI.WI';
    'FUFI.WI'; 'BUFI.WI'; 'SCFI.WI';
    'AUFI.WI'; 'AGFI.WI';
    'APFI.WI'; 'SRFI.WI'; 'CFFI.WI'; 'JDFI.WI'; 'PFI.WI'; 'MFI.WI'; 'RMFI.WI'; 'YFI.WI'; 'OIFI.WI';
    'MAFI.WI'; 'PPFI.WI'; 'LFI.WI'; 'VFI.WI';  'TAFI.WI'; 'EGFI.WI' }; % 品种代码表（万德数据库）
code = Codescell{sn,:}    % 根据序列号查表得到品种代码
pname = code(1:end-3);

% 读取数据文件
if begintime > 10^8
    filename = [ 'Data/Min/'  pname  '.mat' ]; % 分钟频数据
else
    filename = [ 'Data/Daily/'  pname  '.mat' ]; % 日频数据
end
load( filename );

% 核对时间轴，找到给定开始时间与结束时间对应的坐标
beginidx = find( TOHLCV(:,1) == begintime );
endidx = find( TOHLCV(:,1) == endtime );



%% 回测策略

% 显示品种
disp(  [  '交易品种: '  pname  ]  );

% 根据开始与结束时间的对应坐标截取矩阵
TOHLCV = TOHLCV( beginidx : endidx , : );
innan = find( ~isnan(TOHLCV(:,5)) ,1 );
TOHLCV = TOHLCV( innan : end , : );
begintime = TOHLCV(1,1); % 更新begintime

% 模拟交易
inicash = 10^7;
SI = TOHLCV(:,5) / TOHLCV(1,5);

N1 = 0.1:0.05:0.5; % 进场信号探测窗口周期
N2 = 0.1:0.05:0.5; % 出场信号探测窗口周期
b_a = 1; % 信号探测使用高低点 (取值1)或收盘价 (取值2)

AR = nan( numel(N1) , numel(N2) ); % 年化回报率矩阵
Sharpe = nan( numel(N1) , numel(N2) ); % 夏普比矩阵
Calmar = nan( numel(N1) , numel(N2) ); % 卡玛比矩阵

for i = 1 : numel(N1)
    for j = 1 : numel(N2)
        paramcell = parameters_DayTrade_Search(strategyname,N1(i),N2(j));
        %paramcell =  { [N1(i) N2(j) b_a]  [N1(i) N2(j) b_a] };
        [ Capital , H ]  =  feval( [ 'Strategy_' strategyname ] , TOHLCV , paramcell );
        Eqty  =  Capital(:,1) / inicash; % 净值曲线
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
