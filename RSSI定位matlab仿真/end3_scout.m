%reader1 (-70 70) tag_1 (5 65)  reader2 (-40 0) tag2(-35 5)  reader3(40 0)
%tag3(35 5)  reader4（40 70）   被追踪的目标tag5（tag_x,tag_y） 范围-35
clear all
reader_x=[0 10 10 0];% 信号接收端横坐标
reader_y=[0 0 10 10];%纵坐标
tag_x=[0 10 10 0 0 0 0];%参考点坐标           %%%%%%%%%%%%%%%%%%修改tracked tags 第四个中tag_x tag_y值
tag_y=[0 0 10 10 0 0 0];
for i=5:7
    tag_x(i)=rand*10;
    tag_y(i)=rand*10;
end
a=[0 0 0 0]; %初始化 A，N1 Nr reader个数 Ni tag个数
n=[4 4 4 4];
Nr=4;
Ni=7;
PI=3.1415926;
matrix(4,7,20)=1;  %定义三维数据组 matrix(a,b,:)  reader_a接收到reader_b的信号窗口中的随机变量
dist(4,7)=1;        %定义距离数组
mean_rssi(4,7)=1;   %每一个窗口的平均值
st_de=3; %定义方差
r=1;          %迭代次数为5
while(1)
    if(r>20)
        break;
    end
    st_de1=0;
    for i=1:4
        for j=1:7
            if (i~=j)
                dist(i,j)=sqrt((reader_x(i)-tag_x(j))^2+(reader_y(i)-tag_y(j))^2);
                matrix(i,j,:)=a(i)-10*n(i)*log10(dist(i,j))-random('norm',0,st_de,1,20);
                mean_rssi(i,j)=mean(matrix(i,j,:));
                st_de1=st_de1+(std(matrix(i,j,:)))^2;
            end
        end
    end   %maxrix(i,j,:)表示第i个reader 与第j个tag的p阵  dist(i,j)的距离
       st_de1=sqrt(st_de1/(Nr*Ni-Nr));%方差 
        for i=1:4
                m_n1=(mean_rssi(i,mod(i+1,5)+floor((i+1)/5))-mean_rssi(i,mod(i+2,5)+floor((i+2)/5)))/(10*log10(dist(i,mod(i+2,5)+floor((i+2)/5))/dist(i,mod(i+1,5)+floor((i+1)/5))));
                m_a1=mean_rssi(i,mod(i+1,5)+floor((i+1)/5))+10*m_n1*log10(dist(i,mod(i+1,5)+floor((i+1)/5)));
                m_n2=(mean_rssi(i,mod(i+2,5)+floor((i+2)/5))-mean_rssi(i,mod(i+3,5)+floor((i+3)/5)))/(10*log10(dist(i,mod(i+3,5)+floor((i+3)/5))/dist(i,mod(i+2,5)+floor((i+2)/5))));
                m_a2=mean_rssi(i,mod(i+2,5)+floor((i+2)/5))+10*m_n2*log10(dist(i,mod(i+2,5)+floor((i+2)/5)));
                mean_n(i)=(m_n1+m_n2)/2;  
                mean_a(i)=(m_a1+m_a2)/2;
        end
    a=mean_a;
    n=mean_n;
    st_de=round(st_de1);
    %  -40—40  0——70
    k=1;
    for i=0:10
        for j=0:10
            distance(i+1,j+1,1)=sqrt((reader_x(1)-i)^2+(reader_y(1)-j)^2);%距离
            P1(i+1,j+1)=(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(1,5)-a(1)+10*n(1)*(log10(distance(i+1,j+1,1))))^2)/(2*st_de^2));
            P2(i+1,j+1)=(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(1,6)-a(1)+10*n(1)*(log10(distance(i+1,j+1,1))))^2)/(2*st_de^2));
            P3(i+1,j+1)=(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(1,7)-a(1)+10*n(1)*(log10(distance(i+1,j+1,1))))^2)/(2*st_de^2));
            distance(i+1,j+1,2)=sqrt((reader_x(2)-i)^2+(reader_y(2)-j)^2);
            P1(i+1,j+1)=P1(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(2,5)-a(2)+10*n(2)*(log10(distance(i+1,j+1,2))))^2)/(2*st_de^2));
            P2(i+1,j+1)=P2(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(2,6)-a(2)+10*n(2)*(log10(distance(i+1,j+1,2))))^2)/(2*st_de^2));
            P3(i+1,j+1)=P3(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(2,7)-a(2)+10*n(2)*(log10(distance(i+1,j+1,2))))^2)/(2*st_de^2));
            distance(i+1,j+1,3)=sqrt((reader_x(3)-i)^2+(reader_y(3)-j)^2);
            P1(i+1,j+1)=P1(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(3,5)-a(3)+10*n(3)*(log10(distance(i+1,j+1,3))))^2)/(2*st_de^2));
            P2(i+1,j+1)=P2(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(3,6)-a(3)+10*n(3)*(log10(distance(i+1,j+1,3))))^2)/(2*st_de^2));
            P3(i+1,j+1)=P3(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(3,7)-a(3)+10*n(3)*(log10(distance(i+1,j+1,3))))^2)/(2*st_de^2));
            distance(i+1,j+1,4)=sqrt((reader_x(4)-i)^2+(reader_y(4)-j)^2);
            P1(i+1,j+1)=P1(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(4,5)-a(4)+10*n(4)*(log10(distance(i+1,j+1,4))))^2)/(2*st_de^2));
            P2(i+1,j+1)=P2(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(4,6)-a(4)+10*n(4)*(log10(distance(i+1,j+1,4))))^2)/(2*st_de^2));
            P3(i+1,j+1)=P3(i+1,j+1)*(1/sqrt(2*PI)/st_de)*exp((-(mean_rssi(4,7)-a(4)+10*n(4)*(log10(distance(i+1,j+1,4))))^2)/(2*st_de^2));
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
    r=r+1;
end
get_x(1)=mean(m1);
get_y(1)=mean(z1);
get_x(2)=mean(m2);
get_y(2)=mean(z2);
get_x(3)=mean(m3);
get_y(3)=mean(z3);
plot(reader_x,reader_y,'r*',get_x,get_y,'gO',tag_x,tag_y,'b*'),title('测试结果，红色为reader点，蓝色为tag点，绿色为测试结果，改变tag_xy(4)测试'),ylabel('y'),xlabel('x');grid on
set(gca,'Xtick',[0:1:10],'Ytick',[0:1:10]);

hold on
plot([tag_x(5);get_x(1)],[tag_y(5);get_y(1)]);
plot([tag_x(6);get_x(2)],[tag_y(6);get_y(2)]);
plot([tag_x(7);get_x(3)],[tag_y(7);get_y(3)]);
hold off


