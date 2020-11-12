clear all 
close all

fdc=fopen('resultsc.txt','r');
fdc_la=fopen('resultsc_LA.txt','r');
fdm=fopen('resultsm.txt','r')
YC = fscanf(fdc,'%d')
YC_LA = fscanf(fdc_la,'%d')
YM = fscanf(fdm,'%d')

%THD_c = thd(YC,10000,2)
%THD_c_la = thd(YC_LA,10000,2)
%THD_m = thd(YM,10000,2)
THD_c = thd(YC)
THD_c_la = thd(YC_LA)
THD_m = thd(YM)