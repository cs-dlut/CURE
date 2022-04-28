function  [pi_cure,co_cure]= CCpayoff(n,generation,r,c,deltaT,eps)
% caulcuate the payoff and cooperation between CURE-CURE in PGG.

%% Setting up the random number generator
C=clock;
rng(C(5)*60+C(6));

%% calculate
PI_cure=zeros(generation,n);CO_cure=zeros(generation,n);act=zeros(generation,n);Dt=zeros(1,n);%存储每一轮，每个个体的累积平均收益和合作率

act(1:2,:)=1;%初始化第一轮的行为
PI_cure(1,:)=(r-1)*c;CO_cure(1,:)=ones(1,n);
for t=2:generation
    nc=sum(act(t,:));%calcul the number of cooperators
    for y=1:n % calcul the payoff计算组内每个人的收益
        PI_cure(t,y)=PI_cure(t-1,y)*(t-1)/t+(nc*r*c/n-act(t,y)*c)/t;%更新收益
        CO_cure(t,y)=CO_cure(t-1,y)*(t-1)/t+act(t,y)/t;
        
        Dt(1,y)=Dt(1,y)+act(t,y)-(nc-act(t,y))/(n-1);%更新每个玩家视角下，对手与自己的背叛差
        if Dt(1,y)>deltaT && rand(1)<1-eps || Dt(1,y)<=deltaT && rand(1)<eps
            act(t+1,y)=0;
        else
            act(t+1,y)=1;
        end
    end
end
pi_cure=PI_cure(generation,:);%记录最后一轮的值。历史的平均值。
co_cure=CO_cure(generation,:);%记录历史组内平均合作率
end
