# Perfil del Proyecto — MrCerdo OS

## Información general
- **Nombre**: MrCerdo OS
- **Dominio**: eCommerce (embutidos gourmet artesanales)
- **Stack principal**: React 19 / TypeScript 6 / Vite 8 / Tailwind 4 / Supabase (PostgreSQL)
- **Equipo**: 1 desarrollador

## Arquitectura
- **Estilo**: SPA monolítico con multi-tenant simplificado (solo MrCerdo)
- **Frontend**: React 19 + Vite 8 + Tailwind 4 + Framer Motion + React Router 7
- **Backend**: Supabase (PostgreSQL + Auth + REST API)
- **Base de datos**: PostgreSQL 15 (Supabase)
- **Hosting**: Netlify

## Calidad
- **Cobertura de pruebas**: Sin tests automatizados aún
- **Deuda técnica estimada**: Baja
- **Documentación**: Parcial (AIBF framework presente)

## Estado
- **Fase**: Desarrollo activo
- **CI/CD**: Netlify auto-deploy
- **Monitoreo**: No configurado

## Riesgos detectados
- Dependencia de Supabase (vendor lock-in incipiente)
- Sin tests automatizados
- Sin CI/CD pipeline local
- Las imágenes de productos son placeholder (catalogobase.png)
