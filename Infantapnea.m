function [timesamplesnobreath,maxtime,Maxsegmentnumber, lengsthsizebreathing]=Infantapnea(data,frequency)
RespiratoryHold = importdata(data);
realdataname=string(data);
DeltaTempraturechange = RespiratoryHold.record(:,2);
RespirationRate = RespiratoryHold.record(:,1);
Numberofmeasuremntstable = size(DeltaTempraturechange);
RespirationRatevector=table2array(RespirationRate);
DeltaTempraturechangevector=table2array(DeltaTempraturechange);
dt=1/frequency;%Interval of time
time_vector = 0:dt:dt*(Numberofmeasuremntstable-1); %Seconds
figure
subplot(2,1,1);
plot(time_vector,RespirationRatevector);
xlabel('Time [sec]');
ylabel('Respiration Rate [mV]');
title('Respiration Rate Within Time ' + realdataname);
subplot(2,1,2);
plot(time_vector,DeltaTempraturechangevector);
xlabel('Time [sec]');
ylabel('Temperature Change [Celsius]');
title('Changes of Temperature Over Time ' + realdataname);
Nobreathvector=[];
n=1;
Timenobreathvector=[];
for i =101:length(RespirationRatevector)-200
    mone=(RespirationRatevector(i+200)-RespirationRatevector(i-100));
    machane=(time_vector(i+200)-time_vector(i-100));
    Shipua=mone/machane;
   if RespirationRatevector(i)>-0.05 &&  RespirationRatevector(i)<0.05 && Shipua<0.02 && Shipua>-0.02
            Nobreathvector(n)=RespirationRatevector(i);
            Timenobreathvector(n)=time_vector(i); 
            n=n+1;
    end
end
Nobreathvector(Nobreathvector==0)=NaN;
Timenobreathvector(Timenobreathvector==0)=NaN;
figure
plot(time_vector,RespirationRatevector);
xlabel('Time [sec]');
ylabel('Respiration Rate [mV]');
hold on
plot(Timenobreathvector,Nobreathvector,'r*');
legend('Respiration Rate','No breath')
title('Respiration Rate Within Time ' + realdataname);
Lengthofnonbreath=length(Nobreathvector);
cellnobreathing=cell(1,Lengthofnonbreath);
u=1;
numpalcecell=1;
numcellplaceplace=1;
savedvectortime=[];
 for t=1:Lengthofnonbreath
     if Timenobreathvector(u)==time_vector(t)
         savedvectortime(numcellplaceplace)=Timenobreathvector(u);
         u=u+1;
         numcellplaceplace=numcellplaceplace+1;
     else  
         if ~isempty(savedvectortime)
          cellnobreathing{numpalcecell}=savedvectortime;
          savedvectortime=[];
          numpalcecell=numpalcecell+1;
         end
       numcellplaceplace=1;
      end
   if u==Lengthofnonbreath
       break
   end
 end
sizeofeachnobreathingsegemnt=zeros(1,length(cellnobreathing));
for sizearraycell=1:length(cellnobreathing)
    lencellarray=length(cellnobreathing{sizearraycell});
    sizeofeachnobreathingsegemnt(sizearraycell)=lencellarray;
end
sizeofeachnobreathingsegemntclear=sizeofeachnobreathingsegemnt(sizeofeachnobreathingsegemnt~=0);
lengsthsizebreathing=length(sizeofeachnobreathingsegemntclear);
Numberofsamplemaxnobreathing=max(sizeofeachnobreathingsegemntclear);
Maxsegmentnumber=find(sizeofeachnobreathingsegemntclear==Numberofsamplemaxnobreathing);
timesamplesnobreath=zeros(1,length(sizeofeachnobreathingsegemntclear));

for timesampleholdbreath= 1:length(sizeofeachnobreathingsegemntclear) %seconds
    indicator=sizeofeachnobreathingsegemntclear(timesampleholdbreath);
    segmenttimeachvector=0:dt:dt*(indicator-1);
    timesamplesnobreath(timesampleholdbreath)=segmenttimeachvector(end);
    indicator=0;
end
timemaxvector = 0:dt:dt*(Numberofsamplemaxnobreathing-1);
maxtime=timemaxvector(end);
plot(time_vector,RespirationRatevector,'b');
xlabel('Time [sec]');
ylabel('Respiration Rate [mV]');
hold on
plot(Timenobreathvector,Nobreathvector,'r*');
legend('Respiration Rate','No breath')
title('Respiration Rate Within Time ' + realdataname + ' Max Apnea Time ' + num2str(maxtime) + ' seconds  in Segment  ' +  num2str(Maxsegmentnumber));
end
        
        



