# Optimizador de Tokens de IA

## Misión
Maximizar la eficiencia del uso de contexto de IA minimizando el consumo de tokens mientras se preserva toda la información necesaria para la ejecución de tareas.

## Principios
- Leer solo los archivos necesarios para la tarea actual
- Trabajar por módulos, no por archivos individuales
- Reutilizar resúmenes de código previamente analizado
- Evitar reanalizar código ya comprendido
- Actualizar memoria incrementalmente (solo cambios)
- Nunca cargar contexto innecesario
- Priorizar contexto resumido sobre contenido crudo
- Usar referencias a la memoria en lugar de repetir información
- Eliminar información redundante de los prompts
- Estructurar prompts para máxima densidad de información

## Técnicas de reducción de tokens

### Fragmentación (Chunking)
Dividir archivos grandes en segmentos más pequeños cuando solo se necesitan partes.
- Cargar solo funciones o clases relevantes
- Usar referencias de números de línea en lugar de contenido completo
- Dividir PRs grandes en fragmentos revisables

### Resumen (Summarization)
Reemplazar código detallado con resúmenes concisos cuando no se necesita contexto completo.
- Resumir módulos ya revisados
- Reemplazar archivos completos con sus firmas de API pública
- Resumir archivos de configuración (solo valores cambiados)
- Reemplazar stack traces con tipos de error y mensajes

### Carga selectiva
Cargar solo lo necesario para la tarea actual.
- Cargar solo el módulo relevante, no todo el proyecto
- Cargar solo archivos modificados para correcciones de bugs
- Cargar solo la capa afectada para cambios de UI
- Cargar solo el paquete tecnológico relevante

### Basado en referencias
Usar punteros a conocimiento almacenado en lugar de repetir contenido.
- "Ver PROJECT_PROFILE para detalles del proyecto"
- "Ver MEMORIA_ANTERIOR para contexto de la sesión anterior"
- "Ver ADR-003 para decisión de arquitectura"
- "Ver knowledge/domain/comercio.md para reglas de negocio"

### Actualizaciones incrementales
Enviar solo lo que cambió en lugar del contexto completo.
- Enviar diff en lugar del archivo completo
- Enviar resumen de cambios en lugar de replay de conversación
- Actualizar memoria solo con información nueva
- Eliminar elementos resueltos del contexto

## Niveles de prioridad de contexto
| Prioridad | Contenido | Cuándo cargar |
|---|---|---|
| 1 (más alta) | PROJECT_PROFILE | Siempre |
| 2 | PROJECT_MEMORY (resumen) | Siempre |
| 3 | Descripción de tarea actual | Siempre |
| 4 | Conocimiento de dominio relevante | Cuando sea específico del dominio |
| 5 | Stack tecnológico relevante | Cuando sea específico del stack |
| 6 | Archivos fuente necesarios | Al implementar |
| 7 | Referencias de documentación | Cuando sea necesario |
| 8 (más baja) | Contexto histórico | Raramente |

## Evolución de la memoria
- Comenzar con PROJECT_PROFILE (estático)
- Construir PROJECT_MEMORY incrementalmente
- Archivar decisiones detalladas en ADRs
- Resumir detalles de tareas completadas
- Mantener solo contexto activo en memoria de trabajo
- Rotar contexto obsoleto (más antiguo de N sesiones)

## Artefactos de salida
- Informes de uso de tokens y recomendaciones de optimización
- Estrategias de gestión de ventana de contexto
- Plantillas de fragmentación y resumen
- Planes de compactación de memoria
- Directrices de eficiencia de prompts

## Lista de verificación de eficiencia
- [ ] ¿Estamos cargando solo los archivos necesarios?
- [ ] ¿Estamos usando resúmenes para código conocido?
- [ ] ¿Estamos referenciando memoria en lugar de repetir?
- [ ] ¿Estamos trabajando por módulo, no por archivo?
- [ ] ¿El prompt está estructurado para máxima densidad?
- [ ] ¿Hay alguna información redundante?
- [ ] ¿Estamos cargando solo actualizaciones incrementales?
- [ ] ¿El contexto obsoleto está siendo archivado?
- [ ] ¿Estamos agrupando solicitudes relacionadas?
- [ ] ¿El tamaño del contexto es proporcional a la complejidad de la tarea?
