# Limpieza de datos y análisis de vivienda — Barcelona (Idealista)

Limpieza y transformación de datos de venta de propiedades en Barcelona,
con exportación de KPIs agregados y diseño de dashboard visual en Figma.

## 🎨 Dashboard (Figma)

![Dashboard de vivienda en Barcelona](Barcelona%20Housing%20Dashboard.jpg)

## 📁 Contenido de esta carpeta

| Archivo | Descripción |
|---|---|
| `limpieza_barcelona_housing.sql` | Script de limpieza: normalización de barrios, separación de calle/número, estandarización de la condición de la propiedad, eliminación de duplicados |
| `Barcelona Housing.sql` | Queries de análisis: KPIs, precio por barrio, distribución por condición, precio por habitaciones, impacto del ascensor |
| `Barcelona Housing Dashboard.jpg` | Captura del dashboard final diseñado en Figma |

## 🧮 Técnicas SQL utilizadas

- Transformación de texto: `CHARINDEX`, `SUBSTRING`, `LTRIM`
- Estandarización de categorías con `CASE WHEN`
- Detección y eliminación de duplicados con `ROW_NUMBER() OVER (PARTITION BY ...)`
- `ALTER TABLE` para añadir/eliminar columnas
- Agregaciones: `AVG`, `COUNT`, distribución porcentual con `SUM() OVER()`

## 📈 Contenido del dashboard

- KPIs: total de propiedades, precio medio, precio medio por m², tamaño mediano
- Distribución según ascensor
- Distribución según estado de la propiedad
- Precio medio por década de construcción
- Precio medio según número de habitaciones (1 a 8)
- Top 5 barrios más caros

## Fuente de datos

Idealista — anuncios de venta de propiedades en Barcelona.
