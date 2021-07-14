function  paramcell  =  parameters_DayTrade( strategyname ,N1 ,N2)
%% 输出指定策略的参数包



%%
switch  strategyname

    case  'DT'
        
        N = 5;
        K = [N1 N2];
        tcrate = 0.0001;
        paramcell = { N K tcrate };
        
        
    case 'ORB3'
        
        N = 5;
        K = [0.8 0.8];
        tcrate = 0.0001;
        paramcell = { N K tcrate };
        
        
    otherwise
        
        msgbox('Strategy name incorrect!')
        
end


