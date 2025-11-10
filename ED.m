%Evolución diferencial Versión 1.0
%Fernando Aldana Franco
%5 de abril de 2025
%%
clc; %limpia línea de comandos
clear all; %Limpia espacio de trabajo
close all; %Cierra ventanas abiertas
%%
%Variables del programa
%De la función
syms x; %Variable simbólica
syms y; %Variable simbólica
syms z; %Variable simbólica
syms w; %Variable simbólica
f=(x-1)^2+(y-1)^2+(z-1)^2+(w-1)^2; %Declara la función
Resolution=100000; %Resolución de los pesos
nvariables=4;
%Del AG
NumberIndividuals=20; %Cantidad de individuos en una generación
NumberGenerations=100; %Número de generaciones
WeightsResolution=100000; %Resolución de los pesos
fitness=zeros(1,NumberIndividuals); %Guarda la aptitud de la generación
fitnessSons=zeros(1,NumberIndividuals); %Guarda la aptitud de los hijos de la generación
parents=ones(NumberIndividuals,3); %Guarda lista de padres y puntos de cruza
stats=zeros(NumberGenerations,3); %Guarda las estadísticas de todo el proceso: best, average & worst
theBest=zeros(1,nvariables);%Guarda al mejor en cada generación
individual=zeros(NumberIndividuals,nvariables); %Guarda a los individuos de una generación
individualSons=zeros(NumberIndividuals,nvariables); %Guarda a los individuos hijos de una generación
best=1; %Índice del mejor individuo por generación
worst=1; %Índice del peor individuo por generación
factorDiferencial=1.2; %Factor de la evolución diferencial entre 0 y 2
limiteCruza=100;
%%
%Inicia la población
%rng(0,'twister'); %Inicia números aleatorios
rng(0,'v5uniform');
for ci=1:NumberIndividuals %CI es contador de individuos
    for cw=1:nvariables %CW es contador de pesos
        individual(ci,cw)=(10*randi(Resolution))/Resolution; %Genera pesos aleatorios
        if randi(10)>5
            individual(ci,cw)=-1*individual(ci,cw); %Cambia el signo
        end
    end
end
%%
%Ciclo principal
for cg=1: NumberGenerations %CG es el contador de generaciones
    %Prueba cada red de la generación presente
    for ci=1: NumberIndividuals
        %Prueba cada solución
        eval_fun=subs(f,[x,y,z,w],[individual(ci,1),individual(ci,2),individual(ci,3),individual(ci,4)]); %Evalua la función en el punto siguiente
        fitness(1,ci)=(100-double(eval_fun));%Guarda el fitness. Si el valor obtenido es mínimo, el fitness se incrementa
    end
    %Operador de selección
    for ci=1:NumberIndividuals
        %Padre 1
        parents(ci,1)=randi(NumberIndividuals);%Sortea padre A
        parents(ci,2)=randi(NumberIndividuals);%Sortea padre B
        %Verifica no haber seleccionado el mismo individuo para la
        %variación
        if(ci==parents(ci,1))
            if ci<NumberIndividuals-1
                parents(ci,1)=ci+1;
            else
                parents(ci,1)=ci-1;
            end
        end
        %Mismo caso que el padre b
        if(ci==parents(ci,2))
            if ci<NumberIndividuals-1
                parents(ci,2)=ci+1;
            else
                parents(ci,2)=ci-1;
            end
        end
    end
  
    %Variación y curza
    for ci=1: NumberIndividuals
        pa=parents(ci,1);
        pb=parents(ci,2);
        individualSons(ci,cw)=0;
        for cw=1: nvariables
            individualSons(ci,cw)=individual(ci,cw)+(factorDiferencial*(individual(pa,cw)-individual(pb,cw))); %Función de variación
            %Si sale de los límites establecidos, sortea nuevamente el valor
            %del peso
            if(individualSons(ci,cw)>Resolution)
               individualSons(ci,cw)=(10*randi(Resolution))/Resolution;
               if randi(10)>5
                individualSons(ci,cw)=-1*individualSons(ci,cw); %Cambia el signo
               end
            end
            if(individualSons(ci,cw)<-Resolution)
                individualSons(ci,cw)=(10*randi(Resolution))/Resolution;
                if randi(10)>5
                    individualSons(ci,cw)=-1*individualSons(ci,cw); %Cambia el signo
                end
            end
        end
        %Verifica si mantiene o no el gen del padre
        if randi(limiteCruza)<(limiteCruza*0.4)
            individualSons(ci,cw)=individual(ci,cw);
        end
    end
    %Prueba cada red de los hijos
    for ci=1: NumberIndividuals
        %Prueba cada solución
        eval_fun=subs(f,[x,y,z,w],[individualSons(ci,1),individualSons(ci,2),individualSons(ci,3),individualSons(ci,4)]); %Evalua la función en el punto siguiente
        fitnessSons(1,ci)=(100-double(eval_fun));%Guarda el fitness. Si el valor obtenido es mínimo, el fitness se incrementa
    end
    %Sustitución
    for ci=1:NumberIndividuals
        if fitness(1,ci)<fitnessSons(1,ci)
            for cw=1: nvariables
                individual(ci,cw)=individualSons(ci,cw); %Copia al hijo mejor calificado
                fitness(1,ci)=fitnessSons(1,ci);
            end
        end
        %individualSons(ci,cw)=0;%Limpia el arreglo de hijos
    end
    %Elitism
    best=1; %Guarda el índice del mejor individuo por generación
    worst=1; %Guarda el índice del peor individuo por generación
    for ci=2: NumberIndividuals
        %Busca al mejor
        if fitness(1,best)<fitness(1,ci)
            best=ci;
        end
        %Y al peor
        if fitness(1,worst)>fitness(1,ci)
            worst=ci;
        end
    end
    %Estadísticas de la generación
    stats(cg,1)=fitness(1,best);%Mejor
    stats(cg,3)=fitness(1,worst);%Peor
    aux=0;%Auxiliar
    for ci=1:NumberIndividuals %Recorre el fitness de cada individuo
        aux=aux+fitness(1,ci);%Suma el fitness del individiuo
        fitness(1,ci)=0;%Limpia fitness
        fitnessSons(1,ci)=0;%Limpia fitness de hijos
    end
    stats(cg,2)=aux/NumberIndividuals;%Calcula el promedio
end
plot((1:NumberGenerations),stats(:,2));
hold on;
plot((1:NumberGenerations),stats(:,1));
plot((1:NumberGenerations),stats(:,3));
hold off;