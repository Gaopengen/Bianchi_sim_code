clc;
clear all;
close all;

n_step=1;

global n;
global Wmin;
global m;

Wmin=32;
N=30;
m=5;

%store p and tau
p_metrix=[];
tau_metrix=[];
S=[];
for n=1:n_step:N;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%nmfun
%out = fsolve(@myfun,[0 0],optimset('Display','off'));
%myfun.xfx
out = fsolve(@myfun2,[0 0]',optimset('Display','off'));

p=out(1);
tau=out(2);
p_metrix=[p_metrix p];
tau_metrix=[tau_metrix tau];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%commit the throughtput
payload = 8184; % in unit of bytes, assuming fixed-size payload here
DIFS = 128;  % us
SIFS = 28;  % us
slot = 50;  % us,Tid=slot
dataRate = 1; % Mbps
MAC = 272; % bytes
PHY = 128; % bytes
ACK = (112+PHY)*8/dataRate; % us
prop = 1;  %us, propagation delay,¦Ä
H=(PHY+MAC)*8/dataRate;  %us
L=payload*8/dataRate;  %us

%RTS CTS not use now
RTS = (160+PHY)*8/dataRate; % us
CTS = (112+PHY)*8/dataRate; % us

% calculate all the static components
Ptr = 1 - (1 - tau)^n;
Ps = n*tau*(1-tau)^(n-1)/Ptr;

Ts = H + L + SIFS + prop + ACK + DIFS + prop;
Tc = H + L + DIFS + prop;

% now we can compute the throughput
S_temp = (Ps*Ptr*L) / (Ptr*Ps*Ts + Ptr*(1-Ps)*Tc + (1-Ptr)*slot);
S=[S S_temp];

end


figure(1);
subplot(211);
plot(1:n_step:N,p_metrix);
ylabel('p');
xlabel('n');
grid on;
subplot(212);
plot(1:n_step:N,tau_metrix);
ylabel('tau');
xlabel('n');
grid on;


figure(2);
plot(1:n_step:N,S(1:n_step:N),'r-o');
axis([0,N,0.50,0.90]);
grid on;
