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
  id_pagos   INT NOT NULL AUTO_INCREMENT,
  id_cliente INT NOT NULL,
  PRIMARY KEY (id_pagos)
  monto DECIMAL(10, 2) NOT NULL
  fecha_pago DATETIME NOT NULL
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

--Insertar registros de clientes que solicitan el servicio


--Insertar registro de articulos registrados por cada cliente


--Insertar citas para agendar los retiros de los articulos reciclados


--Insertar pagos realizados por los clientes


--Actualizar una cita para un cliente, cambiando la fecha de la cita si se presenta un conflicto de horarios


--Actualizar el estado de un artículo reciclado (por ejemplo, de “pendiente” a “reciclado”)


--Eliminar registros de artículos reciclados que hayan sido removidos por error


--Eliminar citas que hayan sido canceladas

