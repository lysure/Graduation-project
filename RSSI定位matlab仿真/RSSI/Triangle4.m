%三边测量的定位算法
%dA,dB,dC为A,B,C到未知节点(假定坐标[x,y]未知)的模拟测量距离
function [P] = Triangle4(t,D,da,db,dc)
    %A,B,C为三个选定的信标节点,节点坐标已知
%     %定义未知坐标x,y为符号变量
M=[0 10 0 10];
N=[0 0 10 10];
    if (t==1)
        h=2;
        c=3;
        d=4;
    end
    if (t==2)
        h=3;
        c=4;
        d=1;
    end
    if (t==3)
        h=4;
        c=1;
        d=2;
    end
    if (t==4)
        h=1;
        c=2;
        d=3;
    end
%       dj=10.^((Pt-Pl_d0-a)./(10*n));
%       dm=10.^((Pt-Pl_d0-b)./(10*n));
%       dn=10.^((Pt-Pl_d0-c)./(10*n));
%     dj=sqrt((m-M(j))^2+(n-N(j))^2);
%     dm=sqrt((m-M(m))^2+(n-N(m))^2);
%     dn=sqrt((m-M(n))^2+(n-N(n))^2);
    syms x y;
    %距离方程,以信标节点为圆心,信标节点到未知节点的测量距离为半径作三个圆
    f1 = (M(h)-x)^2+(N(h)-y)^2-da^2;
    f2 = (M(c)-x)^2+(N(c)-y)^2-db^2;
    f3 = (M(d)-x)^2+(N(d)-y)^2-dc^2;
    
    %任两个方程联立,求任两圆交点
    s1 = solve(f1,f2); %求A,B两圆的交点
    s2 = solve(f2,f3); %求B,C两圆的交点
    s3 = solve(f1,f3); %求A,C两圆的交点
    
    %将结果(符号变量)转换为双精度数值
    x1 = double(s1.x);
    y1 = double(s1.y);
    x2 = double(s2.x);
    y2 = double(s2.y);
    x3 = double(s3.x);
    y3 = double(s3.y);
    
    %选择内侧的三个交点
    %两圆相交于两点,距第三个圆心近的为选定交点Pab,Pbc,Pac
    d1(1) = sqrt(((D(1)-x1(1))^2+(D(2)-y1(1))^2));
    d1(2) = sqrt(((D(1)-x1(2))^2+(D(2)-y1(2))^2));
    if d1(1) <= d1(2)
        Pad(1) = x1(1);
        Pad(2) = y1(1);
    else
        Pad(1) = x1(2);
        Pad(2) = y1(2);
    end
    d2(1) = sqrt(((D(1)-x2(1))^2+(D(2)-y2(1))^2));
    d2(2) = sqrt(((D(1)-x2(2))^2+(D(2)-y2(2))^2));
    if d2(1) <= d2(2)
        Pbd(1) = x2(1);
        Pbd(2) = y2(1);
    else
        Pbd(1) = x2(2);
        Pbd(2) = y2(2);
    end
    d3(1) = sqrt(((D(1)-x3(1))^2+(D(2)-y3(1))^2));
    d3(2) = sqrt(((D(1)-x3(2))^2+(D(2)-y3(2))^2));
    if d3(1) <= d3(2)
        Pcd(1) = x3(1);
        Pcd(2) = y3(1);
    else
        Pcd(1) = x3(2);
        Pcd(2) = y3(2);
    end
    
    %Pab
    %Pbc
    %Pac
     
    %求三个圆内侧三个交点Pab,Pbc,Pac的质心,即为未知节点P,完成定位
    P(1) = (Pad(1)+Pbd(1)+Pcd(1))/3;
    P(2) = (Pad(2)+Pbd(2)+Pcd(2))/3;
%     plot(P(1),P(2),'ro');
end