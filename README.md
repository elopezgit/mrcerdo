# TITAN FUEL SUPLEMENTOS — E-Commerce & POS Platform

Plataforma de comercio electrónico, catálogo minorista/mayorista, sistema de pedidos y Punto de Venta (POS) diseñado específicamente para **TITAN FUEL SUPLEMENTOS**.

---

## 🚀 Características Principales

1. **Catálogo Digital Interactivo & Optimizado**
   - Más de 300 productos cargados e indexados por categoría (Proteínas, Creatinas, Pre-Entrenos, Quemadores, Aminoácidos, Vitaminas, Barras & Snacks, Accesorios).
   - Filtrado rápido por **Marcas Oficiales** (Star Nutrition, ENA Sport, Hoch Sport, Nutrilab, Body Advanced, Generation Fit, Vitamin Way, Mervick, Xtrenght, Gold Nutrition, Natuliv).
   - Badges visuales con logotipos vectoriales de marcas oficiales.
   - Búsqueda instantánea por palabras clave y código de producto.

2. **Diseño Visual Cyber-Athletic Premium**
   - Paleta de color oficial: **Rojo Eléctrico** (`#FF1E27`), **Naranja Llama** (`#FF5C00`) y **Obsidian Dark** (`#09090E`).
   - Sello oficial de autenticidad en cada producto: *100% Original & Garantizado*.

3. **Carrito & Checkout Directo**
   - Cálculo automático de totales.
   - Datos bancarios oficiales precargados:
     - **Alias:** `strong.gramlo`
     - **Teléfono / WhatsApp:** `3814751620`
   - Generación de pedido por WhatsApp / Seguimiento en vivo.

4. **Panel de Administración Completo (`/admin/titanfuel`)**
   - **Gestión de Catálogo:** Alta, baja y edición de productos, precios y categorías.
   - **Punto de Venta (POS):** Módulo de facturación rápida en mostrador para vendedores.
   - **Tablero Kanban de Pedidos:** Flujo de cocina/armado en tiempo real.
   - **Banners Promocionales:** Edición de banners publicitarios.
   - **Analíticas:** Estadísticas de ventas y métricas clave.

---

## 🛠️ Tecnologías Utilizadas

* **React 18** + **TypeScript**
* **Vite** (Build ultra-rápido)
* **Tailwind CSS** + **Framer Motion** (Animaciones fluidas)
* **Supabase** (Base de datos PostgreSQL real-time & Auth)
* **Lucide Icons**

---

## 📦 Instalación y Uso

```bash
# 1. Instalar dependencias
npm install

# 2. Iniciar servidor de desarrollo
npm run dev

# 3. Compilar para producción
npm run build
```

---

## 🗄️ Carga Inicial de Datos (Seed SQL)

Para poblar la base de datos de Supabase con la tienda oficial **TITAN FUEL SUPLEMENTOS** y sus 318 productos completos:
1. Abre tu consola de SQL en Supabase.
2. Ejecuta el archivo ubicado en `sql/seed_suplementos.sql`.
