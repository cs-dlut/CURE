function [payoff,coope]=PGGdata();
%% Setting up the objects and defining the parameters
%Combine the various parts of the payoffs
n=4;r=1.8;c=1;generation=1000000;round=100;deltaT=0.5;eps=0.001;

%% main codes: obtained all strategies's pair-wise payoff. 2^8=256mem
payoff=zeros(257,257);coope=zeros(257,257);
payoffMC=zeros(256,2);coopeMC=zeros(256,2);payCURE=zeros(1,n);coopeCURE=zeros(1,n);

for rod=1:round
    rod
    tic;
    [pay,coope]=MCpayoff(n,generation,r,c,deltaT,eps);
    payoffMC=payoffMC*(rod-1)/rod+pay/rod;
    coopeMC=coopeMC*(rod-1)/rod+coope/rod;
    
    [pi,coop]=CCpayoff(n,generation,r,c,deltaT,eps);
    payCURE=payCURE*(rod-1)/rod+pi/rod;
    coopeCURE=coopeCURE*(rod-1)/rod+coop/rod;
    toc;
    time=toc
end

[payH,coopH]=MMpayoff(n,r,c,eps);

payoff(1:256,1:256)=payH;
payoff(257,1:256)=payoffMC(:,1);%cure payoff
payoff(1:256,257)=payoffMC(:,2);%mem payoff
payoff(257,257)=payCURE(1);

coope(1:256,1:256)=coopH;
coope(257,1:256)=coopeMC(:,1);%cure cooperation
coope(1:256,257)=coopeMC(:,2);%mem cooperation
coope(257,257)=coopeCURE(1);
%% Creating the output
dlmwrite('IPGGpayoff_001n_05d_1.8r.csv', payoff);
dlmwrite('IPGGcoopeRate_001n_05d_1.8r.csv', coope);
end
