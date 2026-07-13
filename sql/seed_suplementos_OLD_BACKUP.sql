-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- SEED IDEMPOTENTE â€” Suplementos AR - CatÃ¡logo Completo Lisa Mayorista (1)
-- 318 Productos cargados sin omitir ninguno, con CategorÃ­as, Precios y Fotos.
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

-- â–ˆ 0. ASEGURAR COLUMNAS EN ESQUEMA EXISTENTE
ALTER TABLE products ADD COLUMN IF NOT EXISTS code text;
ALTER TABLE products ADD COLUMN IF NOT EXISTS image_url text;
ALTER TABLE products ADD COLUMN IF NOT EXISTS sort_order integer DEFAULT 0;
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_active boolean DEFAULT true;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS icon text;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS sort_order integer DEFAULT 0;
ALTER TABLE banners ADD COLUMN IF NOT EXISTS sort_order integer DEFAULT 0;

-- █ 1. EMPRESA (upsert por slug titanfuel y suplementosar para compatibilidad)
INSERT INTO empresas (slug, name, phone, instagram_url, is_active)
VALUES 
(
  'titanfuel',
  'TITAN FUEL SUPLEMENTOS',
  '3814751620',
  'https://www.instagram.com/titanfuelsuplementos',
  true
),
(
  'suplementosar',
  'TITAN FUEL SUPLEMENTOS',
  '3814751620',
  'https://www.instagram.com/titanfuelsuplementos',
  true
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  phone = EXCLUDED.phone,
  instagram_url = EXCLUDED.instagram_url,
  is_active = EXCLUDED.is_active;

DO $$
DECLARE
  v_emp_id uuid;
BEGIN
  SELECT id INTO v_emp_id FROM empresas WHERE slug = 'titanfuel' LIMIT 1;
  IF v_emp_id IS NULL THEN
    SELECT id INTO v_emp_id FROM empresas WHERE slug = 'suplementosar' LIMIT 1;
  END IF;

  -- â–ˆ 2. LIMPIAR datos viejos de esta empresa
  DELETE FROM products  WHERE empresa_id = v_emp_id;
  DELETE FROM categories WHERE empresa_id = v_emp_id;
  DELETE FROM banners WHERE empresa_id = v_emp_id;

  -- â–ˆ 2.1 BANNERS OFICIALES TITAN FUEL
  INSERT INTO banners (empresa_id, title, subtitle, image_url, link_url, sort_order) VALUES
    (v_emp_id, 'COMBUSTIBLE DE TITANES', 'EnvÃ­os a todo el paÃ­s mayorista y minorista', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1200&q=80', null, 1),
    (v_emp_id, 'POTENCIA TU RENDIMIENTO', 'Las mejores marcas oficiales al mejor precio', 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=1200&q=80', null, 2),
    (v_emp_id, '100% PURA CREATINA & WHEY', 'Calidad superior en suplementaciÃ³n deportiva', 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=1200&q=80', null, 3);

  -- â–ˆ 3. CATEGORÃAS (9 categorÃ­as oficiales)
  INSERT INTO categories (empresa_id, name, icon) VALUES
    (v_emp_id, 'ProteÃ­nas',             'ðŸ¥›'),
    (v_emp_id, 'Creatinas',             'âš¡'),
    (v_emp_id, 'Pre-Entrenos',          'ðŸš€'),
    (v_emp_id, 'Quemadores',            'ðŸ”¥'),
    (v_emp_id, 'Aminoácidos & BCAA',    'ðŸ’ª'),
    (v_emp_id, 'Vitaminas & Minerales',  'ðŸ’Š'),
    (v_emp_id, 'ColÃ¡genos & Belleza',   'âœ¨'),
    (v_emp_id, 'Ganadores & EnergÃ­a',   'ðŸ‹ï¸'),
    (v_emp_id, 'Accesorios & Snacks',   'ðŸ«');

  -- â–ˆ 4. PRODUCTOS (318 productos de Lisa Mayorista)

  -- â”€â”€â”€ PRE-ENTRENOS (25 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] 100% BETA ALANINA X 300GRS', 'Marca oficial STAR NUTRITION. 100% BETA ALANINA X 300GRS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 23874.46, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'ST-0001', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CAFFEINE 200 X 30CAPS', 'Marca oficial STAR NUTRITION. CAFFEINE 200 X 30CAPS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 7005.57, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'ST-0003', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] L - ARGININA GH X 150 GRS', 'Marca oficial STAR NUTRITION. L - ARGININA GH X 150 GRS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 14892.96, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'ST-0023', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] L-CITRULINE X300 GRS', 'Marca oficial STAR NUTRITION. L-CITRULINE X300 GRS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 50704.65, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'ST-0026', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] PUMP V8 X 285GRS', 'Marca oficial STAR NUTRITION. PUMP V8 X 285GRS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 25600.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'ST-0039', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] ARGININA 1500 X 60 CAPS', 'Marca oficial HOCH SPORT. ARGININA 1500 X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 9984.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'HO-0050', 6
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] ARGININA POWDER X 210GR', 'Marca oficial HOCH SPORT. ARGININA POWDER X 210GR. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 12486.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'HO-0051', 7
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] FLASH 5D X 320GR PREMIUM SERIES', 'Marca oficial HOCH SPORT. FLASH 5D X 320GR PREMIUM SERIES. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 18861.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'HO-0061', 8
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] NOX-BLOOD 180GR PREMIUM SERIES', 'Marca oficial HOCH SPORT. NOX-BLOOD 180GR PREMIUM SERIES. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 18287.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'HO-0065', 9
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] TESTOHIGH 120 CAPS PREMIUM SERIES', 'Marca oficial HOCH SPORT. TESTOHIGH 120 CAPS PREMIUM SERIES. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 23708.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'HO-0066', 10
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] BETA ALANINE X 60 TABS', 'Marca oficial ENA SPORT. BETA ALANINE X 60 TABS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 9172.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'EN-0078', 11
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CAFEINA X 60 CAPS', 'Marca oficial ENA SPORT. CAFEINA X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 8580.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'EN-0079', 12
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] PRE WAR X 400 GR', 'Marca oficial ENA SPORT. PRE WAR X 400 GR. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 23374.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'EN-0106', 13
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] TESTO GEN', 'Marca oficial GENERATION FIT. TESTO GEN. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 18900.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'GE-0130', 14
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] PRE 300 GR', 'Marca oficial NUTRILAB. PRE 300 GR. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 21972.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'NU-0144', 15
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] ARGININA 200GR', 'Marca oficial BODY ADVANCED. ARGININA 200GR. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 12005.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'BO-0151', 16
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] CAFFEINE ANHYDROUS 90COMP', 'Marca oficial BODY ADVANCED. CAFFEINE ANHYDROUS 90COMP. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 7229.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'BO-0155', 17
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] NITRIX BOMB 90COMP', 'Marca oficial BODY ADVANCED. NITRIX BOMB 90COMP. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 5747.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'BO-0171', 18
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] TESTO PRO MAX 240GR', 'Marca oficial BODY ADVANCED. TESTO PRO MAX 240GR. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 12950.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'BO-0172', 19
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CAFEINA ENERGY X 30', 'Marca oficial VITAMIN WAY. CAFEINA ENERGY X 30. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 8007.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'VI-0184', 20
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] PRE WORK X 450GR', 'Marca oficial VITAMIN WAY. PRE WORK X 450GR. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 18110.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'VI-0221', 21
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] PRE WORK OUT X 300GR', 'Marca oficial MERVICK. PRE WORK OUT X 300GR. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 27933.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'ME-0251', 22
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] NITROX X 180 COMP', 'Marca oficial XTRENGHT. NITROX X 180 COMP. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 12159.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'XT-0274', 23
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] PRE WORK 280GRS', 'Marca oficial GOLD NUTRITION. PRE WORK 280GRS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 18189.00, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80', 'GO-0298', 24
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] TESTO GOLD - 120 CAPS', 'Marca oficial GOLD NUTRITION. TESTO GOLD - 120 CAPS. Producto de alta pureza y calidad garantizada en la línea de Pre-Entrenos de TITAN FUEL SUPLEMENTOS.', 23386.00, 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80', 'GO-0299', 25
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Pre-Entrenos';

  -- â”€â”€â”€ AMINOÃCIDOS & BCAA (40 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] BCAA 2000 X 120 CAPS', 'Marca oficial STAR NUTRITION. BCAA 2000 X 120 CAPS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 15219.56, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'ST-0002', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] ESSENTIAL AMINO 360GR', 'Marca oficial STAR NUTRITION. ESSENTIAL AMINO 360GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 27034.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ST-0016', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] HMB X 180 CAPS', 'Marca oficial STAR NUTRITION. HMB X 180 CAPS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 20990.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'ST-0017', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] L-GLUTAMINE X 150 GRS', 'Marca oficial STAR NUTRITION. L-GLUTAMINE X 150 GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 16378.99, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ST-0027', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] L-GLUTAMINE X 300 GRS', 'Marca oficial STAR NUTRITION. L-GLUTAMINE X 300 GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 27303.76, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'ST-0028', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] MTOR BCAA X 270 GR', 'Marca oficial STAR NUTRITION. MTOR BCAA X 270 GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 26372.95, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ST-0030', 6
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] AMINOCELL 200GR PREMIUM SERIES', 'Marca oficial HOCH SPORT. AMINOCELL 200GR PREMIUM SERIES. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 13763.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'HO-0049', 7
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] BCAA BEST 3.1.1X245GS PREMIUM SERIES', 'Marca oficial HOCH SPORT. BCAA BEST 3.1.1X245GS PREMIUM SERIES. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 20385.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'HO-0052', 8
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] BCAA POWDER SOLUBLE X 226GR', 'Marca oficial HOCH SPORT. BCAA POWDER SOLUBLE X 226GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 19320.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'HO-0053', 9
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] BCAA2200 X 100 CAPS', 'Marca oficial HOCH SPORT. BCAA2200 X 100 CAPS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 13010.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'HO-0054', 10
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] GLUTAMINA POWDER X 200GR', 'Marca oficial HOCH SPORT. GLUTAMINA POWDER X 200GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 16298.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'HO-0062', 11
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] AMINO 4500 X 150 TABS', 'Marca oficial ENA SPORT. AMINO 4500 X 150 TABS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 19468.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0075', 12
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] BCAA 12:1:1 X 120 CAPS', 'Marca oficial ENA SPORT. BCAA 12:1:1 X 120 CAPS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 11776.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'EN-0076', 13
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] BCAA 2:1:1 X 90 CAPS', 'Marca oficial ENA SPORT. BCAA 2:1:1 X 90 CAPS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 10947.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0077', 14
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] GLUTAMINA 150 GRS', 'Marca oficial ENA SPORT. GLUTAMINA 150 GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 14971.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'EN-0097', 15
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] GLUTAMINA 300 GRS', 'Marca oficial ENA SPORT. GLUTAMINA 300 GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 26765.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0098', 16
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] RE LOAD BCAA 2:1:1 X 220 GR', 'Marca oficial ENA SPORT. RE LOAD BCAA 2:1:1 X 220 GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 16569.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'EN-0109', 17
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] TRUEMADE AMINO FULL X 146GRS', 'Marca oficial ENA SPORT. TRUEMADE AMINO FULL X 146GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 14794.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0111', 18
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] EAAS X 360GRS', 'Marca oficial GENERATION FIT. EAAS X 360GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 17160.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'GE-0122', 19
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] GLUTAMINA', 'Marca oficial GENERATION FIT. GLUTAMINA. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 15330.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GE-0125', 20
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] AMINO ENERGY 240 COMP', 'Marca oficial NUTRILAB. AMINO ENERGY 240 COMP. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 11971.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'NU-0131', 21
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] BCAA 2400 240 COMP', 'Marca oficial NUTRILAB. BCAA 2400 240 COMP. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 17277.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'NU-0133', 22
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] BCAA RECOVERY 300 GR', 'Marca oficial NUTRILAB. BCAA RECOVERY 300 GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 14300.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'NU-0134', 23
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] EAA X 300 GR', 'Marca oficial NUTRILAB. EAA X 300 GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 20852.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'NU-0138', 24
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] BCAA 2200 120COMP', 'Marca oficial BODY ADVANCED. BCAA 2200 120COMP. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 7127.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'BO-0152', 25
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] BCAA AMINO 8,1,1 280GR', 'Marca oficial BODY ADVANCED. BCAA AMINO 8,1,1 280GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 12051.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'BO-0153', 26
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] EAA AMINO X 300GRS', 'Marca oficial BODY ADVANCED. EAA AMINO X 300GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 15666.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'BO-0163', 27
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] GLUTAMINA 300GR', 'Marca oficial BODY ADVANCED. GLUTAMINA 300GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 14201.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'BO-0164', 28
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] GLUTAMINE 250GR POWER', 'Marca oficial BODY ADVANCED. GLUTAMINE 250GR POWER. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 8877.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'BO-0165', 29
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] GLUTAMINA X 150GR', 'Marca oficial VITAMIN WAY. GLUTAMINA X 150GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 10517.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'VI-0207', 30
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] BCAA X 120 TABS', 'Marca oficial MERVICK. BCAA X 120 TABS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 10874.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'ME-0234', 31
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] L-GLUTAMINA X 300GR', 'Marca oficial MERVICK. L-GLUTAMINA X 300GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 19789.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ME-0247', 32
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] BCAA PRO X 120 CAPSULAS', 'Marca oficial XTRENGHT. BCAA PRO X 120 CAPSULAS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 11206.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'XT-0262', 33
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] GLUTAMINE X300GR', 'Marca oficial XTRENGHT. GLUTAMINE X300GR. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 23654.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'XT-0270', 34
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] HYDRO BCAA PRO X 360 GRS', 'Marca oficial XTRENGHT. HYDRO BCAA PRO X 360 GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 21969.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'XT-0271', 35
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] AMINO ESSENTIAL X 240GRS', 'Marca oficial GOLD NUTRITION. AMINO ESSENTIAL X 240GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 20138.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GO-0278', 36
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] AMINO GOLDX 280GRS', 'Marca oficial GOLD NUTRITION. AMINO GOLDX 280GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 20138.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'GO-0279', 37
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] BCAA 2000 X 120 TABS', 'Marca oficial GOLD NUTRITION. BCAA 2000 X 120 TABS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 12343.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GO-0280', 38
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] GLUTAMINA X 225GRS', 'Marca oficial GOLD NUTRITION. GLUTAMINA X 225GRS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 14941.00, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600&q=80', 'GO-0289', 39
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] HMB X 60 CAPS', 'Marca oficial GOLD NUTRITION. HMB X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Aminoácidos & BCAA de TITAN FUEL SUPLEMENTOS.', 10069.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GO-0290', 40
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Aminoácidos & BCAA';

  -- â”€â”€â”€ VITAMINAS & MINERALES (104 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CITRATO DE MAGNESIO POLVO X 500GRS', 'Marca oficial STAR NUTRITION. CITRATO DE MAGNESIO POLVO X 500GRS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 23200.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ST-0004', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] IRON PACK MULTIVITAMIN POWDER X 44 SERV', 'Marca oficial STAR NUTRITION. IRON PACK MULTIVITAMIN POWDER X 44 SERV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 90370.22, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ST-0019', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] MAGNESIO 500GR X 60 CAPS', 'Marca oficial STAR NUTRITION. MAGNESIO 500GR X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13308.95, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'ST-0029', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] OMEGA 3 X 60CAPS', 'Marca oficial STAR NUTRITION. OMEGA 3 X 60CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 29263.36, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ST-0034', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] RESVERATROL 500 X 60 CAPS.', 'Marca oficial STAR NUTRITION. RESVERATROL 500 X 60 CAPS.. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 18420.24, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ST-0041', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] TNT-DYNAMITE X 240GRS', 'Marca oficial STAR NUTRITION. TNT-DYNAMITE X 240GRS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 21473.95, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'ST-0043', 6
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] ALL-IN-ONE VITAMIN X 60 COMP', 'Marca oficial STAR NUTRITION. ALL-IN-ONE VITAMIN X 60 COMP. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 18224.28, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ST-0044', 7
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] VITAMINA C X 60CPS', 'Marca oficial STAR NUTRITION. VITAMINA C X 60CPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 6336.04, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ST-0045', 8
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] VITAMINA K2+D3 X 60CAPS', 'Marca oficial STAR NUTRITION. VITAMINA K2+D3 X 60CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 19889.94, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'ST-0046', 9
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] ZMA X 90 CAPS', 'Marca oficial STAR NUTRITION. ZMA X 90 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 16460.64, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ST-0048', 10
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] BETA-ALANINE X 225GR', 'Marca oficial HOCH SPORT. BETA-ALANINE X 225GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 11051.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'HO-0055', 11
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] VITAMINAS B COMPLEJ 90CAPS', 'Marca oficial HOCH SPORT. VITAMINAS B COMPLEJ 90CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7871.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'HO-0069', 12
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] ZMA-B 120 CAPS PREMIUM SERIES', 'Marca oficial HOCH SPORT. ZMA-B 120 CAPS PREMIUM SERIES. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 18341.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'HO-0073', 13
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CITRATO DE MAGNESIO LEMONADE 192gr', 'Marca oficial ENA SPORT. CITRATO DE MAGNESIO LEMONADE 192gr. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13019.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'EN-0082', 14
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ENACCION MULTIVITAMINICO PLUS X 30 COMP', 'Marca oficial ENA SPORT. ENACCION MULTIVITAMINICO PLUS X 30 COMP. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 10651.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'EN-0094', 15
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ENACCION TABS X 30', 'Marca oficial ENA SPORT. ENACCION TABS X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9468.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'EN-0095', 16
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ENACCION TABS X 60', 'Marca oficial ENA SPORT. ENACCION TABS X 60. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 15681.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'EN-0096', 17
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] MAGNESIO X 60 CAPS', 'Marca oficial ENA SPORT. MAGNESIO X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 10060.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'EN-0101', 18
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] MULTIVITAMIN X 60 CAPS', 'Marca oficial ENA SPORT. MULTIVITAMIN X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13314.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'EN-0102', 19
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] MUSCLE MAX 90 TABS', 'Marca oficial ENA SPORT. MUSCLE MAX 90 TABS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9941.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'EN-0103', 20
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] OXIDO NITRICO 210 GRS', 'Marca oficial ENA SPORT. OXIDO NITRICO 210 GRS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 14202.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'EN-0104', 21
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ZMA 60 CAPS', 'Marca oficial ENA SPORT. ZMA 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9468.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'EN-0118', 22
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] CITRATO DE MAGNESIO 300GR', 'Marca oficial GENERATION FIT. CITRATO DE MAGNESIO 300GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13000.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'GE-0119', 23
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] KILLER 5.0 25 SERV', 'Marca oficial GENERATION FIT. KILLER 5.0 25 SERV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 15360.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'GE-0126', 24
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] KILLER STRIKE X 300GRS', 'Marca oficial GENERATION FIT. KILLER STRIKE X 300GRS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 18600.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'GE-0127', 25
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] PREDATOR X 300GRS', 'Marca oficial GENERATION FIT. PREDATOR X 300GRS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 17160.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'GE-0128', 26
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] MULTIVITAMINICO AM +', 'Marca oficial GENERATION FIT. MULTIVITAMINICO AM +. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7150.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'GE-0129', 27
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] ARGINOX X240 CAPS', 'Marca oficial NUTRILAB. ARGINOX X240 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 14578.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'NU-0132', 28
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] CREA SHOCK 300 GR', 'Marca oficial NUTRILAB. CREA SHOCK 300 GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 16100.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NU-0136', 29
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] GLUTA READY X 300GR', 'Marca oficial NUTRILAB. GLUTA READY X 300GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 20444.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'NU-0139', 30
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] GLUTA RELOAD 300 GR', 'Marca oficial NUTRILAB. GLUTA RELOAD 300 GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 15318.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'NU-0140', 31
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] MULTIVITAMIN 100 X 240 COMP', 'Marca oficial NUTRILAB. MULTIVITAMIN 100 X 240 COMP. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7388.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NU-0143', 32
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] TERMOGENIC MAX 240 COMP', 'Marca oficial NUTRILAB. TERMOGENIC MAX 240 COMP. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 19438.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'NU-0146', 33
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] BEAST BLOOD (PREWORK) 280GR', 'Marca oficial BODY ADVANCED. BEAST BLOOD (PREWORK) 280GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13929.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'BO-0154', 34
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] CITRATO DE MAGNESIO X175GRS', 'Marca oficial BODY ADVANCED. CITRATO DE MAGNESIO X175GRS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7531.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'BO-0156', 35
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] HYDRO DRAIN 60COMP', 'Marca oficial BODY ADVANCED. HYDRO DRAIN 60COMP. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 6789.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'BO-0166', 36
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] VITAL FLEX PLUS X 60 CAPS', 'Marca oficial BODY ADVANCED. VITAL FLEX PLUS X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 4382.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'BO-0173', 37
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] VITAMINA C + VIT D + ZINC 300GR', 'Marca oficial BODY ADVANCED. VITAMINA C + VIT D + ZINC 300GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7505.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'BO-0174', 38
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] V-MINERAL COMPLEX 60COMP', 'Marca oficial BODY ADVANCED. V-MINERAL COMPLEX 60COMP. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 4647.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'BO-0175', 39
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] ZMA 45SERV', 'Marca oficial BODY ADVANCED. ZMA 45SERV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7570.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'BO-0178', 40
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] ACIDO HIALURONICO X 30', 'Marca oficial VITAMIN WAY. ACIDO HIALURONICO X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 14522.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0179', 41
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] BISGLICINATO DE MAGNESIO X 30 CAPS', 'Marca oficial VITAMIN WAY. BISGLICINATO DE MAGNESIO X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9582.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0180', 42
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CABELLO, PIEL Y UÃ‘AS + PROBIOTICOS X 30 CAPS', 'Marca oficial VITAMIN WAY. CABELLO, PIEL Y UÃ‘AS + PROBIOTICOS X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9882.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0181', 43
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CABELLO, PIEL Y UÃ‘AS X 30', 'Marca oficial VITAMIN WAY. CABELLO, PIEL Y UÃ‘AS X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9077.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0182', 44
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CITRATO DE MAGNESIO BEBIBLE X 180GR', 'Marca oficial VITAMIN WAY. CITRATO DE MAGNESIO BEBIBLE X 180GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 17411.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0185', 45
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CITRATO DE MAGNESIO X 30', 'Marca oficial VITAMIN WAY. CITRATO DE MAGNESIO X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 10247.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0186', 46
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CITRATO DE MAGNESIO X 60', 'Marca oficial VITAMIN WAY. CITRATO DE MAGNESIO X 60. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 18453.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0187', 47
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COENZIMA Q10 X 30', 'Marca oficial VITAMIN WAY. COENZIMA Q10 X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7602.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0188', 48
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COGNITIVE DHA X30', 'Marca oficial VITAMIN WAY. COGNITIVE DHA X30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13101.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0189', 49
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] DUO OMEGA 3 X 30', 'Marca oficial VITAMIN WAY. DUO OMEGA 3 X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 15182.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0204', 50
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] DUO OMEGA 3 X 60', 'Marca oficial VITAMIN WAY. DUO OMEGA 3 X 60. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 23534.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0205', 51
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] GARCINIA X 60', 'Marca oficial VITAMIN WAY. GARCINIA X 60. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 8235.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0206', 52
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] HIALURONICO ANTI-ARRUGAS X 30', 'Marca oficial VITAMIN WAY. HIALURONICO ANTI-ARRUGAS X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 21500.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0208', 53
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] INMUNO PLUS X 30', 'Marca oficial VITAMIN WAY. INMUNO PLUS X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 4408.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0209', 54
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] MAGNESIO + CALCIO X 60', 'Marca oficial VITAMIN WAY. MAGNESIO + CALCIO X 60. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13751.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0210', 55
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] MAGNESIO QUELATO X 30', 'Marca oficial VITAMIN WAY. MAGNESIO QUELATO X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9238.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0211', 56
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] MAGNESIO SPORT X 30', 'Marca oficial VITAMIN WAY. MAGNESIO SPORT X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 5533.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0212', 57
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] MAGNESIO STRESS X 30 CAPS', 'Marca oficial VITAMIN WAY. MAGNESIO STRESS X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9602.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0213', 58
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] MAGNESIO X 30', 'Marca oficial VITAMIN WAY. MAGNESIO X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 5847.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0214', 59
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] MAGNESIO X 60', 'Marca oficial VITAMIN WAY. MAGNESIO X 60. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 10683.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0215', 60
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] MULTIVITAMINICO ENERGIA X 3O', 'Marca oficial VITAMIN WAY. MULTIVITAMINICO ENERGIA X 3O. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9024.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0216', 61
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] NAD + VW X 30 CAPS', 'Marca oficial VITAMIN WAY. NAD + VW X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 29559.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0218', 62
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] OMEGA 3 X 30', 'Marca oficial VITAMIN WAY. OMEGA 3 X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13117.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0219', 63
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] OMEGA 3 X 60', 'Marca oficial VITAMIN WAY. OMEGA 3 X 60. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 19076.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0220', 64
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] PROBIOTICOS + PREBOTICOS 10K X 30 CAPS', 'Marca oficial VITAMIN WAY. PROBIOTICOS + PREBOTICOS 10K X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 16104.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0222', 65
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] PROBIOTICOS + VITAMINAS X 30 CAPS', 'Marca oficial VITAMIN WAY. PROBIOTICOS + VITAMINAS X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 17133.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0223', 66
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] PROBIOTICOS+PREBIOTICOS X30', 'Marca oficial VITAMIN WAY. PROBIOTICOS+PREBIOTICOS X30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 15498.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0224', 67
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] TRANS RESVERATROL 500 VW X 30 CAPS', 'Marca oficial VITAMIN WAY. TRANS RESVERATROL 500 VW X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 23625.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0225', 68
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] UP FOR MEN VW ESTUCHE X 30 CAPS', 'Marca oficial VITAMIN WAY. UP FOR MEN VW ESTUCHE X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 8422.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0227', 69
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] UP FOR WOMAN ESTUCHE X 30 CAPS', 'Marca oficial VITAMIN WAY. UP FOR WOMAN ESTUCHE X 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 8422.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0228', 70
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] VITAMINA C BEBIBLE FRASCO X 195 GR', 'Marca oficial VITAMIN WAY. VITAMINA C BEBIBLE FRASCO X 195 GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13657.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0230', 71
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] VITAMINA C X 30', 'Marca oficial VITAMIN WAY. VITAMINA C X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 5910.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'VI-0231', 72
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] VITAMINA C X 60', 'Marca oficial VITAMIN WAY. VITAMINA C X 60. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 11910.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0232', 73
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] VITAMINA D X 30', 'Marca oficial VITAMIN WAY. VITAMINA D X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7157.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'VI-0233', 74
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] CITRATO DE MAGNESIO X 300GR', 'Marca oficial MERVICK. CITRATO DE MAGNESIO X 300GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 16169.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'ME-0238', 75
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] ENERGY X 12', 'Marca oficial MERVICK. ENERGY X 12. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 12960.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ME-0242', 76
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] MULTIVITAMINICO X 120', 'Marca oficial MERVICK. MULTIVITAMINICO X 120. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 13497.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ME-0249', 77
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] OXIDO NITRICO X 150GR', 'Marca oficial MERVICK. OXIDO NITRICO X 150GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 14177.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'ME-0250', 78
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] RACE X 12', 'Marca oficial MERVICK. RACE X 12. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 11443.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ME-0254', 79
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] SPORT DRINK X 1KG', 'Marca oficial MERVICK. SPORT DRINK X 1KG. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 11567.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ME-0255', 80
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] BETA ALALINA X 180 COMP', 'Marca oficial XTRENGHT. BETA ALALINA X 180 COMP. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 12329.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'XT-0265', 81
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] CUTTER X 120 COMP', 'Marca oficial XTRENGHT. CUTTER X 120 COMP. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 10001.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'XT-0269', 82
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] COMPLEX B X 60 CAPS', 'Marca oficial GOLD NUTRITION. COMPLEX B X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7146.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'GO-0284', 83
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] ELECTROLYTES MINERAL & VITAMINS 60 CAPS', 'Marca oficial GOLD NUTRITION. ELECTROLYTES MINERAL & VITAMINS 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 9095.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'GO-0288', 84
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] MAGNESIUM CITRATE X 60 CAPS', 'Marca oficial GOLD NUTRITION. MAGNESIUM CITRATE X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 11693.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'GO-0293', 85
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] N.O. GOLD X 195GR', 'Marca oficial GOLD NUTRITION. N.O. GOLD X 195GR. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 20138.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'GO-0295', 86
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] NAD - 30 CAPS', 'Marca oficial GOLD NUTRITION. NAD - 30 CAPS. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 14292.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'GO-0296', 87
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] OMEGA3 FISH OIL X 30', 'Marca oficial GOLD NUTRITION. OMEGA3 FISH OIL X 30. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 22736.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'GO-0297', 88
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] ZMA X 30SERV', 'Marca oficial GOLD NUTRITION. ZMA X 30SERV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 11693.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'GO-0302', 89
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] ARANDANOS X 60 CAPS - NATULIV', 'Marca oficial NATULIV. ARANDANOS X 60 CAPS - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 8876.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'NA-0303', 90
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] BETACAROTENO - NATULIV', 'Marca oficial NATULIV. BETACAROTENO - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 5587.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'NA-0304', 91
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] CITRATO DE MAGNESIO X 105 GR - NATULIV', 'Marca oficial NATULIV. CITRATO DE MAGNESIO X 105 GR - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 8699.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NA-0306', 92
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] CITRATO DE MAGNESIO X 30 COMP - NATULIV', 'Marca oficial NATULIV. CITRATO DE MAGNESIO X 30 COMP - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 7693.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'NA-0307', 93
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] CURCUMA + JEMGIBRE X 30CAPS - NATULIV', 'Marca oficial NATULIV. CURCUMA + JEMGIBRE X 30CAPS - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 6213.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'NA-0308', 94
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] DOBLE DESCANSO - NATULIV', 'Marca oficial NATULIV. DOBLE DESCANSO - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 6401.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NA-0309', 95
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] MAGNESIO 400 X 30 COMP - NATULIV', 'Marca oficial NATULIV. MAGNESIO 400 X 30 COMP - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 4645.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'NA-0310', 96
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] MAGNESIO PLUS X 30 COMP - NATULIV', 'Marca oficial NATULIV. MAGNESIO PLUS X 30 COMP - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 5060.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'NA-0311', 97
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] OMEGA 3 X 30 CAPS - NATULIV', 'Marca oficial NATULIV. OMEGA 3 X 30 CAPS - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 10798.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NA-0312', 98
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] RESVERATROL - NATULIV', 'Marca oficial NATULIV. RESVERATROL - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 11185.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'NA-0313', 99
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] SPIRULINA X 60 COMP - NATULIV', 'Marca oficial NATULIV. SPIRULINA X 60 COMP - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 8017.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'NA-0314', 100
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] TRIPLE ESCUDO X 30 COMP - NATULIV', 'Marca oficial NATULIV. TRIPLE ESCUDO X 30 COMP - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 5531.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NA-0315', 101
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] VITAMINA C 15 SOBRES - NATULIV', 'Marca oficial NATULIV. VITAMINA C 15 SOBRES - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 4735.00, 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?w=600&q=80', 'NA-0316', 102
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] VITAMINA C X 30 COMP - NATULIV', 'Marca oficial NATULIV. VITAMINA C X 30 COMP - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 4972.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'NA-0317', 103
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] VITAMINA D X 30 COMP - NATULIV', 'Marca oficial NATULIV. VITAMINA D X 30 COMP - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Vitaminas & Minerales de TITAN FUEL SUPLEMENTOS.', 5158.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NA-0318', 104
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Vitaminas & Minerales';

  -- â”€â”€â”€ QUEMADORES (24 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CLA 1000 X 90 CAPS', 'Marca oficial STAR NUTRITION. CLA 1000 X 90 CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 20722.77, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ST-0005', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] L-CARNITINE LIQUID X 500 CM3', 'Marca oficial STAR NUTRITION. L-CARNITINE LIQUID X 500 CM3. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 12427.13, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ST-0024', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] L-CARNITINE X 60 COMP', 'Marca oficial STAR NUTRITION. L-CARNITINE X 60 COMP. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 13504.91, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ST-0025', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] PUMP 3D EVOLUTION RIPPED X 315 GRS.', 'Marca oficial STAR NUTRITION. PUMP 3D EVOLUTION RIPPED X 315 GRS.. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 34129.70, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ST-0038', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] RIPPED V8 X 60CAPS', 'Marca oficial STAR NUTRITION. RIPPED V8 X 60CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 16950.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ST-0040', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] THERMO FUEL MAX X 120 CAPS', 'Marca oficial STAR NUTRITION. THERMO FUEL MAX X 120 CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 18746.84, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ST-0042', 6
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] L-CARNITINA 1500 X 60 CAPS', 'Marca oficial HOCH SPORT. L-CARNITINA 1500 X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 13596.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'HO-0064', 7
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] THERMOGENIX LOSS WEIGHT', 'Marca oficial HOCH SPORT. THERMOGENIX LOSS WEIGHT. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 24077.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'HO-0067', 8
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] THERMOGENIX S.2 CON CAFEINA 120 CAPS', 'Marca oficial HOCH SPORT. THERMOGENIX S.2 CON CAFEINA 120 CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 23513.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'HO-0068', 9
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CARNITINA PRO BURN X60 CAPS', 'Marca oficial ENA SPORT. CARNITINA PRO BURN X60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 11243.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'EN-0081', 10
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] HYDROXY MAX BLACK X 120 TABS', 'Marca oficial ENA SPORT. HYDROXY MAX BLACK X 120 TABS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 10050.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'EN-0099', 11
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] HYDROXY MAX NIGHT X 120 TABS', 'Marca oficial ENA SPORT. HYDROXY MAX NIGHT X 120 TABS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 8990.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'EN-0100', 12
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] RIPPED X X 60CAPS', 'Marca oficial ENA SPORT. RIPPED X X 60CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 8758.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'EN-0110', 13
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] LIPO FEM 240 COMP', 'Marca oficial NUTRILAB. LIPO FEM 240 COMP. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 18012.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NU-0141', 14
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] LIPO EXTREME 60COMP', 'Marca oficial BODY ADVANCED. LIPO EXTREME 60COMP. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 5937.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'BO-0169', 15
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] LIPO EXTREME X 240GRS', 'Marca oficial BODY ADVANCED. LIPO EXTREME X 240GRS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 8318.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'BO-0170', 16
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CAFE VERDE X 60', 'Marca oficial VITAMIN WAY. CAFE VERDE X 60. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 8898.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'VI-0183', 17
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] BIG SHAKER VASO MEZCLADOR (SIMPLE)', 'Marca oficial MERVICK. BIG SHAKER VASO MEZCLADOR (SIMPLE). Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 3582.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ME-0235', 18
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] BIG SHAKER VASO MEZCLADOR (TRICUERPO)', 'Marca oficial MERVICK. BIG SHAKER VASO MEZCLADOR (TRICUERPO). Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 5750.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ME-0236', 19
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] FAT BURNER X 120', 'Marca oficial MERVICK. FAT BURNER X 120. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 13496.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'ME-0243', 20
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] L-CARNITINA X 500 MG X 90 COMP', 'Marca oficial MERVICK. L-CARNITINA X 500 MG X 90 COMP. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 15877.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'ME-0246', 21
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] CARNITINE X 90 CAPS', 'Marca oficial XTRENGHT. CARNITINE X 90 CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 12329.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'XT-0266', 22
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] LIPO GOLD ELITE X 60 CAPS', 'Marca oficial GOLD NUTRITION. LIPO GOLD ELITE X 60 CAPS. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 12992.00, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80', 'GO-0292', 23
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NATULIV] CAFE VERDE X 60 CAPS - NATULIV', 'Marca oficial NATULIV. CAFE VERDE X 60 CAPS - NATULIV. Producto de alta pureza y calidad garantizada en la línea de Quemadores de TITAN FUEL SUPLEMENTOS.', 7923.00, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80', 'NA-0305', 24
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Quemadores';

  -- â”€â”€â”€ COLÃGENOS & BELLEZA (26 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] COLLAGEN PLUS LIMON 360GR', 'Marca oficial STAR NUTRITION. COLLAGEN PLUS LIMON 360GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 19416.37, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'ST-0006', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] COLLAGEN SPORT NARANJA 360GR', 'Marca oficial STAR NUTRITION. COLLAGEN SPORT NARANJA 360GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 19416.37, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'ST-0007', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] COLLAGEN WHEY X 2LBS', 'Marca oficial STAR NUTRITION. COLLAGEN WHEY X 2LBS. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 38947.05, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'ST-0008', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] COLLAGEN X 210GRS', 'Marca oficial STAR NUTRITION. COLLAGEN X 210GRS. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 17816.03, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'ST-0009', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] COLAGENO SPORT X 407GRS', 'Marca oficial ENA SPORT. COLAGENO SPORT X 407GRS. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 22485.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'EN-0083', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ENACCION COLAGENO COMPLEX LIMONADA X 270 GR', 'Marca oficial ENA SPORT. ENACCION COLAGENO COMPLEX LIMONADA X 270 GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 20711.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'EN-0091', 6
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ENACCION COLAGENO MOVE X 30 TABS', 'Marca oficial ENA SPORT. ENACCION COLAGENO MOVE X 30 TABS. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 11835.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'EN-0092', 7
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ENACCION COLAGENO NARANJA X 240GR', 'Marca oficial ENA SPORT. ENACCION COLAGENO NARANJA X 240GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 15829.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'EN-0093', 8
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] PURE COLLAGEN X 350GR', 'Marca oficial ENA SPORT. PURE COLLAGEN X 350GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 24380.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'EN-0108', 9
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] WHEY COLLAGEN 1,7LBS', 'Marca oficial ENA SPORT. WHEY COLLAGEN 1,7LBS. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 38462.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'EN-0114', 10
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] COLLAGEN 8.0 X 260GRS', 'Marca oficial GENERATION FIT. COLLAGEN 8.0 X 260GRS. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 14280.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'GE-0120', 11
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] COLLAGEN FLEX', 'Marca oficial NUTRILAB. COLLAGEN FLEX. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 20491.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'NU-0135', 12
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] COLAGENO HIDROLIZADO 300GR', 'Marca oficial BODY ADVANCED. COLAGENO HIDROLIZADO 300GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 13057.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'BO-0157', 13
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO + ACIDO HIALURONICO X 30', 'Marca oficial VITAMIN WAY. COLAGENO + ACIDO HIALURONICO X 30. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 18647.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'VI-0190', 14
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO + CALCIO X 30', 'Marca oficial VITAMIN WAY. COLAGENO + CALCIO X 30. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 8078.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'VI-0191', 15
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO + CALCIO X 60', 'Marca oficial VITAMIN WAY. COLAGENO + CALCIO X 60. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 14542.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'VI-0192', 16
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO BEAUTY + FLEX BEBIBLE X360 GR', 'Marca oficial VITAMIN WAY. COLAGENO BEAUTY + FLEX BEBIBLE X360 GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 24766.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'VI-0193', 17
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO BEAUTY BEBIBLE X360 GR', 'Marca oficial VITAMIN WAY. COLAGENO BEAUTY BEBIBLE X360 GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 24766.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'VI-0194', 18
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO FLEX BEBIBLE X360 GR', 'Marca oficial VITAMIN WAY. COLAGENO FLEX BEBIBLE X360 GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 21106.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'VI-0195', 19
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO FLEX X 30', 'Marca oficial VITAMIN WAY. COLAGENO FLEX X 30. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 16206.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'VI-0196', 20
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO HIDROLIZADO  X 30', 'Marca oficial VITAMIN WAY. COLAGENO HIDROLIZADO  X 30. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 12692.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'VI-0197', 21
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] COLAGENO SPORT BEBIBLE 360 GR', 'Marca oficial VITAMIN WAY. COLAGENO SPORT BEBIBLE 360 GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 27060.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'VI-0198', 22
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] COLAGENO SPORT Q10 X 330GR', 'Marca oficial MERVICK. COLAGENO SPORT Q10 X 330GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 17390.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'ME-0239', 23
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] COLLAGEN HYDROLIZED POLVO DOY PACK X 200GR', 'Marca oficial GOLD NUTRITION. COLLAGEN HYDROLIZED POLVO DOY PACK X 200GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 15591.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'GO-0281', 24
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] COLLAGEN HYDROLIZED POLVO X 200GR', 'Marca oficial GOLD NUTRITION. COLLAGEN HYDROLIZED POLVO X 200GR. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 18189.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80', 'GO-0282', 25
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] COLLAGEN HYDROLIZED X 60CAPS', 'Marca oficial GOLD NUTRITION. COLLAGEN HYDROLIZED X 60CAPS. Producto de alta pureza y calidad garantizada en la línea de ColÃ¡genos & Belleza de TITAN FUEL SUPLEMENTOS.', 9744.00, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80', 'GO-0283', 26
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ColÃ¡genos & Belleza';

  -- â”€â”€â”€ CREATINAS (32 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CREATINA MONOHIDRATO EEUU DOY PACK X 300 GRS', 'Marca oficial STAR NUTRITION. CREATINA MONOHIDRATO EEUU DOY PACK X 300 GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 22200.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'ST-0010', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CREATINA MONOHIDRATO EEUU DOY PACK FRUIT PUNCH X 300 GRS', 'Marca oficial STAR NUTRITION. CREATINA MONOHIDRATO EEUU DOY PACK FRUIT PUNCH X 300 GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 24304.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ST-0011', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CREATINA MONOHIDRATO EEUU X 1 KILO', 'Marca oficial STAR NUTRITION. CREATINA MONOHIDRATO EEUU X 1 KILO. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 67200.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'ST-0012', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CREATINA MONOHIDRATO X 150GRS', 'Marca oficial STAR NUTRITION. CREATINA MONOHIDRATO X 150GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 12950.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ST-0013', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CREATINA MONOHIDRATO X 300GRS (BOTE)', 'Marca oficial STAR NUTRITION. CREATINA MONOHIDRATO X 300GRS (BOTE). Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 24579.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'ST-0014', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] CREATINA MONOHIDRATO X 500GRS', 'Marca oficial STAR NUTRITION. CREATINA MONOHIDRATO X 500GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 38900.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ST-0015', 6
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] CREATINA X 300GR MICRONIZED', 'Marca oficial HOCH SPORT. CREATINA X 300GR MICRONIZED. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 21679.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'HO-0057', 7
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] CREATINE CELL X 300GRS', 'Marca oficial HOCH SPORT. CREATINE CELL X 300GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 18876.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'HO-0058', 8
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CREATINA ENA X 150GRS', 'Marca oficial ENA SPORT. CREATINA ENA X 150GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 13314.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'EN-0084', 9
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CREATINA MONODOSIS CAJA X 15 SOBRES', 'Marca oficial ENA SPORT. CREATINA MONODOSIS CAJA X 15 SOBRES. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 10360.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0085', 10
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CREATINA MONOHIDRATO X 1 KG', 'Marca oficial ENA SPORT. CREATINA MONOHIDRATO X 1 KG. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 68352.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'EN-0086', 11
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CREATINA MONOHIDRATO X 300 GRAMOS', 'Marca oficial ENA SPORT. CREATINA MONOHIDRATO X 300 GRAMOS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 24855.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0087', 12
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CREATINA+ELECTROLITOS B.L 293 GRAMOS', 'Marca oficial ENA SPORT. CREATINA+ELECTROLITOS B.L 293 GRAMOS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 22369.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'EN-0088', 13
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CREATINA+ELECTROLITOS P.L 302 GRAMOS', 'Marca oficial ENA SPORT. CREATINA+ELECTROLITOS P.L 302 GRAMOS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 22369.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0089', 14
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] CREATINA X 300GR', 'Marca oficial GENERATION FIT. CREATINA X 300GR. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 16500.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'GE-0121', 15
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] CREATINE READY 300GR', 'Marca oficial NUTRILAB. CREATINE READY 300GR. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 19975.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'NU-0137', 16
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] CREAGLINE X 150GR', 'Marca oficial BODY ADVANCED. CREAGLINE X 150GR. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 8359.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'BO-0158', 17
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] CREATINA 150GR', 'Marca oficial BODY ADVANCED. CREATINA 150GR. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 8098.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'BO-0159', 18
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] CREATINA 300GR', 'Marca oficial BODY ADVANCED. CREATINA 300GR. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 14573.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'BO-0160', 19
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] CREATINA DOYPACK 300GR', 'Marca oficial BODY ADVANCED. CREATINA DOYPACK 300GR. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 12444.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'BO-0161', 20
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] CREATINE POWER X 300GRS', 'Marca oficial BODY ADVANCED. CREATINE POWER X 300GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 8511.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'BO-0162', 21
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CREATINA MONOHIDRATO X300GR', 'Marca oficial VITAMIN WAY. CREATINA MONOHIDRATO X300GR. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 16788.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'VI-0199', 22
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CREATINA MONOHIDRATO X372GR LIMON', 'Marca oficial VITAMIN WAY. CREATINA MONOHIDRATO X372GR LIMON. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 16788.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'VI-0200', 23
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CREATINE MONOHYDRATE  NARANJA NEGRO X 378 G', 'Marca oficial VITAMIN WAY. CREATINE MONOHYDRATE  NARANJA NEGRO X 378 G. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 16775.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'VI-0201', 24
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] CREATINE MONOHYDRATE SIN SABOR NEGRO X 300 G', 'Marca oficial VITAMIN WAY. CREATINE MONOHYDRATE SIN SABOR NEGRO X 300 G. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 16775.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'VI-0202', 25
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] CREATINA PREMIUM X 1KG', 'Marca oficial MERVICK. CREATINA PREMIUM X 1KG. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 21965.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ME-0240', 26
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] CREATINE X 300 GRS', 'Marca oficial MERVICK. CREATINE X 300 GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 21227.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'ME-0241', 27
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] CREATINE X 250 GRAMOS', 'Marca oficial XTRENGHT. CREATINE X 250 GRAMOS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 11229.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'XT-0267', 28
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] CREATINE X 500 GRAMOS', 'Marca oficial XTRENGHT. CREATINE X 500 GRAMOS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 33611.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'XT-0268', 29
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] CREATINA MONOHYDRATE X 1KG', 'Marca oficial GOLD NUTRITION. CREATINA MONOHYDRATE X 1KG. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 51040.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GO-0285', 30
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] CREATINA MONOHYDRATE X 300GRS', 'Marca oficial GOLD NUTRITION. CREATINA MONOHYDRATE X 300GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 17177.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'GO-0286', 31
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] CREATINE CREAPURE- 200 GRS', 'Marca oficial GOLD NUTRITION. CREATINE CREAPURE- 200 GRS. Producto de alta pureza y calidad garantizada en la línea de Creatinas de TITAN FUEL SUPLEMENTOS.', 25984.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GO-0287', 32
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Creatinas';

  -- â”€â”€â”€ GANADORES & ENERGÃA (17 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] HYDROPLUS ENDURANCE X 700 GRS.', 'Marca oficial STAR NUTRITION. HYDROPLUS ENDURANCE X 700 GRS.. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 12200.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ST-0018', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] JUST CARBS X1 KGR', 'Marca oficial STAR NUTRITION. JUST CARBS X1 KGR. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 15186.90, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ST-0020', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] MUTANTMASS X 1,5 KGRS', 'Marca oficial STAR NUTRITION. MUTANTMASS X 1,5 KGRS. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 34341.99, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ST-0031', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] MUTANTMASS X 5 KGRS', 'Marca oficial STAR NUTRITION. MUTANTMASS X 5 KGRS. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 93554.57, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ST-0032', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] EXTREME MASS X 4,5KG', 'Marca oficial HOCH SPORT. EXTREME MASS X 4,5KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 64606.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'HO-0059', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] EXTREME MASS X1,5KG', 'Marca oficial HOCH SPORT. EXTREME MASS X1,5KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 24482.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'HO-0060', 6
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] ISOENERGY DRINK 600GR', 'Marca oficial HOCH SPORT. ISOENERGY DRINK 600GR. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 10480.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'HO-0063', 7
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] CARBO ENERGY X 540 GRS', 'Marca oficial ENA SPORT. CARBO ENERGY X 540 GRS. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 11100.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'EN-0080', 8
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ULTRA MASS X 1,5 KG', 'Marca oficial ENA SPORT. ULTRA MASS X 1,5 KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 36687.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'EN-0112', 9
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] ULTRA MASS X 3KG', 'Marca oficial ENA SPORT. ULTRA MASS X 3KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 62131.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'EN-0113', 10
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] MASS BUILDER 1,6 KG', 'Marca oficial NUTRILAB. MASS BUILDER 1,6 KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 20444.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'NU-0142', 11
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] CARBO COMPLEX MANDARINA X 1KG', 'Marca oficial MERVICK. CARBO COMPLEX MANDARINA X 1KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 15308.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ME-0237', 12
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] GAINER 1,5KG', 'Marca oficial MERVICK. GAINER 1,5KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 37573.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ME-0244', 13
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] GAINER 4,5KG', 'Marca oficial MERVICK. GAINER 4,5KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 58204.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ME-0245', 14
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] NITROGAIN X 1.5 KG', 'Marca oficial XTRENGHT. NITROGAIN X 1.5 KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 36300.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'XT-0272', 15
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] NITROGAIN X 5 KG', 'Marca oficial XTRENGHT. NITROGAIN X 5 KG. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 80990.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'XT-0273', 16
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] MUSCLE MASS GAINER X 5LBS', 'Marca oficial GOLD NUTRITION. MUSCLE MASS GAINER X 5LBS. Producto de alta pureza y calidad garantizada en la línea de Ganadores & EnergÃ­a de TITAN FUEL SUPLEMENTOS.', 51968.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'GO-0294', 17
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Ganadores & EnergÃ­a';

  -- â”€â”€â”€ PROTEÃNAS (45 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] JUST PLANT PROTEIN 2 LBS', 'Marca oficial STAR NUTRITION. JUST PLANT PROTEIN 2 LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 37069.10, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ST-0021', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] JUST WHEY 2LBS', 'Marca oficial STAR NUTRITION. JUST WHEY 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 43862.38, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'ST-0022', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] NITRO WHEY X 1 KGRS', 'Marca oficial STAR NUTRITION. NITRO WHEY X 1 KGRS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 49969.80, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ST-0033', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] PLATINUM WHEY ISOLATE X 2LBS', 'Marca oficial STAR NUTRITION. PLATINUM WHEY ISOLATE X 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 85900.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ST-0035', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] PLATINUM WHEY PROTEIN X 2 LB', 'Marca oficial STAR NUTRITION. PLATINUM WHEY PROTEIN X 2 LB. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 51200.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'ST-0036', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] PLATINUM WHEY PROTEIN X 3 KGRS', 'Marca oficial STAR NUTRITION. PLATINUM WHEY PROTEIN X 3 KGRS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 140927.90, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ST-0037', 6
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[STAR NUTRITION] WHEY PROTEIN X 2LBS DOYPACK', 'Marca oficial STAR NUTRITION. WHEY PROTEIN X 2LBS DOYPACK. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 46990.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ST-0047', 7
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] BIOPROT X 1KG PREMIUM SERIES', 'Marca oficial HOCH SPORT. BIOPROT X 1KG PREMIUM SERIES. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 94692.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'HO-0056', 8
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] WHEY PROTEIN 3KG', 'Marca oficial HOCH SPORT. WHEY PROTEIN 3KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 144000.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'HO-0070', 9
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] WHEY PROTEIN X1KG', 'Marca oficial HOCH SPORT. WHEY PROTEIN X1KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 40792.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'HO-0071', 10
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[HOCH SPORT] WHEY PROTEIN X2KG', 'Marca oficial HOCH SPORT. WHEY PROTEIN X2KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 53300.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'HO-0072', 11
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] 100% WHEY 2LBS - ENA SPORT NUTRITION', 'Marca oficial ENA SPORT. 100% WHEY 2LBS - ENA SPORT NUTRITION. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 47500.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0074', 12
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] DIET WHEY PROTEIN X 894GRS', 'Marca oficial ENA SPORT. DIET WHEY PROTEIN X 894GRS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 41362.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'EN-0090', 13
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] PLANT PROTEIN X 779GR', 'Marca oficial ENA SPORT. PLANT PROTEIN X 779GR. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 34912.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'EN-0105', 14
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] WHEY PROTEIN TRUE MADE 1000GRS', 'Marca oficial ENA SPORT. WHEY PROTEIN TRUE MADE 1000GRS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 62000.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'EN-0115', 15
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] WHEY PROTEIN TRUE MADE BIG SIZE 5LB', 'Marca oficial ENA SPORT. WHEY PROTEIN TRUE MADE BIG SIZE 5LB. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 145000.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'EN-0116', 16
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] WHEY X PRO X 1 KG', 'Marca oficial ENA SPORT. WHEY X PRO X 1 KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 53255.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'EN-0117', 17
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] FIT WHEY X 2LBS', 'Marca oficial GENERATION FIT. FIT WHEY X 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 24990.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GE-0123', 18
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GENERATION FIT] FIT WHEY X 5 LBS', 'Marca oficial GENERATION FIT. FIT WHEY X 5 LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 55800.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'GE-0124', 19
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] PROTEIN SHAKE X 1KG', 'Marca oficial NUTRILAB. PROTEIN SHAKE X 1KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 19990.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'NU-0145', 20
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] WHEY FEM 1 KG', 'Marca oficial NUTRILAB. WHEY FEM 1 KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 21443.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'NU-0147', 21
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] WHEY PRO 1 KG', 'Marca oficial NUTRILAB. WHEY PRO 1 KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 21990.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'NU-0148', 22
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[NUTRILAB] WHEY PRO 5 KG', 'Marca oficial NUTRILAB. WHEY PRO 5 KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 91137.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'NU-0149', 23
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] 100% PURE', 'Marca oficial BODY ADVANCED. 100% PURE. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 41036.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'BO-0150', 24
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] ISO HIGH PURE PROTEIN 2LB', 'Marca oficial BODY ADVANCED. ISO HIGH PURE PROTEIN 2LB. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 38621.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'BO-0167', 25
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] ISO VEGETAL PEA PROTEIN 910GR', 'Marca oficial BODY ADVANCED. ISO VEGETAL PEA PROTEIN 910GR. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 22290.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'BO-0168', 26
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] WHEY PROTEIN X3KG', 'Marca oficial BODY ADVANCED. WHEY PROTEIN X3KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 55130.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'BO-0176', 27
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[BODY ADVANCED] WHEY PROTEIN X910G', 'Marca oficial BODY ADVANCED. WHEY PROTEIN X910G. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 21720.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'BO-0177', 28
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] DAILY 100% WHEY  X 900GR', 'Marca oficial VITAMIN WAY. DAILY 100% WHEY  X 900GR. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 34272.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'VI-0203', 29
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] MULTIVITAMINICO VEGANO X 3O', 'Marca oficial VITAMIN WAY. MULTIVITAMINICO VEGANO X 3O. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 6725.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'VI-0217', 30
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] TRI BLEND WHEY PROTEIN X 960GR', 'Marca oficial VITAMIN WAY. TRI BLEND WHEY PROTEIN X 960GR. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 42293.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'VI-0226', 31
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[VITAMIN WAY] VITAMINA B12 VEGANA X 20', 'Marca oficial VITAMIN WAY. VITAMINA B12 VEGANA X 20. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 8839.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'VI-0229', 32
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] WHEY PROTEIN 80% 3 SABORES X 5LBS', 'Marca oficial MERVICK. WHEY PROTEIN 80% 3 SABORES X 5LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 80758.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ME-0256', 33
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] WHEY PROTEIN 80% X 2LBS', 'Marca oficial MERVICK. WHEY PROTEIN 80% X 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 56958.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ME-0257', 34
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] WHEY PROTEIN 80% X 5LBS', 'Marca oficial MERVICK. WHEY PROTEIN 80% X 5LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 133819.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'ME-0258', 35
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] WHEY PROTEIN BLEND X 2,05 LBS', 'Marca oficial MERVICK. WHEY PROTEIN BLEND X 2,05 LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 35723.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'ME-0259', 36
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] WHEY PROTEIN PRO PERFORMANCE X 2LBS', 'Marca oficial MERVICK. WHEY PROTEIN PRO PERFORMANCE X 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 32526.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'ME-0260', 37
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] ADVANCED WHEY PROTEIN 1KG', 'Marca oficial XTRENGHT. ADVANCED WHEY PROTEIN 1KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 61500.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'XT-0261', 38
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] BEST PROTEIN X 3KG', 'Marca oficial XTRENGHT. BEST PROTEIN X 3KG. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 133510.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'XT-0263', 39
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] BEST PROTEIN X 907GRS', 'Marca oficial XTRENGHT. BEST PROTEIN X 907GRS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 46990.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'XT-0264', 40
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] 100% WHEY PROTEIN X 2LBS', 'Marca oficial GOLD NUTRITION. 100% WHEY PROTEIN X 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 53917.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'GO-0276', 41
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] 100% WHEY PROTEIN X 5LB', 'Marca oficial GOLD NUTRITION. 100% WHEY PROTEIN X 5LB. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 128621.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GO-0277', 42
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] ISO PROTEIN HYDROLIZED 2LBS', 'Marca oficial GOLD NUTRITION. ISO PROTEIN HYDROLIZED 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 67559.00, 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600&q=80', 'GO-0291', 43
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] VEGETAL PROTEIN ISOLATE 2LBS', 'Marca oficial GOLD NUTRITION. VEGETAL PROTEIN ISOLATE 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 30207.00, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=600&q=80', 'GO-0300', 44
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[GOLD NUTRITION] WHEY RIPPED X 2LBS', 'Marca oficial GOLD NUTRITION. WHEY RIPPED X 2LBS. Producto de alta pureza y calidad garantizada en la línea de ProteÃ­nas de TITAN FUEL SUPLEMENTOS.', 58464.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80', 'GO-0301', 45
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'ProteÃ­nas';

  -- â”€â”€â”€ ACCESORIOS & SNACKS (5 productos) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[ENA SPORT] PROTEIN BAR CAJA X 16', 'Marca oficial ENA SPORT. PROTEIN BAR CAJA X 16. Producto de alta pureza y calidad garantizada en la línea de Accesorios & Snacks de TITAN FUEL SUPLEMENTOS.', 22990.00, 'https://images.unsplash.com/photo-1622484212850-f4bc807c4c1a?w=600&q=80', 'EN-0107', 1
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Accesorios & Snacks';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] LOW CARB BAR X 12', 'Marca oficial MERVICK. LOW CARB BAR X 12. Producto de alta pureza y calidad garantizada en la línea de Accesorios & Snacks de TITAN FUEL SUPLEMENTOS.', 17413.00, 'https://images.unsplash.com/photo-1622484212850-f4bc807c4c1a?w=600&q=80', 'ME-0248', 2
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Accesorios & Snacks';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] PROTEIN BAR X 12 46GR', 'Marca oficial MERVICK. PROTEIN BAR X 12 46GR. Producto de alta pureza y calidad garantizada en la línea de Accesorios & Snacks de TITAN FUEL SUPLEMENTOS.', 14242.00, 'https://images.unsplash.com/photo-1622484212850-f4bc807c4c1a?w=600&q=80', 'ME-0252', 3
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Accesorios & Snacks';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[MERVICK] PROTEIN BAR X 12 65GR', 'Marca oficial MERVICK. PROTEIN BAR X 12 65GR. Producto de alta pureza y calidad garantizada en la línea de Accesorios & Snacks de TITAN FUEL SUPLEMENTOS.', 18533.00, 'https://images.unsplash.com/photo-1622484212850-f4bc807c4c1a?w=600&q=80', 'ME-0253', 4
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Accesorios & Snacks';
  INSERT INTO products (empresa_id, category_id, name, description, price, image_url, code, sort_order)
  SELECT v_emp_id, c.id, '[XTRENGHT] SHAKER', 'Marca oficial XTRENGHT. SHAKER. Producto de alta pureza y calidad garantizada en la línea de Accesorios & Snacks de TITAN FUEL SUPLEMENTOS.', 4606.00, 'https://images.unsplash.com/photo-1622484212850-f4bc807c4c1a?w=600&q=80', 'XT-0275', 5
  FROM categories c WHERE c.empresa_id = v_emp_id AND c.name = 'Accesorios & Snacks';

END $$;

