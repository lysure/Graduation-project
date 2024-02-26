%三边测量的差分修正定位算法
%dA,dB,dC为A,B,C到未知节点(假定坐标[x,y]未知)的模拟测量距离
    %A,B,C为三个选定的信标节点,节点坐标已知
clc
clear all
BorderLength=12;%正方形区域的边长
BeaconAmount=4;    %参考节点数目
UNAmount=3;        %移动节点的数目
NodeAmount=UNAmount+BeaconAmount;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~在正方形区域内产生均匀分布的随机拓扑~~~~~~~~~~~~~~~~~~~~ 
 C=(BorderLength-2).*rand(2,3); %随机赋给移动节点的坐标 
 Sxy=[1:3;C]; 
 UN=[Sxy(2,1:3);Sxy(3,1:3)];
 UN1(3,2)=1;
 Ref_x=[0 10 0 10];         %已知参考节点的坐标值
 Ref_y=[0 0 10 10];
 Ref1_x=[1 9 1 9];
 Ref1_y=[1 1 9 9];
 tag_x=[Sxy(2,1) Sxy(2,2) Sxy(2,3)];
 tag_y=[Sxy(3,1) Sxy(3,2) Sxy(3,3)];
     A = [0,0];
    B = [10,0];
    C = [0,10];
    D = [10,10];
 PA1(3,2)=1;       %定义数组
 PB1(3,2)=1;
 PC1(3,2)=1;
 PD1(3,2)=1;
 PK(3,2)=1;
 Di(3,4)=1;
 e(3,1)=1;   %定义误差数组
 k(3,1)=1;
 matrix(4,4,20)=1;  %定义三维数据组 matrix(a,b,:)  Ref_a接收到Ref_b的信号窗口中的随机变量
 matrix2(4,4,20)=1;  %定义三维数据组 matrix(a,b,:)  Ref_a接收到Ref_b的信号窗口中的随机变量
 matrix1(3,4,20)=1;  %定义三维数据组 matrix(a,b,:)  tag_a接收到Ref_b的信号窗口中的随机变量
 dist(4,4)=1; %定义距离数组
 dist2(4,4)=1; %定义距离数组
 dist1(3,4)=1; %定义新距离数组
 mean_rssi(4,4)=1;   %每一个窗口的平均值
 mean_rssi2(4,4)=1;   %每一个窗口的平均值
 mean_rssi1(3,4)=1;   %每一个新窗口的平均值
 r=1;          %迭代次数为3
 Pl_d0=50;    %PLd0为近地参考距离的路径损耗
 Pt=4;     %传输功率
 N(3,4)=1;
 n=4;      %路劲损耗因子
while(1)
    if(r>3)
        break;
    end
    for i=1:4
        for j=1:4
            if(j~=i)
                dist(i,j)=sqrt((Ref_x(i)-Ref_x(j))^2+(Ref_y(i)-Ref_y(j))^2);
                matrix(i,j,:)=Pt-Pl_d0-10*n*log10(dist(i,j))-random('norm',0,9,1,20);
                mean_rssi(i,j)=mean(matrix(i,j,:));
                dist(i,j)=10.^((Pt-Pl_d0-mean_rssi(i,j))./(10*n));
            else
                dist(i,j)=0;
                matrix(i,j,:)=0;
                mean_rssi(i,j)=0;
            end
        end
    end
     for i=1:4
        for j=1:4
             dist2(i,j)=sqrt((Ref_x(i)-Ref1_x(j))^2+(Ref_y(i)-Ref1_y(j))^2);
              matrix2(i,j,:)=Pt-Pl_d0-10*n*log10(dist2(i,j))-random('norm',0,9,1,20);
              mean_rssi2(i,j)=mean(matrix2(i,j,:));
              dist2(i,j)=10.^((Pt-Pl_d0-mean_rssi2(i,j))./(10*n));
        end
     end
    PD = Triangle(A,B,C,D,dist(1,4),dist(2,4),dist(3,4));
    PA = Triangle(B,C,D,A,dist(2,1),dist(3,1),dist(4,1));
    PB = Triangle(A,C,D,B,dist(1,2),dist(3,2),dist(4,2));
    PC = Triangle(A,B,D,C,dist(1,3),dist(2,3),dist(4,3));
    deltd=[-PD(1)+10 -PD(2)+10];
    delta=[-PA(1)+0 -PA(2)+0];
    deltb=[-PB(1)+10 -PB(2)+0];
    deltc=[-PC(1)+0 -PC(2)+10];
    deltx=[-PA(1)+0 -PB(1)+10 -PC(1)+0 -PD(1)+10];
    delty=[-PA(2)+0 -PB(2)+0 -PC(2)+10 -PD(2)+10];
    for i=1:3
        for j=1:4
            dist1(i,j)=sqrt((tag_x(i)-Ref_x(j))^2+(tag_y(i)-Ref_y(j))^2);
            matrix1(i,j,:)=Pt-Pl_d0-10*n*log10(dist1(i,j))-random('norm',0,9,1,20);
            mean_rssi1(i,j)=mean(matrix1(i,j,:));
        end
             Di(i,:)=sort(dist1(i,:),2); 
            k(i,1)=find(dist1(i,:)==Di(i,4));
            W=[tag_x(i),tag_y(i)];
            if ( k(i,1)==1)
                u=2;
                x=3;
                y=4;
            end
            if ( k(i,1)==2)
                u=3;
                x=4;
                y=1;
            end
            if (k(i,1)==3)
                u=4;
                x=1;
                y=2;
            end
            if (k(i,1)==4)
                u=1;
                x=2;
                y=3;
            
            end
            N(i,u)=(mean_rssi2(u,u)-mean_rssi1(i,u))/(10*log10(dist1(i,u)/dist2(u,u)));
            N(i,x)=(mean_rssi2(x,x)-mean_rssi1(i,x))/(10*log10(dist1(i,x)/dist2(x,x)));
            N(i,y)=(mean_rssi2(y,y)-mean_rssi1(i,y))/(10*log10(dist1(i,y)/dist2(y,y)));
            matrix1(i,u,:)=Pt-Pl_d0-10*N(i,u)*log10(dist1(i,u))-random('norm',0,9,1,20);
            matrix1(i,x,:)=Pt-Pl_d0-10*N(i,x)*log10(dist1(i,x))-random('norm',0,9,1,20);
            matrix1(i,y,:)=Pt-Pl_d0-10*N(i,y)*log10(dist1(i,y))-random('norm',0,9,1,20);
            mean_rssi1(i,u)=mean(matrix1(i,u,:));
            mean_rssi1(i,x)=mean(matrix1(i,x,:));
            mean_rssi1(i,y)=mean(matrix1(i,y,:));
            dist1(i,u)=10.^((Pt-Pl_d0-mean_rssi1(i,u))./(10*N(i,u)));
            dist1(i,x)=10.^((Pt-Pl_d0-mean_rssi1(i,x))./(10*N(i,x)));
            dist1(i,y)=10.^((Pt-Pl_d0-mean_rssi1(i,y))./(10*N(i,y)));
            P1=Triangle4(k(i,1),W,dist1(i,u),dist1(i,x),dist1(i,y));
            PK(i,1)=P1(1)+deltx(k(i,1));
            PK(i,2)=P1(2)+delty(k(i,1));
            e(i)=sqrt((PK(i,1)-tag_x(i))^2+(PK(i,2)-tag_y(i))^2);
        
    end

    r=r+1;
 end
 plot(Ref_x,Ref_y,'r*',PK(1:3,1),PK(1:3,2),'go',tag_x,tag_y,'b+'),title('测试结果，*为参考点，+为目标点，o为测试结果'),ylabel('y'),xlabel('x');
 grid on  
 set(gca,'Xtick',[-3:1:13],'Ytick',[-3:1:13]);
 
