-- Data Center Management Database Schema --

CREATE SCHEMA IF NOT EXISTS `datacenter_db` DEFAULT CHARACTER SET utf8mb4;
USE `datacenter_db`;

-- Tabla Zona --
CREATE TABLE Zona (
  idZona INT NOT NULL AUTO_INCREMENT,
  Nombre VARCHAR(45) NOT NULL,
  Descripcion VARCHAR(200),
  PRIMARY KEY (idZona)
) ENGINE = InnoDB;

-- Tabla SistemaRefrigeracion --
CREATE TABLE SistemaRefrigeracion (
  idSistema_Refrigeracion INT NOT NULL AUTO_INCREMENT,
  idZona INT NOT NULL,
  Eficiencia_Energia DECIMAL(5,2) NOT NULL,
  Capacidad DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (idSistema_Refrigeracion),
  FOREIGN KEY (idZona)
    REFERENCES Zona(idZona)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Tabla Rack --
CREATE TABLE Rack (
  idRack INT NOT NULL AUTO_INCREMENT,
  idZona INT NOT NULL,
  Ubicacion VARCHAR(45) NOT NULL,
  Codigo VARCHAR(45) NOT NULL,
  PRIMARY KEY (idRack),
  FOREIGN KEY (idZona)
    REFERENCES Zona(idZona)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Tabla Rol --
CREATE TABLE Rol (
  idRol INT NOT NULL AUTO_INCREMENT,
  NombreRol VARCHAR(45) NOT NULL,
  Descripcion VARCHAR(200),
  PRIMARY KEY (idRol)
) ENGINE = InnoDB;

-- Tabla Usuario --
CREATE TABLE Usuario (
  idUsuario INT NOT NULL AUTO_INCREMENT,
  idRol INT NOT NULL,
  Nombre VARCHAR(45) NOT NULL,
  Email VARCHAR(200) NOT NULL UNIQUE,
  PRIMARY KEY (idUsuario),
  FOREIGN KEY (idRol)
    REFERENCES Rol(idRol)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Tabla Servidor --
CREATE TABLE Servidor (
  idServidor INT NOT NULL AUTO_INCREMENT,
  idRack INT NOT NULL,
  Modelo VARCHAR(45) NOT NULL,
  Estado ENUM('activo','retirado') NOT NULL DEFAULT 'activo',
  PRIMARY KEY (idServidor),
  FOREIGN KEY (idRack)
    REFERENCES Rack(idRack)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Tabla Registro_Medicion --
CREATE TABLE Registro_Medicion (
  idRegistro_Medicion INT NOT NULL AUTO_INCREMENT,
  idServidor INT NOT NULL,
  idUsuario INT NOT NULL,
  Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Temperatura DECIMAL(5,2) NOT NULL,
  ConsumoEnergetico DECIMAL(8,2) NOT NULL,
  EmisionesCO2 DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (idRegistro_Medicion),
  FOREIGN KEY (idServidor)
    REFERENCES Servidor(idServidor)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (idUsuario)
    REFERENCES Usuario(idUsuario)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Indexes (Optimization) --
CREATE INDEX idx_servidor
ON Registro_Medicion (idServidor);

CREATE INDEX idx_fecha
ON Registro_Medicion (Fecha);

CREATE INDEX idx_zona_rack
ON Rack (idZona);
