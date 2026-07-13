-- ============================================================
-- CLEANUP MR CERDO — Eliminar datos legacy de suplementos
-- ============================================================
-- Ejecutar SOLO para el tenant MrCerdo.
-- No afecta a otros tenants (titanfuel, suplementosar, etc.)
--
-- 1. Primero ejecutar schema.sql
-- 2. Luego este cleanup
-- 3. Luego seed_mrcerdo.sql
-- ============================================================

DO $$
DECLARE
  v_emp_id uuid;
BEGIN
  SELECT id INTO v_emp_id FROM empresas WHERE slug = 'mrcerdo' LIMIT 1;

  IF v_emp_id IS NULL THEN
    RAISE NOTICE '⚠️ No se encontró la empresa MrCerdo. Ejecutá primero el seed.';
    RETURN;
  END IF;

  -- 1. Eliminar SOLO categorías que NO son de MrCerdo (sólo conservamos Chorizos)
  DELETE FROM categories
  WHERE empresa_id = v_emp_id
    AND name NOT IN ('Chorizos');

  -- 2. Eliminar SOLO productos que NO son las 6 variedades oficiales de Chorizo
  DELETE FROM products
  WHERE empresa_id = v_emp_id
    AND code NOT IN ('CH-001','CH-002','CH-003','CH-004','CH-005','CH-006');

  RAISE NOTICE '✅ Cleanup MrCerdo completado: solo quedan las 6 variedades oficiales de Chorizos Gourmet.';
END $$;
