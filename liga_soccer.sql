-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-09-2025 a las 03:54:07
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `liga_soccer`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_equipo` (IN `equipo_id` INT, IN `nuevo_nombre` VARCHAR(100))   BEGIN
  UPDATE equipos SET nombre = nuevo_nombre WHERE id_equipo = equipo_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_marcador` (IN `partido_id` INT, IN `goles_local` INT, IN `goles_visitante` INT)   BEGIN
  UPDATE partidos SET goles_local = goles_local, goles_visitante = goles_visitante WHERE id_partido = partido_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_puntos` (IN `equipo_id` INT, IN `liga_id` INT, IN `nuevos_puntos` INT)   BEGIN
  UPDATE clasificacion SET puntos = nuevos_puntos WHERE id_equipo = equipo_id AND id_liga = liga_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `arbitros_por_partido` (IN `partido_id` INT)   BEGIN
  SELECT a.nombre FROM arbitros a
  JOIN arbitros_partido ap ON a.id_arbitro = ap.id_arbitro
  WHERE ap.id_partido = partido_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_arbitro` (IN `arbitro_id` INT, IN `partido_id` INT)   BEGIN
  INSERT INTO arbitros_partido(id_arbitro, id_partido) VALUES (arbitro_id, partido_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_jugador` (IN `nombre_busqueda` VARCHAR(100))   BEGIN
  SELECT * FROM jugadores WHERE nombre LIKE CONCAT('%', nombre_busqueda, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiar_equipo_jugador` (IN `jugador_id` INT, IN `nuevo_equipo` INT)   BEGIN
  UPDATE jugadores SET id_equipo = nuevo_equipo WHERE id_jugador = jugador_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clasificacion_completa` ()   BEGIN
  SELECT l.nombre AS liga, e.nombre AS equipo, c.puntos
  FROM clasificacion c
  JOIN equipos e ON c.id_equipo = e.id_equipo
  JOIN ligas l ON c.id_liga = l.id_liga
  ORDER BY l.id_liga, c.puntos DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clasificacion_por_liga` (IN `liga_id` INT)   BEGIN
  SELECT e.nombre AS equipo, c.puntos
  FROM clasificacion c
  JOIN equipos e ON c.id_equipo = e.id_equipo
  WHERE c.id_liga = liga_id
  ORDER BY c.puntos DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `diferencia_goles_equipo` (IN `equipo_id` INT)   BEGIN
  SELECT diferencia_goles FROM clasificacion WHERE id_equipo = equipo_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_arbitro` (IN `arbitro_id` INT)   BEGIN
  DELETE FROM arbitros WHERE id_arbitro = arbitro_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_jugador` (IN `jugador_id` INT)   BEGIN
  DELETE FROM jugadores WHERE id_jugador = jugador_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_liga` (IN `liga_id` INT)   BEGIN
  DELETE FROM ligas WHERE id_liga = liga_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_partido` (IN `partido_id` INT)   BEGIN
  DELETE FROM partidos WHERE id_partido = partido_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `equipos_por_liga` (IN `liga_id` INT)   BEGIN
  SELECT nombre FROM equipos WHERE id_liga = liga_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eventos_partido` (IN `partido_id` INT)   BEGIN
  SELECT
    (SELECT COUNT(*) FROM goles WHERE id_partido = partido_id) AS goles,
    (SELECT COUNT(*) FROM tarjetas WHERE id_partido = partido_id) AS tarjetas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `goles_por_jugador` (IN `jugador_id` INT)   BEGIN
  SELECT COUNT(*) AS total_goles FROM goles WHERE id_jugador = jugador_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_arbitro` (IN `nombre` VARCHAR(100))   BEGIN
  INSERT INTO arbitros(nombre) VALUES (nombre);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_clasificacion` (IN `equipo_id` INT, IN `liga_id` INT, IN `puntos` INT)   BEGIN
  INSERT INTO clasificacion(id_equipo, id_liga, puntos) VALUES (equipo_id, liga_id, puntos);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_equipo` (IN `nombre` VARCHAR(100), IN `id_liga` INT)   BEGIN
  INSERT INTO equipos(nombre, id_liga) VALUES (nombre, id_liga);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_jugador` (IN `nombre` VARCHAR(100), IN `id_equipo` INT)   BEGIN
  INSERT INTO jugadores(nombre, id_equipo) VALUES (nombre, id_equipo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_liga` (IN `nombre` VARCHAR(100))   BEGIN
  INSERT INTO ligas(nombre) VALUES (nombre);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_partido` (IN `fecha` DATETIME, IN `local` INT, IN `visitante` INT, IN `estadio` VARCHAR(100))   BEGIN
  INSERT INTO partidos(fecha_hora, equipo_local, equipo_visitante, estadio)
  VALUES (fecha, local, visitante, estadio);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `jugadores_por_equipo` (IN `equipo_id` INT)   BEGIN
  SELECT nombre FROM jugadores WHERE id_equipo = equipo_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `partidos_por_arbitro` (IN `arbitro_id` INT)   BEGIN
  SELECT p.* FROM partidos p
  JOIN arbitros_partido ap ON p.id_partido = ap.id_partido
  WHERE ap.id_arbitro = arbitro_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `partidos_por_equipo` (IN `equipo_id` INT)   BEGIN
  SELECT * FROM partidos WHERE equipo_local = equipo_id OR equipo_visitante = equipo_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `partidos_por_fecha` (IN `fecha_consulta` DATE)   BEGIN
  SELECT * FROM partidos WHERE DATE(fecha_hora) = fecha_consulta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_gol` (IN `partido_id` INT, IN `jugador_id` INT, IN `minuto` INT)   BEGIN
  INSERT INTO goles(id_partido, id_jugador, minuto) VALUES (partido_id, jugador_id, minuto);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_tarjeta` (IN `partido_id` INT, IN `jugador_id` INT, IN `tipo` VARCHAR(10), IN `minuto` INT)   BEGIN
  INSERT INTO tarjetas(id_partido, id_jugador, tipo, minuto) VALUES (partido_id, jugador_id, tipo, minuto);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tarjetas_por_jugador` (IN `jugador_id` INT)   BEGIN
  SELECT tipo, COUNT(*) AS cantidad FROM tarjetas WHERE id_jugador = jugador_id GROUP BY tipo;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `arbitros`
--

CREATE TABLE `arbitros` (
  `id_arbitro` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `arbitros_partido`
--

CREATE TABLE `arbitros_partido` (
  `id_arbitros_partido` int(11) NOT NULL,
  `id_arbitro` int(11) NOT NULL,
  `id_partido` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencias`
--

CREATE TABLE `asistencias` (
  `id_asistencia` int(11) NOT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `id_jugador` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clasificacion`
--

CREATE TABLE `clasificacion` (
  `id_clasificacion` int(11) NOT NULL,
  `id_equipo` int(11) NOT NULL,
  `id_liga` int(11) NOT NULL,
  `puntos` int(11) DEFAULT 0,
  `partidos_jugados` int(11) DEFAULT 0,
  `partidos_ganados` int(11) DEFAULT 0,
  `partidos_empatados` int(11) DEFAULT 0,
  `partidos_perdidos` int(11) DEFAULT 0,
  `diferencia_goles` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipos`
--

CREATE TABLE `equipos` (
  `id_equipo` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `id_liga` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipos`
--

INSERT INTO `equipos` (`id_equipo`, `nombre`, `id_liga`) VALUES
(1, 'Atlético Medellín', 1),
(2, 'Deportivo Envigado', 1),
(3, 'Café FC', 2),
(4, 'Manizales United', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadios`
--

CREATE TABLE `estadios` (
  `id_estadio` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `goles`
--

CREATE TABLE `goles` (
  `id_gol` int(11) NOT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `id_jugador` int(11) DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugadores`
--

CREATE TABLE `jugadores` (
  `id_jugador` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `id_equipo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `jugadores`
--

INSERT INTO `jugadores` (`id_jugador`, `nombre`, `fecha_nacimiento`, `id_equipo`) VALUES
(1, 'Juan Pérez', NULL, 1),
(2, 'Carlos Gómez', NULL, 1),
(3, 'Luis Torres', NULL, 2),
(4, 'Andrés Ramírez', NULL, 2),
(5, 'Mateo Ríos', NULL, 3),
(6, 'Santiago López', NULL, 3),
(7, 'Daniel Castaño', NULL, 4),
(8, 'Julián Mejía', NULL, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ligas`
--

CREATE TABLE `ligas` (
  `id_liga` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ligas`
--

INSERT INTO `ligas` (`id_liga`, `nombre`) VALUES
(1, 'Liga Antioqueña'),
(2, 'Liga Cafetera');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partidos`
--

CREATE TABLE `partidos` (
  `id_partido` int(11) NOT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  `goles_local` int(11) DEFAULT NULL,
  `goles_visitante` int(11) DEFAULT NULL,
  `id_local` int(11) DEFAULT NULL,
  `id_visitante` int(11) DEFAULT NULL,
  `id_estadio` int(11) DEFAULT NULL,
  `id_liga` int(11) DEFAULT NULL,
  `id_arbitro` int(11) DEFAULT NULL,
  `jornada` int(11) DEFAULT NULL,
  `temporada` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `partidos`
--

INSERT INTO `partidos` (`id_partido`, `fecha_hora`, `goles_local`, `goles_visitante`, `id_local`, `id_visitante`, `id_estadio`, `id_liga`, `id_arbitro`, `jornada`, `temporada`) VALUES
(1, '2025-09-01 15:00:00', 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, '2025-09-02 17:30:00', 3, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarjetas`
--

CREATE TABLE `tarjetas` (
  `id_tarjeta` int(11) NOT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `id_jugador` int(11) DEFAULT NULL,
  `tipo` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_equipos_por_liga`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_equipos_por_liga` (
`id_liga` int(11)
,`liga` varchar(100)
,`id_equipo` int(11)
,`equipo` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_equipos_sin_goles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_equipos_sin_goles` (
`id_equipo` int(11)
,`equipo` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_eventos_por_partido`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_eventos_por_partido` (
`id_partido` int(11)
,`goles` bigint(21)
,`tarjetas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_goleadas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_goleadas` (
`id_partido` int(11)
,`fecha_hora` datetime
,`goles_local` int(11)
,`goles_visitante` int(11)
,`id_local` int(11)
,`id_visitante` int(11)
,`id_estadio` int(11)
,`id_liga` int(11)
,`id_arbitro` int(11)
,`jornada` int(11)
,`temporada` varchar(10)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_goleadores`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_goleadores` (
`id_jugador` int(11)
,`jugador` varchar(100)
,`goles` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_goles_por_equipo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_goles_por_equipo` (
`id_equipo` int(11)
,`equipo` varchar(100)
,`total_goles` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_goles_por_tipo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_goles_por_tipo` (
`tipo` varchar(50)
,`cantidad` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_jugadores_con_goles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_jugadores_con_goles` (
`id_jugador` int(11)
,`jugador` varchar(100)
,`total_goles` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_jugadores_con_tarjetas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_jugadores_con_tarjetas` (
`id_jugador` int(11)
,`jugador` varchar(100)
,`total_tarjetas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_jugadores_por_equipo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_jugadores_por_equipo` (
`id_equipo` int(11)
,`equipo` varchar(100)
,`total_jugadores` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_jugadores_por_liga`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_jugadores_por_liga` (
`id_liga` int(11)
,`liga` varchar(100)
,`id_jugador` int(11)
,`jugador` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_jugadores_sin_tarjetas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_jugadores_sin_tarjetas` (
`id_jugador` int(11)
,`jugador` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_partidos_con_goles_ambos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_partidos_con_goles_ambos` (
`id_partido` int(11)
,`goles_local` int(11)
,`goles_visitante` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_partidos_con_muchos_goles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_partidos_con_muchos_goles` (
`id_partido` int(11)
,`goles_local` int(11)
,`goles_visitante` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_partidos_empatados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_partidos_empatados` (
`id_partido` int(11)
,`fecha_hora` datetime
,`goles_local` int(11)
,`goles_visitante` int(11)
,`id_local` int(11)
,`id_visitante` int(11)
,`id_estadio` int(11)
,`id_liga` int(11)
,`id_arbitro` int(11)
,`jornada` int(11)
,`temporada` varchar(10)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_partidos_por_fecha`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_partidos_por_fecha` (
`fecha` date
,`cantidad` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_promedio_goles_por_partido`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_promedio_goles_por_partido` (
`promedio_goles` decimal(15,4)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_tarjetas_por_equipo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_tarjetas_por_equipo` (
`id_equipo` int(11)
,`equipo` varchar(100)
,`amarillas` bigint(21)
,`rojas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_tarjetas_por_jugador`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_tarjetas_por_jugador` (
`id_jugador` int(11)
,`jugador` varchar(100)
,`amarillas` bigint(21)
,`rojas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_tarjetas_por_tipo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_tarjetas_por_tipo` (
`tipo` varchar(10)
,`cantidad` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_equipos_por_liga`
--
DROP TABLE IF EXISTS `vista_equipos_por_liga`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_equipos_por_liga`  AS SELECT `l`.`id_liga` AS `id_liga`, `l`.`nombre` AS `liga`, `e`.`id_equipo` AS `id_equipo`, `e`.`nombre` AS `equipo` FROM (`ligas` `l` join `equipos` `e` on(`l`.`id_liga` = `e`.`id_liga`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_equipos_sin_goles`
--
DROP TABLE IF EXISTS `vista_equipos_sin_goles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_equipos_sin_goles`  AS SELECT `e`.`id_equipo` AS `id_equipo`, `e`.`nombre` AS `equipo` FROM ((`equipos` `e` left join `jugadores` `j` on(`e`.`id_equipo` = `j`.`id_equipo`)) left join `goles` `g` on(`j`.`id_jugador` = `g`.`id_jugador`)) WHERE `g`.`id_gol` is null ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_eventos_por_partido`
--
DROP TABLE IF EXISTS `vista_eventos_por_partido`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_eventos_por_partido`  AS SELECT `p`.`id_partido` AS `id_partido`, count(distinct `g`.`id_gol`) AS `goles`, count(distinct `t`.`id_tarjeta`) AS `tarjetas` FROM ((`partidos` `p` left join `goles` `g` on(`p`.`id_partido` = `g`.`id_partido`)) left join `tarjetas` `t` on(`p`.`id_partido` = `t`.`id_partido`)) GROUP BY `p`.`id_partido` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_goleadas`
--
DROP TABLE IF EXISTS `vista_goleadas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_goleadas`  AS SELECT `partidos`.`id_partido` AS `id_partido`, `partidos`.`fecha_hora` AS `fecha_hora`, `partidos`.`goles_local` AS `goles_local`, `partidos`.`goles_visitante` AS `goles_visitante`, `partidos`.`id_local` AS `id_local`, `partidos`.`id_visitante` AS `id_visitante`, `partidos`.`id_estadio` AS `id_estadio`, `partidos`.`id_liga` AS `id_liga`, `partidos`.`id_arbitro` AS `id_arbitro`, `partidos`.`jornada` AS `jornada`, `partidos`.`temporada` AS `temporada` FROM `partidos` WHERE abs(`partidos`.`goles_local` - `partidos`.`goles_visitante`) >= 3 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_goleadores`
--
DROP TABLE IF EXISTS `vista_goleadores`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_goleadores`  AS SELECT `j`.`id_jugador` AS `id_jugador`, `j`.`nombre` AS `jugador`, count(`g`.`id_gol`) AS `goles` FROM (`jugadores` `j` left join `goles` `g` on(`j`.`id_jugador` = `g`.`id_jugador`)) GROUP BY `j`.`id_jugador`, `j`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_goles_por_equipo`
--
DROP TABLE IF EXISTS `vista_goles_por_equipo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_goles_por_equipo`  AS SELECT `e`.`id_equipo` AS `id_equipo`, `e`.`nombre` AS `equipo`, count(`g`.`id_gol`) AS `total_goles` FROM ((`equipos` `e` join `jugadores` `j` on(`e`.`id_equipo` = `j`.`id_equipo`)) left join `goles` `g` on(`j`.`id_jugador` = `g`.`id_jugador`)) GROUP BY `e`.`id_equipo`, `e`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_goles_por_tipo`
--
DROP TABLE IF EXISTS `vista_goles_por_tipo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_goles_por_tipo`  AS SELECT `goles`.`tipo` AS `tipo`, count(0) AS `cantidad` FROM `goles` GROUP BY `goles`.`tipo` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_jugadores_con_goles`
--
DROP TABLE IF EXISTS `vista_jugadores_con_goles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_jugadores_con_goles`  AS SELECT `j`.`id_jugador` AS `id_jugador`, `j`.`nombre` AS `jugador`, count(`g`.`id_gol`) AS `total_goles` FROM (`jugadores` `j` left join `goles` `g` on(`j`.`id_jugador` = `g`.`id_jugador`)) GROUP BY `j`.`id_jugador`, `j`.`nombre` HAVING `total_goles` > 0 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_jugadores_con_tarjetas`
--
DROP TABLE IF EXISTS `vista_jugadores_con_tarjetas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_jugadores_con_tarjetas`  AS SELECT `j`.`id_jugador` AS `id_jugador`, `j`.`nombre` AS `jugador`, count(`t`.`id_tarjeta`) AS `total_tarjetas` FROM (`jugadores` `j` left join `tarjetas` `t` on(`j`.`id_jugador` = `t`.`id_jugador`)) GROUP BY `j`.`id_jugador`, `j`.`nombre` HAVING `total_tarjetas` > 0 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_jugadores_por_equipo`
--
DROP TABLE IF EXISTS `vista_jugadores_por_equipo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_jugadores_por_equipo`  AS SELECT `e`.`id_equipo` AS `id_equipo`, `e`.`nombre` AS `equipo`, count(`j`.`id_jugador`) AS `total_jugadores` FROM (`equipos` `e` left join `jugadores` `j` on(`e`.`id_equipo` = `j`.`id_equipo`)) GROUP BY `e`.`id_equipo`, `e`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_jugadores_por_liga`
--
DROP TABLE IF EXISTS `vista_jugadores_por_liga`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_jugadores_por_liga`  AS SELECT `l`.`id_liga` AS `id_liga`, `l`.`nombre` AS `liga`, `j`.`id_jugador` AS `id_jugador`, `j`.`nombre` AS `jugador` FROM ((`ligas` `l` join `equipos` `e` on(`l`.`id_liga` = `e`.`id_liga`)) join `jugadores` `j` on(`e`.`id_equipo` = `j`.`id_equipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_jugadores_sin_tarjetas`
--
DROP TABLE IF EXISTS `vista_jugadores_sin_tarjetas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_jugadores_sin_tarjetas`  AS SELECT `j`.`id_jugador` AS `id_jugador`, `j`.`nombre` AS `jugador` FROM (`jugadores` `j` left join `tarjetas` `t` on(`j`.`id_jugador` = `t`.`id_jugador`)) WHERE `t`.`id_tarjeta` is null ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_partidos_con_goles_ambos`
--
DROP TABLE IF EXISTS `vista_partidos_con_goles_ambos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_partidos_con_goles_ambos`  AS SELECT `partidos`.`id_partido` AS `id_partido`, `partidos`.`goles_local` AS `goles_local`, `partidos`.`goles_visitante` AS `goles_visitante` FROM `partidos` WHERE `partidos`.`goles_local` > 0 AND `partidos`.`goles_visitante` > 0 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_partidos_con_muchos_goles`
--
DROP TABLE IF EXISTS `vista_partidos_con_muchos_goles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_partidos_con_muchos_goles`  AS SELECT `partidos`.`id_partido` AS `id_partido`, `partidos`.`goles_local` AS `goles_local`, `partidos`.`goles_visitante` AS `goles_visitante` FROM `partidos` WHERE `partidos`.`goles_local` + `partidos`.`goles_visitante` > 5 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_partidos_empatados`
--
DROP TABLE IF EXISTS `vista_partidos_empatados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_partidos_empatados`  AS SELECT `partidos`.`id_partido` AS `id_partido`, `partidos`.`fecha_hora` AS `fecha_hora`, `partidos`.`goles_local` AS `goles_local`, `partidos`.`goles_visitante` AS `goles_visitante`, `partidos`.`id_local` AS `id_local`, `partidos`.`id_visitante` AS `id_visitante`, `partidos`.`id_estadio` AS `id_estadio`, `partidos`.`id_liga` AS `id_liga`, `partidos`.`id_arbitro` AS `id_arbitro`, `partidos`.`jornada` AS `jornada`, `partidos`.`temporada` AS `temporada` FROM `partidos` WHERE `partidos`.`goles_local` = `partidos`.`goles_visitante` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_partidos_por_fecha`
--
DROP TABLE IF EXISTS `vista_partidos_por_fecha`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_partidos_por_fecha`  AS SELECT cast(`p`.`fecha_hora` as date) AS `fecha`, count(0) AS `cantidad` FROM `partidos` AS `p` GROUP BY cast(`p`.`fecha_hora` as date) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_promedio_goles_por_partido`
--
DROP TABLE IF EXISTS `vista_promedio_goles_por_partido`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_promedio_goles_por_partido`  AS SELECT avg(`partidos`.`goles_local` + `partidos`.`goles_visitante`) AS `promedio_goles` FROM `partidos` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_tarjetas_por_equipo`
--
DROP TABLE IF EXISTS `vista_tarjetas_por_equipo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_tarjetas_por_equipo`  AS SELECT `e`.`id_equipo` AS `id_equipo`, `e`.`nombre` AS `equipo`, count(case when `t`.`tipo` = 'Amarilla' then 1 end) AS `amarillas`, count(case when `t`.`tipo` = 'Roja' then 1 end) AS `rojas` FROM ((`equipos` `e` join `jugadores` `j` on(`e`.`id_equipo` = `j`.`id_equipo`)) left join `tarjetas` `t` on(`j`.`id_jugador` = `t`.`id_jugador`)) GROUP BY `e`.`id_equipo`, `e`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_tarjetas_por_jugador`
--
DROP TABLE IF EXISTS `vista_tarjetas_por_jugador`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_tarjetas_por_jugador`  AS SELECT `j`.`id_jugador` AS `id_jugador`, `j`.`nombre` AS `jugador`, count(case when `t`.`tipo` = 'Amarilla' then 1 end) AS `amarillas`, count(case when `t`.`tipo` = 'Roja' then 1 end) AS `rojas` FROM (`jugadores` `j` left join `tarjetas` `t` on(`j`.`id_jugador` = `t`.`id_jugador`)) GROUP BY `j`.`id_jugador`, `j`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_tarjetas_por_tipo`
--
DROP TABLE IF EXISTS `vista_tarjetas_por_tipo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_tarjetas_por_tipo`  AS SELECT `tarjetas`.`tipo` AS `tipo`, count(0) AS `cantidad` FROM `tarjetas` GROUP BY `tarjetas`.`tipo` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `arbitros`
--
ALTER TABLE `arbitros`
  ADD PRIMARY KEY (`id_arbitro`);

--
-- Indices de la tabla `arbitros_partido`
--
ALTER TABLE `arbitros_partido`
  ADD PRIMARY KEY (`id_arbitros_partido`),
  ADD KEY `id_arbitro` (`id_arbitro`),
  ADD KEY `id_partido` (`id_partido`);

--
-- Indices de la tabla `asistencias`
--
ALTER TABLE `asistencias`
  ADD PRIMARY KEY (`id_asistencia`);

--
-- Indices de la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  ADD PRIMARY KEY (`id_clasificacion`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_liga` (`id_liga`);

--
-- Indices de la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD PRIMARY KEY (`id_equipo`),
  ADD KEY `id_liga` (`id_liga`);

--
-- Indices de la tabla `estadios`
--
ALTER TABLE `estadios`
  ADD PRIMARY KEY (`id_estadio`);

--
-- Indices de la tabla `goles`
--
ALTER TABLE `goles`
  ADD PRIMARY KEY (`id_gol`);

--
-- Indices de la tabla `jugadores`
--
ALTER TABLE `jugadores`
  ADD PRIMARY KEY (`id_jugador`);

--
-- Indices de la tabla `ligas`
--
ALTER TABLE `ligas`
  ADD PRIMARY KEY (`id_liga`);

--
-- Indices de la tabla `partidos`
--
ALTER TABLE `partidos`
  ADD PRIMARY KEY (`id_partido`);

--
-- Indices de la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  ADD PRIMARY KEY (`id_tarjeta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `arbitros_partido`
--
ALTER TABLE `arbitros_partido`
  MODIFY `id_arbitros_partido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  MODIFY `id_clasificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `arbitros_partido`
--
ALTER TABLE `arbitros_partido`
  ADD CONSTRAINT `arbitros_partido_ibfk_1` FOREIGN KEY (`id_arbitro`) REFERENCES `arbitros` (`id_arbitro`),
  ADD CONSTRAINT `arbitros_partido_ibfk_2` FOREIGN KEY (`id_partido`) REFERENCES `partidos` (`id_partido`);

--
-- Filtros para la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  ADD CONSTRAINT `clasificacion_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`),
  ADD CONSTRAINT `clasificacion_ibfk_2` FOREIGN KEY (`id_liga`) REFERENCES `ligas` (`id_liga`);

--
-- Filtros para la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD CONSTRAINT `equipos_ibfk_1` FOREIGN KEY (`id_liga`) REFERENCES `ligas` (`id_liga`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
