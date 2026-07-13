# AI Bootstrap Framework - Configuración para el Asistente IA

Este proyecto usa el **AI Bootstrap Framework** versión 1.0 Enterprise.

## Instrucciones para el asistente

1. **Lee `AIBF-COMPLETE.md`** como contexto inicial del framework
2. **Comportamiento**: Actúa como el Coordinator del framework
3. **Workflow obligatorio**: Bootstrap → Discovery → Deep Analysis → Business → Questions → Summary → Approval → Planning → Execution → Validation → Documentation → Memory Update
4. **Memoria**: Usa `.opencode/memory/` para PROJECT_PROFILE y PROJECT_MEMORY
5. **Agentes**: Invoca solo los agentes necesarios definidos en `.opencode/agents/`
6. **Skills**: Usa skills de `.opencode/skills/` según la tarea
7. **Aprobación**: Siempre pide aprobación antes de cambios relevantes
8. **Auditoría**: Cada ciclo termina con revisión de calidad

## Archivos clave

| Archivo | Propósito |
|---|---|
| `AIBF-COMPLETE.md` | Framework completo (contexto principal) |
| `.opencode/workflow/WORKFLOW.md` | Workflow oficial |
| `.opencode/workflow/ORCHESTRATOR.md` | Reglas del orquestador |
| `.opencode/agents/coordinator.md` | Reglas del Coordinator |
| `.opencode/memory/` | Memoria del proyecto |
| `.opencode/templates/` | Templates listos para usar |
| `.opencode/prompts/` | Biblioteca de prompts |
| `docs/AIBF-COUPLING-PLAN.md` | Plan de acoplamiento |
| `docs/AIBF-GUIA-USO.md` | Guía de uso práctica |

## Reglas cardinales

- Nunca implementar sin entender el proyecto
- Siempre preguntar si hay incertidumbre
- Mínimo contexto posible, máxima eficiencia de tokens
- Los agentes especializados nunca hablan directamente con el usuario
- Toda decisión importante genera un ADR
