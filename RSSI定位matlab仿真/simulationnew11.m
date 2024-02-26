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
 e(3,1)=1;    %定义误差数组
 a(4,4)=1;    %定义差异修正系数数组
 a1(4,1)=1;   %定义差异修正系数数组
 p(3,4)=1;    %定义距离差分系数数组
 p1(4,4)=1;
 p2(4,4)=1;
 p3(4,4)=1;
 er(4,4)=1;
 d1(4,4)=1;
 d2(4,4)=1;
 d3(4,4)=1;
 matrix(4,4,20)=1;  %定义三维数据组 matrix(a,b,:)  Ref_a接收到Ref_b的信号窗口中的随机变量
 matrix1(3,4,20)=1;  %定义三维数据组 matrix(a,b,:)  tag_a接收到Ref_b的信号窗口中的随机变量
 dist(4,4)=1; %定义距离数组
 dist1(3,4)=1; %定义新距离数组
 dist2(4,4)=1; %定义距离数组
 mean_rssi(4,4)=1;   %每一个窗口的平均值
 mean_rssi1(3,4)=1;   %每一个新窗口的平均值
 r=1;          %迭代次数为3
 Pl_d0=50;    %PLd0为近地参考距离的路径损耗
 Pt=4;     %传输功率
 n=3;      %路劲损耗因子
 while(1)
    if(r>10)
        break;
    end
    for i=1:4
        for j=1:4
            if(j~=i)
                dist(i,j)=sqrt((Ref_x(i)-Ref_x(j))^2+(Ref_y(i)-Ref_y(j))^2);
                matrix(i,j,:)=Pt-Pl_d0-10*n*log10(dist(i,j))-random('norm',0,9,1,20);
                mean_rssi(i,j)=mean(matrix(i,j,:));
            else
                dist(i,j)=0;
                matrix(i,j,:)=0;
                mean_rssi(i,j)=0;
            end
        end
    end
    for i=1:4
        for j=1:4
            if(j~=i)
                dist2(i,j)=10.^((Pt-Pl_d0-mean_rssi(i,j))./(10*n));
                a(i,j)= (dist2(i,j)-dist(i,j))/dist2(i,j);
                a1(i,1)=sum(a(i,:));
                
            else
                dist2(i,j)=0;
                a(i,j)=0;
            end
        end
    end
       
   
%     PD = Triangle(A,B,C,D,dist(1,4),dist(2,4),dist(3,4));
%     PA = Triangle(B,C,D,A,dist(2,1),dist(2,3),dist(2,4));
%     PB = Triangle(A,C,D,B,dist(1,2),dist(3,2),dist(4,2));
%     PC = Triangle(A,B,D,C,dist(1,3),dist(2,3),dist(4,3));
%     deltd=[-PD(1)+10 -PD(2)+10];
%     delta=[-PA(1)+0 -PA(2)+0];
%     deltb=[-PB(1)+10 -PB(2)+0];
%     deltc=[-PC(1)+0 -PC(2)+10];
    for i=1:3
        for j=1:4
            for m=1:4
                if(m~=j)
                    dist1(i,j)=sqrt((tag_x(i)-Ref_x(j))^2+(tag_y(i)-Ref_y(j))^2);
                    matrix1(i,j,:)=Pt-Pl_d0-10*n*log10(dist1(i,j))-random('norm',0,9,1,20);
                    mean_rssi1(i,j)=mean(matrix1(i,j,:));
                    dist1(i,j)=10.^((Pt-Pl_d0-mean_rssi1(i,j))./(10*n));
                    p1(m,j)=r*exp(1-dist1(1,j)/(dist2(m,j)*(1-a(m,1))));
                    p2(m,j)=r*exp(1-dist1(2,j)/(dist2(m,j)*(1-a(m,1))));
                    p3(m,j)=r*exp(1-dist1(3,j)/(dist2(m,j)*(1-a(m,1))));
                    er(m,j)=dist2(m,j)-dist(m,j);
                    d1(m,j)=dist1(1,j)-p1(m,j)*er(m,j);
                    d2(m,j)=dist1(2,j)-p1(m,j)*er(m,j);
                    d3(m,j)=dist1(3,j)-p1(m,j)*er(m,j);
%                     Pa1=Triangle2(B,C,D,Sxy(2,1),Sxy(3,1),d1(1,2),d1(1,3),d1(1,4));
                else
                    er(m,j)=0;
                    p1(m,j)=0;
                    p2(m,j)=0;
                    p3(m,j)=0;
                    d1(m,j)=0;
                    d2(m,j)=0;
                    d3(m,j)=0;
                end
            end
        end
    end
    Pa1=Triangle3(B,C,D,Sxy(2,1),Sxy(3,1),d1(1,2),d1(1,3),d1(1,4));
    Pa2=Triangle3(B,C,D,Sxy(2,2),Sxy(3,2),d2(1,2),d2(1,3),d2(1,4));
    Pa3=Triangle3(B,C,D,Sxy(2,3),Sxy(3,3),d3(1,2),d3(1,3),d3(1,4));
    Pb1=Triangle3(A,C,D,Sxy(2,1),Sxy(3,1),d1(2,1),d1(2,3),d1(2,4));
    Pb2=Triangle3(A,C,D,Sxy(2,2),Sxy(3,2),d2(2,1),d2(2,3),d2(2,4));
    Pb3=Triangle3(A,C,D,Sxy(2,3),Sxy(3,3),d3(2,1),d3(2,3),d3(2,4));
    Pc1=Triangle3(A,B,D,Sxy(2,1),Sxy(3,1),d1(3,1),d1(3,2),d1(3,4));
    Pc2=Triangle3(A,B,D,Sxy(2,2),Sxy(3,2),d2(3,1),d2(3,2),d2(3,4));
    Pc3=Triangle3(A,B,D,Sxy(2,3),Sxy(3,3),d3(3,1),d3(3,2),d3(3,4));
    Pd1=Triangle3(A,B,C,Sxy(2,1),Sxy(3,1),d1(4,1),d1(4,2),d1(4,3));
    Pd2=Triangle3(A,B,C,Sxy(2,2),Sxy(3,2),d2(4,1),d2(4,2),d2(4,3));
    Pd3=Triangle3(A,B,C,Sxy(2,3),Sxy(3,3),d3(4,1),d3(4,2),d3(4,3));
    
%     PA2=Triangle2(B,C,D,Sxy(2,1),Sxy(3,1));
%     for i=1:3
%         PA=Triangle2(B,C,D,Sxy(2,i),Sxy(3,i));
%         PA=PA+delta;
%         PA1(i,1)=PA(1);
%         PA1(i,2)=PA(2);
%         PB=Triangle2(A,C,D,Sxy(2,i),Sxy(3,i));
%         PB=PB+deltb;
%         PB1(i,1)=PB(1);
%         PB1(i,2)=PB(2);
%         PC=Triangle2(A,B,D,Sxy(2,i),Sxy(3,i));
%         PC=PC+deltc;
%         PC1(i,1)=PC(1);
%         PC1(i,2)=PC(2);
%         PD=Triangle2(A,B,C,Sxy(2,i),Sxy(3,i));
%         PD=PD+deltd;
%         PD1(i,1)=PD(1);
%         PD1(i,2)=PD(2);
      
       UN1(1,1)=(Pa1(1)+Pb1(1)+Pc1(1)+Pd1(1))/4;
        UN1(1,2)=(Pa1(2)+Pb1(2)+Pc1(2)+Pd1(2))/4;
%         UN1(1,1)=(Pa1(1)/dist1(1,1)+Pb1(1)/dist1(1,2)+Pc1(1)/dist1(1,3)+Pd1(1)/dist1(1,4))/(1/dist1(1,1)+1/dist1(1,2)+1/dist1(1,3)+1/dist1(1,4));
%         UN1(1,2)=(Pa1(2)/dist1(1,1)+Pb1(2)/dist1(1,2)+Pc1(2)/dist1(1,3)+Pd1(2)/dist1(1,4))/(1/dist1(1,1)+1/dist1(1,2)+1/dist1(1,3)+1/dist1(1,4)); 
%         UN1(2,1)=(Pa2(1)/dist1(2,1)+Pb2(1)/dist1(2,2)+Pc2(1)/dist1(2,3)+Pd2(1)/dist1(2,4))/(1/dist1(2,1)+1/dist1(2,2)+1/dist1(2,3)+1/dist1(2,4));
%         UN1(2,2)=(Pa2(2)/dist1(2,1)+Pb2(2)/dist1(2,2)+Pc2(2)/dist1(2,3)+Pd2(2)/dist1(2,4))/(1/dist1(2,1)+1/dist1(2,2)+1/dist1(2,3)+1/dist1(2,4));
%         UN1(3,1)=(Pa3(1)/dist1(3,1)+Pb3(1)/dist1(3,2)+Pc3(1)/dist1(3,3)+Pd3(1)/dist1(3,4))/(1/dist1(3,1)+1/dist1(3,2)+1/dist1(3,3)+1/dist1(3,4));
%         UN1(3,2)=(Pa3(2)/dist1(3,1)+Pb3(2)/dist1(3,2)+Pc3(2)/dist1(3,3)+Pd3(2)/dist1(3,4))/(1/dist1(3,1)+1/dist1(3,2)+1/dist1(3,3)+1/dist1(3,4));
%         e(i)=sqrt((UN1(i,1)-tag_x(i))^2+(UN1(i,2)-tag_y(i))^2);
%     end
    r=r+1;
 end
 plot(Ref_x,Ref_y,'r*',UN1(1:3,1),UN1(1:3,2),'go',tag_x,tag_y,'b+'),title('测试结果，红色为参考点，蓝色为目标点，绿色为测试结果'),ylabel('y'),xlabel('x');
 grid on  
 set(gca,'Xtick',[-3:1:13],'Ytick',[-3:1:13]);
 
