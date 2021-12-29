clc
clear      
sizepop=50;           
overbest=10;          
MAXGEN=100;            
pcross=0.5;          
pmutation=0.4;      
ps=0.95;              
length=6;            
M=sizepop+overbest;


individuals = struct('fitness',zeros(1,M), 'concentration',zeros(1,M),'excellence',zeros(1,M),'chrom',[]);

individuals.chrom = popinit(M,length);
trace=[]; 


for iii=1:MAXGEN

      for i=1:M
         individuals.fitness(i) = fitness(individuals.chrom(i,:));      
         individuals.concentration(i) = concentration(i,M,individuals); 
     end
    
     individuals.excellence = excellence(individuals,M,ps);
          
    
     [best,index] = min(individuals.fitness);   
     bestchrom = individuals.chrom(index,:);    
     average = mean(individuals.fitness);       
     trace = [trace;best,average];              
     
     
     bestindividuals = bestselect(individuals,M,overbest);  
     individuals = bestselect(individuals,M,sizepop);        

    
     individuals = Select(individuals,sizepop);                                                            
     individuals.chrom = Cross(pcross,individuals.chrom,sizepop,length);                                   
     individuals.chrom = Mutation(pmutation,individuals.chrom,sizepop,length);  
     individuals = incorporate(individuals,sizepop,bestindividuals,overbest);                                  

end

figure(1)
plot(trace(:,1));
hold on
plot(trace(:,2),'--');
legend('Optimal fitness value','Average fitness value')
title('Convergence curve','fontsize',12)
xlabel('Number of iterations','fontsize',12)
ylabel('Fitness value','fontsize',12)


city_coordinate=[1304,2312;3639,1315;4177,2244;3712,1399;3488,1535;3326,1556;3238,1229;4196,1044;4312,790;4386,570;
                 3007,1970;2562,1756;2788,1491;2381,1676;1332,695;3715,1678;3918,2179;4061,2370;3780,2212;3676,2578;
                 4029,2838;4263,2931;3429,1908;3507,2376;3394,2643;3439,3201;2935,3240;3140,3550;2545,2357;2778,2826;2370,2975];
carge=[20,90,90,60,70,70,40,90,90,70,60,40,40,40,20,80,90,70,100,50,50,50,80,70,80,40,40,60,70,50,30];

for i=1:31
    distance(i,:)=dist(city_coordinate(i,:),city_coordinate(bestchrom,:)');
end
[a,b]=min(distance');

index=cell(1,length);

for i=1:length

index{i}=find(b==i);
end
figure(2)
title('Optimal planning delivery route')
cargox=city_coordinate(bestchrom,1);
cargoy=city_coordinate(bestchrom,2);
plot(cargox,cargoy,'rs','LineWidth',2,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','b',...
    'MarkerSize',20)
hold on

plot(city_coordinate(:,1),city_coordinate(:,2),'o','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',10)

for i=1:31
    x=[city_coordinate(i,1),city_coordinate(bestchrom(b(i)),1)];
    y=[city_coordinate(i,2),city_coordinate(bestchrom(b(i)),2)];
    plot(x,y,'c');hold on
end

