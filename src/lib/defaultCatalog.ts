export interface DefaultCategory {
  id: string;
  name: string;
  icon: string;
  description?: string;
}

export interface DefaultProduct {
  id: string;
  name: string;
  description: string;
  price: number;
  category_id: string;
  image_url: string;
  code: string;
  sort_order: number;
  is_active: boolean;
  badge?: string;
  profile?: string[];
  spiciness?: 'Sin picante' | 'Bajo' | 'Medio' | 'Alto';
  intensity?: 'Suave' | 'Media' | 'Intensa' | 'Muy Gourmet';
  smokiness?: 'Sin ahumar' | 'Leve' | 'Ahumado Natural' | 'Ahumado Intenso';
  pairing?: string;
  idealFor?: string;
  cookingTime?: string;
  conservation?: string;
  ingredients?: string[];
  weight?: string;
  curingProcess?: string;
  maturationTime?: string;
}

export const DEFAULT_CATEGORY_CHORIZOS: DefaultCategory[] = [
  {
    id: 'cat-chorizos-mrcerdo',
    name: 'Chorizos',
    icon: '🐷',
    description: 'Chorizos artesanales 100% puro cerdo con ingredientes naturales seleccionados.'
  },
  {
    id: 'cat-salames-mrcerdo',
    name: 'Salames',
    icon: '🥓',
    description: 'Salames y longanizas de maduración lenta en cámaras con control de humedad.'
  },
  {
    id: 'cat-bondiolas-mrcerdo',
    name: 'Bondiolas',
    icon: '🥩',
    description: 'Bondiolas curadas artesanalmente con finas hierbas y especias seleccionadas.'
  },
  {
    id: 'cat-matambres-mrcerdo',
    name: 'Matambres',
    icon: '🍖',
    description: 'Matambres de cerdo arrollados tiernos, listos para hornear o dorar a la parrilla.'
  }
];

export const DEFAULT_CHORIZO_PRODUCTS: DefaultProduct[] = [
  // ==========================================
  // CHORIZOS ARTESANALES (8 VARIEDADES)
  // ==========================================
  {
    id: 'prod-ch-001',
    category_id: 'cat-chorizos-mrcerdo',
    name: 'Chorizo Criollo Tradicional',
    description: 'El clásico argentino elaborado artesanalmente con puro cerdo y condimentos criollos naturales. Equilibrio perfecto de jugosidad y textura.',
    price: 3500,
    image_url: '/img/Catalogo/chorizos/criollo.png',
    code: 'CH-001',
    sort_order: 1,
    is_active: true,
    badge: 'MÁS VENDIDO',
    profile: ['Tradicional', 'Criollo', 'Jugoso'],
    spiciness: 'Bajo',
    intensity: 'Media',
    smokiness: 'Sin ahumar',
    pairing: 'Malbec Reserva o Cabernet Sauvignon',
    idealFor: 'Parrilla al carbón o leña',
    cookingTime: '25-30 minutos a fuego medio',
    conservation: 'Envasado al vacío. Hasta 30 días en heladera (0-4°C) o 6 meses en freezer.',
    ingredients: ['Carne de puro cerdo seleccionada', 'Pimienta negra en grano', 'Ajo fresco', 'Ají molido criollo', 'Sal marina'],
    weight: 'Pack x 4 unidades (~550g)'
  },
  {
    id: 'prod-ch-002',
    category_id: 'cat-chorizos-mrcerdo',
    name: 'Chorizo Tomillo, Mostaza y Miel',
    description: 'Receta gourmet agridulce y aromática. Elaborado con tomillo fresco de huerta, mostaza seleccionada y un sutil toque de miel pura.',
    price: 3800,
    image_url: '/img/Catalogo/chorizos/tomillo.png',
    code: 'CH-002',
    sort_order: 2,
    is_active: true,
    badge: 'GOURMET',
    profile: ['Dulce', 'Aromático', 'Herbal'],
    spiciness: 'Sin picante',
    intensity: 'Intensa',
    smokiness: 'Sin ahumar',
    pairing: 'Chardonnay con paso por roble o Pinot Noir joven',
    idealFor: 'Parrilla gourmet o sartén de hierro',
    cookingTime: '20-25 minutos a fuego medio-bajo',
    conservation: 'Envasado al vacío. Hasta 30 días en heladera o 6 meses en freezer.',
    ingredients: ['Carne de cerdo seleccionada', 'Tomillo fresco', 'Mostaza de grano', 'Miel pura de abejas', 'Especias aromáticas'],
    weight: 'Pack x 4 unidades (~550g)'
  },
  {
    id: 'prod-ch-003',
    category_id: 'cat-chorizos-mrcerdo',
    name: 'Chorizo Morrón y Aceitunas',
    description: 'Sabor mediterráneo incomparable con morrones asados al fuego y aceitunas verdes seleccionadas. Extremadamente jugoso y fragante.',
    price: 3800,
    image_url: '/img/Catalogo/chorizos/criollo.png',
    code: 'CH-003',
    sort_order: 3,
    is_active: true,
    badge: 'PREMIUM',
    profile: ['Mediterráneo', 'Muy jugoso', 'Levemente ahumado'],
    spiciness: 'Sin picante',
    intensity: 'Media',
    smokiness: 'Leve',
    pairing: 'Merlot equilibrado o Cerveza Amber Ale',
    idealFor: 'Parrilla tradicional y picadas tibias',
    cookingTime: '25 minutos a fuego medio',
    conservation: 'Envasado al vacío. Hasta 30 días refrigerado.',
    ingredients: ['Carne de cerdo', 'Morrones rojos asados', 'Aceitunas verdes en rodajas', 'Pimentón ahumado', 'Sal marina'],
    weight: 'Pack x 4 unidades (~550g)'
  },
  {
    id: 'prod-ch-004',
    category_id: 'cat-chorizos-mrcerdo',
    name: 'Chorizo Roquefort y Pera',
    description: 'La combinación dulce-salada más sofisticada de la charcutería. Corazón fundente de auténtico queso azul patagónico con trocitos de pera fresca.',
    price: 4200,
    image_url: '/img/Catalogo/chorizos/tomillo.png',
    code: 'CH-004',
    sort_order: 4,
    is_active: true,
    badge: 'EXCLUSIVO',
    profile: ['Queso azul', 'Contraste dulce', 'Sofisticado'],
    spiciness: 'Sin picante',
    intensity: 'Muy Gourmet',
    smokiness: 'Sin ahumar',
    pairing: 'Vino Cosecha Tardía, Gewürztraminer o Syrah',
    idealFor: 'Degustación gourmet en parrilla o plancha',
    cookingTime: '20 minutos a fuego suave para fundir el queso sin arrebatar',
    conservation: 'Envasado al vacío. Hasta 25 días en heladera.',
    ingredients: ['Puro cerdo magro', 'Queso azul tipo Roquefort', 'Pera fresca deshidratada', 'Pimienta blanca', 'Nuez moscada'],
    weight: 'Pack x 4 unidades (~550g)'
  },
  {
    id: 'prod-ch-005',
    category_id: 'cat-chorizos-mrcerdo',
    name: 'Chorizo Higo y Parmesano',
    description: 'Chorizo artesanal gourmet elaborado con higos secos seleccionados y escamas de queso Parmesano estacionado. Textura inigualable.',
    price: 4200,
    image_url: '/img/Catalogo/chorizos/criollo.png',
    code: 'CH-005',
    sort_order: 5,
    is_active: true,
    badge: 'EDICIÓN CHEF',
    profile: ['Dulce agrio', 'Queso estacionado', 'Muy gourmet'],
    spiciness: 'Sin picante',
    intensity: 'Muy Gourmet',
    smokiness: 'Sin ahumar',
    pairing: 'Cabernet Franc del Valle de Uco o Cerveza Scotch Ale',
    idealFor: 'Tablas gourmet y parrilla de autor',
    cookingTime: '20-25 minutos a fuego medio-suave',
    conservation: 'Envasado al vacío. Hasta 30 días en heladera.',
    ingredients: ['Carne seleccionada de cerdo', 'Higos turcos', 'Queso Parmesano reggiano', 'Pimienta negra recién molida'],
    weight: 'Pack x 4 unidades (~550g)'
  },
  {
    id: 'prod-ch-006',
    category_id: 'cat-chorizos-mrcerdo',
    name: 'Chorizo Español con Cheddar',
    description: 'Chorizo estilo ibérico condimentado con pimentón de la Vera e infusionado con corazón fundente de queso Cheddar madurado.',
    price: 3900,
    image_url: '/img/Catalogo/chorizos/tomillo.png',
    code: 'CH-006',
    sort_order: 6,
    is_active: true,
    badge: 'FUNDENTE',
    profile: ['Pimentón ibérico', 'Cremoso', 'Fundente'],
    spiciness: 'Bajo',
    intensity: 'Intensa',
    smokiness: 'Ahumado Natural',
    pairing: 'Tempranillo o Cerveza IPA',
    idealFor: 'Choripán gourmet, hamburguesas o parrilla',
    cookingTime: '22 minutos a fuego medio',
    conservation: 'Envasado al vacío. Hasta 30 días refrigerado.',
    ingredients: ['Carne de cerdo', 'Queso Cheddar madurado', 'Pimentón ahumado español', 'Ajo macerado en vino blanco'],
    weight: 'Pack x 4 unidades (~550g)'
  },
  {
    id: 'prod-ch-007',
    category_id: 'cat-chorizos-mrcerdo',
    name: 'Chorizo Jalapeño y Queso Fontina',
    description: 'Para los amantes de las notas especiadas intensas: suave picor de chiles jalapeños equilibrado por la untuosidad del queso Fontina.',
    price: 4000,
    image_url: '/img/Catalogo/chorizos/criollo.png',
    code: 'CH-007',
    sort_order: 7,
    is_active: true,
    badge: 'PICANTE',
    profile: ['Especiado', 'Queso fundido', 'Vibrante'],
    spiciness: 'Medio',
    intensity: 'Intensa',
    smokiness: 'Leve',
    pairing: 'Cerveza Indian Pale Ale (IPA) bien fría',
    idealFor: 'Parrilla entre amigos y picadas intensas',
    cookingTime: '25 minutos a fuego medio',
    conservation: 'Envasado al vacío. Hasta 30 días refrigerado.',
    ingredients: ['Carne de cerdo seleccionada', 'Chiles jalapeños verdes', 'Queso Fontina de campo', 'Especias'],
    weight: 'Pack x 4 unidades (~550g)'
  },
  {
    id: 'prod-ch-008',
    category_id: 'cat-chorizos-mrcerdo',
    name: 'Chorizo Ahumado con Romero y Vino Blanco',
    description: 'Chorizo aromático madurado con romero fresco serrano y reducción de vino blanco Torrontés norteño. Delicadeza en cada bocado.',
    price: 4100,
    image_url: '/img/Catalogo/chorizos/tomillo.png',
    code: 'CH-008',
    sort_order: 8,
    is_active: true,
    badge: 'ESPECIAL',
    profile: ['Herbal', 'Ahumado sutil', 'Vino blanco'],
    spiciness: 'Sin picante',
    intensity: 'Media',
    smokiness: 'Ahumado Natural',
    pairing: 'Torrontés de altura de Cafayate o Sauvignon Blanc',
    idealFor: 'Cocina de autor en sartén u horno',
    cookingTime: '20 minutos a fuego lento',
    conservation: 'Envasado al vacío. Hasta 30 días refrigerado.',
    ingredients: ['Puro cerdo magro', 'Romero fresco', 'Vino blanco Torrontés', 'Sal marina patagónica'],
    weight: 'Pack x 4 unidades (~550g)'
  },

  // ==========================================
  // SALAMES ARTESANALES (5 VARIEDADES)
  // ==========================================
  {
    id: 'prod-sa-001',
    category_id: 'cat-salames-mrcerdo',
    name: 'Salame Tradicional de Colonia',
    description: 'Salame artesanal elaborado según la tradición familiar, con curación lenta en bodega natural y perfecto equilibrio magro-graso.',
    price: 4800,
    image_url: '/img/Catalogo/salames/tradicional.png',
    code: 'SA-001',
    sort_order: 10,
    is_active: true,
    badge: 'CURADO NATURAL',
    profile: ['Tradicional', 'Equilibrado', 'Madurado'],
    spiciness: 'Sin picante',
    intensity: 'Media',
    smokiness: 'Sin ahumar',
    pairing: 'Malbec joven o Vermouth rosso con rodaja de naranja',
    idealFor: 'Picadas gourmet, tablas de quesos y panes campesinos',
    curingProcess: 'Secado lento en cámara con humedad controlada',
    maturationTime: '35 a 45 días de maduración',
    conservation: 'Colgado en lugar fresco y seco (12-15°C) o refrigerado envuelto en papel craft.',
    ingredients: ['Carne seleccionada de cerdo y novillo magro', 'Tocino de dorso en dados', 'Pimienta negra en grano', 'Vino tinto moscato'],
    weight: 'Pieza entera (~320g)'
  },
  {
    id: 'prod-sa-002',
    category_id: 'cat-salames-mrcerdo',
    name: 'Salame Picado Grueso Artesanal',
    description: 'El clásico salame de picado visible, textura firme y pronunciado sabor a especias y clavo de olor. Ideal para cortar en fetas finas.',
    price: 4900,
    image_url: '/img/Catalogo/salames/tradicional.png',
    code: 'SA-002',
    sort_order: 11,
    is_active: true,
    badge: 'PICADO GRUESO',
    profile: ['Firme', 'Especiado', 'Rústico'],
    spiciness: 'Bajo',
    intensity: 'Intensa',
    smokiness: 'Sin ahumar',
    pairing: 'Bonarda tucumano o Cerveza Pilsen',
    idealFor: 'Picada criolla y sándwiches gourmet en pan ciabatta',
    curingProcess: 'Estacionamiento natural con flora blanca autóctona',
    maturationTime: '40 días',
    conservation: 'Lugar fresco y seco o heladera.',
    ingredients: ['Carne de cerdo 80%', 'Tocino firme en cubos 20%', 'Especias criollas', 'Ajo'],
    weight: 'Pieza entera (~350g)'
  },
  {
    id: 'prod-sa-003',
    category_id: 'cat-salames-mrcerdo',
    name: 'Salame Premium Selección',
    description: 'Elaborado exclusivamente con solomillo y pernil de cerdo magro seleccionado. Mínimo contenido graso y máximo refinamiento de sabor.',
    price: 5600,
    image_url: '/img/Catalogo/salames/tradicional.png',
    code: 'SA-003',
    sort_order: 12,
    is_active: true,
    badge: 'ALTA CHARCUTERÍA',
    profile: ['Magro', 'Delicado', 'Aromático'],
    spiciness: 'Sin picante',
    intensity: 'Muy Gourmet',
    smokiness: 'Sin ahumar',
    pairing: 'Pinot Noir patagónico o Espumante Extra Brut',
    idealFor: 'Tablas de degustación premium con frutos secos',
    curingProcess: 'Maduración prolongada a temperatura de bodega',
    maturationTime: '60 días de estacionamiento',
    conservation: 'Conservar en heladera entre 4°C y 8°C.',
    ingredients: ['Solomillo y pernil magro de cerdo', 'Pimienta blanca de Sarawak', 'Sal marina del sur'],
    weight: 'Pieza entera (~300g)'
  },
  {
    id: 'prod-sa-004',
    category_id: 'cat-salames-mrcerdo',
    name: 'Salame Ahumado con Leña de Frutales',
    description: 'Ahuma suavemente en caliente con leña de manzano y nogal, aportando notas tostadas increíbles sin tapar el sabor artesanal.',
    price: 5200,
    image_url: '/img/Catalogo/salames/tradicional.png',
    code: 'SA-004',
    sort_order: 13,
    is_active: true,
    badge: 'AHUMADO',
    profile: ['Madera noble', 'Ahumado sutil', 'Intenso'],
    spiciness: 'Sin picante',
    intensity: 'Intensa',
    smokiness: 'Ahumado Intenso',
    pairing: 'Syrah o Cerveza Porter / Stout',
    idealFor: 'Acompañar quesos ahumados y encurtidos artesanales',
    curingProcess: 'Ahumado artesanal en horno de leña y posterior secado',
    maturationTime: '45 días',
    conservation: 'Envasado al vacío o refrigerado.',
    ingredients: ['Carne de cerdo seleccionada', 'Pimienta negra en grano', 'Ahumado natural con leña de manzano'],
    weight: 'Pieza entera (~330g)'
  },
  {
    id: 'prod-sa-005',
    category_id: 'cat-salames-mrcerdo',
    name: 'Salame a la Pimienta Negra en Costra',
    description: 'Recubierto en costra artesanal de pimientas recién partidas. Explosión aromática en cada bocado para paladares exigentes.',
    price: 5100,
    image_url: '/img/Catalogo/salames/tradicional.png',
    code: 'SA-005',
    sort_order: 14,
    is_active: true,
    badge: 'COSTRA PIMIENTA',
    profile: ['Especiado picante', 'Crujiente', 'Intenso'],
    spiciness: 'Medio',
    intensity: 'Intensa',
    smokiness: 'Sin ahumar',
    pairing: 'Cabernet Sauvignon de gran cuerpo',
    idealFor: 'Aperitivos de carácter y maridaje con quesos duros',
    curingProcess: 'Curado en seco y recubrimiento manual en pimientas',
    maturationTime: '40 días',
    conservation: 'Refrigerar envuelto en papel para mantener la costra crujiente.',
    ingredients: ['Carne de cerdo', 'Mix de pimientas negras y verdes partidas', 'Ajo'],
    weight: 'Pieza entera (~320g)'
  },

  // ==========================================
  // BONDIOLAS ARTESANALES (4 VARIEDADES)
  // ==========================================
  {
    id: 'prod-bo-001',
    category_id: 'cat-bondiolas-mrcerdo',
    name: 'Bondiola Curada Tradicional',
    description: 'Bondiola de cerdo madurada lentamente con sal marina y especias criollas. Textura sedosa y vetas marmoladas que se deshacen en el paladar.',
    price: 7500,
    image_url: '/img/Catalogo/bondiolas/tradicional.png',
    code: 'BO-001',
    sort_order: 20,
    is_active: true,
    badge: 'ARTESANAL',
    profile: ['Sedosa', 'Curación lenta', 'Delicada'],
    spiciness: 'Sin picante',
    intensity: 'Media',
    smokiness: 'Sin ahumar',
    pairing: 'Malbec elegante o Pinot Noir',
    idealFor: 'Cortar súper fina en carpaccio o sándwiches gourmet con rúcula',
    curingProcess: 'Salazón seca artesanal y maduración en cava',
    maturationTime: '60 a 75 días de curado controlado',
    conservation: 'Envasado al vacío. Una vez abierta, envolver en film en heladera.',
    ingredients: ['Corte entero de bondiola de cerdo magra', 'Sal marina', 'Nuez moscada', 'Pimienta negra'],
    weight: 'Pieza media o feteada (~450g)'
  },
  {
    id: 'prod-bo-002',
    category_id: 'cat-bondiolas-mrcerdo',
    name: 'Bondiola Ahumada al Nogal',
    description: 'Ahumada con astillas de madera de nogal del norte argentino. Aroma profundo, color ámbar y jugosidad inconfundible.',
    price: 7900,
    image_url: '/img/Catalogo/bondiolas/tradicional.png',
    code: 'BO-002',
    sort_order: 21,
    is_active: true,
    badge: 'AHUMADA',
    profile: ['Madera de nogal', 'Aromática', 'Marmolada'],
    spiciness: 'Sin picante',
    intensity: 'Intensa',
    smokiness: 'Ahumado Intenso',
    pairing: 'Cabernet Franc o Cerveza Bock',
    idealFor: 'Tablas de ahumados premium y bruschettas de masa madre',
    curingProcess: 'Curado en seco y ahumado natural en frío por 18 horas',
    maturationTime: '60 días',
    conservation: 'Envasado al vacío. Refrigerar.',
    ingredients: ['Bondiola de cerdo seleccionada', 'Ahumado con nogal', 'Especias aromáticas'],
    weight: 'Pieza media (~450g)'
  },
  {
    id: 'prod-bo-003',
    category_id: 'cat-bondiolas-mrcerdo',
    name: 'Bondiola a la Pimienta Negra y Coriandro',
    description: 'Envuelta en una fina costra de pimienta negra partida y semillas tostadas de coriandro cítrico. Un equilibrio gourmet de frescura e intensidad.',
    price: 7800,
    image_url: '/img/Catalogo/bondiolas/tradicional.png',
    code: 'BO-003',
    sort_order: 22,
    is_active: true,
    badge: 'GOURMET',
    profile: ['Cítrica especiada', 'Refinada', 'Intensa'],
    spiciness: 'Bajo',
    intensity: 'Muy Gourmet',
    smokiness: 'Sin ahumar',
    pairing: 'Syrah o Riesling seco',
    idealFor: 'Degustación con quesos de cabra o Brie',
    curingProcess: 'Maduración artesanal y rebozado en especias frescas',
    maturationTime: '65 días',
    conservation: 'Envasado al vacío. Refrigerar.',
    ingredients: ['Bondiola de cerdo', 'Semillas de coriandro tostado', 'Pimienta negra en grano'],
    weight: 'Pieza media (~450g)'
  },
  {
    id: 'prod-bo-004',
    category_id: 'cat-bondiolas-mrcerdo',
    name: 'Bondiola a las Finas Hierbas del Cerro',
    description: 'Aromatizada con tomillo serrano, romero fresco y laurel tucumano. Un perfil herbal suave y distinguido.',
    price: 7800,
    image_url: '/img/Catalogo/bondiolas/tradicional.png',
    code: 'BO-004',
    sort_order: 23,
    is_active: true,
    badge: 'HIERBAS SERRANAS',
    profile: ['Herbal fresco', 'Aromático', 'Suave'],
    spiciness: 'Sin picante',
    intensity: 'Suave',
    smokiness: 'Sin ahumar',
    pairing: 'Torrontés tucumano o Chardonnay',
    idealFor: 'Entradas ligeras con aceite de oliva virgen extra',
    curingProcess: 'Infusión en hierbas y secado lento',
    maturationTime: '60 días',
    conservation: 'Refrigerado envasado al vacío.',
    ingredients: ['Bondiola seleccionada', 'Romero serrano', 'Tomillo fresco', 'Sal marina'],
    weight: 'Pieza media (~450g)'
  },

  // ==========================================
  // MATAMBRES ARTESANALES (5 VARIEDADES)
  // ==========================================
  {
    id: 'prod-ma-001',
    category_id: 'cat-matambres-mrcerdo',
    name: 'Matambre Arrollado Tradicional',
    description: 'Matambre de cerdo tierno relleno con zanahoria asada, morrón colorado, huevo de campo y condimentos criollos. Listo para cortar o dorar.',
    price: 8200,
    image_url: '/img/Catalogo/matambres/tradicional.png',
    code: 'MA-001',
    sort_order: 30,
    is_active: true,
    badge: 'RECETA CASERA',
    profile: ['Casero', 'Tierno', 'Relleno criollo'],
    spiciness: 'Sin picante',
    intensity: 'Media',
    smokiness: 'Sin ahumar',
    pairing: 'Malbec o Bonarda de cuerpo medio',
    idealFor: 'Entrada fría clásica o calentar a la parrilla/horno hasta dorar',
    cookingTime: '15 minutos a horno fuerte para gratinar o servir frío',
    conservation: 'Envasado al vacío. Refrigerar (0-4°C) hasta 20 días.',
    ingredients: ['Matambre de cerdo tierno', 'Morrones asados', 'Zanahoria fresca', 'Especias verdes naturales'],
    weight: 'Arrollado grande (~800g)'
  },
  {
    id: 'prod-ma-002',
    category_id: 'cat-matambres-mrcerdo',
    name: 'Matambre al Tomillo, Mostaza y Miel',
    description: 'Marinado en mostaza antigua, tomillo fresco y glaseado con miel. Al hornearlo o asarlo, logra un laqueado dorado irresistible.',
    price: 8600,
    image_url: '/img/Catalogo/matambres/tradicional.png',
    code: 'MA-002',
    sort_order: 31,
    is_active: true,
    badge: 'LAQUEADO GOURMET',
    profile: ['Glaseado miel', 'Aromático', 'Dulce-salado'],
    spiciness: 'Sin picante',
    intensity: 'Muy Gourmet',
    smokiness: 'Sin ahumar',
    pairing: 'Chardonnay reserva o Cerveza Golden Ale',
    idealFor: 'Asado gourmet o pieza central al horno con papas rústicas',
    cookingTime: '25 minutos al horno a 180°C pincelando con sus jugos',
    conservation: 'Envasado al vacío. Refrigerar.',
    ingredients: ['Matambre seleccionado de cerdo', 'Mostaza en grano', 'Miel pura', 'Tomillo serrano'],
    weight: 'Pieza entera macerada (~800g)'
  },
  {
    id: 'prod-ma-003',
    category_id: 'cat-matambres-mrcerdo',
    name: 'Matambre a las Hierbas Serranas',
    description: 'Adobado con romero, orégano de sierra, ajo asado y aceite de oliva virgen extra. Fresco, aromático y tierno como manteca.',
    price: 8400,
    image_url: '/img/Catalogo/matambres/tradicional.png',
    code: 'MA-003',
    sort_order: 32,
    is_active: true,
    badge: 'AROMÁTICO',
    profile: ['Herbal serrano', 'Ajo asado', 'Tierno'],
    spiciness: 'Sin picante',
    intensity: 'Media',
    smokiness: 'Sin ahumar',
    pairing: 'Cabernet Franc o Sauvignon Blanc',
    idealFor: 'Parrilla al limón o cocina al horno',
    cookingTime: '20 minutos a la parrilla del lado del cuero primero',
    conservation: 'Envasado al vacío refrigerado.',
    ingredients: ['Matambre de cerdo', 'Aceite de oliva extra virgen', 'Mix de hierbas serranas tucumanas'],
    weight: 'Pieza entera (~800g)'
  },
  {
    id: 'prod-ma-004',
    category_id: 'cat-matambres-mrcerdo',
    name: 'Matambre al Ajo Confitado y Romero',
    description: 'Infundido con pasta de ajo confitado a baja temperatura durante 6 horas y ramitas de romero. Un sabor profundo, dulce y nada invasivo.',
    price: 8500,
    image_url: '/img/Catalogo/matambres/tradicional.png',
    code: 'MA-004',
    sort_order: 33,
    is_active: true,
    badge: 'CONFITADO',
    profile: ['Ajo suave confitado', 'Untuoso', 'Gourmet'],
    spiciness: 'Sin picante',
    intensity: 'Intensa',
    smokiness: 'Sin ahumar',
    pairing: 'Malbec Reserva del Norte',
    idealFor: 'Horno lento o parrilla sobre brasas suaves',
    cookingTime: '25 minutos a horno moderado',
    conservation: 'Envasado al vacío refrigerado.',
    ingredients: ['Matambre magro de cerdo', 'Ajo confitado en aceite de oliva', 'Romero fresco'],
    weight: 'Pieza entera (~800g)'
  },
  {
    id: 'prod-ma-005',
    category_id: 'cat-matambres-mrcerdo',
    name: 'Matambre Especiado Picante Norteño',
    description: 'Adobado con ají locoto tucumano, pimentón ahumado y especias calientes. Para los que buscan carácter y un toque picante criollo auténtico.',
    price: 8500,
    image_url: '/img/Catalogo/matambres/tradicional.png',
    code: 'MA-005',
    sort_order: 34,
    is_active: true,
    badge: 'PICANTE CRIOLLO',
    profile: ['Picante norteño', 'Ahuma pimentón', 'Intenso'],
    spiciness: 'Alto',
    intensity: 'Intensa',
    smokiness: 'Leve',
    pairing: 'Cerveza IPA o Torrontés bien frío',
    idealFor: 'Parrilla con rodajas de limón fresco',
    cookingTime: '20 minutos a la parrilla fuego medio',
    conservation: 'Envasado al vacío refrigerado.',
    ingredients: ['Matambre de cerdo', 'Ají locoto en copos', 'Pimentón de los Valles', 'Sal marina'],
    weight: 'Pieza entera (~800g)'
  }
];

export function filterMrCerdoCategories(cats: any[]): any[] {
  if (!cats || !Array.isArray(cats)) return DEFAULT_CATEGORY_CHORIZOS;
  const filtered = cats.filter(c => {
    const name = (c.name || '').trim().toLowerCase();
    // Exclude any supplement categories
    if (/proteín|creatin|suplement|pre-entren|vitamin|amino|quemador|ganador|barra|shaker|ropa|accesor/i.test(name)) {
      return false;
    }
    return ['chorizos', 'salames', 'bondiolas', 'matambres', 'combos', 'parrilla', 'embutidos'].some(allowed => name.includes(allowed));
  });
  return filtered.length > 0 ? filtered : DEFAULT_CATEGORY_CHORIZOS;
}

export function filterMrCerdoProducts(prods: any[]): any[] {
  if (!prods || !Array.isArray(prods)) return DEFAULT_CHORIZO_PRODUCTS;
  const filtered = prods.filter(p => {
    const code = (p.code || '').toUpperCase();
    const text = `${p.name || ''} ${p.description || ''}`.toLowerCase();
    // Exclude any supplement products
    if (/protein|proteína|whey|creatin|nutrition|lisa mayorista|suplement|pre-entreno|bcaa|glutamin|gainer|lbs|star nutrition/i.test(text)) {
      return false;
    }
    return code.startsWith('CH-') ||
           code.startsWith('SA-') ||
           code.startsWith('BO-') ||
           code.startsWith('MA-') ||
           /chorizo|salame|bondiola|matambre|embutido|cerdo|criollo|morrón|tomillo|roquefort|higo|cheddar/i.test(text);
  });
  return filtered.length > 0 ? filtered : DEFAULT_CHORIZO_PRODUCTS;
}
