-- =====================================================
-- БАЗА ДАННЫХ: АГРО
-- СОЗДАНИЕ ВСЕХ ТАБЛИЦ (20 таблиц)
-- =====================================================

USE АГРО;
GO

-- 1. Роли пользователей
CREATE TABLE Роли (
    ид_роли INT IDENTITY(1,1) PRIMARY KEY,
    название VARCHAR(50) NOT NULL UNIQUE,
    описание VARCHAR(200) NULL
);
GO

-- 2. Пользователи (из твоего JSON)
CREATE TABLE Пользователи (
    ид_пользователя INT IDENTITY(1,1) PRIMARY KEY,
    логин VARCHAR(50) NOT NULL UNIQUE,
    пароль_хеш VARCHAR(100) NOT NULL,
    фио VARCHAR(150) NOT NULL,
    роль VARCHAR(50) NOT NULL,
    email VARCHAR(100) NULL,
    телефон VARCHAR(20) NULL,
    активен BIT DEFAULT 1,
    последний_вход DATETIME2 NULL,
    создан DATETIME2 DEFAULT GETDATE(),
    отдел VARCHAR(100) NULL
);
GO

-- 3. Продукты
CREATE TABLE Продукты (
    ид_продукта INT IDENTITY(1,1) PRIMARY KEY,
    код_продукта VARCHAR(30) NOT NULL UNIQUE,
    название VARCHAR(150) NOT NULL,
    тип VARCHAR(50) NULL,
    форма_выпуска VARCHAR(50) NULL,
    статус VARCHAR(20) DEFAULT 'Активен'
);
GO

-- 4. Компоненты
CREATE TABLE Компоненты (
    ид_компонента INT IDENTITY(1,1) PRIMARY KEY,
    название VARCHAR(100) NOT NULL,
    единица_измерения VARCHAR(10) NOT NULL,
    описание VARCHAR(200) NULL
);
GO

-- 5. Оборудование
CREATE TABLE Оборудование (
    ид_оборудования INT IDENTITY(1,1) PRIMARY KEY,
    наименование VARCHAR(100) NOT NULL,
    тип VARCHAR(50) NOT NULL,
    линия VARCHAR(20) NULL,
    статус VARCHAR(20) DEFAULT 'Работает'
);
GO

-- 6. Рецептуры (из recipe)
CREATE TABLE Рецептуры (
    ид_рецептуры INT IDENTITY(1,1) PRIMARY KEY,
    название VARCHAR(100) NOT NULL,
    версия INT NOT NULL,
    статус VARCHAR(20) DEFAULT 'Черновик',
    создан DATETIME2 DEFAULT GETDATE()
);
GO

-- 7. Производственные заказы (из production_order)
CREATE TABLE Производственные_заказы (
    ид_заказа INT IDENTITY(1,1) PRIMARY KEY,
    номер_заказа VARCHAR(30) NOT NULL UNIQUE,
    ид_рецептуры INT NOT NULL,
    количество_план DECIMAL(12,2) NOT NULL,
    статус VARCHAR(30) DEFAULT 'Черновик',
    дата_начала_план DATE NULL
);
GO

-- 8. Партии (из batch)
CREATE TABLE Партии (
    ид_партии INT IDENTITY(1,1) PRIMARY KEY,
    номер_партии VARCHAR(30) NOT NULL UNIQUE,
    ид_заказа INT NOT NULL,
    время_старта DATETIME2 NULL,
    время_окончания DATETIME2 NULL,
    статус VARCHAR(30) DEFAULT 'Планируется',
    количество_факт DECIMAL(12,2) NULL
);
GO

-- 9. Шаги производства (из production_step)
CREATE TABLE Шаги_производства (
    ид_шага INT IDENTITY(1,1) PRIMARY KEY,
    ид_партии INT NOT NULL,
    порядковый_номер INT NOT NULL,
    название_шага VARCHAR(100) NOT NULL,
    температура_план DECIMAL(8,2) NULL,
    температура_факт DECIMAL(8,2) NULL,
    время_план_мин INT NULL,
    время_факт_мин INT NULL,
    давление_план DECIMAL(8,2) NULL,
    давление_факт DECIMAL(8,2) NULL,
    флаг_отклонения BIT DEFAULT 0,
    комментарий_оператора VARCHAR(500) NULL
);
GO

-- 10. Контроль качества (из quality_control)
CREATE TABLE Контроль_качества (
    ид_контроля INT IDENTITY(1,1) PRIMARY KEY,
    ид_партии INT NOT NULL,
    дата_анализа DATETIME2 NOT NULL,
    тип_образца VARCHAR(50) NOT NULL,
    название_параметра VARCHAR(100) NOT NULL,
    значение_измеренное VARCHAR(50) NOT NULL,
    значение_норма VARCHAR(50) NULL,
    единица_измерения VARCHAR(20) NULL,
    результат VARCHAR(20) NOT NULL,
    решение VARCHAR(30) NOT NULL,
    комментарий_лаборанта VARCHAR(500) NULL
);
GO

-- =====================================================
-- ДОПОЛНИТЕЛЬНЫЕ ТАБЛИЦЫ ПО ТЗ
-- =====================================================

-- 11. Состав рецептуры (компоненты с долями)
CREATE TABLE Состав_рецептуры (
    ид_состава INT IDENTITY(1,1) PRIMARY KEY,
    ид_рецептуры INT NOT NULL,
    ид_компонента INT NOT NULL,
    доля_процент DECIMAL(8,4) NOT NULL,
    порядок_загрузки INT NOT NULL
);
GO

-- 12. Технологические карты
CREATE TABLE Технологические_карты (
    ид_техкарты INT IDENTITY(1,1) PRIMARY KEY,
    ид_продукта INT NOT NULL,
    ид_рецептуры INT NOT NULL,
    версия INT NOT NULL,
    статус VARCHAR(20) DEFAULT 'Черновик',
    утверждена DATETIME2 NULL
);
GO

-- 13. Отклонения
CREATE TABLE Отклонения (
    ид_отклонения INT IDENTITY(1,1) PRIMARY KEY,
    ид_партии INT NOT NULL,
    ид_шага INT NULL,
    тип VARCHAR(50) NOT NULL,
    серьезность VARCHAR(20) DEFAULT 'Средняя',
    описание VARCHAR(500) NOT NULL,
    дата_время DATETIME2 DEFAULT GETDATE(),
    ид_зафиксировал INT NULL,
    решение VARCHAR(500) NULL
);
GO

-- 14. Журнал событий
CREATE TABLE Журнал_событий (
    ид_события INT IDENTITY(1,1) PRIMARY KEY,
    ид_пользователя INT NOT NULL,
    тип_события VARCHAR(50) NOT NULL,
    сущность VARCHAR(50) NOT NULL,
    ид_сущности INT NOT NULL,
    описание VARCHAR(500) NOT NULL,
    дата_время DATETIME2 DEFAULT GETDATE()
);
GO

-- 15. Партии сырья
CREATE TABLE Партии_сырья (
    ид_партии_сырья INT IDENTITY(1,1) PRIMARY KEY,
    номер_партии VARCHAR(30) NOT NULL UNIQUE,
    ид_компонента INT NOT NULL,
    поставщик VARCHAR(100) NULL,
    количество DECIMAL(12,3) NOT NULL,
    дата_поступления DATE NOT NULL,
    качество_статус VARCHAR(20) DEFAULT 'Ожидание'
);
GO

-- 16. Расход сырья в партии
CREATE TABLE Расход_сырья (
    ид_расхода INT IDENTITY(1,1) PRIMARY KEY,
    ид_партии INT NOT NULL,
    ид_партии_сырья INT NOT NULL,
    количество_факт DECIMAL(12,3) NOT NULL
);
GO

-- 17. Испытания (лабораторные)
CREATE TABLE Испытания (
    ид_испытания INT IDENTITY(1,1) PRIMARY KEY,
    тип_испытания VARCHAR(30) NOT NULL,
    ид_партии INT NULL,
    ид_партии_сырья INT NULL,
    статус VARCHAR(20) DEFAULT 'Создано',
    дата_назначения DATETIME2 DEFAULT GETDATE(),
    ид_лаборант INT NULL
);
GO

-- 18. Результаты испытаний
CREATE TABLE Результаты_испытаний (
    ид_результата INT IDENTITY(1,1) PRIMARY KEY,
    ид_испытания INT NOT NULL,
    показатель VARCHAR(50) NOT NULL,
    норма_мин VARCHAR(20) NULL,
    норма_макс VARCHAR(20) NULL,
    значение_факт VARCHAR(50) NOT NULL,
    соответствует BIT NULL
);
GO

-- 19. Лабораторные решения
CREATE TABLE Лабораторные_решения (
    ид_решения INT IDENTITY(1,1) PRIMARY KEY,
    ид_партии INT NULL,
    ид_партии_сырья INT NULL,
    решение VARCHAR(30) NOT NULL,
    причина VARCHAR(500) NULL,
    дата_решения DATETIME2 DEFAULT GETDATE()
);
GO

-- 20. Индексы
CREATE INDEX IX_Партии_Статус ON Партии(статус);
CREATE INDEX IX_Партии_Номер ON Партии(номер_партии);
CREATE INDEX IX_Шаги_Партия ON Шаги_производства(ид_партии);
CREATE INDEX IX_Контроль_Партия ON Контроль_качества(ид_партии);
CREATE INDEX IX_Журнал_Дата ON Журнал_событий(дата_время);
GO

SELECT 'Все 20 таблиц созданы' AS Статус;
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_NAME;
GO