function  [ H , Cash , Capital ]  =  signaltradeS( OHLC , entrysignal , exitsignal , inicash , tstop , pstop )
%% ���ݸ��������źŷ��潻�ף����գ�

% entrysignal & exitsignal: ����������ź����� (1 or 0)
% inicash: ��ʼ�ʽ�
% tstop: ʱ���������
% pstop: ����ֹ���������

% H (2 by T): �ֲ�ͷ�� (in volume and in capital) at the end of each bar
% Cash (1 by T): �˻��ֽ�����
% Capital (1 by T): �˻���ֵ����





%% ������ʵѡ��Ĳ���
tcrate1 = 0.0000; % �������׷���
tcrate2 = 0.0000; % ���뽻�׷���
lots = 1; % ��С���׵�λ��һ�֣��� how many shares(contracts) per lot
slip = 0; % ����



%% Ĭ�ϳ�������
if nargin < 6
    pstop  =  Inf * ones( size(entrysignal) );
end
if nargin < 5
    tstop = Inf;
end



%% ���ڸ���ͷ�硢�ֽ��˻���ֵ

% ��ʼ��
T = size(OHLC,1);
H = zeros(2,T); % recording position (in volume and in capital) at the end of each bar
Cash = zeros(1,T); % cash held in the account
Capital = zeros(1,T); % recording the total capital at the end of each bar
post = 0; % trader's current position
cash = inicash; % trader's current cash
entertime = 0; % record last entry time

%
if sum(entrysignal) == 0
    Capital = inicash*ones(1,T);
    return
end

% loop starts
for i = 1 : T
    
    % stop conditions
    if entertime == 0
        stopcon = 0;
    else
        timestop  =  i-entertime >= tstop; % time stop condition
        trailstop  =  OHLC(i,4) / min(OHLC(entertime+1:i,4)) - 1 > pstop(i); % trail stop condition
        stopcon  =  timestop || trailstop;
    end
    
    % open or cover position according to given signals
    if  post == 0  &&  entrysignal(i)  % need to open position
        sellprc  =  OHLC(i,4) - slip; % sell price
        sellcost = sellprc*(1-tcrate1); % share(contract) cost when sold, accounting for transaction cost
        selllots = floor(cash/sellcost/lots); % how many lots to sell
        post = -selllots*lots; % number of shares(contracts) held
        H(1,i) = post; % position in terms of volume
        H(2,i) = post*OHLC(i,4); % position in terms of capital
        cash = cash-post*sellcost; % current cash
        Cash(i) = cash; % cash at the end of this bar
        Capital(i) = H(2,i)+cash; % total capital in the account
        entertime = i;
    elseif  post ~= 0  &&  ( exitsignal(i)  ||  stopcon )  % need to cover position
        buyprc  =  OHLC(i,4) + slip; % buy price
        buycost = buyprc*(1+tcrate2); % share(contract) cost when bought, accounting for transaction cost
        H(1,i) = 0; % position in terms of volume
        H(2,i) = 0; % position in terms of capital
        cash = cash+post*buycost; % current cash
        Cash(i) = cash; % cash at the end of this bar
        Capital(i) = cash; % total capital in the account
        post = 0;
        entertime = 0;
    else % no trading action in this bar
        H(1,i) = post; % position in terms of volume
        H(2,i) = post*OHLC(i,4); % position in terms of capital
        Cash(i) = cash; % cash at hand
        Capital(i) = H(2,i)+cash; % total capital
    end
    
end % loop ends

