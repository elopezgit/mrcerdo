-- ============================================================
-- SEED MR CERDO — Embutidos Gourmet Artesanales
-- ============================================================
-- Limpia datos previos y siembra solo los 9 productos reales.
--
-- Ejecutar en la consola SQL de Supabase:
--   1. schema.sql
--   2. cleanup_mrcerdo.sql (opcional, si hay datos sucios)
--   3. este archivo
-- ============================================================

DO $$
DECLARE
  v_emp_id uuid;
  cat_chorizos uuid;
BEGIN
  -- ============================================================
  -- 1. EMPRESA: MrCerdo
  -- ============================================================
  INSERT INTO empresas (slug, name, phone, instagram_url, maps_url, logo_url, is_active)
  VALUES
    ('mrcerdo', 'MrCerdo', '5493816045706', 'https://www.instagram.com/mrcerdo.26', NULL, '/img/logo/logoMrCerdo.jpg', true)
  ON CONFLICT (slug) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    instagram_url = EXCLUDED.instagram_url,
    logo_url = EXCLUDED.logo_url;

  SELECT id INTO v_emp_id FROM empresas WHERE slug = 'mrcerdo' LIMIT 1;

  -- ============================================================
  -- 2. LIMPIAR datos previos del tenant MrCerdo
  -- ============================================================
  DELETE FROM products  WHERE empresa_id = v_emp_id;
  DELETE FROM banners   WHERE empresa_id = v_emp_id;
  DELETE FROM categories WHERE empresa_id = v_emp_id;

  -- ============================================================
  -- 3. CATEGORÍAS (sólo Chorizos Gourmet por ahora)
  -- ============================================================
  INSERT INTO categories (empresa_id, name, icon) VALUES
    (v_emp_id, 'Chorizos', '🌭');

  SELECT id INTO cat_chorizos FROM categories WHERE empresa_id = v_emp_id AND name = 'Chorizos' LIMIT 1;

  -- ============================================================
  -- 4. BANNERS
  -- ============================================================
  INSERT INTO banners (empresa_id, image_url, link, is_active, sort_order) VALUES
    (v_emp_id, '/img/Banner/bannertupedido.png', NULL, true, 1);

  -- ============================================================
  -- 5. PRODUCTOS — solo las 6 variedades exclusivas de Chorizo Gourmet
  -- ============================================================
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order, is_active) VALUES
    (v_emp_id, cat_chorizos, 'Chorizo Tomillo, Mostaza y Miel', 'Dulce y aromático. El equilibrio perfecto. Chorizo artesanal gourmet elaborado con tomillo fresco, mostaza seleccionada y un toque de miel pura.', 3500, '/img/Catalogo/catalogobase.png', 'CH-001', 1, true),
    (v_emp_id, cat_chorizos, 'Chorizo Morrón y Aceituna', 'Sabroso y colorido. Con un toque mediterráneo. Chorizo artesanal con morrón asado al fuego y aceitunas verdes seleccionadas.', 3500, '/img/Catalogo/catalogobase.png', 'CH-002', 2, true),
    (v_emp_id, cat_chorizos, 'Chorizo Roquefort y Pera', 'Intenso y sofisticado. Un clásico gourmet. Chorizo artesanal relleno con auténtico queso roquefort y trozos de pera fresca.', 3800, '/img/Catalogo/catalogobase.png', 'CH-003', 3, true),
    (v_emp_id, cat_chorizos, 'Chorizo Higo y Parmesano', 'Agridulce y sabroso. Una combinación única. Chorizo artesanal gourmet elaborado con higos secos seleccionados y queso parmesano.', 3800, '/img/Catalogo/catalogobase.png', 'CH-004', 4, true),
    (v_emp_id, cat_chorizos, 'Chorizo Español con Cheddar', 'Clásico y fundente. El sabor que todos aman. Chorizo artesanal estilo español con corazón de queso cheddar fundido.', 3600, '/img/Catalogo/catalogobase.png', 'CH-005', 5, true),
    (v_emp_id, cat_chorizos, 'Chorizo Criollo', 'Tradicional y bien criollo. Puro sabor. Receta tradicional argentina elaborada 100% con puro cerdo y especias criollas.', 3200, '/img/Catalogo/catalogobase.png', 'CH-006', 6, true);

  RAISE NOTICE '✅ MrCerdo seed completado: 1 categoría, 6 chorizos gourmet, 1 banner.';
END $$;
