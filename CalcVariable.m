function [ d1,d2,theta ] = Activitat53_6( image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
imageCrom = rgb2ycbcr(image);
imageCr=imageCrom(:,:,3);
imageBW=im2bw(imageCr,0.52);

existd2=true;

SEh=strel('line',100,0);
SEv=strel('line',80,90);
imageEROSIONADAh=imerode(imageBW,SEh);
imageEROSIONADAv=imerode(imageBW,SEv);

%   figure
%   imshow(imageEROSIONADAv);
%   figure
%   imshow(imageEROSIONADAh);
 if (max(imageEROSIONADAh(:))==0) 
     existd2=false;
%      disp('negre')
 end


f=1;
while(isempty(find(imageEROSIONADAv(f,:), 1, 'first'))&& f<240)
f =f+1;
 end
 
[y]=find(imageEROSIONADAv(f,:), 1, 'first');
Pv1=[y;f;1];

f=240;
while(isempty(find(imageEROSIONADAv(f,:), 1, 'first'))&& f>1)
 f =f-1;
end
 
[y]=find(imageEROSIONADAv(f,:), 1, 'first');
Pv2=[y;f;1];

c=1;
if (existd2==true)
while(isempty(find(imageEROSIONADAh(:,c), 1, 'first')) && c<320)
c =c+1;
end

[x]=find(imageEROSIONADAh(:,c), 1, 'first');
Ph1=[c;x;1];
 
c=320;
while(isempty(find(imageEROSIONADAh(:,c), 1, 'first'))&& c>1)
c =c-1;
end
 
[x]=find(imageEROSIONADAh(:,c), 1, 'first');
Ph2=[c;x;1];
end

load Activitat41.mat
R=[Mrobcam(1,1) Mrobcam(1,2) Mrobcam(1,3) ; Mrobcam(2,1) Mrobcam(2,2) Mrobcam(2,3) ; Mrobcam(3,1) Mrobcam(3,2) Mrobcam(3,3)];
t=[Mrobcam(1,4);Mrobcam(2,4);Mrobcam(3,4)];
KK= [KK(1,1) KK(1,2) KK(1,3) ; KK(2,1) KK(2,2) KK(2,3) ; KK(3,1) KK(3,2) KK(3,3)];

if (existd2==true)
[xr,yr]=Activitat43(Ph1(1),Ph1(2),KK,R,t);
Probh1= [xr;yr;1];

[xr,yr]=Activitat43(Ph2(1),Ph2(2),KK,R,t);
Probh2= [xr;yr;1];
end

[xr,yr]=Activitat43(Pv1(1),Pv1(2),KK,R,t);
Probv1= [xr;yr;1];

[xr,yr]=Activitat43(Pv2(1),Pv2(2),KK,R,t);
Probv2= [xr;yr;1];

if (existd2==true)
lh = cross(Probh1, Probh2);
end
lv = cross(Probv1, Probv2);

d1=lv(3)/sqrt(lv(1)^2+lv(2)^2);
theta=atan2d(-lv(2),lv(1));

if (existd2==true)
d2=lh(3)/sqrt(lh(1)^2+lh(2)^2);
else
    d2=NaN;
end
end

