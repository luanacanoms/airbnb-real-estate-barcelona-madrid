# Dashboard Airbnb — Barcelona y Madrid

Análisis interactivo de ~38.000 anuncios de Airbnb en Barcelona y Madrid,
usando SQL Server para la limpieza y agregación de datos, y Tableau para
la visualización final.

## 🔗 Dashboard

**[Ver dashboard interactivo en Tableau Public](AÑADE_TU_LINK_AQUI)**

## 📁 Contenido de esta carpeta

| Archivo | Descripción |
|---|---|
| `Airbnb Barcelona y Madrid - Dashboard interativo.twb` | Archivo de Tableau con el dashboard completo |
| `airbnb_analysis.sql` | Script SQL de limpieza, unión de tablas y generación de KPIs |
| `tabla_1_kpis.csv` | KPIs generales por ciudad (precio, valoración, total de anuncios) |
| `tabla_2_kpis.csv` | Precio máximo por barrio |
| `tabla_3_kpis.csv` | Datos geográficos por anuncio (para el mapa) |
| `tabla_4_kpis.csv` | Reseñas acumuladas por fecha y ciudad (para la tendencia) |

## 🧮 Técnicas SQL utilizadas

- `UNION ALL` para combinar datasets de Barcelona y Madrid
- `JOIN` entre tablas de anuncios y reseñas
- **CTE** (Common Table Expressions)
- **Window Functions**: `SUM(COUNT(*)) OVER (PARTITION BY ... ORDER BY ...)`
  para calcular reseñas acumuladas
- Tablas temporales (`#ResenasAcumuladas`)
- **Vista** (`VistaResenasAcumuladas`) para alimentar Tableau directamente

## 📈 Contenido del dashboard

- KPIs: precio medio, valoración media, total de anuncios
- Top 10 barrios más caros
- Mapa de distribución geográfica por precio
- Distribución por tipo de alojamiento
- Tendencia de reseñas acumuladas (Barcelona vs. Madrid, 2016–2026)

## Fuente de datos

[Inside Airbnb](http://insideairbnb.com/) — datos públicos y abiertos de
anuncios de Airbnb en Barcelona y Madrid.
