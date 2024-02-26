function [Accuracy]=dingwei(BeaconAmount) 
  
BorderLength=100;%正方形区域的边长 
BeaconAmount=20;
UNAmount=60; 
NodeAmount=UNAmount+BeaconAmount;%网络节点个数 
R=50;%节点的通信距离 
% D=zeros(NodeAmount,NodeAmount);%未知节电到信标节点距离初始矩阵；BeaconAmount行NodeAmount列 
%X=zeros(2,UNAmount);%节点估计坐标初始矩 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~在正方形区域内产生均匀分布的随机拓扑~~~~~~~~~~~~~~~~~~~~ 
C=BorderLength.*rand(2,NodeAmount); 
%带逻辑号的节点坐标 
Sxy=[[1:NodeAmount];C]; 
Beacon=[Sxy(2,1:BeaconAmount);Sxy(3,1:BeaconAmount)];%信标节点坐标 
UN=[Sxy(2,(BeaconAmount+1):NodeAmount);Sxy(3,(BeaconAmount+1):NodeAmount)];%未知节点坐标  
sume=0; 
for i=1:1:UNAmount   
    m=0; 
    sumx=0; %x的累积值 
    sumy=0; %y的累积值 
    for j=1:1:BeaconAmount  %n为信标节点个数 
        if sqrt(abs(UN(1,i)-Beacon(1,j))^2+abs(UN(2,i)-Beacon(2,j))^2)<=R %x2、y2为网络节点坐标，S.xd、S.yd为目标坐标 
           m=m+1; 
           sumx=sumx+Beacon(1,j); 
           sumy=sumy+Beacon(2,j); 
        end 
     end 
     if m==0 
          X(1,i)=0; 
          X(2,i)=0; 
     end 
      T.xd(i)=sumx./m; 
      X(1,i)= T.xd(i); %x的坐标平均值 
      T.yd(i)=sumy./m; 
      X(2,i)=T.yd(i);  %y的坐标平均值 
      error(1,i)=sqrt(abs(UN(1,i)-X(1,i))^2+abs(UN(2,i)-X(2,i))^2); 
      sume=sume+error(1,i); 
  end     
   Accuracy=sume/(UNAmount*R); 
