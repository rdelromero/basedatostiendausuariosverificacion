drop database if exists basedatostiendausuariosverificacion;
create database basedatostiendausuariosverificacion;
use basedatostiendausuariosverificacion;

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    imagen_url VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE fabricantes (
    id_fabricante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    imagen_url VARCHAR(100) NOT NULL,
    fecha_fundacion DATE,
    descripcion TEXT
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    direccion_email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    apellido1 VARCHAR(40) NOT NULL,
    apellido2 VARCHAR(40),
	active BOOLEAN,
    otp VARCHAR(6) NOT NULL,
    fecha_generacion_otp DATETIME,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE subcategorias (
    id_subcategoria INT AUTO_INCREMENT PRIMARY KEY,
    identidad_categoria INT,
    nombre VARCHAR(50),
    imagen_url VARCHAR(100) NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (identidad_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    identidad_fabricante INT,
    identidad_subcategoria INT,
    nombre VARCHAR(50) UNIQUE,
    descripcion TEXT,
    precio DECIMAL(7,2),
    stock INT,
    novedad BOOLEAN,
    oferta BOOLEAN,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (identidad_fabricante) REFERENCES fabricantes(id_fabricante),
    FOREIGN KEY (identidad_subcategoria) REFERENCES subcategorias(id_subcategoria)
);

CREATE TABLE imagenes (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    identidad_producto INT NOT NULL,
    imagen_url VARCHAR(100),
    FOREIGN KEY (identidad_producto) REFERENCES productos(id_producto)
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    identidad_usuario INT,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    /*precio_total se calculará será la suma de los precio_linea de la linea_facturacion para el id_pedido en cuestión*/
	precio_total DECIMAL(8, 2),
    estado ENUM('pendiente', 'enviado', 'entregado', 'cancelado') NOT NULL DEFAULT 'pendiente',
    /*Datos del destinatario*/
	nombre VARCHAR(30) NOT NULL,
    apellidos VARCHAR(40) NOT NULL,
    direccion VARCHAR(80) NOT NULL,
    pais VARCHAR(40),
    ciudad VARCHAR(30),
    numero_telefono_movil VARCHAR(20),
    /**********/
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (identidad_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE linea_facturacion (
    id_linea_facturacion INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_producto INT,
    cantidad INT NOT NULL,
    /*El precio_linea = precio del producto*cantidad*/
    precio_linea DECIMAL(10, 2) NOT NULL,
    UNIQUE (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
);

CREATE TABLE envios (
    id_envio INT AUTO_INCREMENT PRIMARY KEY,
    identidad_pedido INT UNIQUE,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    entregado BOOLEAN,
    fecha_entrega DATETIME,
    numero_documento_identidad_receptor VARCHAR(20),
    comentario VARCHAR(150), /*P. ej. si ha habido varios intentos de entrega*/
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (identidad_pedido) REFERENCES pedidos(id_pedido)
);

INSERT INTO categorias(nombre, imagen_url, descripcion) value
    ('Armas airsoft', 
    '/imagenes/categorias/replicas.jpg',
    'Las armas de airsoft son réplicas de armas utilizadas en los deportes de airsoft. Son un tipo especial de armas de aire de cañón liso de baja potencia 
    diseñadas para disparar proyectiles llamados "airsoft pellets" o BBs, los cuales están típicamente hechos de (pero no limitados a) materiales plásticos o 
    resinas biodegradables. Las plantas de energía de las armas de airsoft están diseñadas para tener bajas calificaciones de energía en la boca del cañón 
    (generalmente menos de 1.5 J, o 1.1 ft⋅lb) y los pellets tienen significativamente menos poder penetrante y de detención que las armas de aire convencionales, y
    son generalmente seguras para uso deportivo competitivo y recreativo si se lleva el equipo de protección adecuado.'),
    ('Munición y recarga', 
    '/imagenes/categorias/consumibles.jpg',
    'La munición se utiliza para marcar a otros jugadores durante el juego. Estas son pequeñas esferas de plástico, conocidas como BBs, 
    que se disparan desde las réplicas de armas. El objetivo principal es alcanzar a los oponentes con estas BBs para "eliminarlos" o cumplir objetivos específicos 
    dentro del escenario del juego. Las BBs pueden ser de diferentes pesos y calidades, y su elección puede influir en la precisión y el rendimiento de la réplica.
    <br> La recarga en airsoft implica rellenar los cargadores de las réplicas con estas BBs. Los jugadores deben cargar manualmente sus cargadores, ya sea utilizando un
    tubo cargador o un dispositivo de carga rápida. Esta acción es más que una simple tarea; es una habilidad táctica crucial en el juego. Recargar requiere 
    estrategia y buen timing, ya que hacerlo en un momento inapropiado o en una posición expuesta puede dejar al jugador vulnerable a ser marcado por los oponentes.
    Por lo tanto, saber cuándo y dónde recargar forma parte integral de la táctica y la estrategia en el airsoft, añadiendo un elemento de realismo y desafío que 
    mejora la experiencia del juego.'),
    ('Accesorios',
    '/imagenes/categorias/accesorios.jpg',
	'Los accesorios son elementos adicionales que se pueden añadir a las réplicas de armas para mejorar su funcionalidad, eficiencia, comodidad y realismo. Estos 
	accesorios no solo sirven para mejorar el rendimiento en el campo de batalla, sino también para aumentar la inmersión en el juego y hacer que la experiencia 
	sea más agradable y personalizada.'),
    ('Equipamiento',
    '/imagenes/categorias/equipamiento.jpg',
    'El equipamiento en Airsoft es fundamental para asegurar la seguridad y la efectividad durante el juego. Este incluye réplicas de armas como rifles, pistolas, 
    escopetas y francotiradores, que disparan bolas de plástico o biodegradables. La protección personal es crucial, destacando el uso de máscaras y gafas para 
    proteger los ojos y la cara, cascos para la cabeza, chalecos tácticos que ofrecen protección y espacio para llevar accesorios, y guantes para proteger las manos
    y mejorar el agarre. La vestimenta también es importante; se utilizan uniformes, a menudo de camuflaje, para integrarse con el entorno y botas tácticas para 
    proteger los pies en terrenos irregulares. Los accesorios para armas como mirillas, visores, silenciadores, linternas y láseres mejoran la funcionalidad y 
    precisión. La comunicación entre jugadores se facilita mediante radios y auriculares, y la hidratación se mantiene con mochilas de hidratación o cantimploras, 
    especialmente vital en juegos largos o en climas cálidos. Todo este equipamiento no solo enriquece la experiencia de juego haciéndola más inmersiva y 
    estratégica, sino que también es esencial para la protección de los jugadores.'),
    ('Internos',
    '/imagenes/categorias/internos.jpg',
    'Los "elementos internos" se refieren a las partes y componentes que están dentro de la réplica de arma y que son esenciales para su funcionamiento. Estos 
    incluyen varios sistemas y piezas que influyen en el rendimiento del arma, como la precisión, la potencia y la fiabilidad.');

INSERT INTO fabricantes(nombre, imagen_url) VALUES
    ('Ares', '/imagenes/fabricantes/ares.jpg'),
    ('AW Custom', '/imagenes/fabricantes/armorer-works.jpg'),
    ('Delta Tactics', '/imagenes/fabricantes/delta-tactics.jpg'),
    ('Dual Code', '/imagenes/fabricantes/dual-code.jpg'),
    ('Krytac', '/imagenes/fabricantes/krytac.jpg'),
    ('Tokyo Marui', '/imagenes/fabricantes/tokyo-marui.jpg');

INSERT INTO subcategorias(identidad_categoria, nombre, imagen_url, descripcion) VALUES
    (1, 'fusiles', '/imagenes/subcategorias/fusiles.jpg', 'Los fusiles de airsoft son la elección ideal para todo tipo de partidas de airsoft, ya que son las armas más versátiles, convirtiéndose
    en una de las armas más utilizadas por los jugadores de airsoft'),
    (1, 'subfusiles', '/imagenes/subcategorias/subfusiles.jpg', 'Los subfusiles de airsoft son armas muy utilizadas por los jugadores de airsoft que buscan juegos rápidos a cortas distancias, estos utilizan cargadores mas estrechos que los fusiles, convirtiéndolas en replicas exactas de los subfusiles reales, los cuales están diseñados para utilizarse con munición de pistola. El subfusil de airsoft es la elección perfecta para los amantes del CQB o partidas de corto alcance. A pesar de que estas armas también pueden llegar a distancias mas largas pudiendo casi igualar a los fusiles, generalmente están diseñadas con cañones mas cortos para facilitar su movilidad y convertirlas en armas mas rápidas.'),
    (1, 'pistolas', '/imagenes/subcategorias/pistolas.jpg', 'Si quieres iniciarte en este hobby o renovar tu equipamiento por muy poco dinero, una pistola airsoft es el producto ideal para empezar con buen pie o salir victorioso de todos tus enfrentamientos a corta distancia.'),
    (1, 'escopetas', '/imagenes/subcategorias/escopetas.jpg', 'Las escopetas Airsoft son una de las réplicas Airsoft más usadas por los jugadores a nivel mundial después de los rifles y las pistolas eléctricas. Estas escopetas de bolas son ideales para la simulación militar de un combate ordinario y también para aquellos que son aficionados a las actividades de enfrentamiento. Por lo general, son empleadas como una herramienta de defensa en contra del enemigo que está atacando durante la duración del juego.Estas escopetas de Airsoft son un tipo de arma por lo general largas (también existen los cañones cortos) y utilizadas como arma principal del juego por su jugador. Es un arma con mayor alcance de todas las que se pueden utilizar y cuenta con mayor atracción de manera visual para muchos de los jugadores. Este tipo de escopeta para Airsoft es de las preferidas por aquellos jugadores que tienen el papel de fusileros. Esto se debe a su gran parecido con las armas reales y por el gran tamaño que pueden tener. Puedes conseguir una gran cantidad de escopetas de bolas que son réplicas de las reales y puede ser usadas por jugadores expertos del Airsoft y también por los novatos en el área, así que no te preocupes y disfruta de tu escopeta de bolas.'),
    (1, 'francotiradores', '/imagenes/subcategorias/francotiradores.jpg', 'Los francotiradores Airsoft juegan un papel muy importante dentro de este juego. Son jugadores que tienen que contar con mucha paciencia, inteligencia y a su vez una puntería increíble. Si tienes estas características principales, quiere decir que puedes ser excelente con los rifles para francotiradores en este juego que ha revolucionado al mundo entero desde su creación en Japón. La función principal de los francotiradores de Airsoft es ofrecerle protección a su equipo. Una tarea que se hace por medio de la observación de inteligencia y eliminando a los jugadores del equipo contrario con disparos realizados a larga distancia con diversas armas. Su objetivo es abatir a determinados jugadores del equipo contrario que pueden ser una amenaza para sus compañeros. Al realizar este tipo de disparos, los francotiradores logran que el equipo contrario quede con bajas y con movimientos limitados, por lo que consiguen una mejor penetración en terreno enemigo.'),
    (2, 'bolas de airsoft', '/imagenes/subcategorias/bolas-bbs.jpg', 'Los balines de Airsoft (conocidos como BBs) son proyectiles esféricos utilizados por las armas de airsoft. Por lo general, están hechos de plástico, suelen medir alrededor de 6 mm (0,24 pulgadas) de diámetro (aunque algunos modelos usan 8 mm) y pesan entre 0,20 y 0,40 g (3,1 a 6,2 g), siendo los pesos más comunes 0,20 gy 0,25 g. , mientras que las bolas de 0,28 g, 0,30 g, 0,32 g y 0,40 g también son habituales. Aunque los usuarios de airsoft los conocen con frecuencia como "BBs", estos BBs no son los mismos que los proyectiles metálicos de 4,5 mm que disparan las pistolas de BB ni los perdigones de 4,6 mm (0,180 pulgadas) de los que se originó el término "BB".'),
	(2, 'cargadores', '/imagenes/subcategorias/cargadores-pistola.jpg', 'un cargador es un dispositivo que almacena y alimenta las BBs (bolas de plástico que actúan como munición) a la réplica del arma. Es un componente crucial para el funcionamiento de las armas de airsoft, y su diseño y capacidad varían dependiendo del tipo de arma y del realismo deseado.'),
    (2, 'baterías y cargadores de batería', '/imagenes/subcategorias/baterias.jpg', 'En el airsoft, las baterías son utilizadas principalmente para alimentar las réplicas de armas eléctricas, conocidas como AEGs (Airsoft Electric Guns).'),
    (2, 'granadas y lanzagranadas', '/imagenes/subcategorias/granadas-y-lanzagranadas.jpg', 'Las granadas de airsoft están diseñadas para simular el efecto y la funcionalidad de las granadas reales. A menudo se utilizan para limpiar habitaciones o despejar trincheras y otros espacios cerrados, permitiendo a los jugadores golpear a múltiples objetivos simultáneamente.'),
    (2, 'gas, co2 y mantenimiento', '/imagenes/subcategorias/gas-co2-y-mantenimiento.jpg', 'El gas y el CO2 son dos tipos de propelentes utilizados en las armas de airsoft para proporcionar la energía necesaria para disparar las BBs. Cada uno tiene características específicas y se utiliza en diferentes tipos de réplicas de armas. El lubricante ayuda a reducir la fricción entre las partes móviles del arma, como los engranajes en una AEG (Airsoft Electric Gun) o las partes móviles del mecanismo de blowback en armas de gas. Esto asegura un funcionamiento más suave y eficiente, lo que es crucial para la durabilidad del arma. Previene el Desgaste: Al disminuir la fricción, el lubricante también reduce el desgaste general de las partes móviles del arma. Esto es especialmente importante en componentes como pistones, cilindros y válvulas.'),
    (3, 'miras y red dot', '/imagenes/subcategorias/nombre.jpg', 'Las miras y red dot son son un accesorio airsoft complementario de cada uno de los jugadores. Permiten tener una pequeña ventaja sobre el adversario, ya que nos ayuda a visualizar y apuntar más rápido a grandes distancias'),
    (3, 'correas y landyards', '/imagenes/subcategorias/nombre.jpg', 'Las correas habilitan al jugador a utilizar sus manos en otras labores mientras su réplica primaria cuelga sin perderse.  El lanyard es una cuerda o cordón que se coloca alrededor del cuello y permite colgar complementos y accesorios airsoft.'),
    (3, 'monturas y raíles', '/imagenes/subcategorias/nombre.jpg', 'Las monturas y raíles para Airsoft son ampliamente utilizadas en este deporte ya que ayudan a colocar cualquier accesorio a nuestra replica. Es decir, nos permite colocar: teléfonos, cámaras, miras, linternas o cualquier objeto que nos ayudará a un mejor desempeño en el campo de batalla.'),
    (3, 'linternas y láseres', '/imagenes/subcategorias/nombre.jpg', 'Las linternas y láser Airsoft tienen muchos usos: desde planear emboscadas a dar señales, pasar mensaje en código, indicar posiciones, o simplemente para poder tener una visión nocturna. Son un accesorio de Airsoft necesario para todos los equipos, en especial en jornadas de juego nocturnas.'),
    (4, 'proteccion facial', '/imagenes/subcategorias/nombre.jpg', 'La protección en Airsoft por ningún motivo es sacrificable y en especial la PROTECCIÓN FACIAL, ya que es la encargada de cuidar gran parte de nuestro rosto y no queremos sufrir alguna lesión en cualquiera zona baja de nuestro rostro ya que es la carta de presentación de cualquier persona.'),
    (4, 'gafas', '/imagenes/subcategorias/nombre.jpg', 'La aplicación de gafas airsoft en el desarrollo de una incursión es altamente recomendable porque en un primer momento nos proporciona los elementos de protección necesarios ante cualquier disparo, es necesario destacar que no se recomienda bajo ningún concepto usar elementos similares de uso convencional o cotidiano, ya que la intensidad de una partida de este deporte puede ocasionar la pérdida o daño permanente del mismo.'),
    (4, 'chalecos', '/imagenes/subcategorias/nombre.jpg', 'el deportista debe poner en práctica el contar con todos los elementos de equipamiento necesarios como los chalecos, ya que los mismos en su mayoría proporcionan un nivel de cobertura altamente conocida con respecto a la exposición constante que se realiza ante los disparos, teniendo en cuenta que, los mismos en algunas ocasiones pueden impactar en el cuerpo con distintos tipos de lesiones.'),
    (4, 'portacargadores y pouch', '/imagenes/subcategorias/nombre.jpg', 'Como su nombre lo indica los PORTACARGADORES, POUCH son uno de los accesorios más buscados en la práctica de Airsoft, ya que nos permite llevar municiones de una forma fácil y segura, que no impide en nada el buen desarrollo en el campo de batalla.'),
    (4, 'cascos', '/imagenes/subcategorias/nombre.jpg', 'Dentro del equipamiento mínimo necesario para la práctica correcta de airsoft, se incluyen los cascos de uso obligatorio.  Son artículos de seguridad en el juego y son necesarios para asegurar un juego con una mínima exposición al daño craneal.  Además de que son físicamente atractivos como parte del uniforme.'),
    (5, 'Cámaras y gomas Hop-up', '/imagenes/subcategorias/nombre.jpg', 'La cámara de Hop Up es un componente crítico en cualquier réplica de airsoft, ya que es responsable de impartir un efecto de giro a la bola mientras sale del cañón. Esto permite que la bola se estabilice en el aire, mejorando la precisión y el alcance del disparo. En nuestra tienda online, ofrecemos una amplia gama de cámaras de Hop Up de diferentes fabricantes y modelos, incluyendo marcas líderes como Lonex, Prometheus, y Mad Bull.'),
    (5, 'Gearbox', '/imagenes/subcategorias/nombre.jpg', 'El gearbox es uno de los componentes más importantes de cualquier réplica de Airsoft. Es el corazón del arma, y es responsable de la mayoría de las funciones, desde la alimentación de BBs hasta el disparo. En esta categoría te ofrecemos una amplia selección de Gearbox (cajas de cambios) de Airsoft.'),
    (5, 'Engranajes', '/imagenes/subcategorias/nombre.jpg', 'Los engranajes son uno de los componentes más críticos en una réplica de airsoft, ya que son responsables de transferir la energía del motor al mecanismo de disparo. Por lo tanto, es importante que los engranajes estén diseñados y fabricados con precisión para asegurar un rendimiento óptimo y una larga vida útil.'),
    (5, 'Motores', '/imagenes/subcategorias/nombre.jpg', 'Ofrecemos una amplia selección de motores de alta calidad, diseñados específicamente para réplicas de airsoft. Nuestros motores son potentes y eficientes, lo que resulta en una mayor velocidad de disparo y una mejor respuesta del gatillo. Además, también ofrecemos motores de diferentes tamaños y potencias para que puedas personalizar tu sistema según tus necesidades. Todos nuestros motores son fabricados con materiales duraderos y de alta calidad para garantizar un rendimiento óptimo y una larga vida útil.'),
    (5, 'Pistón y cabeza pistón', '/imagenes/subcategorias/nombre.jpg', 'Los pistones y cabeza de pistones de alta calidad mejoran el rendimiento de tu réplica de airsoft. Encontrarás pistones y cabezas de pistones para airsoft de diferentes materiales y diseños, desde pistones reforzados con dientes metálicos para una mayor durabilidad, hasta cabezas de pistón de aluminio y juntas tóricas para mejorar la estanqueidad y reducir la pérdida de aire.');

INSERT INTO usuarios (nombre, apellido1, apellido2, password, direccion_email, active, otp, fecha_generacion_otp) VALUES
    ('Alfredo', 'Landa', 'Areta', 'alflanare', 'alflanare@example.com', true, '000000', CURRENT_TIMESTAMP),
    ('Antonio', 'Ozores', 'Puchol', 'antozopuc', 'antozopuc@example.com', true, '000000', CURRENT_TIMESTAMP),
    ('Amparo', 'Baró', 'San Martín', 'ampbarsm', 'ampbarsm@example.com', true, '000000', CURRENT_TIMESTAMP),
    ('Carlos', 'Larrañaga', 'Ladrón de Guevera', 'carlarldg', 'carlarladdegue@example.com', true, '000000', CURRENT_TIMESTAMP),
    ('Concepción', 'Velasco', 'Varona', 'convelvar', 'convelvar@example.com', false, '000000', CURRENT_TIMESTAMP),
    ('Enrique', 'San Francisco', 'Cobo', 'enrsanfan', 'enrsfcob@sqlmail.com', true, '000000', CURRENT_TIMESTAMP),
    ('Francisco', 'Rabal', 'Valera', 'frarabval', 'frarabval@sqlmail.com', true, '000000', CURRENT_TIMESTAMP),
    ('Fernando', 'Fernández', 'Gómez', 'ferfergom', 'ferfergom@sqlmail.com', true, '000000', CURRENT_TIMESTAMP),
    ('Florinda', 'Chico', 'Martín-Mora', 'flochimar-mor', 'flochim-m@sqlmail.com', true, '000000', CURRENT_TIMESTAMP);

INSERT INTO pedidos (identidad_usuario, nombre, apellidos, direccion, pais, ciudad, numero_telefono_movil, fecha_pedido, precio_total, estado) VALUES
    (1, 'Alfredo', 'Landa', 'direccion AL', 'España', 'Pamplona', '+346XXXXXXXX', '2024-04-01', 60, 'entregado'),
    (1, 'Alfredo', 'Landa', 'direccion AL', 'España', 'Pamplona', '+346XXXXXXXX', '2024-04-01', 60, 'cancelado'),
    (3, 'Amparo', 'Baró', 'direccion AB', 'España', 'Barcelona', '+346XXXXXXXX', '2024-04-02', 70, 'entregado'),
    (3, 'Amparo', 'Baró', 'direccion AB', 'España', 'Barcelona', '+346XXXXXXXX', '2024-04-03', 50, 'entregado'),
    (1, 'Germán', 'Areta', 'direccion GA', 'España', 'Madrid', '+346XXXXXXXX', '2024-04-04', 60, 'entregado'),
    (8, 'Miguel', 'Aguirrezabala', 'direccion CV', 'España', 'Azpeitia', '+346XXXXXXXX', '2024-04-05', 30, 'cancelado'),
    (5, 'Concepción', 'Velasco', 'direccion CV', 'España', 'Valladolid', '+346XXXXXXXX', '2024-04-07', 30, 'enviado'),
    (6, 'Ramiro', 'Pacheco', 'direccion RP', 'España', 'Madrid', '+346XXXXXXXX', '2024-04-07', 120, 'entregado'),
    (7, 'Francisco', 'Rabal', 'direccion FR', 'España', 'Águilas', '+346XXXXXXXX', '2024-04-09', 25, 'enviado'),
    (1, 'Agustín', 'Romero', 'direccion AR', 'España', 'Segovia', '+346XXXXXXXX', '2024-04-15', 120, 'pendiente'),
    (5, 'Nuria', 'Berenguer', 'direccion NB', 'España', 'Gerona', '+346XXXXXXXX', '2024-04-16', 30, 'pendiente');

/*Recordar identidad_pedido es único*/
INSERT INTO envios (identidad_pedido, fecha_envio, fecha_entrega, numero_documento_identidad_receptor, comentario) VALUES
    (1, '2024-04-04', '2024-04-11', 'nif receptor', null),
    (3, '2024-04-05', '2024-04-15', 'nif receptor', null),
    (4, '2024-04-06', '2024-04-15', 'nif receptor', null),
    (5, '2024-04-06', '2024-04-15', 'nif receptor', null),
    (6, '2024-04-08', null, null, 'Tres intentos fallidos de entrega. Imposible contactar por teléfono. Devolvemos a almacén.'),
    (7, '2024-04-10', '2024-04-17', 'nif receptor', null),
    (8, '2024-04-13', null, null, null),
    (9, '2024-04-13', null, null, null);

SELECT * FROM usuarios;
SELECT * FROM pedidos;
SELECT * FROM envios;
/*SELECT * FROM usuarios WHERE active = TRUE;*/
