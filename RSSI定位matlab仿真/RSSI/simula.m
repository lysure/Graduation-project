%reader1 (-70 70) tag_1 (5 65)  reader2 (-40 0) tag2(-35 5)  reader3(40 0) 
%tag3(35 5)  reader4（40 70）   被追踪的目标tag5（tag_x,tag_y） 范围-35
clc
clear all
reader_x=[0 10 0 10];% 信号接收端横坐标 
reader_y=[0 0 10 10];%纵坐标
tag_x=[0 0 0];%参考点坐标           %%%%%%%%%%%%%%%%%%修改tracked tags 第四个中tag_x tag_y值
tag_y=[0 0 0];
for i=1:3
    tag_x(i)=rand*10;
    tag_y(i)=rand*10;
end
delt(4,2)=1;
n=4;
P(4,2)=1;
PL1(4,2)=1;
PL2(4,2)=1;
PL3(4,2)=1;
matrix(4,3,20)=1;  %定义三维数据组 matrix(a,b,:)  reader_a接收到reader_b的信号窗口中的随机变量
matrix1(4,3,20)=1;
dist(4,3)=1;        %定义距离数组
dist1(4,3)=1;        %定义距离数组
readerx(3,3)=1;
readery(3,3)=1;
refx(4,1)=1;
refy(4,1)=1;
mean_rssi(4,3)=1;   %每一个窗口的平均值
mean_rssi1(4,3)=1;   %每一个窗口的平均值
 Pl_d0=50;    %PLd0为近地参考距离的路径损耗
 Pt=4;     %传输功率
r=1;          %迭代次数为3
e(1,3)=1;
while(1)
    if(r>3)
        break;
    end
    for i=1:4
        for j=1:3
            dist1(i,j)=sqrt((tag_x(j)-reader_x(i))^2+(tag_y(j)-reader_y(i))^2);
            matrix1(i,j,:)=Pt-Pl_d0-10*n*log10(dist1(i,j))-random('norm',0,3,1,20);
            mean_rssi1(i,j)=mean(matrix1(i,j,:));
            dist1(i,j)=10.^((Pt-Pl_d0-mean_rssi1(i,j))./(10*n));
        end
    end
    for i=1:4
        if ( i==1)
                u=2;
                x=3;
                y=4;
         end
            if ( i==2)
                u=3;
                x=4;
                y=1;
            end
            if (i==3)
                u=4;
                x=1;
                y=2;
            end
            if (i==4)
                u=1;
                x=2;
                y=3;
            end
            readerx(i,:)=[reader_x(u) reader_x(x) reader_x(y)];
            readery(i,:)=[reader_y(u) reader_y(x) reader_y(y)];
            refx(i,1)=reader_x(i);
            refy(i,1)=reader_y(i);
            A=[readerx(i,1),readery(i,1)];
            B=[readerx(i,2),readery(i,2)];
            C=[readerx(i,3),readery(i,3)];
            D=[refx(i,1),refy(i,1)];
         for j=1:3
             dist(i,j)=sqrt((refx(i,1)-readerx(i,j))^2+(refy(i,1)-readery(i,j))^2);
             matrix(i,j,:)=Pt-Pl_d0-10*n*log10(dist(i,j))-random('norm',0,3,1,20);
             mean_rssi(i,j)=mean(matrix(i,j,:));
            dist(i,j)=10.^((Pt-Pl_d0-mean_rssi(i,j))./(10*n));
         end
         Pi=Triangle(A,B,C,D,dist(i,1),dist(i,2),dist(i,3));
         P(i,1)=Pi(1);
         P(i,2)=Pi(2);
         delt(i,1)=reader_x(i)-P(i,1);
         delt(i,2)=reader_y(i)-P(i,2);
         P1=Triangle2(A,B,C,tag_x(1),tag_y(1));
         PL1(i,1)=P1(1)+delt(i,1);
         PL1(i,2)=P1(2)+delt(i,2);
         P2=Triangle2(A,B,C,tag_x(2),tag_y(2));
         PL2(i,1)=P2(1)+delt(i,1);
         PL2(i,2)=P2(2)+delt(i,2);
         P3=Triangle2(A,B,C,tag_x(3),tag_y(3));
         PL3(i,1)=P3(1)+delt(i,1);
         PL3(i,2)=P3(2)+delt(i,2);  
    end        %maxrix(i,j,:)表示第i个reader 与第j个tag的p阵  dist(i,j)的距离 
      m1(r)=(PL1(1,1)/dist1(1,1)+PL1(2,1)/dist1(2,1)+PL1(3,1)/dist1(3,1)+PL1(4,1)/dist1(4,1))/(1/dist1(1,1)+1/dist1(2,1)+1/dist1(3,1)+1/dist1(4,1));
      z1(r)=(PL1(1,2)/dist1(1,1)+PL1(2,2)/dist1(2,1)+PL1(3,2)/dist1(3,1)+PL1(4,2)/dist1(4,1))/(1/dist1(1,1)+1/dist1(2,1)+1/dist1(3,1)+1/dist1(4,1));
      m2(r)=(PL2(1,1)/dist1(1,2)+PL2(2,1)/dist1(2,2)+PL2(3,1)/dist1(3,2)+PL2(4,1)/dist1(4,2))/(1/dist1(1,2)+1/dist1(2,2)+1/dist1(3,2)+1/dist1(4,2));
      z2(r)=(PL2(1,2)/dist1(1,2)+PL2(2,2)/dist1(2,2)+PL2(3,2)/dist1(3,2)+PL2(4,2)/dist1(4,2))/(1/dist1(1,2)+1/dist1(2,2)+1/dist1(3,2)+1/dist1(4,2));
      m3(r)=(PL3(1,1)/dist1(1,3)+PL3(2,1)/dist1(2,3)+PL3(3,1)/dist1(3,3)+PL3(4,1)/dist1(4,3))/(1/dist1(1,3)+1/dist1(2,3)+1/dist1(3,3)+1/dist1(4,3));
      z3(r)=(PL3(1,2)/dist1(1,3)+PL3(2,2)/dist1(2,3)+PL3(3,2)/dist1(3,3)+PL3(4,2)/dist1(4,3))/(1/dist1(1,3)+1/dist1(2,3)+1/dist1(3,3)+1/dist1(4,3));
      r=r+1;
end
get_x(1)=mean(m1);
get_y(1)=mean(z1);
get_x(2)=mean(m2);
get_y(2)=mean(z2);
get_x(3)=mean(m3);
get_y(3)=mean(z3);
plot(reader_x,reader_y,'r+',get_x,get_y,'go',tag_x,tag_y,'b*'),title('红+为参考点，蓝*为目标点，绿o为测试结果'),ylabel('y'),xlabel('x');grid on  
set(gca,'Xtick',[-1:1:11],'Ytick',[-1:1:11]);
hold on
plot([tag_x(1);get_x(1)],[tag_y(1);get_y(1)]);
plot([tag_x(2);get_x(2)],[tag_y(2);get_y(2)]);
plot([tag_x(3);get_x(3)],[tag_y(3);get_y(3)]);
for i=1:3
   e(i)=sqrt((get_x(i)-tag_x(i))^2+(get_y(i)-tag_y(i))^2);
end
hold off


