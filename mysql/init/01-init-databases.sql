-- Criação dos bancos do ecossistema RouterLink
CREATE DATABASE IF NOT EXISTS `erp_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `adm_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `fiscal_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Garante que o usuário da aplicação tenha acesso total aos bancos
CREATE USER IF NOT EXISTS 'router_user'@'%' IDENTIFIED BY 'router_pass';
GRANT ALL PRIVILEGES ON `erp_db`.* TO 'router_user'@'%';
GRANT ALL PRIVILEGES ON `adm_db`.* TO 'router_user'@'%';
GRANT ALL PRIVILEGES ON `fiscal_db`.* TO 'router_user'@'%';
FLUSH PRIVILEGES;
