% this code is for caluclating performance 
clc;
clear 
close all
addpath('support')
F=dir('TEST');
F=char(F.name)
sz=size(F,1)-2;
load SS
st{1}='Apple';st{2}='Babycorn';st{3}='Banana';st{4}='Beetroot';st{5}='Biryani';st{6}='Bittergourd';st{7}='Blackforest cake';st{8}='Blueberry';st{9}='Boiled egg';
cnt=0;t=0;
addpath(pwd);
for ii=1:sz
    cd TEST
    str=F(3,:);    
    G=dir(str);
    G=char(G.name);
    sz2=size(G,1)-2;   
  for kk=1:sz2   
    cd(str)
    st2=G(kk+2,:);
    I=imread(st2);
    I=imresize(I,[256 256]);
    fq=IRCTF(I);
    rst1=cnntest(fq(:)',9,SS);
    str
    dst=st{rst1}
    dd=double(dst);
    dd=dd(dd~=32);
    stt=double(str);
    stt=stt(stt~=32);
    if strcmp(char(stt),char(dd))==1
        cnt=cnt+1;
    end
    t=t+1;
   cd ..
  end
  cd ..
end

disp(['The performance of the system is ',num2str((cnt/t*100))]);
    