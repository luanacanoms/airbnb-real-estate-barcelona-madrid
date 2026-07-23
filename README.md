Análisis del Mercado Inmobiliario: Barcelona y Madrid
Portfolio de análisis de datos centrado en el mercado de vivienda y alquiler
a corto plazo (Airbnb) en dos de las ciudades más dinámicas de España:
Barcelona y Madrid.
El proyecto está compuesto por tres análisis conectados, cada uno
abordando el mismo tema desde un ángulo distinto — precios de alquiler
turístico, precios de venta de vivienda, y rentabilidad potencial — usando
un stack de herramientas profesional: SQL Server, Tableau, Figma y Excel.

Proyectos

Dashboard interactivo de Airbnb (SQL Server + Tableau)
Análisis de ~38.000 anuncios de Airbnb en Barcelona y Madrid: precios,
valoraciones, tipo de alojamiento, distribución geográfica y evolución de
reseñas a lo largo de una década (2016–2026).
Herramientas: SQL Server (T-SQL), Tableau Public
Técnicas SQL: JOIN, CTE, Window Functions (`SUM() OVER()`), tablas
temporales, vistas (Views)

Fuente de datos: Inside Airbnb

Dashboard interactivo: Ver en Tableau Public

`01-tableau-airbnb/`
Contenido del dashboard:
KPIs generales: precio medio, valoración media, total de anuncios
Top 10 barrios más caros
Mapa de distribución geográfica por precio
Distribución por tipo de alojamiento
Tendencia de reseñas acumuladas, Barcelona vs. Madrid

Limpieza y análisis de datos de venta de vivienda (SQL Server + Figma)
Limpieza y transformación de datos de venta de propiedades en Barcelona
(Idealista), con diseño de dashboard visual en Figma para presentar los
principales indicadores del mercado de compraventa.
Herramientas: SQL Server (T-SQL), Figma
Técnicas SQL: transformación de texto, `CASE WHEN`, detección y
eliminación de duplicados con `ROW\_NUMBER() OVER()`, `ALTER TABLE`
Fuente de datos: Idealista (anuncios de venta, Barcelona)

`02-sql-barcelona-housing/`
Contenido del dashboard:
KPIs: total de propiedades, precio medio, precio medio por m², tamaño mediano
Distribución según ascensor y estado de la propiedad
Precio medio por década de construcción
Precio medio según número de habitaciones
Top 5 barrios más caros

Dashboard de alquiler Airbnb (Excel)
Análisis de precios y disponibilidad de anuncios de Airbnb en Barcelona
mediante Tabla Dinámica, con foco en detectar posibles patrones de alquiler
de larga duración disfrazado de alquiler turístico.
Herramientas: Excel (Tabla Dinámica, gráficos dinámicos)

`03-excel-airbnb-rental/`
Contenido:
Precio medio por barrio y tipo de alojamiento
Disponibilidad media anual por anuncio
Insight: anuncios con alta disponibilidad todo el año como posible
indicio de alquiler de larga duración

Stack técnico
Categoría	Herramientas
Bases de datos	SQL Server (T-SQL)
Visualización	Tableau Public, Excel
Diseño UI	Figma
Fuentes de datos	Inside Airbnb, Idealista

Nota sobre el archivo `.twb`
El archivo de Tableau (`.twb`) incluido en este repositorio referencia las
fuentes de datos mediante una ruta local. Para abrirlo correctamente:
Descarga la carpeta `01-tableau-airbnb/` completa (incluye los CSV)
Abre el `.twb` en Tableau Desktop
Si aparece un error de conexión, haz clic derecho sobre la fuente de
datos afectada → Editar conexión → selecciona el CSV correspondiente
en tu carpeta local
Para una visualización sin configuración adicional, se recomienda usar el
link de Tableau Public enlazado arriba, que no requiere reconexión.

Autora
Luana de Morais Cano
Estudiante de Ingeniería Informática — Universidad Miguel Hernández (UMH)
