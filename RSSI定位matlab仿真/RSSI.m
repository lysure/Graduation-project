%reader1 (0 0) 0  reader2 (10 0)  reader3(0 10)  reader4(10 10)
%tag   ��׷�ٵ�Ŀ��tag��tag_x,tag_y�� Ϊ��������������20����
clear all
reader_x=[0 10 0 10];% �źŽ��ն˺����� 
reader_y=[0 0 10 10];%������
BorderLength=10;
 C=BorderLength.*rand(2,20); %����ֲ����ƶ��ڵ����� 
 Sxy=[1:20;C]; 
 UN=[Sxy(2,1:20);Sxy(3,1:20)];
 plot(Sxy(2,1:20),Sxy(3,1:20),'ro');
 hold on
matrix(3,4,20)=1;  %������ά������ matrix(a,b,:)  reader_a���յ�reader_b���źŴ����е������������3��4�е�20������
% matrix(i,j,:)=a(i)-10*n(i)*log10(dist(i,j))-random('norm',0,9,1,20);
% random('norm',0,9,1,20)�е�'norm'ָ������̬�ֲ��������0,9,1,20������̬�ֲ���Ҫ�Ĳ������ֱ��Ǿ�ֵ������С��� 
dist(3,4)=1;        %�����������
mean_rssi(3,4)=1;   %ÿһ�����ڵ�ƽ��ֵ
st_de=3; %���巽�� 
r=1;          %��������Ϊ50
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
    end   %maxrix(i,j,:)��ʾ��i��reader ���j��tag��p��  dist(i,j)�ľ���
    st_de1=sqrt(st_de1/Nr/Ni);%����
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
        mean_n(i)=mean(n(i,:))*3/2;           %�õ�reader��n��aֵ
        mean_a(i)=mean(a(i,:))*3/2;
    end
    %  -40��40  0����70
    k=1;
    for i=-35:35
        for j=5:65
         distance(i+36,j-4,1)=sqrt((reader_x(1)-i)^2+(reader_y(1)-j)^2);%����
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
plot(reader_x,reader_y,'r*',get_x,get_y,'g*',tag_x,tag_y,'b*'),title('���Խ������ɫΪreader�㣬��ɫΪtag�㣬��ɫΪ���Խ�����ı�tag_xy(4)����'),ylabel('y'),xlabel('x');grid on  
set(gca,'Xtick',[-40:5:40],'Ytick',[10:5:70]);


