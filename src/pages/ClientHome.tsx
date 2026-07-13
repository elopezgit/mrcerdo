import React, { useEffect, useState, useRef } from 'react';
import { useParams } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import { ShoppingCart, Search, Info, MapPin, Plus, Star, ChevronRight, RotateCcw } from 'lucide-react';
import { useCart } from '../lib/CartContext';
import CartModal from '../components/client/CartModal';
import ProductModal from '../components/client/ProductModal';
import OrderTrackerModal from '../components/client/OrderTrackerModal';
import { motion, AnimatePresence } from 'framer-motion';
import { getEmpresaData } from '../lib/getEmpresa';
import { 
  DEFAULT_CATEGORY_CHORIZOS, 
  DEFAULT_CHORIZO_PRODUCTS, 
  filterMrCerdoCategories, 
  filterMrCerdoProducts 
} from '../lib/defaultCatalog';

interface Empresa {
  id: string;
  name: string;
  phone: string;
  instagram_url: string;
  maps_url: string;
}

interface Category {
  id: string;
  name: string;
  icon: string;
}

interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  category_id: string;
  image_url?: string;
  is_active: boolean;
  sort_order?: number;
}

interface Banner {
  id: string;
  image_url: string;
  link?: string;
  title?: string;
  subtitle?: string;
}

export default function ClientHome() {
  const { empresaSlug } = useParams<{ empresaSlug?: string }>();
  const activeSlug = empresaSlug || 'mrcerdo';

  const [empresa, setEmpresa] = useState<Empresa | null>(null);
  const [categories, setCategories] = useState<Category[]>(DEFAULT_CATEGORY_CHORIZOS);
  const [products, setProducts] = useState<Product[]>(DEFAULT_CHORIZO_PRODUCTS as unknown as Product[]);
  const [banners, setBanners] = useState<Banner[]>([]);
  
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showSplash, setShowSplash] = useState(true);
  
  const [lastOrder, setLastOrder] = useState<any[]>([]);
  const [activeOrderId, setActiveOrderId] = useState<string | null>(null);
  const [isTrackerOpen, setIsTrackerOpen] = useState(false);

  // UI States
  const [searchQuery, setSearchQuery] = useState('');
  const [activeCategory, setActiveCategory] = useState<string | 'todas'>('todas');
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);
  const [selectedKeyword, setSelectedKeyword] = useState<string>('todas');

  const categoryColors: Record<string, { from: string; to: string; shadow: string }> = {
    'Chorizos': { from: '#8E201B', to: '#A82B24', shadow: 'rgba(161,44,37,0.25)' },
    'Salames': { from: '#9A3412', to: '#C2410C', shadow: 'rgba(194,65,12,0.25)' },
    'Bondiolas': { from: '#7C2D12', to: '#9A3412', shadow: 'rgba(180,83,9,0.25)' },
    'Matambres': { from: '#451A03', to: '#78350F', shadow: 'rgba(120,53,15,0.25)' },
  };

  const getCategoryStyle = (catName: string) => {
    return categoryColors[catName] || { from: '#8E201B', to: '#A82B24', shadow: 'rgba(161,44,37,0.25)' };
  };

  const { items, setIsCartOpen, addToCart, clearCart } = useCart();
  const cartItemCount = items.reduce((sum, item) => sum + item.quantity, 0);

  const scrollRef = useRef<HTMLDivElement>(null);
  const scrollIntervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const startAutoScroll = () => {
    if (scrollIntervalRef.current) clearInterval(scrollIntervalRef.current);
    scrollIntervalRef.current = setInterval(() => {
      if (scrollRef.current) {
        const { scrollLeft, scrollWidth, clientWidth } = scrollRef.current;
        const maxScroll = scrollWidth - clientWidth;
        const firstChild = scrollRef.current.children[0] as HTMLElement;
        const cardWidth = firstChild ? firstChild.offsetWidth + 16 : 320; 
        
        if (scrollLeft >= maxScroll - 10) {
          scrollRef.current.scrollTo({ left: 0, behavior: 'smooth' });
        } else {
          scrollRef.current.scrollBy({ left: cardWidth, behavior: 'smooth' });
        }
      }
    }, 4000);
  };

  useEffect(() => {
    startAutoScroll();
    return () => {
      if (scrollIntervalRef.current) clearInterval(scrollIntervalRef.current);
    };
  }, []);

  const handleTouchStart = () => {
    if (scrollIntervalRef.current) clearInterval(scrollIntervalRef.current);
  };

  const handleTouchEnd = () => {
    setTimeout(() => {
      startAutoScroll();
    }, 5000);
  };

  useEffect(() => {
    async function loadData() {
      try {
        const empData = await getEmpresaData();
        if (empData) {
          setEmpresa(empData);

          const savedOrder = localStorage.getItem(`lastOrder_${empData.id}`);
          if (savedOrder) {
            try {
              setLastOrder(JSON.parse(savedOrder));
            } catch(e) {}
          }

          const activeOrder = localStorage.getItem(`activeOrder_${empData.id}`);
          if (activeOrder) {
            setActiveOrderId(activeOrder);
          }

          const [cats, prods, bans] = await Promise.all([
            supabase.from('categories').select('*').eq('empresa_id', empData.id),
            supabase.from('products').select('*').eq('empresa_id', empData.id).eq('is_active', true),
            supabase.from('banners').select('*').eq('empresa_id', empData.id).eq('is_active', true)
          ]);

          const cleanCategories = filterMrCerdoCategories(cats.data || []);
          const cleanProducts = filterMrCerdoProducts(prods.data || []);

          if (cleanCategories.length > 0) setCategories(cleanCategories);
          if (cleanProducts.length > 0) setProducts(cleanProducts as unknown as Product[]);
          if (bans.data && bans.data.length > 0) {
            const sortedBans = bans.data.sort((a, b) => (a.sort_order || 0) - (b.sort_order || 0));
            setBanners(sortedBans);
          }
        }
      } catch (err: any) {
        setError(err.message);
      } finally {
        setLoading(false);
        setTimeout(() => setShowSplash(false), 2600);
      }
    }
    loadData();
  }, [activeSlug]);

  if (loading || showSplash) {
    return (
      <AnimatePresence>
        <motion.div 
          exit={{ opacity: 0, scale: 1.03 }}
          transition={{ duration: 0.5, ease: "easeInOut" }}
          onClick={() => setShowSplash(false)}
          className="min-h-screen bg-[#FAF8F5] flex flex-col items-center justify-center relative overflow-hidden cursor-pointer select-none"
        >
          <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,_rgba(161,44,37,0.08)_0%,_rgba(250,248,245,1)_70%)] pointer-events-none" />
          
          <div className="relative z-10 flex flex-col items-center justify-center text-center px-6 max-w-lg mx-auto">
            <motion.div
              initial={{ opacity: 0, y: -15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5 }}
              className="inline-flex items-center gap-2 bg-[#A12C25]/10 border border-[#A12C25]/30 px-4 py-1.5 rounded-full mb-6 shadow-sm"
            >
              <span className="w-2 h-2 rounded-full bg-[#A12C25] animate-ping" />
              <span className="text-[11px] font-black uppercase tracking-widest text-[#A12C25]">
                🔥 CHARCUTERÍA & EMBUTIDOS ARTESANALES 🔥
              </span>
            </motion.div>

            <motion.div
              initial={{ scale: 0.7, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ duration: 0.6, type: "spring", bounce: 0.3 }}
              className="relative mb-6"
            >
              <div className="w-40 h-40 sm:w-48 sm:h-48 rounded-full border-4 border-[#A12C25] shadow-xl overflow-hidden bg-white flex items-center justify-center relative z-10">
                <img 
                  src="/img/logo/logoMrCerdo.jpg" 
                  alt="Mr Cerdo" 
                  className="w-full h-full object-cover"
                />
              </div>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.5 }}
            >
              <h1 className="text-3xl sm:text-4xl font-black text-stone-900 uppercase tracking-tight font-display drop-shadow-sm">
                MR CERDO
              </h1>
              <p className="text-xs sm:text-sm font-extrabold text-[#A12C25] uppercase tracking-widest mt-2">
                🥩 CARNES SELECCIONADAS • CALIDAD GOURMET PREMIUM 🔥
              </p>
            </motion.div>

            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.4, duration: 0.5 }}
              className="flex flex-wrap items-center justify-center gap-2 mt-6"
            >
              <span className="bg-white border border-stone-200 text-stone-700 text-[10px] font-bold px-3 py-1.5 rounded-xl uppercase shadow-sm">
                🐷 Chorizos Artesanales
              </span>
              <span className="bg-white border border-stone-200 text-stone-700 text-[10px] font-bold px-3 py-1.5 rounded-xl uppercase shadow-sm">
                🥓 Salames & Bondiolas
              </span>
              <span className="bg-white border border-stone-200 text-stone-700 text-[10px] font-bold px-3 py-1.5 rounded-xl uppercase shadow-sm">
                🥩 Matambres Gourmet
              </span>
            </motion.div>

            <motion.div
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ delay: 0.6, duration: 0.5, type: "spring" }}
              className="mt-8 flex flex-col items-center gap-2"
            >
              <span className="bg-gradient-to-r from-[#A12C25] to-[#D9381E] text-white font-black text-base uppercase tracking-wider px-8 py-3.5 rounded-2xl shadow-lg shadow-[#A12C25]/25 active:scale-95 transition-transform">
                ⚡ ENTRAR AL CATÁLOGO ⚡
              </span>
              <span className="text-[11px] text-stone-500 font-medium">
                Toca en cualquier lugar para ingresar
              </span>
            </motion.div>
          </div>
        </motion.div>
      </AnimatePresence>
    );
  }

  if (error || !empresa) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#FAF8F5] p-4">
        <div className="bg-white p-8 rounded-3xl shadow-xl text-center max-w-sm border border-stone-200">
          <Info size={48} className="mx-auto text-[#A12C25] mb-4" />
          <h1 className="text-xl font-bold text-stone-900 mb-2">Ops! Algo salió mal</h1>
          <p className="text-stone-600 break-words">{error}</p>
        </div>
      </div>
    );
  }

  const activeCategoryName = activeCategory === 'todas'
    ? 'todas'
    : categories.find(c => c.id === activeCategory)?.name || 'todas';

  const categoryKeywordsMap: Record<string, string[]> = {
    'Chorizos': ['Criollo', 'Queso', 'Picante', 'Ahumado', 'Roquefort', 'Miel'],
    'Salames': ['Colonia', 'Picado Grueso', 'Ahumado', 'Pimienta'],
    'Bondiolas': ['Curada', 'Ahumada', 'Hierbas'],
    'Matambres': ['Arrollado', 'Tomillo', 'Hierbas', 'Picante'],
    'todas': ['Criollo', 'Queso', 'Ahumado', 'Picante', 'Miel', 'Salame', 'Bondiola']
  };

  const availableKeywords = categoryKeywordsMap[activeCategoryName] || categoryKeywordsMap['todas'];

  const filteredProducts = products.filter(p => {
    const matchesSearch = p.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
                          (p.description && p.description.toLowerCase().includes(searchQuery.toLowerCase()));
    const matchesCategory = activeCategory === 'todas' || p.category_id === activeCategory;
    const matchesKeyword = selectedKeyword === 'todas' || 
                          p.name.toLowerCase().includes(selectedKeyword.toLowerCase()) ||
                          (p.description && p.description.toLowerCase().includes(selectedKeyword.toLowerCase()));
    return matchesSearch && matchesCategory && matchesKeyword;
  });

  const getProductQuantity = (productId: string) => {
    return items.filter(i => i.id === productId).reduce((acc, curr) => acc + curr.quantity, 0);
  };

  const handleSelectCategory = (catId: string) => {
    setActiveCategory(catId);
    setSelectedKeyword('todas');
  };

  const handleReorder = () => {
    clearCart();
    lastOrder.forEach(item => {
      addToCart({ id: item.id, name: item.name, price: item.price }, item.quantity, item.notes);
    });
    setIsCartOpen(true);
  };

  const displayBanners = banners.length > 0 ? banners : [
    { 
      id: '1', 
      image_url: '/img/Catalogo/bondiola.png',
      title: 'EMBUTIDOS 100% ARTESANALES',
      subtitle: 'Pura Carne Seleccionada de Cerdo'
    },
    { 
      id: '2', 
      image_url: '/img/Catalogo/salame.png',
      title: 'CURADOS & AHUMADOS GOURMET',
      subtitle: 'Salames de Colonia & Bondiolas Premium'
    },
    { 
      id: '3', 
      image_url: '/img/Catalogo/matambre.png',
      title: 'CHORIZOS RELLENOS ESPECIALES',
      subtitle: 'Roquefort, Cheddar, Jalapeño y Más'
    }
  ];

  return (
    <div className="min-h-screen bg-[#FAF8F5] pb-28 font-sans text-stone-800">
      {/* 1. HERO HEADER */}
      <header className="bg-white/95 pt-6 pb-5 px-4 sticky top-0 z-40 border-b border-stone-200 backdrop-blur-xl shadow-sm">
        <div className="max-w-6xl mx-auto">
          <div className="flex justify-between items-center mb-4">
            <div className="flex items-center gap-3.5">
               <div className="w-13 h-13 bg-white rounded-2xl border-2 border-[#A12C25] flex items-center justify-center shadow-sm overflow-hidden shrink-0 transition-transform hover:scale-105">
                  <img src="/img/logo/logoMrCerdo.jpg" alt="Mr Cerdo Logo" className="w-full h-full object-cover" />
               </div>
               <div>
                 <h1 className="text-xl md:text-2xl font-black tracking-tight text-stone-900 font-display uppercase">
                   MR CERDO
                 </h1>
                 <div className="flex items-center gap-2 text-xs font-semibold text-stone-600 mt-0.5">
                   <span className="flex items-center gap-1 font-extrabold text-[#A12C25] uppercase tracking-wider">
                     🔥 Embutidos Gourmet
                   </span>
                   <span className="text-stone-300">•</span>
                   <span className="flex items-center gap-1 text-stone-500">
                     <MapPin size={11} className="text-[#A12C25]"/> Envíos a todo el país
                   </span>
                 </div>
               </div>
            </div>
            
            <div className="flex items-center gap-2.5">
              <a 
                href={`https://wa.me/5493814751620?text=${encodeURIComponent('¡Hola Mr Cerdo! Quisiera hacer un pedido de embutidos artesanales.')}`}
                target="_blank" 
                rel="noreferrer"
                title="Consultar por WhatsApp"
                className="w-10 h-10 rounded-xl bg-emerald-50 border border-emerald-300 flex items-center justify-center text-emerald-600 hover:bg-emerald-600 hover:text-white transition-all shadow-sm"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M3 21l1.65-3.8a9 9 0 1 1 3.4 2.9L3 21"/><path d="M9 10a.5.5 0 0 0 1 0V9a.5.5 0 0 0-1 0v1a5 5 0 0 0 5 5h1a.5.5 0 0 0 0-1h-1a.5.5 0 0 0 0 1"/></svg>
              </a>
            </div>
          </div>

          {/* Search Bar */}
          <div className="relative group">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-stone-400 group-focus-within:text-[#A12C25] transition-colors" size={18} />
            <input 
              type="text" 
              placeholder="Buscar chorizos, salames, bondiolas, roquefort..." 
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-stone-100 border border-stone-200 text-stone-900 rounded-2xl py-3.5 pl-12 pr-4 shadow-inner outline-none focus:bg-white focus:border-[#A12C25] focus:ring-2 focus:ring-[#A12C25]/15 transition-all text-sm placeholder:text-stone-400"
            />
          </div>

          {activeOrderId && !searchQuery && (
            <motion.button 
              initial={{ opacity: 0, y: -20 }}
              animate={{ opacity: 1, y: 0 }}
              onClick={() => setIsTrackerOpen(true)}
              className="w-full mt-4 bg-amber-50 border border-amber-300 text-amber-800 py-3 px-4 rounded-xl flex items-center justify-between font-bold text-sm shadow-sm"
            >
              <div className="flex items-center gap-2">
                <span className="relative flex h-3 w-3 mr-1">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-500 opacity-75"></span>
                  <span className="relative inline-flex rounded-full h-3 w-3 bg-amber-500"></span>
                </span>
                Sigue tu pedido en vivo
              </div>
              <ChevronRight size={18} />
            </motion.button>
          )}
        </div>
      </header>

      <main className="mt-2 max-w-6xl mx-auto w-full">
        {lastOrder.length > 0 && !searchQuery && (
          <section className="px-4 py-2 mt-2">
            <button 
              onClick={handleReorder}
              className="w-full bg-white border border-stone-200 p-4 rounded-2xl flex items-center justify-between shadow-sm hover:shadow-md transition-all"
            >
              <div className="flex items-center gap-3 text-left">
                <div className="bg-[#A12C25]/10 p-2.5 rounded-full text-[#A12C25]">
                  <RotateCcw size={20} />
                </div>
                <div>
                  <h3 className="font-bold text-stone-900 text-sm">Pedir lo mismo de nuevo</h3>
                  <p className="text-xs text-stone-500">Tu último pedido fue increíble.</p>
                </div>
              </div>
              <ChevronRight size={20} className="text-stone-400" />
            </button>
          </section>
        )}

        {/* 2. BANNERS CAROUSEL */}
        {!searchQuery && (
          <section className="py-4 overflow-hidden relative group">
            <div 
              ref={scrollRef}
              onTouchStart={handleTouchStart}
              onTouchEnd={handleTouchEnd}
              onMouseEnter={handleTouchStart}
              onMouseLeave={handleTouchEnd}
              className="flex gap-4 px-4 overflow-x-auto snap-x snap-mandatory hide-scrollbar pb-2"
              style={{ scrollBehavior: 'smooth' }}
            >
              {displayBanners.map((banner) => (
                <div 
                  key={banner.id} 
                  className="shrink-0 w-[85vw] max-w-[340px] md:w-96 h-44 rounded-3xl overflow-hidden relative border border-stone-200 shadow-md block bg-stone-900 snap-center group/banner cursor-pointer"
                >
                  <img 
                    src={banner.image_url} 
                    alt={banner.title || "Promo Mr Cerdo"} 
                    className="w-full h-full object-cover opacity-75 group-hover/banner:scale-105 transition-transform duration-500" 
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-stone-950/90 via-stone-950/35 to-transparent"></div>
                  
                  <div className="absolute bottom-4 left-4 right-4 text-left">
                    <span className="inline-block bg-[#A12C25] text-white font-extrabold text-[10px] px-2.5 py-0.5 rounded-md uppercase tracking-widest mb-1.5 shadow-sm">
                      MR CERDO
                    </span>
                    {banner.title && (
                      <h3 className="text-white font-black text-lg leading-tight uppercase tracking-tight drop-shadow-sm">
                        {banner.title}
                      </h3>
                    )}
                    {banner.subtitle && (
                      <p className="text-stone-200 text-xs font-medium mt-0.5 line-clamp-1">
                        {banner.subtitle}
                      </p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* 3. CATEGORY SELECTOR — LIGHT PEDIDOSYA CARD DESIGN */}
        {!searchQuery && (
          <section className="px-4 mb-6">
            <h2 className="text-base font-black text-stone-900 mb-3 tracking-tight uppercase flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[#A12C25]"></span>
              Categorías Oficiales
            </h2>
            
            <div className="flex overflow-x-auto hide-scrollbar gap-3 pb-2 -mx-4 px-4 snap-x snap-mandatory">
              <motion.button
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.3, delay: 0 }}
                onClick={() => handleSelectCategory('todas')}
                className="snap-start shrink-0"
              >
                <div className={`w-20 h-28 rounded-2xl flex flex-col items-center justify-center gap-1.5 transition-all duration-200 border ${activeCategory === 'todas' ? 'bg-gradient-to-br from-[#A12C25] to-[#D9381E] text-white border-[#A12C25] shadow-md scale-105' : 'bg-white border-stone-200 text-stone-700 hover:border-[#A12C25] shadow-sm'}`}>
                  <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${activeCategory === 'todas' ? 'bg-black/20 text-white' : 'bg-stone-100 text-[#A12C25]'}`}>
                    <Star size={20} />
                  </div>
                  <span className="text-[11px] font-extrabold uppercase tracking-wider">Todas</span>
                </div>
              </motion.button>

              {categories.map((cat, i) => {
                const colors = getCategoryStyle(cat.name);
                const isActive = activeCategory === cat.id;
                const productCount = products.filter(p => p.category_id === cat.id).length;
                return (
                  <motion.button
                    key={cat.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.4, delay: 0.05 * (i + 1) }}
                    whileTap={{ scale: 0.95 }}
                    onClick={() => handleSelectCategory(cat.id)}
                    className="snap-start shrink-0"
                  >
                    <div
                      className={`w-36 h-28 rounded-2xl p-4 flex flex-col justify-between relative overflow-hidden transition-all duration-200 border ${isActive ? 'ring-2 ring-[#A12C25] ring-offset-2 ring-offset-[#FAF8F5] shadow-md scale-[1.03]' : 'border-stone-200/80 shadow-sm hover:shadow-md'}`}
                      style={{
                        background: `linear-gradient(135deg, ${colors.from}, ${colors.to})`,
                      }}
                    >
                      <div className="absolute -right-4 -top-4 text-6xl opacity-20 select-none">
                        {cat.icon}
                      </div>
                      <div className="absolute inset-0 bg-gradient-to-t from-black/35 to-transparent" />
                      <div className="relative z-10 flex flex-col h-full justify-between">
                        <div className="w-10 h-10 rounded-xl bg-black/25 backdrop-blur-sm flex items-center justify-center text-2xl border border-white/20 shadow-inner">
                          {cat.icon}
                        </div>
                        <div className="text-left">
                          <span className="block text-sm font-black text-white drop-shadow-sm leading-tight uppercase">{cat.name}</span>
                          <span className="text-[10px] text-white/90 font-semibold">{productCount} productos</span>
                        </div>
                      </div>
                    </div>
                  </motion.button>
                );
              })}
            </div>
          </section>
        )}

        {/* KEYWORDS QUICK FILTER */}
        <section className="px-4 mb-8">
          <div>
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs font-black uppercase tracking-wider text-stone-400 flex items-center gap-1.5">
                ⚡ Búsqueda Rápida
              </span>
              {selectedKeyword !== 'todas' && (
                <button 
                  onClick={() => setSelectedKeyword('todas')}
                  className="text-[11px] font-bold text-[#A12C25] hover:underline"
                >
                  Limpiar filtro
                </button>
              )}
            </div>
            <div className="flex overflow-x-auto hide-scrollbar gap-2 pb-1 -mx-4 px-4">
              <button
                onClick={() => setSelectedKeyword('todas')}
                className={`shrink-0 px-3.5 py-1.5 rounded-lg text-xs font-bold transition-all border ${
                  selectedKeyword === 'todas'
                    ? 'bg-[#A12C25] text-white border-[#A12C25] shadow-sm'
                    : 'bg-white text-stone-600 border-stone-200 hover:border-[#A12C25] hover:text-[#A12C25] shadow-sm'
                }`}
              >
                # Todos
              </button>
              {availableKeywords.map(kw => (
                <button
                  key={kw}
                  onClick={() => setSelectedKeyword(selectedKeyword === kw ? 'todas' : kw)}
                  className={`shrink-0 px-3.5 py-1.5 rounded-lg text-xs font-bold transition-all border ${
                    selectedKeyword === kw
                      ? 'bg-[#A12C25] text-white border-[#A12C25] shadow-sm scale-105'
                      : 'bg-white text-stone-700 border-stone-200 hover:border-[#A12C25] hover:text-[#A12C25] shadow-sm'
                  }`}
                >
                  #{kw}
                </button>
              ))}
            </div>
          </div>
        </section>

        {/* 4. PRODUCT LIST */}
        <section className="px-4">
          {categories.map(category => {
            const categoryProducts = filteredProducts.filter(p => p.category_id === category.id).sort((a, b) => (a.sort_order || 0) - (b.sort_order || 0));
            if (categoryProducts.length === 0) return null;

            return (
              <div key={category.id} className="mb-10">
                <h2 className="text-lg font-black text-stone-900 mb-3.5 flex items-center gap-2.5 uppercase tracking-wide">
                  <span className="w-8 h-8 rounded-xl bg-white border border-stone-200 shadow-sm flex items-center justify-center text-lg">{category.icon}</span> 
                  <span>{category.name}</span>
                </h2>
                
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {categoryProducts.map((product, idx) => {
                    const qty = getProductQuantity(product.id);
                    
                    return (
                      <motion.div 
                        initial={{ opacity: 0, y: 8 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: idx * 0.03 }}
                        key={product.id} 
                        onClick={() => setSelectedProduct(product)}
                        className="bg-white rounded-2xl border border-stone-200/90 hover:border-[#A12C25]/40 p-3.5 flex gap-4 relative cursor-pointer active:scale-[0.99] transition-all duration-200 shadow-sm hover:shadow-md group"
                      >
                        <div className="flex-1 flex flex-col justify-between">
                          <div>
                            <h3 className="font-bold text-stone-900 group-hover:text-[#A12C25] text-[15px] leading-tight mb-1 pr-2 transition-colors">{product.name}</h3>
                            <p className="text-xs text-stone-500 line-clamp-2 mb-2 leading-relaxed">{product.description}</p>
                          </div>
                          
                          <div className="flex items-center gap-3 mt-1">
                            <span className="font-black text-stone-900 text-lg tracking-tight">${product.price.toLocaleString('es-AR')}</span>
                            {qty > 0 && (
                              <span className="bg-[#A12C25]/10 text-[#A12C25] font-bold text-[10px] px-2.5 py-0.5 rounded-md border border-[#A12C25]/25 uppercase tracking-wider">
                                {qty} en pedido
                              </span>
                            )}
                          </div>
                        </div>

                        <div className="w-28 h-28 sm:w-32 sm:h-32 shrink-0 bg-stone-100 rounded-xl relative overflow-hidden shadow-inner border border-stone-200 group-hover:border-[#A12C25]/30 transition-all flex flex-col justify-between p-2">
                          <div className="z-10 flex justify-between items-center w-full">
                            <span className="text-sm select-none">{category.icon}</span>
                            <span className="bg-white/95 text-[#A12C25] font-black text-[9px] px-1.5 py-0.5 rounded border border-stone-200 tracking-wider uppercase shadow-sm">
                              GOURMET
                            </span>
                          </div>

                          <img 
                            src={product.image_url || '/img/Catalogo/bondiola.png'} 
                            alt={product.name}
                            className="absolute inset-0 w-full h-full object-cover opacity-90 group-hover:scale-105 transition-transform duration-500"
                          />
                          <div className="absolute inset-0 bg-gradient-to-t from-stone-900/65 via-transparent to-stone-900/10 pointer-events-none" />

                          <button 
                            onClick={(e) => {
                              e.stopPropagation();
                              addToCart(product, 1);
                            }}
                            className="absolute bottom-1.5 right-1.5 z-20 w-8 h-8 flex items-center justify-center bg-gradient-to-r from-[#A12C25] to-[#D9381E] rounded-lg text-white shadow-md shadow-[#A12C25]/30 active:scale-90 hover:brightness-110 transition-all"
                          >
                            <Plus size={16} strokeWidth={3} />
                          </button>
                        </div>
                      </motion.div>
                    );
                  })}
                </div>
              </div>
            );
          })}

          {filteredProducts.length === 0 && (
            <div className="text-center py-16 bg-white rounded-3xl border border-stone-200 shadow-sm">
              <Search size={48} className="mx-auto text-stone-300 mb-4" />
              <p className="text-base font-bold text-stone-800">No encontramos ningún producto</p>
              <p className="text-stone-500 text-sm">Prueba buscando con otras palabras o seleccionando otra categoría.</p>
            </div>
          )}
        </section>
      </main>

      {/* FLOATING CART BUTTON */}
      <AnimatePresence>
        {cartItemCount > 0 && (
          <motion.div
            initial={{ y: 100, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 100, opacity: 0 }}
            className="fixed bottom-6 left-4 right-4 md:max-w-md md:mx-auto z-40"
          >
            <button 
              onClick={() => setIsCartOpen(true)}
              className="w-full bg-gradient-to-r from-[#A12C25] to-[#D9381E] text-white p-4 rounded-2xl shadow-xl shadow-[#A12C25]/35 flex items-center justify-between transition-all hover:brightness-110 active:scale-95 border border-white/20"
            >
              <div className="flex items-center gap-3">
                <div className="bg-black/25 text-white w-10 h-10 rounded-xl flex items-center justify-center font-black text-lg border border-white/20 shadow-inner">
                  {cartItemCount}
                </div>
                <div className="text-left">
                  <span className="block text-xs font-semibold text-red-100 uppercase tracking-wider">Tu Pedido</span>
                  <span className="font-black text-base">Ver Carrito</span>
                </div>
              </div>
              <div className="flex items-center gap-2 font-black text-lg">
                <span>Ir a Pagar</span>
                <ChevronRight size={20} />
              </div>
            </button>
          </motion.div>
        )}
      </AnimatePresence>

      {/* MODALS */}
      <ProductModal 
        product={selectedProduct} 
        isOpen={!!selectedProduct} 
        onClose={() => setSelectedProduct(null)}
        onAddToCart={(prod, qty, notes) => addToCart(prod, qty, notes)}
      />

      <CartModal 
        empresaId={empresa.id}
        empresaName={empresa.name}
        empresaPhone={empresa.phone}
        onOrderPlaced={(orderId) => {
          setActiveOrderId(orderId);
          setIsTrackerOpen(true);
        }}
      />

      <OrderTrackerModal 
        isOpen={isTrackerOpen}
        onClose={() => setIsTrackerOpen(false)}
        orderId={activeOrderId}
        onClearActiveOrder={() => setActiveOrderId(null)}
      />
    </div>
  );
}
