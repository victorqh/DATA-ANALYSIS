create database BDClinica

use BDClinica

-- Dim_Pacientes: Información sobre los pacientes
CREATE TABLE Dim_Pacientes (
    PacienteID INT PRIMARY KEY IDENTITY(1,1),  -- Clave primaria
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    FechaNacimiento DATE,
    Genero CHAR(1),
    Direccion NVARCHAR(255),
    Telefono NVARCHAR(15),
    DNI NVARCHAR(15) UNIQUE
);

-- Dim_Fechas: Información sobre las fechas
CREATE TABLE Dim_Fechas (
    Fecha DATE PRIMARY KEY,               -- Clave primaria en Dim_Fechas
	Anio NVARCHAR(50),
    NombreDia NVARCHAR(50),               -- Nombre del día
    NombreMes NVARCHAR(50),               -- Nombre del mes
    Trimestre INT,                        -- Trimestre
    Semana INT                            -- Semana del año
);

-- Dim_Medicos: Información sobre los médicos
CREATE TABLE Dim_Medicos (
    MedicoID INT PRIMARY KEY IDENTITY(1,1),  -- Clave primaria
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    Especialidad NVARCHAR(50) NOT NULL,
    Telefono NVARCHAR(15),
    Correo NVARCHAR(50)
);

-- Dim_Consultorios: Información sobre los consultorios
CREATE TABLE Dim_Consultorios (
    NConsultorio INT PRIMARY KEY,  -- Número del consultorio como clave primaria
    Piso INT
);


-- Dim_Servicios: Información sobre los servicios médicos
CREATE TABLE Dim_Servicios (
    ServicioID INT PRIMARY KEY IDENTITY(1,1),  -- Clave primaria
    NombreServicio NVARCHAR(50) NOT NULL,
	Descripcion NVARCHAR(255)
);

-- Citas: Información sobre las citas médicas (hechos)
CREATE TABLE Citas (
    CitaID INT PRIMARY KEY IDENTITY(1,1),     -- Clave primaria de la cita
    PacienteID INT NOT NULL,                   -- Clave foránea hacia Dim_Pacientes
    Fecha DATE,                                -- Fecha de la cita
    Hora TIME NOT NULL,                        -- Hora de la cita
    MedicoID INT NOT NULL,                     -- Clave foránea hacia Dim_Medicos
    NConsultorio INT NOT NULL,                -- Clave foránea hacia Dim_Consultorios
    ServicioID INT NOT NULL,                   -- Clave foránea hacia Dim_Servicios
    Motivo NVARCHAR(255),                      -- Motivo de la cita
    Estado NVARCHAR(50),                       -- Estado de la cita (Ej. Programada, Cancelada)
    
    -- Definición de claves foráneas
    FOREIGN KEY (PacienteID) REFERENCES Dim_Pacientes(PacienteID),
    FOREIGN KEY (Fecha) REFERENCES Dim_Fechas(Fecha),  -- Usamos la fecha como clave foránea
    FOREIGN KEY (MedicoID) REFERENCES Dim_Medicos(MedicoID),
    FOREIGN KEY (NConsultorio) REFERENCES Dim_Consultorios(NConsultorio),
    FOREIGN KEY (ServicioID) REFERENCES Dim_Servicios(ServicioID)
);


DECLARE @Fecha DATE = '2024-01-01';
DECLARE @FechaFin DATE = '2025-12-31';

WHILE @Fecha <= @FechaFin
BEGIN
    -- Verificar si la fecha ya existe en Dim_Fechas
    IF NOT EXISTS (SELECT 1 FROM Dim_Fechas WHERE Fecha = @Fecha)
    BEGIN
        -- Insertar la fecha en Dim_Fechas si no existe
        INSERT INTO Dim_Fechas (Fecha, Anio, NombreDia, NombreMes, Trimestre, Semana)
        VALUES 
        (
            @Fecha,
            YEAR(@Fecha),                    -- Año (Ej. 2024)
            DATENAME(WEEKDAY, @Fecha),        -- Nombre del día (Ej. Lunes)
            DATENAME(MONTH, @Fecha),          -- Nombre del mes (Ej. Noviembre, Diciembre)
            DATEPART(QUARTER, @Fecha),        -- Trimestre (1, 2, 3, 4)
            DATEPART(WEEK, @Fecha)            -- Semana del año
        );
    END
    
    -- Avanzar al siguiente día
    SET @Fecha = DATEADD(DAY, 1, @Fecha);
END;


-- Verificar los datos en la tabla de pacientes
SELECT * FROM Dim_Pacientes;
SELECT * FROM Dim_Servicios;
select * from Dim_Consultorios
SELECT * FROM Dim_Medicos;
SELECT * FROM Dim_Fechas;
SELECT * FROM Citas;

-- Insertar los consultorios
INSERT INTO Dim_Consultorios (NConsultorio, Piso)
VALUES
(101, 1), (102, 1), (103, 1), (104, 1), (105, 1),  -- Piso 1
(201, 2), (202, 2), (203, 2), (204, 2), (205, 2),  -- Piso 2
(301, 3), (302, 3), (303, 3), (304, 3), (305, 3),  -- Piso 3
(401, 4), (402, 4), (403, 4), (404, 4), (405, 4),  -- Piso 4
(501, 5), (502, 5), (503, 5), (504, 5), (505, 5),  -- Piso 5
(601, 6), (602, 6), (603, 6), (604, 6), (605, 6);  -- Piso 6

-- Insertar los servicios en la tabla Dim_Servicios
INSERT INTO Dim_Servicios (NombreServicio, Descripcion)
VALUES
('Medicina General', 'Atención primaria, diagnóstico y tratamiento de enfermedades comunes.'),
('Urgencias', 'Atención médica inmediata para situaciones de emergencia o accidentes.'),
('Pediatría', 'Atención médica para niños y adolescentes, control del crecimiento y desarrollo.'),
('Ginecoobstetricia', 'Atención médica a la mujer en embarazo, parto y salud reproductiva.'),
('Cardiología', 'Diagnóstico y tratamiento de enfermedades del corazón y el sistema circulatorio.'),
('Dermatología', 'Tratamiento de afecciones de la piel, cabello y uñas.'),
('Oftalmología', 'Diagnóstico y tratamiento de enfermedades de los ojos y la visión.'),
('Otorrinolaringología', 'Tratamiento de enfermedades del oído, nariz y garganta.'),
('Traumatología y Ortopedia', 'Tratamiento de lesiones y enfermedades de los huesos, articulaciones, músculos y ligamentos.'),
('Endocrinología', 'Tratamiento de trastornos hormonales y del sistema endocrino, como diabetes.'),
('Neurología', 'Diagnóstico y tratamiento de enfermedades del sistema nervioso.'),
('Psiquiatría', 'Diagnóstico y tratamiento de trastornos mentales y emocionales.'),
('Urología', 'Tratamiento de problemas del tracto urinario y los órganos reproductores masculinos.'),
('Reumatología', 'Tratamiento de enfermedades autoinmunes y trastornos musculoesqueléticos.'),
('Oncología', 'Prevención, diagnóstico y tratamiento de diferentes tipos de cáncer.'),
('Gastroenterología', 'Tratamiento de enfermedades del sistema digestivo, como problemas de estómago e intestinos.'),
('Neumología', 'Diagnóstico y tratamiento de enfermedades respiratorias.'),
('Fisioterapia', 'Tratamiento de lesiones físicas y rehabilitación mediante ejercicios y técnicas.'),
('Medicina Estética', 'Tratamientos médicos relacionados con la mejora estética, como botox y rellenos dérmicos.'),
('Odontología', 'Atención dental preventiva, restauradora y estética.'),
('Cirugía General', 'Tratamientos quirúrgicos para diversas condiciones, desde procedimientos menores hasta mayores.');

INSERT INTO Dim_Pacientes (Nombre, Apellido, FechaNacimiento, Genero, Direccion, Telefono, DNI) 
VALUES 
('Juan', 'Pérez', '1990-03-15', 'M', 'Calle Falsa 123, Madrid', '612345678', '12345678'),
('María', 'Gómez', '1985-07-22', 'F', 'Av. Libertad 456, Sevilla', '654321987', '87654321'),
('Carlos', 'Rodríguez', '1980-11-10', 'M', 'Calle Real 789, Barcelona', '600123456', '23456789'),
('Ana', 'López', '1992-06-05', 'F', 'Plaza Mayor 12, Valencia', '611234567', '34567890'),
('Pedro', 'Sánchez', '1988-08-30', 'M', 'C/ del Sol 34, Zaragoza', '612345789', '45678901'),
('Laura', 'Martínez', '1995-02-01', 'F', 'Calle de la Luna 56, Bilbao', '623456789', '56789012'),
('Luis', 'García', '1993-09-17', 'M', 'Calle de los Olivos 23, Málaga', '624567890', '67890123'),
('Isabel', 'Fernández', '1987-04-27', 'F', 'C/ Primavera 87, Granada', '635678901', '78901234'),
('Javier', 'Díaz', '1990-01-03', 'M', 'C/ del Mar 10, Valencia', '645789012', '89012345'),
('Patricia', 'Torres', '1982-12-16', 'F', 'Av. Andalucía 67, Sevilla', '656890123', '90123456'),
('Raúl', 'Sánchez', '1984-03-09', 'M', 'Calle Juana 45, Sevilla', '610234567', '12312312'),
('Carmen', 'Ruiz', '1991-05-20', 'F', 'Calle Palma 33, Málaga', '611345678', '23423423'),
('Mario', 'Jiménez', '1983-11-25', 'M', 'C/ del Río 17, Granada', '612456789', '34534534'),
('Luisa', 'Hernández', '1994-07-14', 'F', 'Av. Constitución 22, Zaragoza', '613567890', '45645645'),
('Joaquín', 'Díaz', '1987-09-11', 'M', 'Plaza Mayor 14, Madrid', '614678901', '56756756'),
('Elena', 'Pérez', '1992-02-28', 'F', 'Calle Luna 101, Valencia', '615789012', '67867867'),
('Alberto', 'Martínez', '1986-01-06', 'M', 'Av. del Mar 90, Barcelona', '616890123', '78978978'),
('Silvia', 'Sánchez', '1988-07-03', 'F', 'Calle Esperanza 77, Sevilla', '617901234', '89089089'),
('David', 'López', '1990-04-15', 'M', 'Calle Sol 56, Madrid', '618012345', '90190190'),
('Teresa', 'González', '1985-12-22', 'F', 'Av. de la Paz 89, Málaga', '619123456', '12343234');

INSERT INTO Dim_Medicos (Nombre, Apellido, Especialidad, Telefono, Correo)
VALUES
('Juan', 'Pérez', 'Medicina General', '612345678', 'juan.perez@clinica.com'),
('María', 'Gómez', 'Urgencias', '654321987', 'maria.gomez@clinica.com'),
('Carlos', 'Rodríguez', 'Cirugía', '600123456', 'carlos.rodriguez@clinica.com'),
('Ana', 'López', 'Pediatría', '611234567', 'ana.lopez@clinica.com'),
('Pedro', 'Sánchez', 'Odontología', '612345789', 'pedro.sanchez@clinica.com'),
('Laura', 'Martínez', 'Dermatología', '623456789', 'laura.martinez@clinica.com'),
('Luis', 'García', 'Ginecoobstetricia', '624567890', 'luis.garcia@clinica.com'),
('Isabel', 'Fernández', 'Cardiología', '635678901', 'isabel.fernandez@clinica.com'),
('Javier', 'Díaz', 'Oncología', '645789012', 'javier.diaz@clinica.com'),
('Patricia', 'Torres', 'Rehabilitación', '656890123', 'patricia.torres@clinica.com');


-- Insertar más pacientes con DNI únicos
INSERT INTO Dim_Pacientes (Nombre, Apellido, FechaNacimiento, Genero, Direccion, Telefono, DNI)
VALUES
('Raúl', 'Pérez', '1989-05-25', 'M', 'Calle del Sol 45, Madrid', '630123456', '23467890'),
('Mercedes', 'Gómez', '1983-11-02', 'F', 'Av. Castilla 78, Valencia', '631234567', '34578901'),
('Antonio', 'Rodríguez', '1979-10-12', 'M', 'Calle de la Paz 56, Zaragoza', '632345678', '45689012'),
('Verónica', 'López', '1992-08-17', 'F', 'Calle de la Luna 34, Bilbao', '633456789', '56790123'),
('José', 'Sánchez', '1984-02-20', 'M', 'Calle del Río 89, Málaga', '634567890', '67801234'),
('Raquel', 'Fernández', '1986-03-28', 'F', 'Plaza del Sol 22, Sevilla', '635678901', '78912345'),
('Ricardo', 'Torres', '1991-12-05', 'M', 'Av. de la Libertad 33, Granada', '636789012', '89023456'),
('Mónica', 'Díaz', '1985-01-11', 'F', 'Calle del Mar 56, Valencia', '637890123', '90134567'),
('Fernando', 'Jiménez', '1980-07-25', 'M', 'Av. Andalucía 88, Barcelona', '638901234', '12345679'),
('Clara', 'Hernández', '1994-05-30', 'F', 'Calle del Viento 14, Zaragoza', '639012345', '23456780'),
('Manuel', 'García', '1988-09-03', 'M', 'Calle de la Luna 67, Málaga', '640123456', '34567891'),
('Sofía', 'Martínez', '1990-04-18', 'F', 'Calle del Sol 12, Madrid', '641234567', '45678902'),
('David', 'Pérez', '1983-11-14', 'M', 'Av. del Mar 45, Valencia', '642345678', '56789013'),
('Elena', 'Gómez', '1992-03-08', 'F', 'Calle Real 23, Sevilla', '643456789', '67890124'),
('Eduardo', 'Rodríguez', '1987-07-20', 'M', 'Plaza del Sol 56, Barcelona', '644567890', '78901235'),
('Irene', 'Sánchez', '1984-12-15', 'F', 'Calle Libertad 90, Bilbao', '645678901', '89012346'),
('Javier', 'López', '1989-01-27', 'M', 'Calle del Río 12, Zaragoza', '646789012', '90123457'),
('Lucía', 'Torres', '1990-11-04', 'F', 'Av. Constitución 78, Málaga', '647890123', '12343235'),
('José', 'Jiménez', '1985-04-08', 'M', 'Calle Esperanza 33, Granada', '648901234', '23456781'),
('Cristina', 'Hernández', '1993-06-11', 'F', 'Plaza Mayor 17, Madrid', '649012345', '34567892'),
('Carlos', 'García', '1980-09-29', 'M', 'Calle del Sol 99, Valencia', '650123456', '45678903');


INSERT INTO Citas (PacienteID, Fecha, Hora, MedicoID, NConsultorio, ServicioID, Motivo, Estado)
VALUES
(1, '2024-10-05', '09:00', 1, 101, 1, 'Chequeo general', 'Atendida'),
(2, '2024-10-06', '11:00', 2, 102, 2, 'Consulta especializada', 'Programada'),
(3, '2024-10-07', '14:00', 3, 103, 3, 'Urgencias', 'Cancelada');


INSERT INTO Citas (PacienteID, Fecha, Hora, MedicoID, NConsultorio, ServicioID, Motivo, Estado)
VALUES
(1, '2024-10-01', '08:30', 1, 101, 1, 'Chequeo general', 'Atendida'),
(2, '2024-10-03', '10:00', 2, 102, 2, 'Consulta especializada', 'Cancelada'),
(3, '2024-10-04', '14:00', 3, 103, 3, 'Urgencias', 'Atendida'),
(4, '2024-10-06', '12:00', 1, 104, 1, 'Chequeo general', 'Cancelada'),
(5, '2024-10-07', '09:30', 2, 105, 2, 'Consulta especializada', 'Atendida'),
(6, '2024-10-08', '11:30', 3, 103, 3, 'Urgencias', 'Atendida'),
(7, '2024-10-10', '10:00', 1, 102, 1, 'Chequeo general', 'Atendida'),
(8, '2024-10-12', '13:00', 2, 103, 2, 'Consulta especializada', 'Cancelada'),
(9, '2024-10-14', '15:00', 3, 104, 3, 'Urgencias', 'Atendida'),
(10, '2024-10-15', '08:00', 1, 105, 1, 'Chequeo general', 'Atendida');


INSERT INTO Citas (PacienteID, Fecha, Hora, MedicoID, NConsultorio, ServicioID, Motivo, Estado)
VALUES
(1, '2024-11-02', '10:00', 2, 201, 2, 'Consulta especializada', 'Programada'),
(2, '2024-11-03', '11:30', 3, 202, 3, 'Urgencias', 'Atendida'),
(3, '2024-11-05', '09:00', 1, 203, 1, 'Chequeo general', 'Programada'),
(4, '2024-11-06', '13:00', 2, 204, 2, 'Consulta especializada', 'Atendida'),
(5, '2024-11-08', '12:00', 3, 205, 3, 'Urgencias', 'Atendida'),
(6, '2024-11-10', '14:00', 1, 203, 1, 'Chequeo general', 'Programada'),
(7, '2024-11-12', '08:30', 2, 201, 2, 'Consulta especializada', 'Programada'),
(8, '2024-11-14', '11:00', 3, 202, 3, 'Urgencias', 'Atendida'),
(9, '2024-11-15', '13:30', 1, 203, 1, 'Chequeo general', 'Atendida'),
(10, '2024-11-17', '15:00', 2, 204, 2, 'Consulta especializada', 'Programada');


INSERT INTO Citas (PacienteID, Fecha, Hora, MedicoID, NConsultorio, ServicioID, Motivo, Estado)
VALUES
(1, '2024-12-01', '09:30', 1, 301, 1, 'Chequeo general', 'Atendida'),
(2, '2024-12-02', '10:00', 2, 302, 2, 'Consulta especializada', 'Programada'),
(3, '2024-12-04', '13:30', 3, 303, 3, 'Urgencias', 'Atendida'),
(4, '2024-12-05', '11:00', 1, 304, 1, 'Chequeo general', 'Programada'),
(5, '2024-12-07', '15:00', 2, 305, 2, 'Consulta especializada', 'Atendida'),
(6, '2024-12-09', '14:00', 3, 301, 3, 'Urgencias', 'Programada'),
(7, '2024-12-11', '09:00', 1, 302, 1, 'Chequeo general', 'Atendida'),
(8, '2024-12-13', '10:30', 2, 303, 2, 'Consulta especializada', 'Programada'),
(9, '2024-12-15', '12:30', 3, 304, 3, 'Urgencias', 'Atendida'),
(10, '2024-12-17', '13:00', 1, 305, 1, 'Chequeo general', 'Programada');


