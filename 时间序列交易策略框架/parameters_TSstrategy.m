function  paramcell  =  parameters_TSstrategy( strategyname )
%% output the parameter cell for a given momentum strategy



%%
switch  strategyname
    
    case  'breakH'
        
        N1 = 20; % 进场信号探测窗口周期
        N2 = 5; % 出场信号探测窗口周期
        hl_c = 2; % 信号探测使用高低点 (取值1)或收盘价 (取值2)
        paramcell = { [N1 hl_c]  [N2 hl_c] };
        
    case  'breakL'
        
        N1 = 20; % 进场信号探测窗口周期
        N2 = 5; % 出场信号探测窗口周期
        hl_c = 2; % 信号探测使用高低点 (取值1)或收盘价 (取值2)
        paramcell = { [N1 hl_c]  [N2 hl_c] };
        
    case  'MAcross1'
        
        K = [5 30]; % 双均线参数
        paramcell = { K  K };
        
    case  'MAcross2'
        
        K = [5 30]; % 双均线参数
        paramcell = { K  K };
        
    case 'CL'
        
        N = 30; % detection window parameter
        x1 = 0.8; % band width multiple for entry
        x2 = 0.8; % band width multiple for exit
        s_r = 1; % use stochastic value(1) or rank score(2)
        hl_c = 2; % using HL (1) or Close price (2)
        nx = 1; % ma parameter for channel value
        paramcell = { [N x1 s_r hl_c nx]  [N x2 s_r hl_c nx] };
        
    case  'crossB'
        
        N = 30; % detection window parameter
        x1 = 0.8; % band width multiple for entry
        x2 = 0.8; % band width multiple for exit
        b_a = 1; % bb(1) or atrband(2)
        paramcell = { [N x1 b_a]  [N x2 b_a] };
        
        
        
        
        
    case  '  '
        
    case  '  '
        
    case  '  '
        
    case  '  '
        
        

        
    otherwise
        
        msgbox('Strategy name incorrect!')
        
end


