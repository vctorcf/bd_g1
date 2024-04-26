-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 26/04/2024 às 22:37
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `loja_prints`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `materiais`
--

CREATE TABLE `materiais` (
  `id` int(11) NOT NULL,
  `id_preco` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `pedidos_com_moldura`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `pedidos_com_moldura` (
`id` int(11)
,`id_portfolio` int(11)
,`moldura_preco` float
,`moldura_tipo` int(11)
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedido_cliente`
--

CREATE TABLE `pedido_cliente` (
  `id` int(11) NOT NULL,
  `id_portfolio` int(11) NOT NULL,
  `id_material` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `cpf` int(11) NOT NULL,
  `endereco` varchar(255) NOT NULL,
  `forma_de_entrega` varchar(255) NOT NULL,
  `valor_entrega` float NOT NULL,
  `moldura` tinyint(1) NOT NULL,
  `moldura_preco` float DEFAULT NULL,
  `valor_total` float NOT NULL,
  `forma_pagamento` varchar(100) NOT NULL,
  `data_pedido` datetime DEFAULT NULL,
  `pedido_status` varchar(15) DEFAULT NULL,
  `moldura_tipo` int(11) DEFAULT NULL,
  `valor_base` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `pedido_cliente`
--
DELIMITER $$
CREATE TRIGGER `atualisar_valor_total` BEFORE UPDATE ON `pedido_cliente` FOR EACH ROW BEGIN
    SET NEW.valor_total = NEW.moldura_preco + NEW.valor_base + NEW.valor_entrega;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `calcular_valor_total` BEFORE INSERT ON `pedido_cliente` FOR EACH ROW BEGIN
    SET NEW.valor_total = NEW.moldura_preco + NEW.valor_base + NEW.valor_entrega;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `portfolio`
--

CREATE TABLE `portfolio` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `descricao` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `precos`
--

CREATE TABLE `precos` (
  `id` int(11) NOT NULL,
  `id_materiais` int(11) NOT NULL,
  `valor` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `total_compras_cliente`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `total_compras_cliente` (
`id` int(11)
,`nome` varchar(255)
,`valor_total` float
,`total_compras` double
);

-- --------------------------------------------------------

--
-- Estrutura para view `pedidos_com_moldura`
--
DROP TABLE IF EXISTS `pedidos_com_moldura`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pedidos_com_moldura`  AS SELECT `pedido_cliente`.`id` AS `id`, `pedido_cliente`.`id_portfolio` AS `id_portfolio`, `pedido_cliente`.`moldura_preco` AS `moldura_preco`, `pedido_cliente`.`moldura_tipo` AS `moldura_tipo` FROM `pedido_cliente` WHERE `pedido_cliente`.`moldura` = 1 ;

-- --------------------------------------------------------

--
-- Estrutura para view `total_compras_cliente`
--
DROP TABLE IF EXISTS `total_compras_cliente`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `total_compras_cliente`  AS SELECT `pc`.`id` AS `id`, `pc`.`nome` AS `nome`, `pc`.`valor_total` AS `valor_total`, (select sum(`pedido_cliente`.`valor_total`) from `pedido_cliente` where `pedido_cliente`.`nome` = `pc`.`nome`) AS `total_compras` FROM `pedido_cliente` AS `pc` ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `materiais`
--
ALTER TABLE `materiais`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_materiais_id_preco` (`id_preco`);

--
-- Índices de tabela `pedido_cliente`
--
ALTER TABLE `pedido_cliente`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pedido_cliente_id_portfolio` (`id_portfolio`),
  ADD KEY `fk_pedido_cliente_id_material` (`id_material`),
  ADD KEY `fk_pedido_cliente_moldura_tipo` (`moldura_tipo`);

--
-- Índices de tabela `portfolio`
--
ALTER TABLE `portfolio`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `precos`
--
ALTER TABLE `precos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_precos_id_materiais` (`id_materiais`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `materiais`
--
ALTER TABLE `materiais`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de tabela `pedido_cliente`
--
ALTER TABLE `pedido_cliente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `portfolio`
--
ALTER TABLE `portfolio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `precos`
--
ALTER TABLE `precos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `materiais`
--
ALTER TABLE `materiais`
  ADD CONSTRAINT `fk_materiais_id_preco` FOREIGN KEY (`id_preco`) REFERENCES `precos` (`id`);

--
-- Restrições para tabelas `pedido_cliente`
--
ALTER TABLE `pedido_cliente`
  ADD CONSTRAINT `fk_pedido_cliente_id_material` FOREIGN KEY (`id_material`) REFERENCES `materiais` (`id`),
  ADD CONSTRAINT `fk_pedido_cliente_id_portfolio` FOREIGN KEY (`id_portfolio`) REFERENCES `portfolio` (`id`),
  ADD CONSTRAINT `fk_pedido_cliente_moldura_tipo` FOREIGN KEY (`moldura_tipo`) REFERENCES `materiais` (`id`);

--
-- Restrições para tabelas `precos`
--
ALTER TABLE `precos`
  ADD CONSTRAINT `fk_precos_id_materiais` FOREIGN KEY (`id_materiais`) REFERENCES `materiais` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
