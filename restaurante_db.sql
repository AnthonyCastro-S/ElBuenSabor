CREATE DATABASE restaurante_db;
GO

USE restaurante_db;
GO

CREATE TABLE usuario (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    rol NVARCHAR(20) NOT NULL DEFAULT 'MESERO',
    activo BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT CK_usuario_rol CHECK
    (rol IN ('ADMIN', 'MESERO', 'COCINERO', 'CAJERO'))
);
GO

CREATE TABLE categoria (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    activa BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE plato (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(MAX),
    precio DECIMAL(10,2) NOT NULL,
    disponible BIT NOT NULL DEFAULT 1,
    categoria_id BIGINT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_plato_categoria FOREIGN KEY (categoria_id)
    REFERENCES categoria(id),
    CONSTRAINT CK_plato_precio CHECK (precio > 0)
);
GO

CREATE TABLE mesa (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    numero INT NOT NULL UNIQUE,
    capacidad INT NOT NULL,
    ubicacion NVARCHAR(100),
    estado NVARCHAR(20) DEFAULT 'DISPONIBLE',
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT CK_mesa_capacidad CHECK (capacidad > 0),
    CONSTRAINT CK_mesa_estado CHECK
    (estado IN ('DISPONIBLE', 'OCUPADA', 'RESERVADA'))
);
GO

CREATE TABLE pedido (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    mesa_id BIGINT NOT NULL,
    mesero_id BIGINT NOT NULL,
    estado NVARCHAR(20) DEFAULT 'PENDIENTE',
    total DECIMAL(10,2) DEFAULT 0.00,
    observaciones NVARCHAR(MAX),
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    fecha_cierre DATETIME2,
    CONSTRAINT FK_pedido_mesa FOREIGN KEY (mesa_id)
    REFERENCES mesa(id),
    CONSTRAINT FK_pedido_mesero FOREIGN KEY (mesero_id)
    REFERENCES usuario(id),
    CONSTRAINT CK_pedido_estado CHECK
    (estado IN ('PENDIENTE', 'EN_PREPARACION', 'LISTO',
    'ENTREGADO', 'PAGADO', 'CANCELADO'))
);
GO

CREATE TABLE detalle_pedido (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    pedido_id BIGINT NOT NULL,
    plato_id BIGINT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    notas NVARCHAR(255),
    CONSTRAINT FK_detalle_pedido FOREIGN KEY (pedido_id)
    REFERENCES pedido(id) ON DELETE CASCADE,
    CONSTRAINT FK_detalle_plato FOREIGN KEY (plato_id)
    REFERENCES plato(id),
    CONSTRAINT CK_detalle_cantidad CHECK (cantidad > 0)
);
GO

INSERT INTO usuario
(nombre, apellido, email, password, rol)
VALUES
('Administrador', 'Sistema', 'admin@elbuensabor.pe', 'admin123', 'ADMIN'),
('Juan', 'Perez', 'juan@elbuensabor.pe', 'juan123', 'MESERO'),
('Maria', 'Lopez', 'maria@elbuensabor.pe', 'maria123', 'MESERO'),
('Carlos', 'Ramirez', 'carlos@elbuensabor.pe', 'carlos123', 'COCINERO'),
('Ana', 'Torres', 'ana@elbuensabor.pe', 'ana123', 'CAJERO');
GO

INSERT INTO categoria
(nombre, descripcion)
VALUES
('Entradas', 'Platos de entrada'),
('Platos de Fondo', 'Platos principales'),
('Bebidas', 'Jugos y refrescos'),
('Postres', 'Dulces y postres');
GO

INSERT INTO plato
(nombre, descripcion, precio, disponible, categoria_id)
VALUES
('Papa a la Huancaina', 'Papa con crema de aji', 18.00, 1, 1),
('Ceviche Clasico', 'Pescado con limon y cebolla', 38.00, 1, 1),
('Lomo Saltado', 'Carne con papas y arroz', 35.00, 1, 2),
('Aji de Gallina', 'Pollo en crema de aji', 28.00, 1, 2),
('Arroz con Mariscos', 'Arroz con mariscos variados', 42.00, 1, 2),
('Chicha Morada', 'Bebida de maiz morado', 8.00, 1, 3),
('Limonada', 'Bebida de limon natural', 7.00, 1, 3),
('Suspiro a la Limena', 'Postre de manjar y merengue', 15.00, 1, 4);
GO

INSERT INTO mesa
(numero, capacidad, ubicacion, estado)
VALUES
(1, 4, 'Salon principal', 'DISPONIBLE'),
(2, 4, 'Salon principal', 'DISPONIBLE'),
(3, 2, 'Salon principal', 'DISPONIBLE'),
(4, 6, 'Salon principal', 'DISPONIBLE'),
(5, 2, 'Salon principal', 'DISPONIBLE'),
(6, 4, 'Salon principal', 'DISPONIBLE'),
(7, 4, 'Terraza', 'DISPONIBLE'),
(8, 2, 'Terraza', 'DISPONIBLE'),
(9, 8, 'Terraza', 'DISPONIBLE'),
(10, 8, 'Terraza', 'DISPONIBLE');
GO
