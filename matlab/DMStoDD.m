function DD = DMStoDD(DMS, type)
if (type=='lat')
    latD=str2double(DMS(1:2));
    latM=str2double(DMS(3:9));
    DD=latD+(latM/60);
elseif (type=='lon')
    longD=str2double(DMS(1:3));
    longM=str2double(DMS(4:10));
    DD=longD+(longM/60);
end