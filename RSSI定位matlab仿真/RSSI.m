%reader1 (0 0) 0  reader2 (10 0)  reader3(0 10)  reader4(10 10)
%tag   被追踪的目标tag（tag_x,tag_y） 为区域内随机分配的20个点
clear all
reader_x=[0 10 0 10];% 信号接收端横坐标 
reader_y=[0 0 10 10];%纵坐标
BorderLength=10;
 C=BorderLength.*rand(2,20); %随机分布的移动节点坐标 
 Sxy=[1:20;C]; 
 UN=[Sxy(2,1:20);Sxy(3,1:20)];
 plot(Sxy(2,1:20),Sxy(3,1:20),'ro');
 hold on
matrix(3,4,20)=1;  %定义三维数据组 matrix(a,b,:)  reader_a接收到reader_b的信号窗口中的随机变量，即3行4列的20个矩阵
% matrix(i,j,:)=a(i)-10*n(i)*log10(dist(i,j))-random('norm',0,9,1,20);
% random('norm',0,9,1,20)中的'norm'指定是正态分布，后面的0,9,1,20则是正态分布需要的参数，分别是均值、方差、行、列 
dist(3,4)=1;        %定义距离数组
mean_rssi(3,4)=1;   %每一个窗口的平均值
st_de=3; %定义方差 
r=1;          %迭代次数为50
while(1)
    if(r>50)
        break;
    end
    st_de1=0;
    for i=1:3
        for j=1:4
            dist(i,j)=sqrt((reader_x(i)-tag_x(j))^2+(reader_y(i)-tag_y(j))^2);
            matrix(i,j,:)=a(i)-10*n(i)*log10(dist(i,j))-random('norm',0,9,1,20);
            mean_rssi(i,j)=mean(matrix(i,j,:));
            st_de1=st_de1+(std(matrix(i,j,:)))^2;
        end
    end   %maxrix(i,j,:)表示第i个reader 与第j个tag的p阵  dist(i,j)的距离
    st_de1=sqrt(st_de1/Nr/Ni);%方差
    for i=1:3
        for j=1:3
            if(j~=i)
            n(i,j)=(mean_rssi(i,i)-mean_rssi(i,j))/(10*log10(dist(i,j)/dist(i,i)));
            a(i,j)=mean_rssi(i,j)+10*n(i,j)*log10(dist(i,j));
            else
                n(i,j)=0;
                a(i,j)=0;
            end
        end
        mean_n(i)=mean(n(i,:))*3/2;           %得到reader的n和a值
        mean_a(i)=mean(a(i,:))*3/2;
    end
    %  -40—40  0——70
    k=1;
    for i=-35:35
        for j=5:65
         distance(i+36,j-4,1)=sqrt((reader_x(1)-i)^2+(reader_y(1)-j)^2);%距离
        P(i+36,j-4)=(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(1,4)-a(1)+10*n(1)*(log10(distance(i+36,j-4,1))))^2)/(2*st_de^2));
        distance(i+36,j-4,2)=sqrt((reader_x(2)-i)^2+(reader_y(2)-j)^2);
         P(i+36,j-4)=P(i+36,j-4)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(2,4)-a(2)+10*n(2)*(log10(distance(i+36,j-4,2))))^2)/(2*st_de^2));        
        distance(i+36,j-4,3)=sqrt((reader_x(3)-i)^2+(reader_y(3)-j)^2);
        P(i+36,j-4)=P(i+36,j-4)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(3,4)-a(3)+10*n(3)*(log10(distance(i+36,j-4,3))))^2)/(2*st_de^2));   
        P(i+36,j-4)=abs(P(i+36,j-4));
        PL(k)=abs(P(i+36,j-4));   
        k=k+1;
        end
    end
        for i=-35:35
            for j=5:65
              P(i+36,j-4)=(P(i+36,j-4))/max(PL) ;
              if(P(i+36,j-4)==1)
               x1=i;y1=j;
              end
            end
        end
    m(r)=x1;
    z(r)=y1;
    a=mean_a;
    n=mean_n;
    st_de=round(st_de1);
    r=r+1;
end
get_x=mean(m);
get_y=mean(z);
plot(reader_x,reader_y,'r*',get_x,get_y,'g*',tag_x,tag_y,'b*'),title('测试结果，红色为reader点，蓝色为tag点，绿色为测试结果，改变tag_xy(4)测试'),ylabel('y'),xlabel('x');grid on  
set(gca,'Xtick',[-40:5:40],'Ytick',[10:5:70]);


