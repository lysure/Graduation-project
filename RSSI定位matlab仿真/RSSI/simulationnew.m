%���߲����Ĳ��������λ�㷨
%dA,dB,dCΪA,B,C��δ֪�ڵ�(�ٶ�����[x,y]δ֪)��ģ���������
    %A,B,CΪ����ѡ�����ű�ڵ�,�ڵ�������֪
BorderLength=12;%����������ı߳�
BeaconAmount=4;
UNAmount=20;
NodeAmount=UNAmount+BeaconAmount;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~�������������ڲ������ȷֲ����������~~~~~~~~~~~~~~~~~~~~ 
 C=(BorderLength-2).*rand(2,3); %���߼��ŵ��ƶ��ڵ����� 
 Sxy=[1:3;C]; 
 UN=[Sxy(2,1:3);Sxy(3,1:3)];
 UN1(3,2)=1;
 Ref_x=[0 10 0 10];
 Ref_y=[0 0 10 10];
 tag_x=[Sxy(2,1) Sxy(2,2) Sxy(2,3)];
 tag_y=[Sxy(3,1) Sxy(3,2) Sxy(3,3)];
     A = [0,0];
    B = [10,0];
    C = [0,10];
    D = [10,10];
 PA1(3,2)=1;
 PB1(3,2)=1;
 PC1(3,2)=1;
 PD1(3,2)=1;
 matrix(4,4,20)=1;  %������ά������ matrix(a,b,:)  Ref_a���յ�Ref_b���źŴ����е��������
 matrix1(3,4,20)=1;  %������ά������ matrix(a,b,:)  tag_a���յ�Ref_b���źŴ����е��������
 dist(4,4)=1; %�����������
 dist1(3,4)=1; %�����¾�������
 mean_rssi(4,4)=1;   %ÿһ�����ڵ�ƽ��ֵ
 mean_rssi1(3,4)=1;   %ÿһ���´��ڵ�ƽ��ֵ
 r=1;          %��������Ϊ5
 Pl_d0=50;    %PLd0Ϊ���زο������·�����
 Pt=4;     %���书��
 n=4;
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
                dist(i,j)=10.^((Pt-Pl_d0-mean_rssi(i,j))./(10*n));
            else
                dist(i,j)=0;
            end
        end
    end
    PD = Triangle(A,B,C,D,dist(1,4),dist(2,4),dist(3,4));
    PA = Triangle(B,C,D,A,dist(2,1),dist(2,3),dist(2,4));
    PB = Triangle(A,C,D,B,dist(1,2),dist(3,2),dist(4,2));
    PC = Triangle(A,B,D,C,dist(1,3),dist(2,3),dist(4,3));
    deltd=[PD(1)-10 PD(2)-10];
    delta=[PA(1)-0 PA(2)-0];
    deltb=[PB(1)-10 PB(2)-0];
    deltc=[PC(1)-0 PC(2)-10];
    for i=1:3
        for j=1:4
            dist1(i,j)=sqrt((tag_x(i)-Ref_x(j))^2+(tag_y(i)-Ref_y(j))^2);
            matrix1(i,j,:)=Pt-Pl_d0-10*n*log10(dist1(i,j))-random('norm',0,9,1,20);
            mean_rssi1(i,j)=mean(matrix1(i,j,:));
            dist1(i,j)=10.^((Pt-Pl_d0-mean_rssi1(i,j))./(10*n));
        end
    end
%     PA2=Triangle2(B,C,D,Sxy(2,1),Sxy(3,1));
    for i=1:3
        PA=Triangle2(B,C,D,Sxy(2,i),Sxy(3,i));
        PA=PA-delta;
        PA1(i,1)=PA(1);
        PA1(i,2)=PA(2);
        PB=Triangle2(A,C,D,Sxy(2,i),Sxy(3,i));
        PB=PB-deltb;
        PB1(i,1)=PB(1);
        PB1(i,2)=PB(2);
        PC=Triangle2(A,B,D,Sxy(2,i),Sxy(3,i));
        PC=PC-deltc;
        PC1(i,1)=PC(1);
        PC1(i,2)=PC(2);
        PD=Triangle2(A,B,C,Sxy(2,i),Sxy(3,i));
        PD=PD-deltd;
        PD1(i,1)=PD(1);
        PD1(i,2)=PD(2);
        UN1(i,1)=(PA1(i,1)/dist1(i,1)+PB1(i,1)/dist1(i,2)+PC1(i,1)/dist1(i,3)+PD1(i,1)/dist1(i,4))/(1/dist1(i,1)+1/dist1(i,2)+1/dist1(i,3)+1/dist1(i,4));
        UN1(i,2)=(PA1(i,2)/dist1(i,1)+PB1(i,2)/dist1(i,2)+PC1(i,2)/dist1(i,3)+PD1(i,2)/dist1(i,4))/(1/dist1(i,1)+1/dist1(i,2)+1/dist1(i,3)+1/dist1(i,4));    
    end
    r=r+1;
 end
 plot(Ref_x,Ref_y,'r*',UN1(1:3,1),UN1(1:3,2),'g*',tag_x,tag_y,'b*'),title('���Խ������ɫΪ�ο��㣬��ɫΪĿ��㣬��ɫΪ���Խ��'),ylabel('y'),xlabel('x');
 grid on  
 set(gca,'Xtick',[-3:1:13],'Ytick',[-3:1:13]);