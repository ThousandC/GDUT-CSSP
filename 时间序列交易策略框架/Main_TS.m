%% 主程序入口



%% 选择策略

strategysn =1;
strategyname_cell = {  'breakH'  'breakL'  'MAcross1'  'MAcross2'  'CL'  'crossB'  '...'  '...'  '...'   };
strategyname = strategyname_cell{ strategysn };
disp(strategyname)



%% 调用子函数提取策略参数

paramcell  =  parameters_TSstrategy( strategyname );



%% 选择时间段

begintime = 20100104; % YYYYMMDD or YYYYMMDDHHMM
endtime = 20200611; % YYYYMMDD or YYYYMMDDHHMM



%% 读取数据；确定开始时间与结束时间对应坐标

% 选择交易品种
sn = 1; % 选择品种序列号
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
load( filename );%内部数据集名称为TOHLCV

% 核对时间轴，找到给定开始时间与结束时间对应的坐标
beginidx = find( TOHLCV(:,1) == begintime );
endidx = find( TOHLCV(:,1) == endtime );



%% 回测策略

% 显示品种
disp(  [  '交易品种: '  pname  ]  );

% 根据开始与结束时间的对应坐标截取矩阵
TOHLCV = TOHLCV( beginidx : endidx , : );
innan = find( ~isnan(TOHLCV(:,5)) ,1 );%这里只取第一个时间点：NaN出现的出现是因为那一年还没开始交易这种品种
TOHLCV = TOHLCV( innan : end , : );
begintime = TOHLCV(1,1); % 更新begintime

% 模拟交易
inicash = 10^7;
[ Capital , H ]  =  feval( [ 'Strategy_' strategyname ] , TOHLCV , paramcell , inicash );

    
    
Eqty  =  Capital / inicash; % 净值曲线
SI = TOHLCV(:,5) / TOHLCV(1,5);

plot( Eqty )
hold on
plot( SI,':' )
hold off
xlabel('交易日')
ylabel('策略净值')
legend( '择时策略' , '固定持有' )
title( {  [ 'Strategy - ' strategyname ]; [ pname ': ' num2str(begintime) '--' num2str(endtime) ]  } )

equitypfm  =  performmetrics( Eqty , 1 , SI' )
tpfm  =  trademetrics( Capital , H(1,:)>0 )


