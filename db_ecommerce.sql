-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 09-Mar-2018 às 22:11
-- Versão do servidor: 10.1.28-MariaDB
-- PHP Version: 7.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ecommerce`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addresses_save` (`pidaddress` INT(11), `pidperson` INT(11), `pdesaddress` VARCHAR(128), `pdesnumber` VARCHAR(16), `pdescomplement` VARCHAR(32), `pdescity` VARCHAR(32), `pdesstate` VARCHAR(32), `pdescountry` VARCHAR(32), `pdeszipcode` CHAR(8), `pdesdistrict` VARCHAR(32))  BEGIN

	IF pidaddress > 0 THEN
		
		UPDATE tb_addresses
        SET
			idperson = pidperson,
            desaddress = pdesaddress,
            desnumber = pdesnumber,
            descomplement = pdescomplement,
            descity = pdescity,
            desstate = pdesstate,
            descountry = pdescountry,
            deszipcode = pdeszipcode, 
            desdistrict = pdesdistrict
		WHERE idaddress = pidaddress;
        
    ELSE
		
		INSERT INTO tb_addresses (idperson, desaddress, desnumber, descomplement, descity, desstate, descountry, deszipcode, desdistrict)
        VALUES(pidperson, pdesaddress, pdesnumber, pdescomplement, pdescity, pdesstate, pdescountry, pdeszipcode, pdesdistrict);
        
        SET pidaddress = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_addresses WHERE idaddress = pidaddress;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_carts_save` (`pidcart` INT, `pdessessionid` VARCHAR(64), `piduser` INT, `pdeszipcode` CHAR(8), `pvlfreight` DECIMAL(10,2), `pnrdays` INT)  BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))  BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))  BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))  BEGIN
	
	INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
		desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
	WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
		deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
	WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_delete` (`piduser` INT)  BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    DELETE FROM tb_users WHERE iduser = piduser;
    DELETE FROM tb_persons WHERE idperson = vidperson;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `desnumber` varchar(16) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `deszipcode` char(8) NOT NULL,
  `desdistrict` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_addresses`
--

INSERT INTO `tb_addresses` (`idaddress`, `idperson`, `desaddress`, `desnumber`, `descomplement`, `descity`, `desstate`, `descountry`, `deszipcode`, `desdistrict`, `dtregister`) VALUES
(1, 48, 'Rua Joaquim Nabuco', '1234', '', 'MaringÃ¡', 'PR', 'Brasil', '87014100', 'Zona 04', '2018-03-09 15:47:20'),
(2, 48, 'Rua Joaquim Nabuco', '', '', 'MaringÃ¡', 'PR', 'Brasil', '87014100', 'Zona 04', '2018-03-09 15:52:22'),
(3, 48, 'Rua Universo', '900', '', 'MaringÃ¡', 'PR', 'Brasil', '87060420', 'Jardim Universo', '2018-03-09 15:52:56');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_carts`
--

INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
(4, 'bum9mueuunttvpgrn9b1aqbi85', NULL, NULL, NULL, NULL, '2018-02-07 15:21:24'),
(5, 'bvt6g5jik8s064im0mantu13hl', NULL, NULL, NULL, NULL, '2018-02-12 19:55:25'),
(6, 'm1om6ejp56a8dvfere0lm24or9', NULL, NULL, NULL, NULL, '2018-02-12 20:01:34'),
(7, 'ilqm1h9vhu75tmnrssi2t3a245', NULL, '87014100', '0.00', 0, '2018-02-14 14:42:08'),
(8, 'ej3kkv2gnvp25v1i296cdiudpn', NULL, '69932970', '183.50', 10, '2018-02-14 16:50:05'),
(9, 'vi2ba7duv6pcnsck1pvjkbd66m', NULL, '87050130', '54.57', 1, '2018-02-14 20:27:30'),
(10, 'kttq8flg9n464voqgggvvecchk', NULL, '87014100', '54.57', 1, '2018-02-15 14:24:17'),
(11, 'fh7hhsvuttiuso9d0tk17igmir', NULL, '87014100', '54.57', 1, '2018-02-16 14:06:15'),
(12, '44ied037k5538mql37fujl4sqr', NULL, '', '0.00', 0, '2018-02-16 14:14:59'),
(13, 'ru1jb9ueleoae66bice0rqku8n', NULL, NULL, NULL, NULL, '2018-02-16 15:10:21'),
(14, '6mm0onrdug2g3sa60uu14t7qca', NULL, NULL, NULL, NULL, '2018-02-16 15:12:24'),
(15, 'mldr1gmq55gl35cg252jcevnj4', NULL, NULL, NULL, NULL, '2018-02-16 15:13:05'),
(16, 'hftg3ooi3gc20lbjiojb9kcl8k', NULL, NULL, NULL, NULL, '2018-02-16 15:14:16'),
(17, '2m8nnl1inocre99ftpn859n2hp', NULL, '87015170', '43.28', 1, '2018-02-16 15:14:28'),
(18, 'na8sehppa9qsqq5vf3ejdafi4l', NULL, '87014100', '54.57', 1, '2018-02-16 15:32:24'),
(19, 'd6gf24s2r77354v5kp1ri0tpko', NULL, '87014100', '43.49', 1, '2018-02-16 15:33:18'),
(20, 'limpvk74ahb2j2ief21bt3mupb', NULL, '87014100', '54.57', 1, '2018-02-16 20:24:15'),
(21, 't0oqftte48rdsns7ln4o0atjhq', NULL, NULL, NULL, NULL, '2018-02-16 20:25:31'),
(22, 'mm44kclp9opsok5jmoo1gormus', NULL, NULL, NULL, NULL, '2018-02-16 20:27:26'),
(23, 'sn4ri1ope9ffmsbvnoekhvrsvu', NULL, '87014100', '43.49', 1, '2018-02-16 20:27:45'),
(24, 'c9mnjfb68nla85ugl3ve7rfgd8', NULL, '87014100', '54.57', 1, '2018-02-19 16:09:08'),
(25, 'ih5sn6oukoknqgclssgffhlc16', NULL, NULL, NULL, NULL, '2018-02-19 19:02:23'),
(26, '8epn70bgapjknrcb3bhhded6qa', NULL, NULL, NULL, NULL, '2018-02-21 13:17:15'),
(27, '7e1mjce9mb169e60b8bdet71bm', 16, NULL, NULL, NULL, '2018-02-22 16:15:49'),
(28, '863vh891bmfq276e9443f415ac', 43, NULL, NULL, NULL, '2018-02-23 16:57:43'),
(29, '9sitcoga4cp4sifkamlga0v6e6', 15, NULL, NULL, NULL, '2018-02-27 11:44:58'),
(30, 'ka0g9o23uod1qstars8fpkr9b1', 1, NULL, NULL, NULL, '2018-02-27 16:31:05'),
(31, '03c43002032ieh9sq05umbgbkp', 13, '87014100', '85.86', 1, '2018-03-02 15:20:56'),
(32, 'ufpvlblpk0u6f3silc1189ibn6', NULL, NULL, NULL, NULL, '2018-03-05 22:02:02'),
(33, 'k5ma0ugithb00v4rdlnt090j9j', NULL, '87050190', '56.34', 1, '2018-03-05 22:03:06'),
(34, 'j5epdcfeedr7f0745d93thhrib', NULL, '87060420', '141.81', 1, '2018-03-07 15:49:04'),
(35, '7os1qgg9angs6r1dfnn16jsl4s', NULL, '87014100', '56.34', 1, '2018-03-07 16:46:59'),
(36, '2omu1m8j7np4qafto634fag292', NULL, '87060420', '85.86', 1, '2018-03-09 15:05:25'),
(37, '6nqg33h6i0mkum6d9ma9c2viu4', 14, '87060120', NULL, NULL, '2018-03-09 15:19:58');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_cartsproducts`
--

INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
(1, 5, 64, '2018-02-12 17:56:21', '2018-02-12 19:55:26'),
(2, 5, 64, '2018-02-12 17:56:23', '2018-02-12 19:55:36'),
(3, 5, 64, '2018-02-12 17:56:25', '2018-02-12 19:55:38'),
(4, 5, 64, '2018-02-12 17:56:40', '2018-02-12 19:55:39'),
(5, 5, 64, '2018-02-12 17:56:42', '2018-02-12 19:55:39'),
(6, 5, 64, '2018-02-12 17:56:45', '2018-02-12 19:56:16'),
(7, 5, 62, NULL, '2018-02-12 19:56:54'),
(8, 5, 81, '2018-02-12 17:57:10', '2018-02-12 19:57:05'),
(9, 5, 81, '2018-02-12 17:57:10', '2018-02-12 19:57:05'),
(10, 5, 81, '2018-02-12 17:57:10', '2018-02-12 19:57:05'),
(11, 5, 81, '2018-02-12 17:57:10', '2018-02-12 19:57:06'),
(12, 5, 81, '2018-02-12 17:57:10', '2018-02-12 19:57:06'),
(13, 5, 81, NULL, '2018-02-12 19:57:20'),
(14, 5, 81, NULL, '2018-02-12 19:57:20'),
(15, 5, 81, NULL, '2018-02-12 19:57:20'),
(16, 6, 81, NULL, '2018-02-12 20:01:34'),
(17, 6, 81, NULL, '2018-02-12 20:02:14'),
(18, 6, 81, NULL, '2018-02-12 20:02:16'),
(19, 6, 63, NULL, '2018-02-12 20:02:32'),
(20, 6, 63, NULL, '2018-02-12 20:02:38'),
(21, 7, 81, NULL, '2018-02-14 14:42:15'),
(22, 7, 64, NULL, '2018-02-14 14:42:22'),
(23, 7, 64, NULL, '2018-02-14 14:42:29'),
(24, 7, 64, NULL, '2018-02-14 14:42:31'),
(25, 7, 64, NULL, '2018-02-14 14:42:32'),
(26, 7, 64, NULL, '2018-02-14 14:42:32'),
(27, 7, 64, NULL, '2018-02-14 14:42:34'),
(28, 7, 64, NULL, '2018-02-14 14:42:36'),
(29, 8, 81, NULL, '2018-02-14 16:50:12'),
(30, 8, 81, NULL, '2018-02-14 16:51:40'),
(31, 8, 81, NULL, '2018-02-14 16:51:43'),
(32, 9, 81, NULL, '2018-02-14 20:29:57'),
(33, 10, 81, '2018-02-15 13:36:58', '2018-02-15 14:24:26'),
(34, 10, 62, NULL, '2018-02-15 15:37:08'),
(35, 10, 62, NULL, '2018-02-15 15:37:14'),
(36, 10, 62, NULL, '2018-02-15 15:37:17'),
(37, 11, 63, '2018-02-16 12:09:57', '2018-02-16 14:06:15'),
(38, 11, 63, '2018-02-16 12:10:00', '2018-02-16 14:06:29'),
(39, 11, 81, '2018-02-16 12:13:08', '2018-02-16 14:12:44'),
(40, 12, 81, '2018-02-16 12:15:35', '2018-02-16 14:15:16'),
(41, 12, 81, '2018-02-16 12:29:23', '2018-02-16 14:28:48'),
(42, 12, 81, '2018-02-16 12:29:27', '2018-02-16 14:28:52'),
(43, 12, 81, '2018-02-16 12:29:30', '2018-02-16 14:28:55'),
(44, 12, 81, '2018-02-16 12:29:33', '2018-02-16 14:28:59'),
(45, 12, 81, '2018-02-16 12:29:36', '2018-02-16 14:29:02'),
(46, 12, 62, '2018-02-16 13:08:18', '2018-02-16 14:30:01'),
(47, 12, 62, NULL, '2018-02-16 14:30:43'),
(48, 12, 62, NULL, '2018-02-16 14:30:46'),
(49, 12, 81, '2018-02-16 13:08:16', '2018-02-16 15:08:12'),
(50, 12, 81, NULL, '2018-02-16 15:09:43'),
(51, 13, 81, '2018-02-16 13:12:07', '2018-02-16 15:10:28'),
(52, 14, 81, NULL, '2018-02-16 15:12:49'),
(53, 17, 81, '2018-02-16 13:20:58', '2018-02-16 15:14:45'),
(54, 17, 81, '2018-02-16 13:21:00', '2018-02-16 15:18:16'),
(55, 17, 81, '2018-02-16 13:21:03', '2018-02-16 15:18:21'),
(56, 17, 81, '2018-02-16 13:21:11', '2018-02-16 15:20:52'),
(57, 17, 64, '2018-02-16 13:23:30', '2018-02-16 15:22:31'),
(58, 17, 65, '2018-02-16 13:23:41', '2018-02-16 15:22:48'),
(59, 17, 62, '2018-02-16 13:29:21', '2018-02-16 15:23:49'),
(60, 18, 81, '2018-02-16 13:32:57', '2018-02-16 15:32:41'),
(61, 18, 81, '2018-02-16 13:32:59', '2018-02-16 15:32:46'),
(62, 19, 62, '2018-02-16 13:35:08', '2018-02-16 15:33:39'),
(63, 19, 65, '2018-02-16 13:35:06', '2018-02-16 15:33:45'),
(64, 19, 62, '2018-02-16 13:35:09', '2018-02-16 15:33:48'),
(65, 19, 65, '2018-02-16 13:35:40', '2018-02-16 15:35:17'),
(66, 20, 81, '2018-02-16 18:24:58', '2018-02-16 20:24:43'),
(67, 23, 81, '2018-02-16 18:36:46', '2018-02-16 20:27:53'),
(68, 23, 81, '2018-02-16 18:36:46', '2018-02-16 20:28:04'),
(69, 23, 81, '2018-02-16 18:36:46', '2018-02-16 20:36:19'),
(70, 23, 81, '2018-02-16 18:36:46', '2018-02-16 20:36:42'),
(71, 23, 65, '2018-02-16 18:38:14', '2018-02-16 20:38:05'),
(72, 24, 81, '2018-02-21 09:29:26', '2018-02-19 16:09:16'),
(73, 24, 81, '2018-02-21 09:29:26', '2018-02-19 16:09:19'),
(74, 24, 81, '2018-02-21 09:29:26', '2018-02-19 16:09:56'),
(75, 24, 62, '2018-02-21 09:29:24', '2018-02-19 19:02:38'),
(76, 24, 62, '2018-02-21 09:29:24', '2018-02-19 19:03:07'),
(77, 24, 81, '2018-02-26 12:08:59', '2018-02-21 12:29:34'),
(78, 26, 65, NULL, '2018-02-21 13:17:21'),
(79, 24, 81, '2018-02-26 13:09:06', '2018-02-26 15:08:49'),
(80, 24, 81, NULL, '2018-02-26 21:09:16'),
(81, 31, 81, NULL, '2018-03-02 15:21:05'),
(82, 31, 64, '2018-03-05 18:16:51', '2018-03-05 15:18:10'),
(83, 31, 81, NULL, '2018-03-05 15:19:30'),
(84, 33, 81, NULL, '2018-03-05 22:04:03'),
(85, 34, 64, NULL, '2018-03-07 15:49:45'),
(86, 34, 65, NULL, '2018-03-07 16:05:14'),
(87, 34, 81, NULL, '2018-03-07 16:07:05'),
(88, 34, 81, NULL, '2018-03-07 16:08:32'),
(89, 34, 65, NULL, '2018-03-07 16:38:41'),
(90, 35, 81, NULL, '2018-03-07 16:46:59'),
(91, 36, 81, NULL, '2018-03-09 15:05:25'),
(92, 36, 81, NULL, '2018-03-09 15:13:18');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(2, 'Google', '2018-01-16 14:04:14'),
(5, 'Android', '2018-01-16 14:05:39'),
(7, 'Azus', '2018-01-23 15:08:05');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categoriesproducts`
--

CREATE TABLE `tb_categoriesproducts` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categoriesproducts`
--

INSERT INTO `tb_categoriesproducts` (`idcategory`, `idproduct`) VALUES
(5, 62);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 03:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 03:00:00'),
(3, 'Pago', '2017-03-13 03:00:00'),
(4, 'Entregue', '2017-03-13 03:00:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(1, 'Xbyte', 'admin@xbyte.com.br', 4499756, '2017-03-01 03:00:00'),
(7, 'Suporte', 'biancagarciadossantos2014@gmail.com', 1112345678, '2017-03-15 16:10:27'),
(10, 'Johnny', 'jhone.henrique@hotmail.com', 4430251271, '2018-01-15 01:49:40'),
(13, 'Jhone Henrique', 'jhone.henrique.info@gmail.com', 4430251271, '2018-01-15 04:23:09'),
(16, '', '', 0, '2018-02-22 16:13:45'),
(21, '', 'jhone.henrique.info@gmail.com', 4430251271, '2018-02-22 16:22:41'),
(22, 'Jhone', 'jhone.henrique.info@gmail.com', 4430251271, '2018-02-22 16:30:28'),
(24, 'jhone', 'jhone.henrique.info@gmail.com', 4430251271, '2018-02-22 16:31:18'),
(31, 'Jhone', 'jhone.henrique.info@gmail.com', 4430251271, '2018-02-23 16:20:21'),
(32, 'Jhonlel', 'jhone.henrique.info@gmail.com', 4430251271, '2018-02-23 16:22:55'),
(33, 'Jhonlel', 'jhone.henrique.info@gmail.com', 4430251271, '2018-02-23 16:24:55'),
(34, 'Jhone', 'jhone.henrique.info@gmail.com', 4430251271, '2018-02-23 16:27:05'),
(35, 'Jhone', 'jhone.henrique.info@gmail.com', 4430251271, '2018-02-23 16:27:17'),
(36, 'jhone Henrique', 'jhone.henrique@hotmail.com', 4499759218, '2018-02-23 16:29:26'),
(37, 'jhone Henrique', 'jhone.henrique256@hotmail.com', 4499759218, '2018-02-23 16:30:24'),
(38, 'Henrique xxx', 'jhone.henrique2568@hotmail.com', 4499759218, '2018-02-23 16:30:51'),
(39, 'Henrique xxx', 'jhone.henrique2568@hotmail.com', 4499759218, '2018-02-23 16:41:43'),
(40, 'Henrique xxx', 'jhone.henrique2568@hotmail.com', 4499759218, '2018-02-23 16:52:01'),
(41, 'Henrique xxx', 'jhone.henrique256548@hotmail.com', 4499759218, '2018-02-23 16:52:33'),
(42, 'Henrique xxx', 'jhone.henrique48@hotmail.com', 4499759218, '2018-02-23 16:55:10'),
(43, 'lupp', 'jhone.henrique.info9@gmail.com', 4430251271, '2018-02-23 16:57:42'),
(44, 'Henrique 123', 'jhone.henrique489@hotmail.com', 4499759218, '2018-02-23 21:10:34'),
(45, 'xbyte', 'jhone@xbyte.com.br', 4430251271, '2018-02-26 15:11:07'),
(46, 'Oliver', 'jhone@oliverdigital.com.br', 4430251271, '2018-02-26 16:41:14'),
(47, 'xxx', 'jhone.henrique@hotmail.com', 4499759218, '2018-02-27 11:51:39'),
(48, 'Oliver Digital', 'jhone.henrique.info@gmail.com', 4430251271, '2018-03-05 21:14:12');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(62, 'Smartphone Motorola Moto G5 Plus', '1135.23', '15.20', '7.40', '0.70', '0.16', 'smartphone-motorola-moto-g5-plus', '2018-01-28 19:57:14'),
(63, 'Smartphone Samsung Galaxy J3 Dual', '679.90', '14.20', '7.10', '0.70', '0.14', 'smartphone-samsung-galaxy-j3', '2018-01-28 19:57:33'),
(64, 'Smartphone Samsung Galaxy J5 Pro', '1299.00', '14.60', '7.10', '0.80', '0.16', 'smartphone-samsung-galaxy-j5', '2018-01-28 19:57:53'),
(65, 'Smartphone Samsung Galaxy J7 Prime', '1149.00', '15.10', '7.50', '0.80', '0.16', 'smartphone-samsung-galaxy-j7', '2018-01-28 19:58:09'),
(81, 'XSmartphone Moto Z Play', '1887.78', '14.10', '0.90', '1.16', '0.30', 'smartphone-moto-z-play', '2018-01-29 01:21:04');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_productscategories`
--

INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
(2, 62),
(5, 62),
(5, 65),
(7, 62),
(7, 63),
(7, 81);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT '0',
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(1, 1, 'admin', '$2y$12$rOUG9OxwscCH8Ym3ICUNCemEI8aUT2nKWaunbo2PmVxulVENGu9Ge', 1, '2017-03-13 03:00:00'),
(13, 13, 'jhone.henrique.info@gmail.com', '$2y$12$a5j9KE0FNex3b4YlcW3F.eZ0r8UknlLySt7aYjzoWslPwBOZeYYzC', 1, '2018-01-15 04:23:09'),
(14, 48, 'jhone@oliverdigital.com.br', '$2y$12$AEfdUV1MIXYHsNWg7x0S.uP3pLc/jYUAaNKw3gS.DCWJSmnNhUyqm', 0, '2018-03-05 21:14:12');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(1, 7, '127.0.0.1', NULL, '2017-03-15 16:10:59'),
(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 16:11:18'),
(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 16:37:12'),
(4, 10, '127.0.0.1', NULL, '2018-01-15 01:57:21'),
(5, 10, '127.0.0.1', NULL, '2018-01-15 01:57:43'),
(6, 10, '127.0.0.1', NULL, '2018-01-15 02:06:15'),
(7, 10, '127.0.0.1', NULL, '2018-01-15 02:10:03'),
(8, 10, '127.0.0.1', NULL, '2018-01-15 02:12:30'),
(9, 10, '127.0.0.1', NULL, '2018-01-15 02:14:38'),
(10, 7, '127.0.0.1', NULL, '2018-01-15 02:19:21'),
(11, 10, '127.0.0.1', '2018-01-15 01:56:19', '2018-01-15 03:55:50'),
(12, 10, '127.0.0.1', NULL, '2018-01-15 03:59:26'),
(13, 7, '127.0.0.1', NULL, '2018-01-15 04:02:05'),
(14, 10, '127.0.0.1', '2018-01-15 02:04:22', '2018-01-15 04:03:57'),
(15, 10, '127.0.0.1', NULL, '2018-01-15 04:17:35'),
(16, 13, '127.0.0.1', NULL, '2018-01-15 04:23:31'),
(17, 13, '127.0.0.1', '2018-01-15 02:25:10', '2018-01-15 04:24:31'),
(18, 13, '127.0.0.1', NULL, '2018-01-15 12:08:16'),
(19, 13, '127.0.0.1', NULL, '2018-02-26 15:17:39'),
(20, 13, '127.0.0.1', NULL, '2018-02-26 16:14:54'),
(21, 13, '127.0.0.1', '2018-02-26 13:17:34', '2018-02-26 16:17:01'),
(22, 14, '127.0.0.1', NULL, '2018-02-26 16:37:24'),
(23, 14, '127.0.0.1', NULL, '2018-02-26 16:39:33'),
(24, 13, '127.0.0.1', NULL, '2018-02-26 16:40:02'),
(25, 15, '127.0.0.1', NULL, '2018-02-26 16:41:30'),
(26, 13, '127.0.0.1', '2018-02-27 12:20:10', '2018-02-27 15:18:52'),
(27, 13, '127.0.0.1', NULL, '2018-02-27 18:03:39'),
(28, 13, '127.0.0.1', '2018-02-28 12:17:10', '2018-02-28 15:16:43'),
(29, 13, '127.0.0.1', '2018-02-28 12:41:56', '2018-02-28 15:41:14'),
(30, 13, '127.0.0.1', '2018-02-28 13:40:42', '2018-02-28 16:39:32'),
(31, 13, '127.0.0.1', NULL, '2018-03-01 15:14:45'),
(32, 13, '127.0.0.1', NULL, '2018-03-01 15:18:03'),
(33, 13, '127.0.0.1', '2018-03-01 12:19:40', '2018-03-01 15:19:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Indexes for table `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`);

--
-- Indexes for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `FK_cartsproducts_products_idx` (`idproduct`);

--
-- Indexes for table `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Indexes for table `tb_categoriesproducts`
--
ALTER TABLE `tb_categoriesproducts`
  ADD PRIMARY KEY (`idcategory`,`idproduct`);

--
-- Indexes for table `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_carts_idx` (`idcart`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`);

--
-- Indexes for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Indexes for table `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Indexes for table `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Indexes for table `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Indexes for table `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Indexes for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Indexes for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  MODIFY `idaddress` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tb_carts`
--
ALTER TABLE `tb_carts`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD CONSTRAINT `fk_userspasswordsrecoveries_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
