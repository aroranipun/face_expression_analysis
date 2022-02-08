function [speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
newV1=reshape(V1, size(V1,1)*size(V1,2), size(V1,3));
dV1=diff(newV1);
k=1;
speedV1=[];
for i=1:size(dV1,1)
    if isnan(dV1(i,:))
        ;
    else
        speedV1(k)=norm(dV1(i,:));
        k=k+1;
    end
end
newV2=reshape(V2, size(V2,1)*size(V2,2), size(V2,3));
dV2=diff(newV2);

k=1;
speedV2=[];
for i=1:size(dV2,1)
    if isnan(dV2(i,:))
        ;
    else
        speedV2(k)=norm(dV2(i,:));
        k=k+1;
    end
end
newV3=reshape(V3, size(V3,1)*size(V3,2), size(V3,3));
dV3=diff(newV3);

k=1;
speedV3=[];
for i=1:size(dV3,1)
    if isnan(dV3(i,:))
        ;
    else
        speedV3(k)=norm(dV3(i,:));
        k=k+1;
    end
end
end

