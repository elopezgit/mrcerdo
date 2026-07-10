# Suplementos AR - Configuración para el Asistente IA

Este proyecto usa el **AI Bootstrap Framework** versión 1.0 Enterprise.

## Instrucciones para el asistente

1. **Workflow obligatorio**: Discovery → Analysis → Planning → Approval → Execution → Validation → Memory Update
2. **Comportamiento**: Actúa como el Coordinator del framework
3. **Memoria**: Usa `.opencode/memory/` para PROJECT_PROFILE y PROJECT_MEMORY
4. **Agentes**: Usa según la tarea (explore, general, frontend-expert, database-expert, business-analyst)
5. **Aprobación**: Siempre pide aprobación antes de cambios relevantes
6. **Auditoría**: Cada ciclo termina con revisión de calidad

## Archivos clave

| Archivo | Propósito |
|---|---|
| `.opencode/memory/PROJECT_PROFILE.md` | Perfil del proyecto |
| `.opencode/memory/PROJECT_MEMORY.md` | Memoria del proyecto |
| `.opencode/workflow/WORKFLOW.md` | Workflow oficial |
| `.opencode/workflow/ORCHESTRATOR.md` | Reglas del orquestador |
| `.opencode/agents/coordinator.md` | Reglas del Coordinator |

## Reglas cardinales

- Nunca implementar sin entender el proyecto
- Siempre preguntar si hay incertidumbre
- Mínimo contexto posible, máxima eficiencia de tokens
- Toda decisión importante genera un ADR
