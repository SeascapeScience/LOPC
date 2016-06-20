function LOPC=LOPCread(fname)
% LOPC=LOPCread(fname)
%
% Reads a .dat file created from LOPC processing
% into a scruct with fields:
%   .L  -  single element particle counts (128 bins)
%   .M  -  multiple element particle data
%   .L5 -  additional data from 5th L-line in .dat file
%
% NRR 2008



fid=fopen(fname);
lin=0;
L=[];
M=[];
L5=[];
CTD=[];
Ldepth=[];
Mdepth=[];
cntL=1;
cntM=1;
cntL5=1;
cntCTD=1;
t=0;
depth=0;

testlin=0;

%while(lin~=-1)
while(testlin<10)
	lin=fgetl(fid);
    %disp(lin)
    %pause
    
	if(length(lin)>1 & lin(1:2)=='L1')
		L(cntL,1:32)=str2num(lin(4:end));
		lin=fgetl(fid);
		L(cntL,33:64)=str2num(lin(4:end));
		lin=fgetl(fid);
		L(cntL,65:96)=str2num(lin(4:end));
		lin=fgetl(fid);
		L(cntL,97:128)=str2num(lin(4:end));
        Ldepth(cntL)=depth;
		cntL=cntL+1;
	end
	if(length(lin)>1 & lin(1:2)=='M ')
		M(cntM,1:4)=str2num(lin(3:end));
        M(cntM,5) = t;
        Mdepth(cntM)=depth;
		cntM=cntM+1;
	end
	if(length(lin)>1 & lin(1:2)=='L5')
        ss=str2num(lin(4:end));
        L5(cntL5,1:length(ss))=ss;
		%L5(cntL5,1:10)=str2num(lin(4:end));
        t = L5(cntL5,3);
		cntL5=cntL5+1;
    end
    if(length(lin)>1 & lin(1:2)=='C ')
        ctd=str2num(lin(3:end));
        if length(ctd)==6
            CTD(cntCTD,1:6)=ctd;
            cntCTD=cntCTD+1;
            depth=ctd(1);
        elseif length(ctd)==5
            CTD(cntCTD,1:5)=ctd;
            cntCTD=cntCTD+1;
            depth=ctd(1);
        end
    end
    if(length(lin==1) & lin==-1)
        testlin=testlin+1;
    end
end
fclose(fid);
LOPC.L=L;
LOPC.Ldepth=Ldepth';
LOPC.M=M;
LOPC.Mdepth=Mdepth';
LOPC.L5=L5;
LOPC.CTD=CTD;


