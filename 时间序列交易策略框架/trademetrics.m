function  tradespfm  =  trademetrics( Capital , flagH )
%% �����ױʣ���ȶĲ������в�������
% Capital (1 by T): �˻��ʽ����߻�ֵ����
% flagH (1 by T): �ֱֲ�־����, Ԫ��ȡֵ 1���ֲ֣� or 0���ղ֣�





%% ÿ�ʽ���ʱ��

T = numel(flagH);

dH = flagH - [0 flagH(1:end-1)];
entrytime  =  find(dH == 1);
exittime  =  find(dH == -1);

if isempty(entrytime)
    tradespfm = NaN;
    return
end

if numel(exittime) ~= numel(entrytime)
    exittime = [ exittime T ];
end

Ttrade = [ entrytime'  exittime' ]; % T by 2 matrix, recording each round trade's time (entry and exit time)



%% �ֲ�����ͳ��

holdtime = Ttrade(:,2)-Ttrade(:,1);
tmetrics = [  mean(holdtime)  std(holdtime)  max(holdtime)  min(holdtime)  ];



%% per-trade performance metrics

N = size(Ttrade,1); % number of round trades

roi  =  Capital( Ttrade(:,2) )  ./  Capital( Ttrade(:,1) ) - 1; % ROI per trade series
winrate  =  sum(roi>0) / N; % win rate

if  all(roi>0)     % no loss trade
    plr = NaN; % P/L ratio
    conloss = 0; % max numbers of consecutive loss
elseif  all(roi<0)     % no profit trade
    plr = NaN; % P/L ratio
    conloss = N; % max numbers of consecutive loss
else
    plr  =  mean( roi(roi>0) ) / -mean( roi(roi<0) ); % P/L ratio
    conloss  =  max(  diff( find([1 roi 1]>0) )  ) - 1; % ����ֱ����������������������������
end


tradespfm  =  [ N winrate plr conloss tmetrics ]; % �ۺ�ָ��

