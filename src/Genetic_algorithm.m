clc;
clear all;
close all;
%Por vezes a aptidão dá valores muito pequenos, portanto será necessário exibir mais casas decimais
format long

% Função objetivo
limits=[0,1]; % Limites da pesquisa
f1 = @(x) 4*(sin(5*pi*x+0.5).^6).*exp(log2((x-0.8).^2));
axis([0,1,-0.1,2]); % Delimitar os eixos

 
% Definições de variáveis
pop_size=5; % Tamanho da populaçao
lchrome=12; % Tamanho do cromossoma
maxgen=96; % Número maximo de geraçoes
p_cross=0.8; % Probabilidade de cruzamento
p_mutation=0.04; % Probabilidade de mutação
gen=1; % Contador das geraçoes

% init_pop- Função que inicializa a populaçao
% CHROME - Matriz da população atual
% POP - Vetor com a aptidão da população
% POP_x - Vetor com o valor da variável de decisão
[CHROME,POP,POP_x]=init_pop(pop_size,lchrome,limits);

% Determina alguns parametros de avaliaçao
% statist - Função que calcula algumas métricas estatísticas
% sumfit - Soma das aptidões da população
% best - Indice do melhor elemento da população
% max_fit - Valor maximo atingido em cada iteracao
% average - Média aritmética da população
[sumfit,best,max_fit,average]=statist(POP,pop_size);

%Inicializar varivaies para armazenas dados
Melhor_aptidao = zeros(1, maxgen); %Melhor aptidao de cada geracao
aptidao_media = zeros(1, maxgen); %Aptidao media de cada geracao
variavel_dec = zeros(1,maxgen); %Variavel de decisao da melhor aptidao de cada geracao
historico_POP_x = zeros(pop_size, maxgen); %Guardar a var. dec. de cada elemento de cada geraçao
historico_POP = zeros(pop_size, maxgen); %Guardar a aptidao de cada elemento de cada geraçao
cores = [ %Definir matriz de cores dos gráficos
    0, 1, 0; %Verde
    0, 1, 1; %Ciano
    [0.6350 0.0780 0.1840]; %Vinho
    1, 1, 0; %Amarelo
    1, 0, 1; %Magenta
    ];

%Para redirecionar todo o output para um arquivo de texto .txt, "diary", para que
%possamos entender melhor o que aconteceu ao longo de todas as gerações, com
%uma maior exatidão
diary(sprintf('Run - Algoritmo genético - %s_%d.txt',datestr(now,'yyyy_mm_dd_HH_MM_SS'),randi([1,10000],1)))

%Motrar dados, neste caso a pop. inicial, a aptidao e variavel de decisao
%de cada elemento da mesma.
%Colocar "format long" caso seja necessário observar mais casas decimais
disp('Populacao inicial: ')
disp(CHROME)
disp('POP -> Aptidao')
disp(POP)
disp('POP_X -> Variavel de decisao')
disp(POP_x)
 


while (gen<=maxgen)
 set(0,'defaultlinelinewidth',2);
 ezplot('4*(sin(5*pi*x+0.5)^6)*exp(log2((x-0.8)^2))',limits)
 axis([0,1,-0.1,2]); % Delimitar os eixos
 title('Algoritmo genético');
 xlabel('x');
 ylabel('f(x)');
 hold on

 % Geraçao da nova populaçao
 % generate - função que gera uma nova população
 % Esta função tem de chamar funções para a seleção, cruzamento e
 % mutação
 [CHROME]=generate(pop_size,POP,CHROME,lchrome,p_cross,p_mutation);

 % Avalia a população
 % Report - Função que avalia a evolução da optmização
 [POP,POP_x]=report(CHROME,pop_size,lchrome,limits);

 % Faz a estatistica da população
 [sumfit,best,max_fit,average]=statist(POP,pop_size);

 % Motrar dados, neste caso cada uma das gerações
 fprintf('\n')
 disp(['Geração: ', num2str(gen)]);
 disp(CHROME);

 % Guardar dados para fazer gráficos
 Melhor_aptidao(gen) = max_fit;
 aptidao_media(gen) = average;
 variavel_dec(gen) = POP_x(best);
for i = 1:pop_size
    %Para cada elemento de cada ger. guarda a var.dec. e a aptidao
    historico_POP_x(i, gen) = POP_x(i);
    historico_POP(i, gen) = POP(i);
end

 % Plot do máximo global da func.
 plot(0.066,1.6332,'o', 'markersize', 9, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black');

 % Plot dos pontos correspondentes aos elementos da população com
 % respetivas cores indicadas em cima
 plot(POP_x(1), POP(1), 'o', 'markersize', 6, 'color', [0 1 0]);
 plot(POP_x(2), POP(2), 'o', 'markersize', 6, 'color', [0 1 1]);
 plot(POP_x(3), POP(3), 'o', 'markersize', 6, 'color', [0.6350 0.0780 0.1840]);
 plot(POP_x(4), POP(4), 'o', 'markersize', 6, 'color', [1 1 0]);
 plot(POP_x(5), POP(5), 'o', 'markersize', 6, 'color', [1 0 1]);

 % Adicionar contador à legenda
 legend_str = {['f1(x) - Geração: ', num2str(gen)], 'Máximo global', 'Individuo 1', 'Individuo 2', 'Individuo 3', 'Individuo 4', 'Individuo 5'};
 legend(legend_str);


 pause(0.05);

 gen=gen+1;

 hold off
end


% Gráficos
figure;

% Gráfico da melhor aptidão, média da aptidão e aptidão máxima esperada ao longo das gerações
subplot(2, 1, 1);
axis([0, maxgen, -0.1, 4]);
hold on;
% Gráfico da aptidão máxima esperada
plot(1:maxgen, 1.6332 * ones(1, maxgen),':', 'LineWidth', 3, 'color', [0 1 0], 'DisplayName', 'Aptidão Máxima Esperada');
% Gráfico da melhor aptidão
plot(1:maxgen, Melhor_aptidao, 'LineWidth', 2, 'color', [1 0 0], 'DisplayName', 'Melhor Aptidão');
% Gráfico da média de aptidão
plot(1:maxgen, aptidao_media, 'LineWidth', 2, 'color', [0.7 0.2 0.9], 'DisplayName', 'Aptidão Média');
title('Evolução da Aptidão');
xlabel('Geração');
ylabel('f(x) (POP - Aptidão)');
legend('show'); % Exibe a legenda
hold off;

% Gráfico de POP_X, que é a variavel de decisao, neste caso, do melhor elemento de cada
% geração
subplot(2, 1, 2);
axis([0,maxgen,-0.1,1]);
hold on;
plot(1:maxgen, variavel_dec, 'LineWidth', 2, 'color',[1 0.5 0]);
title('Evolução da variável de decisão do indivíduo de melhor aptidão');
xlabel('Geração');
ylabel('x (POP_X - Var. de decisão)');

% Gráficos da evolução de POP_x para cada indivíduo
figure;
for i = 1:pop_size
    subplot(pop_size, 2, 2* i - 1); %Fica na coluna impar, posicao indice impar
    plot(1:maxgen, historico_POP_x(i, :), 'LineWidth', 2, 'color', cores(i, :));
    title(['Evolução de POP_x - Indivíduo ', num2str(i)]);
    xlabel('Geração');
    ylabel('x (POP_x)');
end

% Gráficos da evolução de POP para cada indivíduo
% figure;
for i = 1:pop_size
    subplot(pop_size, 2, 2 * i); %Fica na coluna par, posicao indice par
    plot(1:maxgen, historico_POP(i, :), 'LineWidth', 2, 'color', cores(i, :));
    title(['Evolução de POP - Indivíduo ', num2str(i)]);
    xlabel('Geração');
    ylabel('f(x) (POP)');
end




% FUNÇÕES
% Funcao para inicializar a população
function [CHROME, POP, POP_x] = init_pop(pop_size, lchrome, limits)
    % Inicializa a população (CHROME) com cromossomas binários aleatórios
    CHROME = randi([0, 1], pop_size, lchrome); %Criaçao da matriz Chrome

    % Decodifica os cromossomas para obter os valores da variável de decisão (POP_x)
    POP_x = descodificador(CHROME, lchrome, limits);

    % Avalia a aptidão da população (POP)
    POP = func_objetivo(POP_x);

end

% Função para converter os cromossomas binários da matriz Chrome em valores reais dentro dos
% limites
function x = descodificador(CHROME, lchrome, limits)
    % Decodifica os cromossomas binários para valores reais dentro dos limites
    x = zeros(size(CHROME, 1), 1);

    for i = 1:size(CHROME, 1) 
        %Escalonamento 
        x(i) = limits(1) + bin2dec(num2str(CHROME(i, :))) / (2^lchrome - 1) * (limits(2) - limits(1));
        % Converte cada linha i da matriz Chrome em string onde cada elemento
        % da linha representa um bit, cromossoma
        % Depois deslocamos o numero normalizado para estar dentro dos limites reais
    end
end

% Função para avaliar a aptidão da população 
function POP = func_objetivo(POP_x)
    POP = 4 * (sin(5 * pi * POP_x + 0.5).^6) .* exp(log2((POP_x - 0.8).^2));
end

%Funcao para calcular a soma das aptidões, o indice do melhor elemento, o
%valor maximo em cada it. e a media aritmetica da populaçao
function [sumfit, best, max_fit, average] = statist(POP, pop_size)
    %Troquei o nome da variavel "max" do protocolo para "max_fit" devido a
    %existencia de uma func. "max" já propria do matlab
    % Soma das aptidões da população
    sumfit = sum(POP);

    % Índice do melhor elemento da população
    [~, best] = max(POP); %Como apenas queremos o indice do valor max. aptidao colocamos o ~
    %para "ignorar" o valor maximo e obtermos apenas o indice deste

    % Valor da melhor aptidao
    max_fit = POP(best);

    % Média aritmética da população
    average = sumfit / pop_size;
end

%Funcao para gerar a nova população. Esta funcao chama outras funcoes como,
%seleçao, cruzamento e mutacao
function [new_CHROME] = generate(pop_size,POP,CHROME,lchrome,p_cross,p_mutation)
    new_CHROME = zeros(pop_size, lchrome);
    
    %Apenas cinco cruzamentos, cada um gera um filho, mantendo assim pop_size =
    % 5 em todas as geracoes
    num_cruzamentos = 5;
    for i = 1:num_cruzamentos
        % Seleção
        parente1 = selection(POP);
        
        parente2 = selection(POP);
        while parente1 == parente2 %Garantir que o mesmo nao cruza com ele proprio
            parente2 = selection(POP);
        end
       
        disp(['Cruzamento de ponto único ', num2str(i), ':'])
        % Cruzamento
        if rand() < p_cross
            [filho1, ~] = crossover(CHROME(parente1, :), CHROME(parente2, :));
            % ":" extrair a linha da matriz do determinado indice
            % ~ Ignora o filho2
            % correspondente ao parente
            fprintf('\tProgenitores: %d com %d\n', parente1, parente2)
        else
            filho1 = CHROME(parente1, :);
%             filho2 = CHROME(parente2, :);
        fprintf('\tO cruzamento %d, entre %d com %d, nao foi realizado. Portanto o filho %d será igual ao progenitor %d\n', i, parente1, parente2,i, parente1)
        end
        
        % Mutação
        filho1 = mutation(filho1, p_mutation);
%         filho2 = mutation(filho2, p_mutation);

        new_CHROME(i, :) = filho1;
%         new_CHROME(i+1, :) = filho2;

    end
end

%Funcao de Selecao
function selected_index = selection(POP)
    % Roleta virtual simples para a seleção

    Soma_comulativa = cumsum(POP); %Soma comulativa das aptidoes
    
    selected_value = rand() * Soma_comulativa(end); %Ponto aleatorio na roleta, entre 0 e soma total da aptidao
    selected_index = find(Soma_comulativa >= selected_value, 1); %Retorna o indice do primeiro elemento que verifique a condicao
    %(Foto explicativa no computador)
end

%Funcao de Cruzamento 
function [filho1, filho2] = crossover(parente1, parente2)
    % Ponto de cruzamento
    ponto_cruzamento = randi([0, numel(parente1)]);
   
    % Realiza o cruzamento
    filho1 = [parente1(1:ponto_cruzamento), parente2(ponto_cruzamento+1:end)];
    fprintf('\tPonto de cruzamento: %d\n', ponto_cruzamento)

    %Deixa de ser utilizado, uma vez que o prof. falou em cruzamentos que
    %apenas geram um filho ou seja haverá 5 cruzamentos apenas (pop_size)
    filho2 = [parente2(1:ponto_cruzamento), parente1(ponto_cruzamento+1:end)];
end

%Funcao de Mutaçao
function mutacao = mutation(filho, p_mutation)
    % Realiza a mutação em cada bit do cromossoma
    mutacao = filho;

    for i = 1:numel(filho) %Percorre cada bit do cromossoma
        if rand() < p_mutation
            fprintf('\tOcorreu mutação no cromossoma %d.\n', i)
            mutacao(i) = ~filho(i); % Inverte o bit
        end
    end
end

%Funcao para avaliar a populacao
function [POP, POP_x] = report(new_CHROME, pop_size, lchrome, limits)
    % Inicializar vetores para armazenar a aptidão e os valores da variável de decisão
    POP = zeros(1, pop_size);
    POP_x = zeros(1, pop_size);

    % Loop para avaliar cada indivíduo na população
    for i = 1:pop_size
        % Converte o cromossoma binário em valor real dentro dos limites 
        %(Variavel de decisao)
        x = descodificador(new_CHROME(i, :), lchrome, limits);

        % Avalia a aptidão do indivíduo
        aptidao = func_objetivo(x); 

        % Armazena a aptidão e o valor da variável de decisão
        POP(i) = aptidao;
        POP_x(i) = x; %Variavel de decisao
    end
end
