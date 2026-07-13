# Base de Datos

## Esquema principal
- [Tabla/colección 1]
- [Tabla/colección 2]

## Estrategia
- **Motor**: [PostgreSQL / SQL Server / MongoDB / etc.]
- **ORM**: [Entity Framework / Sequelize / Prisma / etc.]
- **Migraciones**: [Flyway / EF Migrations / Alembic / etc.]

## Conexiones
| Nombre | Cadena de conexión (referencia) | Propósito |
|---|---|---|
| Principal | `CONNECTION_STRINGS__PRIMARY` | Operaciones CRUD |
| ReadOnly | `CONNECTION_STRINGS__READONLY` | Consultas reportes |

## Políticas
- **Backup**: [Frecuencia, retención]
- **Retención de datos**: [Período por tipo de dato]
- **Encriptación**: [En reposo, en tránsito]

## Pendientes
- [Pendiente 1]
