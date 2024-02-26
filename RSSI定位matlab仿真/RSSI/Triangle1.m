%���߲����Ķ�λ�㷨
%dA,dB,dCΪA,B,C��δ֪�ڵ�(�ٶ�����[x,y]δ֪)��ģ���������
function [P] = Triangle(A,B,C)
BorderLength=12;%����������ı߳�
BeaconAmount=4;
UNAmount=20;
NodeAmount=UNAmount+BeaconAmount;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~�������������ڲ������ȷֲ����������~~~~~~~~~~~~~~~~~~~~ 
 C=(BorderLength-2).*rand(2,UNAmount); %���߼��ŵ��ƶ��ڵ����� 
 Sxy=[[1:UNAmount];C]; 
 UN=[Sxy(2,1:UNAmount);Sxy(3,1:UNAmount)];
 plot(Sxy(2,1:UNAmount),Sxy(3,1:UNAmount),'r*');
 hold on
    A = [0,0];
    B = [10,0];
    C = [0,10];
%     D = [10,10];
%     A=[0 10 0 10;0 0 10 10];
         %XnΪ���ֵ�ĸ�˹�ֲ��������,��׼��Ϊcigema
     cigema = 4; %��λ��dB
     N=3;
     Xn = normrnd(0,cigema,N,1); 
     % R��normrnd(MU,SIGMA,m,n)�� ����m��n��ʽ����̬�ֲ������������
    X = mean(Xn); %��ֵ

    for i=1:1:UNAmount
    distai=sqrt((Sxy(2,i)-A(1))^2+(Sxy(3,i)-A(2))^2);
    distbi=sqrt((Sxy(2,i)-B(1))^2+(Sxy(3,i)-B(2))^2);
    distci=sqrt((Sxy(2,i)-C(1))^2+(Sxy(3,i)-C(2))^2);
    RSSIai= Distance11(distai);
    RSSIbi= Distance11(distbi);
    RSSIci = Distance11(distci);
    RSSIai= RSSIai+X;
    RSSIbi= RSSIbi+X;
    RSSIci= RSSIci+X;
    dia=rssi2dist(RSSIai);
    dib=rssi2dist(RSSIbi);
    dic=rssi2dist(RSSIci);
        syms x y;
    %���뷽��,���ű�ڵ�ΪԲ��,�ű�ڵ㵽δ֪�ڵ�Ĳ�������Ϊ�뾶������Բ
    f4 = (A(1)-x)^2+(A(2)-y)^2-dia^2;
    f5 = (B(1)-x)^2+(B(2)-y)^2-dib^2;
    f6 = (C(1)-x)^2+(C(2)-y)^2-dic^2;
    %��������������,������Բ����
    s4 = solve(f4,f5); %��A,B��Բ�Ľ���
    s5 = solve(f5,f6); %��B,C��Բ�Ľ���
    s6 = solve(f4,f6); %��A,C��Բ�Ľ��� 
    %�����(���ű���)ת��Ϊ˫������ֵ
    x11 = double(s4.x);
    y11 = double(s4.y);
    x21 = double(s5.x);
    y21 = double(s5.y);
    x31 = double(s6.x);
    y31 = double(s6.y);
    %ѡ���ڲ����������
    %��Բ�ཻ������,�������Բ�Ľ���Ϊѡ������Pab,Pbc,Pac
    dai(1) = sqrt((Sxy(2,i)-x11(1))^2+((Sxy(3,i)-y11(1))^2));
    dai(2) = sqrt((Sxy(2,i)-x11(2))^2+((Sxy(3,i)-y11(2))^2));
    if dai(1) <= dai(2)
        Pai(1) = x11(1);
        Pai(2) = y11(1);
    else
        Pai(1) = x11(2);
        Pai(2) = y1(2);
    end
    dbi(1) = sqrt((Sxy(2,i)-x21(1))^2+((Sxy(3,i)-y21(1))^2));
    dbi(2) = sqrt((Sxy(2,i)-x21(2))^2+((Sxy(3,i)-y21(2))^2));
    if dbi(1) <= dbi(2)
        Pbi(1) = x21(1);
        Pbi(2) = y21(1);
    else
        Pbi(1) = x21(2);
        Pbi(2) = y21(2);
    end
    dci(1) = sqrt((Sxy(2,i)-x31(1))^2+((Sxy(3,i)-y31(1))^2));
    dci(2) = sqrt((Sxy(2,i)-x31(2))^2+((Sxy(3,i)-y31(2))^2));
    if dci(1) <= dci(2)
        Pci(1) = x31(1);
        Pci(2) = y31(1);
    else
        Pci(1) = x31(2);
        Pci(2) = y31(2);
    end
    %Pab
    %Pbc
    %Pac 
    %������Բ�ڲ���������Pab,Pbc,Pac������,��Ϊδ֪�ڵ�P,��ɶ�λ
    Pi(1) = (Pai(1)+Pbi(1)+Pci(1))/3;
    Pi(2) = (Pai(2)+Pbi(2)+Pci(2))/3;
%     error=0;
%    error=sqrt((P(1)-10)^2+(P(2)-10)^2);
%    Pi(1) =Pi(1)+deltax;
%    Pi(2) =Pi(2)+deltay;
    plot(Pi(1),Pi(2),'bo');
%     hold on
%     m=[Sxy(2,i) Pi(1)];
%     n=[Sxy(3,i) Pi(2)];
%     plot(m,n,'b-');

    end
end