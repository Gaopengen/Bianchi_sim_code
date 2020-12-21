clear;clc;
for Lambda = 1:50
    SimTotal=10000; %仿真顾客总数；
    Mu=5;%服务率Mu；
    K=4;
    server_num=1;%服务台数量
    c = server_num;
    Q_max=K-server_num; %最大队长
    m=0;%成功服务客户个数

server_realtime=zeros(1,server_num);
rou_c=Lambda/Mu/server_num;
rou = Lambda/Mu;
t_Arrive=zeros(1,SimTotal);
t_Wait = zeros(1,SimTotal);
ArriveNum=zeros(1,SimTotal);
LeaveNum=zeros(1,SimTotal);

Interval_Arrive=-log(rand(1,SimTotal))/Lambda;%到达时间间隔
Interval_Serve=-log(rand(1,SimTotal))/Mu;%服务时间

%% Init customers property
customers=cell(1,SimTotal);
for i=1:SimTotal
    customer.name = i;
    if i==1
        customer.t_arrive = Interval_Arrive(1);
    else
        customer.t_arrive = Interval_Arrive(i)+ customers{i-1}.t_arrive;
    end
    customer.t_serve = Interval_Serve(i);
    customer.t_leave = -1;
    customer.t_wait = -1;
    customers{i}=customer;
end

%% Start service
server_inuse = zeros(1,server_num);
queue_inuse = zeros(1,Q_max);
signed_time_point = zeros(1,2*server_num);

for i=1:SimTotal
    customer_in_server = find(server_inuse); %find busy server
    customer_in_queue = find(queue_inuse);
    if(isempty(customer_in_server))
%         customer_in_server(1)=i;
        server_inuse(1)=i;
        customers{i}.t_leave = customers{i}.t_arrive+customers{i}.t_serve;
    else
        % clear left customer
        % clear server
        for j=1:length(customer_in_server)
            if(customers{server_inuse(customer_in_server(j))}.t_leave < customers{i}.t_arrive )
                server_inuse(customer_in_server(j))=0;
            end
        end
        % clear pre queue
        for j=1:length(customer_in_queue)
            if(customers{queue_inuse(customer_in_queue(j))}.t_leave < customers{i}.t_arrive )
                queue_inuse(customer_in_queue(j))=0;
            end
        end
        % add new customer
        server_empty=find(0==server_inuse);
        server_n_empty=find(server_inuse);
        queue_empty=find(0==queue_inuse);
        queue_n_empty=find(queue_inuse);
        
        if(~isempty(server_empty)) % empty server
            server_inuse(server_empty(1))=i;
            customers{i}.t_leave = customers{i}.t_arrive+customers{i}.t_serve;
        elseif(length(server_n_empty)==server_num) %queue and service after a minist left time
            if( length(queue_n_empty)<Q_max )
                min_t_left = customers{server_inuse(server_n_empty(1))}.t_leave; 
                min_index = 1;
                for j = 2:size(server_n_empty,2)
                    if(customers{server_inuse(server_n_empty(j))}.t_leave<min_t_left) %Get the min t_left
                        min_t_left = customers{server_inuse(server_n_empty(j))}.t_leave;
                        min_index = server_n_empty(j); %index of server first finished
                    end
                    % Join the server after the first left one.
                end
                queue_inuse(queue_empty(1)) = server_inuse(min_index); %Add to queue pre
                customers{i}.t_leave = min_t_left+customers{i}.t_serve;
                customers{i}.t_wait = customers{i}.t_leave-customers{i}.t_arrive;
                if(customers{i}.t_wait<0)
                    disp('??');
                end
                server_inuse(min_index)=i;
            else
                customers{i}.t_wait=-1;
            end
        end
    end
    
    if(customers{i}.t_leave~=-1)
        customers{i}.t_wait = customers{i}.t_leave-customers{i}.t_arrive;
        signed_time_point(2*m+1) = customers{i}.t_arrive;
        signed_time_point(2*m+2) = -customers{i}.t_leave;
        t_Wait(i) = customers{i}.t_wait;
        m=m+1;
    end
end

time_point = abs(signed_time_point);
[time_point,I] = sort(time_point);
signed_time_point = signed_time_point(I);
Time_interval = [time_point(1),time_point(2:end)-time_point(1:end-1)];
CusNum = zeros(size(time_point));

% Customer num statistic
for i=1:length(time_point)-1
	if(signed_time_point(i)>0)
        CusNum(i+1)=CusNum(i)+1;
    else
        CusNum(i+1)=CusNum(i)-1;
	end
end 

CustNum_avg = sum(CusNum.*Time_interval)/time_point(end);%系统中平均顾客数计算
QueueNum_len = zeros(size(CusNum));
QueueNum_len(CusNum>server_num)= CusNum(CusNum>server_num)-server_num;
QueueNum_avg = sum(QueueNum_len.*Time_interval)/time_point(end);%平均队长
t_Wait_avg = sum(t_Wait)/SimTotal;%平均等待时间
t_Queue_avg = sum(t_Wait-Interval_Serve)/SimTotal;
p_k_Sim = zeros(1,K+1);
for i=0:K
    p_k_Sim(i+1) = sum((CusNum==i).*Time_interval)/time_point(end);
end
throughput_Sim = m/time_point(end);

j=1:c-1; i=c:K;
p_static = zeros(1,K+1);
p_static(1) = 1/(1+sum(rou.^j/factorial(j))+sum(rou.^i./(factorial(c)*c.^(i-c)))); %p0
for i = 0:K
    if(i<c)
        p_static(i+1)=rou^i/factorial(i)*p_static(1);
    else
        p_static(i+1)=rou^i*p_static(1)/factorial(c)/c^(i-c);
    end
end
% p_k = (rou^K)*p_static(1)/prod(1:c)/c^(K-c);
throughput = Lambda*(1-p_static(K+1));

% disp(['理论吞吐量=',num2str(throughput)]); 
% disp(['仿真吞吐量=',num2str(throughput_Sim)]); 
% plot([p_static;p_k_Sim]');
plot(p_static');
title('Probability of People in System');
xlabel('People in System');
ylabel('Probability');
grid on
throughput_rst(1,Lambda) = throughput_Sim;
throughput_rst(2,Lambda) = throughput;
end
figure(2);
plot(throughput_rst(2,:)');
title('吞吐量随到达率的变化曲线');
xlabel('到达率(人)/分钟');
ylabel('吞吐量（人）/分钟');
% legend('理论','仿真');
grid on;
% disp(['理论平均逗留时间t_Wait_avg=',num2str(W)]); 
% disp(['理论平均逗留时间t_Wait_avg=',num2str(W)]); 
%平均服务时间
% disp(['理论平均逗留时间t_Wait_avg=',num2str(W)]); 
% disp(['理论平均排队时间t_Wait_avg=',num2str(Wq)]);
% disp(['理论系统中平均顾客数=',num2str(N)]);
% disp(['理论系统中平均等待队长=',num2str(Nq)]);
% disp(['仿真平均逗留时间t_Wait_avg=',num2str(t_Wait_avg)]);
% disp(['仿真平均排队时间t_Queue_avg=',num2str(t_Queue_avg)]);
% disp(['仿真系统中平均顾客数=',num2str(CustNum_avg)]); 
% disp(['仿真系统中平均等待队长=',num2str(QueueNum_avg)]);
%Statistic data
%Queue time
%Waiting time
%Service time
%
