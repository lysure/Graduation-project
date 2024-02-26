%reader1 (-70 70) tag_1 (5 65)  reader2 (-40 0) tag2(-35 5)  reader3(40 0) 
%tag3(35 5)  reader4（40 70）   被追踪的目标tag5（tag_x,tag_y） 范围-35
clc
clear all
reader_x=[0 10 0 10];% 信号接收端横坐标 
reader_y=[0 0 10 10];%纵坐标
tag_x=[0 0 0 0 0 0 0 0 0 0];%参考点坐标           %%%%%%%%%%%%%%%%%%修改tracked tags 第四个中tag_x tag_y值
tag_y=[0 0 0 0 0 0 0 0 0 0];
for i=1:10
    tag_x(i)=rand*10;
    tag_y(i)=rand*10;
end
delt(4,2)=1;
n=3;
P(4,2)=1;
PL1(4,2)=1;
PL2(4,2)=1;
PL3(4,2)=1;
PL4(4,2)=1;
PL5(4,2)=1;
PL6(4,2)=1;
PL7(4,2)=1;
PL8(4,2)=1;
PL9(4,2)=1;
PL10(4,2)=1;
matrix(4,3,20)=1;  %定义三维数据组 matrix(a,b,:)  reader_a接收到reader_b的信号窗口中的随机变量
matrix1(4,10,20)=1;
dist(4,3)=1;        %定义距离数组
dist1(4,10)=1;        %定义距离数组
readerx(3,3)=1;
readery(3,3)=1;
refx(4,1)=1;
refy(4,1)=1;
mean_rssi(4,3)=1;   %每一个窗口的平均值
mean_rssi1(4,10)=1;   %每一个窗口的平均值wu
 Pl_d0=43;    %PLd0为近地参考距离的路径损耗
 Pt=4;     %传输功率
r=1;          %迭代次数为3
e(1,10)=1;
while(1)
    if(r>3)
        break;
    end
    for i=1:4
        for j=1:10
            dist1(i,j)=sqrt((tag_x(j)-reader_x(i))^2+(tag_y(j)-reader_y(i))^2);
            matrix1(i,j,:)=Pt-Pl_d0-10*n*log10(dist1(i,j))-random('norm',0,6,1,20);
            mean_rssi1(i,j)=mean(matrix1(i,j,:));
            dist1(i,j)=10.^((Pt-Pl_d0-mean_rssi1(i,j))./(10*n));
        end
    end
    for i=1:4
        if ( i==1)
                u=2;
                m=3;
                o=4;
         end
            if ( i==2)
                u=3;
                m=4;
                o=1;
            end
            if (i==3)
                u=4;
                m=1;
                o=2;
            end
            if (i==4)
                u=1;
                m=2;
                o=3;
            end
            readerx(i,:)=[reader_x(u) reader_x(m) reader_x(o)];
            readery(i,:)=[reader_y(u) reader_y(m) reader_y(o)];
            refx(i,1)=reader_x(i);
            refy(i,1)=reader_y(i);
            A=[readerx(i,1),readery(i,1)];
            B=[readerx(i,2),readery(i,2)];
            C=[readerx(i,3),readery(i,3)];
            D=[refx(i,1),refy(i,1)];
         for j=1:3
             dist(i,j)=sqrt((refx(i,1)-readerx(i,j))^2+(refy(i,1)-readery(i,j))^2);
             matrix(i,j,:)=Pt-Pl_d0-10*n*log10(dist(i,j))-random('norm',0,6,1,20);
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
          P4=Triangle2(A,B,C,tag_x(4),tag_y(4));
         PL4(i,1)=P4(1)+delt(i,1);
         PL4(i,2)=P4(2)+delt(i,2);
         P5=Triangle2(A,B,C,tag_x(5),tag_y(5));
         PL5(i,1)=P5(1)+delt(i,1);
         PL5(i,2)=P5(2)+delt(i,2);
         P6=Triangle2(A,B,C,tag_x(6),tag_y(6));
         PL6(i,1)=P6(1)+delt(i,1);
         PL6(i,2)=P6(2)+delt(i,2);  
         P7=Triangle2(A,B,C,tag_x(7),tag_y(7));
         PL7(i,1)=P7(1)+delt(i,1);
         PL7(i,2)=P7(2)+delt(i,2);
         P8=Triangle2(A,B,C,tag_x(8),tag_y(8));
         PL8(i,1)=P8(1)+delt(i,1);
         PL8(i,2)=P8(2)+delt(i,2);
         P9=Triangle2(A,B,C,tag_x(9),tag_y(9));
         PL9(i,1)=P9(1)+delt(i,1);
         PL9(i,2)=P9(2)+delt(i,2);  
         P10=Triangle2(A,B,C,tag_x(10),tag_y(10));
         PL10(i,1)=P10(1)+delt(i,1);
         PL10(i,2)=P10(2)+delt(i,2); 
    end        %maxrix(i,j,:)表示第i个reader 与第j个tag的p阵  dist(i,j)的距离 
      m1(r)=(PL1(1,1)/dist1(1,1)+PL1(2,1)/dist1(2,1)+PL1(3,1)/dist1(3,1)+PL1(4,1)/dist1(4,1))/(1/dist1(1,1)+1/dist1(2,1)+1/dist1(3,1)+1/dist1(4,1));
      z1(r)=(PL1(1,2)/dist1(1,1)+PL1(2,2)/dist1(2,1)+PL1(3,2)/dist1(3,1)+PL1(4,2)/dist1(4,1))/(1/dist1(1,1)+1/dist1(2,1)+1/dist1(3,1)+1/dist1(4,1));
      m2(r)=(PL2(1,1)/dist1(1,2)+PL2(2,1)/dist1(2,2)+PL2(3,1)/dist1(3,2)+PL2(4,1)/dist1(4,2))/(1/dist1(1,2)+1/dist1(2,2)+1/dist1(3,2)+1/dist1(4,2));
      z2(r)=(PL2(1,2)/dist1(1,2)+PL2(2,2)/dist1(2,2)+PL2(3,2)/dist1(3,2)+PL2(4,2)/dist1(4,2))/(1/dist1(1,2)+1/dist1(2,2)+1/dist1(3,2)+1/dist1(4,2));
      m3(r)=(PL3(1,1)/dist1(1,3)+PL3(2,1)/dist1(2,3)+PL3(3,1)/dist1(3,3)+PL3(4,1)/dist1(4,3))/(1/dist1(1,3)+1/dist1(2,3)+1/dist1(3,3)+1/dist1(4,3));
      z3(r)=(PL3(1,2)/dist1(1,3)+PL3(2,2)/dist1(2,3)+PL3(3,2)/dist1(3,3)+PL3(4,2)/dist1(4,3))/(1/dist1(1,3)+1/dist1(2,3)+1/dist1(3,3)+1/dist1(4,3));
      m4(r)=(PL4(1,1)/dist1(1,4)+PL4(2,1)/dist1(2,4)+PL4(3,1)/dist1(3,4)+PL4(4,1)/dist1(4,4))/(1/dist1(1,4)+1/dist1(2,4)+1/dist1(3,4)+1/dist1(4,4));
      z4(r)=(PL4(1,2)/dist1(1,4)+PL4(2,2)/dist1(2,4)+PL4(3,2)/dist1(3,4)+PL4(4,2)/dist1(4,4))/(1/dist1(1,4)+1/dist1(2,4)+1/dist1(3,4)+1/dist1(4,4));
      m5(r)=(PL5(1,1)/dist1(1,5)+PL5(2,1)/dist1(2,5)+PL5(3,1)/dist1(3,5)+PL5(4,1)/dist1(4,5))/(1/dist1(1,5)+1/dist1(2,5)+1/dist1(3,5)+1/dist1(4,5));
      z5(r)=(PL5(1,2)/dist1(1,5)+PL5(2,2)/dist1(2,5)+PL5(3,2)/dist1(3,5)+PL5(4,2)/dist1(4,5))/(1/dist1(1,5)+1/dist1(2,5)+1/dist1(3,5)+1/dist1(4,5));
      m6(r)=(PL6(1,1)/dist1(1,6)+PL6(2,1)/dist1(2,6)+PL6(3,1)/dist1(3,6)+PL6(4,1)/dist1(4,6))/(1/dist1(1,6)+1/dist1(2,6)+1/dist1(3,6)+1/dist1(4,6));
      z6(r)=(PL6(1,2)/dist1(1,6)+PL6(2,2)/dist1(2,6)+PL6(3,2)/dist1(3,6)+PL6(4,2)/dist1(4,6))/(1/dist1(1,6)+1/dist1(2,6)+1/dist1(3,6)+1/dist1(4,6));
      m7(r)=(PL7(1,1)/dist1(1,7)+PL7(2,1)/dist1(2,7)+PL7(3,1)/dist1(3,7)+PL7(4,1)/dist1(4,7))/(1/dist1(1,7)+1/dist1(2,7)+1/dist1(3,7)+1/dist1(4,7));
      z7(r)=(PL7(1,2)/dist1(1,7)+PL7(2,2)/dist1(2,7)+PL7(3,2)/dist1(3,7)+PL7(4,2)/dist1(4,7))/(1/dist1(1,7)+1/dist1(2,7)+1/dist1(3,7)+1/dist1(4,7));
      m8(r)=(PL8(1,1)/dist1(1,8)+PL8(2,1)/dist1(2,8)+PL8(3,1)/dist1(3,8)+PL8(4,1)/dist1(4,8))/(1/dist1(1,8)+1/dist1(2,8)+1/dist1(3,8)+1/dist1(4,8));
      z8(r)=(PL8(1,2)/dist1(1,8)+PL8(2,2)/dist1(2,8)+PL8(3,2)/dist1(3,8)+PL8(4,2)/dist1(4,8))/(1/dist1(1,8)+1/dist1(2,8)+1/dist1(3,8)+1/dist1(4,8));
      m9(r)=(PL9(1,1)/dist1(1,9)+PL9(2,1)/dist1(2,9)+PL9(3,1)/dist1(3,9)+PL9(4,1)/dist1(4,9))/(1/dist1(1,9)+1/dist1(2,9)+1/dist1(3,9)+1/dist1(4,9));
      z9(r)=(PL9(1,2)/dist1(1,9)+PL9(2,2)/dist1(2,9)+PL9(3,2)/dist1(3,9)+PL9(4,2)/dist1(4,9))/(1/dist1(1,9)+1/dist1(2,9)+1/dist1(3,9)+1/dist1(4,9));
      m10(r)=(PL10(1,1)/dist1(1,10)+PL10(2,1)/dist1(2,10)+PL10(3,1)/dist1(3,10)+PL10(4,1)/dist1(4,10))/(1/dist1(1,10)+1/dist1(2,10)+1/dist1(3,10)+1/dist1(4,10));
      z10(r)=(PL10(1,2)/dist1(1,10)+PL10(2,2)/dist1(2,10)+PL10(3,2)/dist1(3,10)+PL10(4,2)/dist1(4,10))/(1/dist1(1,10)+1/dist1(2,10)+1/dist1(3,10)+1/dist1(4,10));
      r=r+1;
end
get_x(1)=mean(m1);
get_y(1)=mean(z1);
get_x(2)=mean(m2);
get_y(2)=mean(z2);
get_x(3)=mean(m3);
get_y(3)=mean(z3);
get_x(4)=mean(m4);
get_y(4)=mean(z4);
get_x(5)=mean(m5);
get_y(5)=mean(z5);
get_x(6)=mean(m6);
get_y(6)=mean(z6);
get_x(7)=mean(m7);
get_y(7)=mean(z7);
get_x(8)=mean(m8);
get_y(8)=mean(z8);
get_x(9)=mean(m9);
get_y(9)=mean(z9);
get_x(10)=mean(m10);
get_y(10)=mean(z10);
plot(reader_x,reader_y,'kp',get_x,get_y,'k*',tag_x,tag_y,'bo'),title('☆为参考点，*为测试结果，o为目标点'),ylabel('y    /m'),xlabel('x    /m');grid on  
set(gca,'Xtick',[-1:1:11],'Ytick',[-1:1:11]);
hold on
plot([tag_x(1);get_x(1)],[tag_y(1);get_y(1)],'LineWidth',2);
plot([tag_x(2);get_x(2)],[tag_y(2);get_y(2)],'LineWidth',2);
plot([tag_x(3);get_x(3)],[tag_y(3);get_y(3)],'LineWidth',2);
plot([tag_x(4);get_x(4)],[tag_y(4);get_y(4)],'LineWidth',2);
plot([tag_x(5);get_x(5)],[tag_y(5);get_y(5)],'LineWidth',2);
plot([tag_x(6);get_x(6)],[tag_y(6);get_y(6)],'LineWidth',2);
plot([tag_x(7);get_x(7)],[tag_y(7);get_y(7)],'LineWidth',2);
plot([tag_x(8);get_x(8)],[tag_y(8);get_y(8)],'LineWidth',2);
plot([tag_x(9);get_x(9)],[tag_y(9);get_y(9)],'LineWidth',2);
plot([tag_x(10);get_x(10)],[tag_y(10);get_y(10)],'LineWidth',2);
for i=1:10
   e(i)=sqrt((get_x(i)-tag_x(i))^2+(get_y(i)-tag_y(i))^2);
end
hold off


