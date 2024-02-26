%reader1 (-70 70) tag_1 (5 65)  reader2 (-40 0) tag2(-35 5)  reader3(40 0) 
%tag3(35 5)  reader4（40 70）   被追踪的目标tag5（tag_x,tag_y） 范围-35
clear all
reader_x=[0 10 0 10];% 信号接收端横坐标 
reader_y=[0 0 10 10];%纵坐标
tag_x=[0 0 0];%参考点坐标           %%%%%%%%%%%%%%%%%%修改tracked tags 第四个中tag_x tag_y值
tag_y=[0 0 0];
for i=1:3
    tag_x(i)=rand*10;
    tag_y(i)=rand*10;
end
a=[0 0 0]; %初始化 A，N1 Nr reader个数 Ni tag个数
n=[4 4 4];  
Nr=3;
Ni=4;
PI=3.1415926;
matrix(3,3,20)=1;  %定义三维数据组 matrix(a,b,:)  reader_a接收到reader_b的信号窗口中的随机变量
matrix2(3,3,20)=1;
dist(3,3)=1;        %定义距离数组
dist2(3,3)=1;        %定义距离数组
dist1(3,4)=1;        %定义距离数组
readerx(3,3)=1;
readery(3,3)=1;
k(3,1)=1;
refx(3,1)=1;
refy(3,1)=1;
mean_rssi(3,3)=1;   %每一个窗口的平均值
mean_rssi2(3,3)=1;   %每一个窗口的平均值
st_de=3; %定义方差 
r=1;          %迭代次数为5
e(1,3)=1;
while(1)
    if(r>30)
        break;
    end
    st_de1=0;
    for i=1:3
        for j=1:4
            dist1(i,j)=sqrt((tag_x(i)-reader_x(j))^2+(tag_y(i)-reader_y(j))^2);
        end
        k(i,:)=find(dist1(i,:)==max(dist1(i,:)));
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
            readerx(i,:)=[reader_x(u) reader_x(x) reader_x(y)];
            readery(i,:)=[reader_y(u) reader_y(x) reader_y(y)];
            refx(i,1)=reader_x(k(i,1));
            refy(i,1)=reader_y(k(i,1));
%         reader_x=reader_x(reader_x~=reader_x(k(i,:)));%找出最大距离的点，并去除
    end        %maxrix(i,j,:)表示第i个reader 与第j个tag的p阵  dist(i,j)的距离 
    for i=1:3
        for j=1:3
            dist(i,j)=sqrt((refx(i,1)-readerx(i,j))^2+(refy(i,1)-readery(i,j))^2);
            dist2(i,j)=sqrt((tag_x(i)-readerx(i,j))^2+(tag_y(i)-readery(i,j))^2);
            matrix(i,j,:)=a(j)-10*n(j)*log10(dist(i,j))-random('norm',0,st_de,1,20);
            matrix2(i,j,:)=a(j)-10*n(j)*log10(dist2(i,j))-random('norm',0,st_de,1,20);
            mean_rssi(i,j)=mean(matrix(i,j,:));
            mean_rssi2(i,j)=mean(matrix2(i,j,:));
            st_de1=st_de1+(std(matrix2(i,j,:)))^2;%std(x)是算出x矩阵的标准偏差
        end
    end       
    st_de1=sqrt(st_de1/Nr/Ni);%方差
    for i=1:3
        for j=1:3            
            n(i,j)=abs((mean_rssi(i,j)-mean_rssi2(i,j))/(10*log10(dist2(i,j)/dist(i,j))));
            a(i,j)=mean_rssi2(i,j)+10*n(i,j)*log10(dist2(i,j));        
            if (n(i,j)>=7)
                n(i,j)=4;
            end
            if (a(i,j)>=7||a(i,j)<=-7)
                a(i,j)=1;
            end
        end
        mean_n(i)=mean(n(i,:))*3/2;           %得到reader的n和a值
        mean_a(i)=mean(a(i,:))*3/2;
    end
    %  -40—40  0——70        NaN指的是不代表一个数字，或者值不唯一
    k=1;
    for i=0:10
        for j=0:10
        distance(i+1,j+1,1)=sqrt((readerx(1)-i)^2+(readery(1)-j)^2);%距离
        P1(i+1,j+1)=(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(1,1)-a(1)+10*n(1)*(log10(distance(i+1,j+1,1))))^2)/(2*st_de^2));
        P2(i+1,j+1)=(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(2,1)-a(1)+10*n(1)*(log10(distance(i+1,j+1,1))))^2)/(2*st_de^2));
        P3(i+1,j+1)=(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(3,1)-a(1)+10*n(1)*(log10(distance(i+1,j+1,1))))^2)/(2*st_de^2));
        distance(i+1,j+1,2)=sqrt((readerx(2)-i)^2+(readery(2)-j)^2);
        P1(i+1,j+1)=P1(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(1,2)-a(2)+10*n(2)*(log10(distance(i+1,j+1,2))))^2)/(2*st_de^2));  
        P2(i+1,j+1)=P2(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(2,2)-a(2)+10*n(2)*(log10(distance(i+1,j+1,2))))^2)/(2*st_de^2)); 
        P3(i+1,j+1)=P3(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(3,2)-a(2)+10*n(2)*(log10(distance(i+1,j+1,2))))^2)/(2*st_de^2));   
        distance(i+1,j+1,3)=sqrt((readerx(3)-i)^2+(readery(3)-j)^2);
        P1(i+1,j+1)=P1(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(1,3)-a(3)+10*n(3)*(log10(distance(i+1,j+1,3))))^2)/(2*st_de^2));  
        P2(i+1,j+1)=P2(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(2,3)-a(3)+10*n(3)*(log10(distance(i+1,j+1,3))))^2)/(2*st_de^2));
        P3(i+1,j+1)=P3(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi2(3,3)-a(3)+10*n(3)*(log10(distance(i+1,j+1,3))))^2)/(2*st_de^2));
%         distance(i+1,j+1,4)=sqrt((reader_x(4)-i)^2+(reader_y(4)-j)^2);
%         P1(i+1,j+1)=P1(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(4,5)-a(4)+10*n(4)*(log10(distance(i+1,j+1,4))))^2)/(2*st_de^2));   
%         P2(i+1,j+1)=P2(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(4,6)-a(4)+10*n(4)*(log10(distance(i+1,j+1,4))))^2)/(2*st_de^2)); 
%         P3(i+1,j+1)=P3(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(4,7)-a(4)+10*n(4)*(log10(distance(i+1,j+1,4))))^2)/(2*st_de^2)); 
        P1(i+1,j+1)=abs(P1(i+1,j+1));
        PL1(k)=abs(P1(i+1,j+1));   
        P2(i+1,j+1)=abs(P2(i+1,j+1));
        PL2(k)=abs(P2(i+1,j+1)); 
        P3(i+1,j+1)=abs(P3(i+1,j+1));
        PL3(k)=abs(P3(i+1,j+1)); 
          
        k=k+1;
        end
    end
        for i=0:10
            for j=0:10
              P1(i+1,j+1)=(P1(i+1,j+1))/max(PL1) ;
              P2(i+1,j+1)=(P2(i+1,j+1))/max(PL2) ;
              P3(i+1,j+1)=(P3(i+1,j+1))/max(PL3) ;           
              if(P1(i+1,j+1)==1)
               m1(r)=i;z1(r)=j;
              end
             if(P2(i+1,j+1)==1)
               m2(r)=i;z2(r)=j;
             end
             if(P3(i+1,j+1)==1)
               m3(r)=i;z3(r)=j;
             end   
            end
        end
    
    a=mean_a;
    n=mean_n;
    st_de=round(st_de1);
    r=r+1;
end
get_x(1)=mean(m1);
get_y(1)=mean(z1);
get_x(2)=mean(m2);
get_y(2)=mean(z2);
get_x(3)=mean(m3);
get_y(3)=mean(z3);
plot(reader_x,reader_y,'r+',get_x,get_y,'go',tag_x,tag_y,'b*'),title('测试结果，红色为reader点，蓝色为tag点，绿色为测试结果，改变tag_xy(4)测试'),ylabel('y'),xlabel('x');grid on  
set(gca,'Xtick',[0:1:10],'Ytick',[0:1:10]);
hold on
plot([tag_x(1);get_x(1)],[tag_y(1);get_y(1)]);
plot([tag_x(2);get_x(2)],[tag_y(2);get_y(2)]);
plot([tag_x(3);get_x(3)],[tag_y(3);get_y(3)]);
e(1)=sqrt((get_x(1)-tag_x(1))^2+(get_y(1)-tag_y(1))^2);
e(2)=sqrt((get_x(2)-tag_x(2))^2+(get_y(2)-tag_y(2))^2);
e(3)=sqrt((get_x(3)-tag_x(3))^2+(get_y(3)-tag_y(3))^2);
hold off


