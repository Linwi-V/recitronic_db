CREATE DATABASE recitronic;
USE recitronic;

CREATE TABLE Clientes
(
  id_cliente INT     NOT NULL AUTO_INCREMENT,
  nombre     VARCHAR(100) NOT NULL,
  telefono   VARCHAR(100) NOT NULL,
  direccion  VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_cliente)
);

CREATE TABLE Articulos
(
  id_articulo   INT     NOT NULL AUTO_INCREMENT,
  id_cliente    INT     NOT NULL,
  tipo_articulo VARCHAR(100) NOT NULL,
  estado        VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_articulo)
);

CREATE TABLE Citas
(
  id_cita    INT      NOT NULL AUTO_INCREMENT,
  id_cliente INT      NOT NULL,
  fecha_hora DATETIME NOT NULL,
  PRIMARY KEY (id_cita)
);

CREATE TABLE Pagos
(
  id_pagos   INT      NOT NULL AUTO_INCREMENT,
  id_cliente INT      NOT NULL,
  monto      DECIMAL(10,2)  NOT NULL,
  fecha_pago DATETIME NOT NULL,
  PRIMARY KEY (id_pagos)
);

ALTER TABLE Articulos
  ADD CONSTRAINT FK_Clientes_TO_Articulos
    FOREIGN KEY (id_cliente)
    REFERENCES Clientes (id_cliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE Citas
  ADD CONSTRAINT FK_Clientes_TO_Citas
    FOREIGN KEY (id_cliente)
    REFERENCES Clientes (id_cliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE Pagos
  ADD CONSTRAINT FK_Clientes_TO_Pagos
    FOREIGN KEY (id_cliente)
    REFERENCES Clientes (id_cliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Agregar restricciones de integridad
ALTER TABLE Articulos
ADD CONSTRAINT check_estado 
CHECK (estado IN ('pendiente', 'reciclado'));

ALTER TABLE Articulos
ADD CONSTRAINT check_tipo 
CHECK (tipo_articulo IN ('plastico', 'vidrio', 'metal'));


--Insertar registros de clientes que solicitan el servicio
INSERT INTO Clientes (nombre, telefono, direccion) VALUES
('Juan Perez', '555-1234', 'Calle Falsa 123'),
('Maria Gomez', '555-5678', 'Avenida Siempre Viva 456'),
('Carlos Lopez', '555-8765', 'Boulevard Central 789'),
('Ana Martinez', '555-4321', 'Calle del Sol 101'),
('Luis Rodriguez', '555-6789', 'Avenida de la Luna 202');

--Insertar registro de articulos registrados por cada cliente
INSERT INTO Articulos (id_cliente, tipo_articulo, estado) VALUES
(1, 'plastico', 'pendiente'),
(2, 'vidrio', 'pendiente'),
(3, 'metal', 'pendiente'),
(4, 'plastico', 'pendiente'),
(5, 'vidrio', 'pendiente'),
(1, 'metal', 'reciclado'),
(2, 'plastico', 'reciclado'),
(3, 'vidrio', 'reciclado'),
(4, 'metal', 'pendiente'),
(5, 'plastico', 'pendiente');

--Insertar citas para agendar los retiros de los articulos reciclados
INSERT INTO Citas (id_cliente, fecha_hora) VALUES
(1, '2025-07-01 10:00:00'),
(2, '2025-07-02 11:00:00'),
(3, '2025-07-03 12:00:00'),
(4, '2025-07-04 13:00:00'),
(5, '2025-07-05 14:00:00');

--Insertar pagos realizados por los clientes
INSERT INTO Pagos (id_cliente, monto, fecha_pago) VALUES
(1, 5000.11, '2025-07-01 10:30:00'),
(2, 7500.99, '2025-07-02 11:30:00'),
(3, 1000.99, '2025-07-03 12:30:00'),
(4, 1250.65, '2025-07-04 13:30:00'),
(5, 1500.23, '2025-07-05 14:30:00'),
(1, 6000.22, '2025-07-06 15:30:00'),
(2, 8000.69, '2025-07-07 16:30:00'),
(3, 1100.08, '2025-07-08 17:30:00'),
(4, 1300.15, '2025-07-09 18:30:00'),
(5, 1600.99, '2025-07-10 19:30:00');

-- Establecer nivel de aislamiento
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;
--Actualizar una cita para un cliente, cambiando la fecha de la cita si se presenta un conflicto de horarios
UPDATE Citas SET fecha_hora = '2025-07-02 13:00:00' WHERE id_cita = 2;
SELECT * FROM Citas WHERE id_cita = 2;

--Actualizar el estado de un artículo reciclado (por ejemplo, de “pendiente” a “reciclado”)
UPDATE articulos
SET estado =
    CASE
        WHEN estado = 'pendiente' THEN 'reciclado'
        WHEN estado = 'reciclado' THEN 'pendiente'
    END
WHERE id_articulo = 1;

--Eliminar registros de artículos reciclados que hayan sido removidos por error
DELETE FROM Articulos 
WHERE estado = 'reciclado'
AND id_cliente = 3;

--Eliminar citas que hayan sido canceladas
DELETE FROM Citas
WHERE id_cliente = 5;

-- Si todo está bien, confirmamos los cambios
COMMIT;

-- Si algo falla, revertimos todo
ROLLBACK;