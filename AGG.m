%AGG Versión 1.0
%Fernando Aldana Franco
%Octubre 2025
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
NumberIndividuals=100; %Cantidad de individuos en una generación
NumberGenerations=100; %Número de generaciones
MutationRate=2; %Porcentaje de mutación (1%-3%)
SustitutionRate=10; %Porcentaje de sustitución (0-50%)
fitness=zeros(1,NumberIndividuals); %Guarda la aptitud de la generación
parents=ones(NumberIndividuals,3); %Guarda lista de padres y puntos de cruza
stats=zeros(NumberGenerations,3); %Guarda las estadísticas de todo el proceso: best, average & worst
theBest=zeros(1,nvariables);%Guarda al mejor en cada generación
individual=zeros(NumberIndividuals,nvariables); %Guarda a los individuos de una generación
best=1; %Índice del mejor individuo por generación
worst=1; %Índice del peor individuo por generación
%%
%Inicia la población
rng(0,'philox');%Inicia números aleatorios
for ci=1:NumberIndividuals %CI es contador de individuos
    for cw=1:nvariables %CW es contador de variables
        individual(ci,cw)=randi(Resolution)/(Resolution); %Punto inicial en X 0 a 1 %Genera pesos aleatorios
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
        pa=randi(NumberIndividuals);%Sortea padre potencial A
        pb=randi(NumberIndividuals);%Sortea padre potencial B
        if pa==pb %Verifica si los padres son el mismo
            if pb>NumberIndividuals
                pb=pb-1;
            else
                if pb==1
                    pb=pb+1;
                else
                    pb=pb-1;
                end
            end
        end
        parents(ci,1)=pa; %Supone que el padre a es el mejor
        if fitness(1,pb)>fitness(1,pa)%Verifica si el fitness del padre b es mayor al del padre a
            parents(ci,1)=pb;%Acualiza al padre b
        end
        %Padre 2
        pa=randi(NumberIndividuals);%Sortea padre potencial A
        pb=randi(NumberIndividuals);%Sortea padre potencial B
        if pa==pb %Verifica si los padres son el mismo
            if pb>NumberIndividuals
                pb=pb-1;
            else
                if pb==1
                    pb=pb+1;
                else
                    pb=pb-1;
                end
            end
        end
        parents(ci,2)=pa; %Supone que el padre a es el mejor
        if fitness(1,pb)>fitness(1,pa)%Verifica si el fitness del padre b es mayor al del padre a
            parents(ci,2)=pb;%Acualiza al padre b
        end
    end
    %Cross Over
    for ci=1: NumberIndividuals
        cp=randi(nvariables);%Sortea punto de cruza
        parents(ci,3)=cp;%Guarda punto de cruza
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
    %Copia al mejor de los individuos
    for cw=1:nvariables
        theBest(1,cw)=individual(best,cw);
    end
    %Sustitución
    sus_index=int16(NumberIndividuals*(SustitutionRate/100));%Valor de sustitución
    ind_temp=zeros(NumberIndividuals,nvariables); %Guarda temporalmente a los individuos de la generación actual
    for ci=1:NumberIndividuals
        for cw=1: nvariables
            ind_temp(ci,cw)=individual(ci,cw); %Copia la generación actual
        end
    end
    %Realiza cruza
    for ci=1: NumberIndividuals
        for cw=1: nvariables
            if cw<=parents(ci,3)
                individual(ci,cw)=ind_temp(parents(ci,1),cw);
            else
                individual(ci,cw)=ind_temp(parents(ci,2),cw);
            end
        end
    end
    %Sortea los padres que serán conservados
    for ci=1:sus_index
        aux=randi(NumberIndividuals);%Sortea el individuo a mantener
        %if randi(10)<6 %Sortea si se preserva o no el individuo
        for cw=1:nvariables
            individual(aux,cw)=ind_temp(aux,cw);%Copia al individuo a preservar
        end
        %end
    end
    %Mutación
    %Calcula el total de mutaciones máximas por generación
    mut_index=int16(nvariables*NumberIndividuals*(MutationRate/100));
    %Recorreo individuos y pesos para aplicar mutación
    for ci=1:NumberIndividuals 
        for cw=1: nvariables %Recorre todos los pesos de la generación
            if mut_index>0 %Si aún queda espacio para mutaciones
                if randi(10)<5 %Sortea si a ese peso se le aplica mutación
                    individual(ci,cw)=randi(Resolution); %Sortea el valor de mutación
                    if randi(10)>5 %Sortea cambio de signo
                        individual(ci,cw)=individual(ci,cw)*-1;
                    end
                    mut_index=mut_index-1;%decrementa la mutación
                end
            end
        end
    end
    %Copia al mejor individuo en la nueva generación
    for cw=1: nvariables
        individual(best,cw)=theBest(1,cw);
    end
    %Estadísticas de la generación
    stats(cg,1)=fitness(1,best);%Mejor
    stats(cg,3)=fitness(1,worst);%Peor
    aux=0;%Auxiliar
    for ci=1:NumberIndividuals %Recorre el fitness de cada individuo
        aux=aux+fitness(1,ci);%Suma el fitness del individiuo
        fitness(1,ci)=0;%Limpia fitness
    end
    stats(cg,2)=aux/NumberIndividuals;%Calcula el promedio
end
plot((1:NumberGenerations),stats(:,2));
hold on;
plot((1:NumberGenerations),stats(:,1));
plot((1:NumberGenerations),stats(:,3));
hold off;