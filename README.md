# Desafio Universidade dos Dados – Auxiliando os Times de Marketing e Pricing da Empresa de Delivery 🚲

#### Desafio proposto no Clube de Assinaturas da [Universidade dos Dados](https://universidadedosdados.com/). 


![anime](https://camo.githubusercontent.com/1ffd19330e0112e238790f80ace2a275600a33c440a1154350998a595bbbdf07/68747470733a2f2f6170692d636c75622d66696c652e63622e686f746d6172742e636f6d2f7075626c69632f76352f66696c65732f39373131663735312d323563642d343638662d383639612d653932613965636132333632)

### Objetivos e resultados
Como analista de dados em uma equipe centralizada e que atende diversas áreas recebemos algumas demandas:

- Numa ação de marketing, para atrair mais entregadores, vamos dar uma bonificação para os 20 entregadores que possuem maior distância percorrida ao todo. A bonificação vai variar de acordo com o tipo de profissional que ele é e o modelo que ele usa para se locomover (moto, bike, etc).

- Além disso, o time de Pricing precisa ajustar os valores pagos aos entregadores. Para isso, eles precisam da distribuição da distância média percorrida pelos motoqueiros separada por estado, já que cada região terá seu preço.

- Por fim, o CFO precisa de alguns indicadores de receita para apresentar para a diretoria executiva. Dentre esses indicadores, vocês precisarão levantar (1) a receita média e total separada por tipo (Food x Good), (2) A receita média e total por estado. Ou seja, são 4 tabelas ao todo.

- Se a empresa tem um gasto fixo de 5 reais por entrega, recebe 15% do valor de cada entrega como receita e, do total do lucro, distribui 20% em forma de bônus para os 2 mil funcionários, quanto cada um irá receber no período contido no dataset?

Após a realização de consultas SQL, limpeza e manipualação de dados com Python e uma análise das solicitações foram geradas as planilhas solicitadas (ranking de entregadores e receitas), além disso foram calculadas as distâncias médias e o bônus para os funcionários que foi de R$ 201,03. Os resultados em forma de apresentação .ppt você pode conferir [aqui](https://docs.google.com/presentation/d/1Ok_sNpYxzhzkrtfBb1XwWTQN4w1Z1cL_Jwdykt2WYd4/edit?usp=sharing).
### 🛠️ Ferramentas utilizadas
![Jupyter Notebook](https://img.shields.io/badge/jupyter-%23FA0F00.svg?style=for-the-badge&logo=jupyter&logoColor=white) ![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white) ![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) ![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white) ![Microsoft Excel](https://img.shields.io/badge/Microsoft_Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white) ![Microsoft PowerPoint](https://img.shields.io/badge/Microsoft_PowerPoint-B7472A?style=for-the-badge&logo=microsoft-powerpoint&logoColor=white)

## Estrutura dos Dados
![schema](https://i.imgur.com/GMqqrNJ.png)

## Bibliotecas Python utilizadas
#### Manipulação de dados
- Pandas, Numpy, OS, sqlalchemy
#### Análise Exploratória
- Seaborn, Matplotlib

# Consultas SQL para geração da tabela de análise
```sql
WITH tb_orders AS 
(SELECT
    t1.order_id,
    t1.store_id,
    t1.channel_id,
    t1.payment_order_id,
    t1.delivery_order_id
FROM orders AS t1
WHERE t1.order_status = 'FINISHED'),

tb_pay AS
(SELECT 
    t1.*,
    t2.payment_id,
    t2.payment_amount,
    t2.payment_fee,
    ((t2.payment_amount - t2.payment_fee) * 0.15) - 5 AS order_revenue
FROM tb_orders AS t1
LEFT JOIN payments AS t2
ON t1.payment_order_id = t2.payment_order_id
WHERE t2.payment_status = 'PAID'),

tb_deliveries AS 
(SELECT 
    t1.*,
    t2.driver_id,
    t2.delivery_distance_meters,
    t3.driver_modal
FROM tb_pay t1
LEFT JOIN deliveries AS t2
ON t1.delivery_order_id = t2.delivery_order_id
LEFT JOIN drivers AS t3
ON t2.driver_id = t3.driver_id
WHERE t2.delivery_status = 'DELIVERED'),

tb_stores AS
(SELECT 
    t1.*,
    t2.store_segment,
    t3.hub_state
FROM tb_deliveries AS t1
LEFT JOIN stores AS t2
ON t1.store_id = t2.store_id
LEFT JOIN hubs AS t3
ON t2.hub_id = t3.hub_id)

SELECT
    DATE('2024-07-08') AS dt_ref,
    order_id,
    store_id,
    payment_amount,
    payment_fee,
    order_revenue,
    driver_id,
    delivery_distance_meters,
    driver_modal,
    store_segment,
    hub_state
FROM tb_stores
```
Após carregar os dados no Python, foi realizado o processa de limpeza e manipulação dos dados, para tratar nulos, duplicados e outliers antes de prosseguir a análise.

# Respondendo as demandas
## Ranking dos entregadores
### Melhores entregadores
  
| Colocação | driver_id | Modal | Distância Total (m) |
|---------|-----------|--------------|--------------|
| 1       | 25651     | MOTOBOY      | 13854626.0   |
| 2       | 26223     | MOTOBOY      | 8340694.0    |
| 3       | 7615      | MOTOBOY      | 2599726.0    |
| 4       | 9806      | MOTOBOY      | 2295311.0    |
| 5       | 4737      | MOTOBOY      | 2286124.0    |
| 6       | 7549      | MOTOBOY      | 2283929.0    |
| 7       | 11522     | MOTOBOY      | 2212062.0    |
| 8       | 7799      | MOTOBOY      | 2184855.0    |
| 9       | 15561     | MOTOBOY      | 2097759.0    |
| 10      | 902       | MOTOBOY      | 2073159.0    |
| 11      | 5527      | MOTOBOY      | 2044375.0    |
| 12      | 17749     | MOTOBOY      | 2036488.0    |
| 13      | 32109     | MOTOBOY      | 2006135.0    |
| 14      | 20495     | MOTOBOY      | 1944693.0    |
| 15      | 11063     | MOTOBOY      | 1940638.0    |
| 16      | 34207     | MOTOBOY      | 1923331.0    |
| 17      | 627       | MOTOBOY      | 1866923.0    |
| 18      | 21923     | MOTOBOY      | 1854807.0    |
| 19      | 26536     | MOTOBOY      | 1848829.0    |
| 20      | 598       | MOTOBOY      | 1843619.0    |

### Melhores motoboys
| Colocação | driver_id | Modal | Distância Total (m) |
|---------|-----------|--------------|--------------|
| 1       | 25651     | MOTOBOY      | 13854626.0   |
| 2       | 26223     | MOTOBOY      | 8340694.0    |
| 3       | 7615      | MOTOBOY      | 2599726.0    |
| 4       | 9806      | MOTOBOY      | 2295311.0    |
| 5       | 4737      | MOTOBOY      | 2286124.0    |
| 6       | 7549      | MOTOBOY      | 2283929.0    |
| 7       | 11522     | MOTOBOY      | 2212062.0    |
| 8       | 7799      | MOTOBOY      | 2184855.0    |
| 9       | 15561     | MOTOBOY      | 2097759.0    |
| 10      | 902       | MOTOBOY      | 2073159.0    |
| 11      | 5527      | MOTOBOY      | 2044375.0    |
| 12      | 17749     | MOTOBOY      | 2036488.0    |
| 13      | 32109     | MOTOBOY      | 2006135.0    |
| 14      | 20495     | MOTOBOY      | 1944693.0    |
| 15      | 11063     | MOTOBOY      | 1940638.0    |
| 16      | 34207     | MOTOBOY      | 1923331.0    |
| 17      | 627       | MOTOBOY      | 1866923.0    |
| 18      | 21923     | MOTOBOY      | 1854807.0    |
| 19      | 26536     | MOTOBOY      | 1848829.0    |
| 20      | 598       | MOTOBOY      | 1843619.0    |

### Melhores bikers
| Colocação | driver_id | Modal | Distância Total (m) |
|---------|-----------|--------------|--------------|
| 1       | 3780      | BIKER        | 829689.0     |
| 2       | 794       | BIKER        | 826101.0     |
| 3       | 12724     | BIKER        | 696300.0     |
| 4       | 7773      | BIKER        | 604160.0     |
| 5       | 18487     | BIKER        | 597504.0     |
| 6       | 12079     | BIKER        | 560326.0     |
| 7       | 14059     | BIKER        | 559636.0     |
| 8       | 4536      | BIKER        | 553887.0     |
| 9       | 9996      | BIKER        | 553366.0     |
| 10      | 1203      | BIKER        | 542755.0     |
| 11      | 18748     | BIKER        | 539334.0     |
| 12      | 5364      | BIKER        | 497430.0     |
| 13      | 8592      | BIKER        | 489791.0     |
| 14      | 15279     | BIKER        | 487758.0     |
| 15      | 34079     | BIKER        | 486136.0     |
| 16      | 1943      | BIKER        | 483183.0     |
| 17      | 8771      | BIKER        | 480084.0     |
| 18      | 1301      | BIKER        | 474372.0     |
| 19      | 6675      | BIKER        | 473240.0     |
| 20      | 196       | BIKER        | 472256.0     |

## Distância média por estado
| Estado | Total de Entregadores | Distância Média por Entrega (m) |
|-----------|---------------|------------------------|
| RS        | 216           | 2890.157412            |
| PR        | 291           | 2624.129476            |
| SP        | 2051          | 2246.582950            |
| RJ        | 1907          | 2010.072113            |

## Receitas 
### Média: GOOD x FOOD
|Segmento|Receita Média por Entrega|
|-------------|------------------|
|FOOD|6.08|
|GOOD|12.61|

### Total: GOOD x FOOD
|Segmento|Receita Total|
|-------------|------------------|
|FOOD|1756841.99|
|GOOD|253492.26|

### Média: Estados
| Estado | Receita Média por Entrega |
|-----------|--------------------|
| SP        | 7.79               |
| RJ        | 6.52               |
| RS        | 4.14               |
| PR        | 2.40               |

### Total: Estados
| Estado | Receita Total|
|-----------|--------------------|
| SP        | 1041347.69         |
| RJ        | 785328.08          |
| RS        | 123573.03          |
| PR        | 60085.45           |

## Bônus para os funcionários
O faturamento total foi de R$2010334.24 e o bônus para o funcionários é de R$201.03.