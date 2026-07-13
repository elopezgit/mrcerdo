import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useCart } from '../../lib/CartContext';
import { supabase } from '../../lib/supabase';
import { X, Minus, Plus, Trash2, MapPin, Wallet, Receipt, CreditCard, Copy, CheckCircle2 } from 'lucide-react';

interface CartModalProps {
  empresaId: string;
  empresaName: string;
  empresaPhone: string;
  onOrderPlaced?: (orderId: string) => void;
}

export default function CartModal({ empresaId, empresaName, empresaPhone, onOrderPlaced }: CartModalProps) {
  const { isCartOpen, setIsCartOpen, items, updateQuantity, removeFromCart, total, clearCart } = useCart();
  
  const [customerName, setCustomerName] = useState('');
  const [customerPhone, setCustomerPhone] = useState('');
  const [deliveryAddress, setDeliveryAddress] = useState('');
  const [comment, setComment] = useState('');
  const [paymentMethod, setPaymentMethod] = useState<'efectivo' | 'transferencia'>('efectivo');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [copied, setCopied] = useState(false);

  const handleCopyAlias = () => {
    navigator.clipboard.writeText('mrcerdo.mp');
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (items.length === 0) return;
    
    setIsSubmitting(true);

    const fullComment = `${paymentMethod === 'transferencia' ? '[PAGA CON TRANSFERENCIA] ' : '[PAGA EN EFECTIVO] '}${comment}`;

    try {
      const { data: orderData, error } = await supabase
        .from('orders')
        .insert({
          empresa_id: empresaId,
          customer_name: customerName,
          customer_phone: customerPhone,
          delivery_address: deliveryAddress,
          comment: fullComment,
          total: total,
          items: items,
          status: 'pendiente'
        })
        .select()
        .single();

      if (error) throw error;

      let wpMessage = `*NUEVO PEDIDO - ${empresaName}*\n`;
      wpMessage += `Orden #${orderData.id.split('-')[0].toUpperCase()}\n\n`;
      wpMessage += `*Cliente:* ${customerName}\n`;
      wpMessage += `*Teléfono:* ${customerPhone}\n`;
      if (deliveryAddress) wpMessage += `*Dirección:* ${deliveryAddress}\n`;
      wpMessage += `\n*Detalle del pedido:*\n`;
      items.forEach(item => {
        wpMessage += `• ${item.quantity}x ${item.name} ($${item.price})\n`;
        if (item.notes) wpMessage += `  _Nota: ${item.notes}_\n`;
      });
      wpMessage += `\n*Medio de Pago:* ${paymentMethod.toUpperCase()}`;
      if (comment) wpMessage += `\n*Comentarios:* ${comment}`;
      wpMessage += `\n\n*TOTAL: $${total.toLocaleString('es-AR')}*`;

      const wpUrl = `https://wa.me/${empresaPhone.replace(/\D/g, '')}?text=${encodeURIComponent(wpMessage)}`;
      window.open(wpUrl, '_blank');

      // Save order to localStorage for the "Reorder" feature
      localStorage.setItem(`lastOrder_${empresaId}`, JSON.stringify(items));
      // Save order id for Tracking feature
      localStorage.setItem(`activeOrder_${empresaId}`, orderData.id);
      
      if (onOrderPlaced) onOrderPlaced(orderData.id);

      clearCart();
      setIsCartOpen(false);
    } catch (err) {
      console.error(err);
      alert('Hubo un error al procesar el pedido. Por favor intenta de nuevo.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <AnimatePresence>
      {isCartOpen && (
        <>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={() => setIsCartOpen(false)}
                className="fixed inset-0 bg-black/60 z-[100] backdrop-blur-sm"
          />

          <motion.div
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', damping: 25, stiffness: 200 }}
            className="fixed bottom-0 left-0 right-0 top-12 md:top-1/2 md:bottom-auto md:left-1/2 md:-translate-x-1/2 md:-translate-y-1/2 md:max-w-xl md:max-h-[88vh] bg-white text-stone-900 z-[101] rounded-t-3xl md:rounded-3xl shadow-2xl flex flex-col overflow-hidden border border-stone-200"
          >
            <div className="px-5 py-4 border-b border-stone-200 flex items-center justify-between bg-stone-50 shrink-0">
              <h2 className="text-lg font-black text-stone-900 flex items-center gap-2 font-display">
                <span className="w-2 h-2 rounded-full bg-[#A12C25]"></span>
                Mi Pedido
              </h2>
              <button 
                onClick={() => setIsCartOpen(false)}
                className="p-2 bg-white text-stone-500 border border-stone-200 rounded-xl hover:bg-[#A12C25] hover:text-white transition-colors"
              >
                <X size={18} />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto hide-scrollbar bg-white">
              {items.length === 0 ? (
                <div className="flex flex-col items-center justify-center h-full p-8 text-stone-400">
                  <span className="text-5xl mb-4 opacity-30">🛒</span>
                  <p className="text-base font-bold text-stone-800 font-display">Tu pedido está vacío</p>
                  <p className="text-sm mt-1 text-stone-500">Agregá tus embutidos favoritos</p>
                </div>
              ) : (
                <div className="p-4 space-y-4">
                  <div className="bg-stone-50 p-4 rounded-2xl border border-stone-200 space-y-3">
                    {items.map((item, idx) => (
                      <div key={idx} className="flex gap-3 items-start border-b border-stone-200/80 pb-3 last:border-0 last:pb-0">
                        <div className="flex-1 min-w-0">
                          <h4 className="font-bold text-stone-900 text-sm">{item.name}</h4>
                          {item.notes && <p className="text-[11px] text-[#A12C25] font-medium mt-0.5">"{item.notes}"</p>}
                          <div className="font-extrabold text-stone-800 mt-0.5 text-sm">${(item.price * item.quantity).toLocaleString('es-AR')}</div>
                        </div>
                        <div className="flex flex-col items-end gap-2 shrink-0">
                          <button onClick={() => removeFromCart(item.id, item.notes)} className="text-stone-400 hover:text-[#A12C25] transition-colors">
                            <Trash2 size={15} />
                          </button>
                          <div className="flex items-center bg-white border border-stone-200 rounded-lg overflow-hidden shadow-sm">
                            <button onClick={() => updateQuantity(item.id, item.quantity - 1, item.notes)} className="w-7 h-7 flex items-center justify-center text-stone-700 hover:bg-stone-100 transition-colors">
                              <Minus size={12} />
                            </button>
                            <span className="font-bold text-xs w-5 text-center text-stone-900">{item.quantity}</span>
                            <button onClick={() => updateQuantity(item.id, item.quantity + 1, item.notes)} className="w-7 h-7 flex items-center justify-center bg-[#A12C25] text-white hover:brightness-110 transition-all">
                              <Plus size={12} />
                            </button>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* Checkout Form */}
                  <form id="checkout-form" onSubmit={handleSubmit} className="bg-stone-50 p-4 rounded-2xl border border-stone-200 space-y-3">
                    <h3 className="font-bold text-stone-900 text-xs uppercase tracking-wider border-b border-stone-200 pb-2 font-display">Datos de entrega</h3>
                    
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                      <div>
                        <label className="block text-[10px] font-bold text-stone-500 mb-0.5 uppercase tracking-wider">Nombre</label>
                        <input required type="text" value={customerName} onChange={e => setCustomerName(e.target.value)} className="w-full bg-white border border-stone-200 text-stone-900 rounded-xl p-2.5 text-sm focus:border-[#A12C25] outline-none placeholder:text-stone-400 shadow-sm" placeholder="Juan Pérez" />
                      </div>
                      <div>
                        <label className="block text-[10px] font-bold text-stone-500 mb-0.5 uppercase tracking-wider">WhatsApp</label>
                        <input required type="tel" value={customerPhone} onChange={e => setCustomerPhone(e.target.value)} className="w-full bg-white border border-stone-200 text-stone-900 rounded-xl p-2.5 text-sm focus:border-[#A12C25] outline-none placeholder:text-stone-400 shadow-sm" placeholder="381 123 4567" />
                      </div>
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-stone-500 mb-0.5 uppercase tracking-wider flex items-center gap-1">
                        <MapPin size={12} className="text-[#A12C25]" /> Dirección
                      </label>
                      <input type="text" value={deliveryAddress} onChange={e => setDeliveryAddress(e.target.value)} className="w-full bg-white border border-stone-200 text-stone-900 rounded-xl p-2.5 text-sm focus:border-[#A12C25] outline-none placeholder:text-stone-400 shadow-sm" placeholder="Calle 123 (opcional si retira)" />
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-stone-500 mb-0.5 uppercase tracking-wider">Comentario</label>
                      <textarea value={comment} onChange={e => setComment(e.target.value)} className="w-full bg-white border border-stone-200 text-stone-900 rounded-xl p-2.5 text-sm focus:border-[#A12C25] outline-none resize-none h-14 placeholder:text-stone-400 shadow-sm" placeholder="Ej: Preferencia de horario" />
                    </div>

                    <div className="pt-3 border-t border-stone-200">
                      <label className="block text-[10px] font-bold text-stone-500 mb-2 uppercase tracking-wider">Método de pago</label>
                      <div className="grid grid-cols-2 gap-2">
                        <button 
                          type="button" 
                          onClick={() => setPaymentMethod('efectivo')}
                          className={`flex items-center justify-center gap-2 p-2.5 font-bold text-xs rounded-xl transition-all border shadow-sm ${paymentMethod === 'efectivo' ? 'bg-[#A12C25] border-[#A12C25] text-white' : 'bg-white border-stone-200 text-stone-600 hover:border-[#A12C25]'}`}
                        >
                          <Wallet size={14} /> Efectivo
                        </button>
                        <button 
                          type="button" 
                          onClick={() => setPaymentMethod('transferencia')}
                          className={`flex items-center justify-center gap-2 p-2.5 font-bold text-xs rounded-xl transition-all border shadow-sm ${paymentMethod === 'transferencia' ? 'bg-[#A12C25] border-[#A12C25] text-white' : 'bg-white border-stone-200 text-stone-600 hover:border-[#A12C25]'}`}
                        >
                          <CreditCard size={14} /> Transferencia
                        </button>
                      </div>

                      {paymentMethod === 'transferencia' && (
                        <motion.div 
                          initial={{ opacity: 0, height: 0 }} 
                          animate={{ opacity: 1, height: 'auto' }} 
                          className="mt-3 overflow-hidden border border-[#C9A962]/20 bg-[#231C17]"
                        >
                          <div className="p-2.5 bg-[#D4262F]/10 text-[#D4262F] text-[10px] font-bold text-center uppercase tracking-wider border-b border-[#C9A962]/10">
                            Datos para transferencia
                          </div>
                          <div className="p-3 flex flex-col gap-2">
                            <div className="flex justify-between items-center bg-[#1A1410] p-2.5 border border-slate-800">
                              <span className="text-[10px] text-slate-500">Titular</span>
                              <span className="text-xs font-bold text-white">MrCerdo Embutidos</span>
                            </div>
                            <div className="flex justify-between items-center bg-[#1A1410] p-2.5 border border-slate-800">
                              <span className="text-[10px] text-slate-500">Alias</span>
                              <div className="flex items-center gap-2">
                                <span className="text-xs font-bold text-[#C9A962]">mrcerdo.mp</span>
                                <button
                                  type="button"
                                  onClick={handleCopyAlias}
                                  className="p-1 bg-[#D4262F]/20 text-[#D4262F] hover:bg-[#D4262F]/40 transition-colors"
                                  title="Copiar"
                                >
                                  {copied ? <CheckCircle2 size={14} className="text-green-400" /> : <Copy size={14} />}
                                </button>
                              </div>
                            </div>
                          </div>
                          <p className="text-[10px] text-slate-500 text-center px-3 pb-3">
                            Al finalizar enviamos el detalle por WhatsApp
                          </p>
                        </motion.div>
                      )}
                    </div>
                  </form>
                </div>
              )}
            </div>

            {/* Footer Total & Button */}
            {items.length > 0 && (
              <div className="px-5 py-4 border-t border-stone-200 bg-stone-50 shrink-0">
                <div className="flex justify-between items-center mb-3">
                  <span className="text-stone-500 text-xs font-bold uppercase tracking-wider">Total del Pedido</span>
                  <span className="text-2xl font-black text-stone-900 font-display">${total.toLocaleString('es-AR')}</span>
                </div>
                <button 
                  type="submit"
                  form="checkout-form"
                  disabled={isSubmitting}
                  className="w-full bg-gradient-to-r from-[#A12C25] to-[#D9381E] hover:brightness-110 text-white py-3.5 rounded-2xl font-black text-sm uppercase tracking-wider transition-all active:scale-[0.98] disabled:opacity-70 disabled:active:scale-100 shadow-md shadow-[#A12C25]/25"
                >
                  {isSubmitting ? 'Procesando...' : 'Confirmar pedido por WhatsApp'}
                </button>
              </div>
            )}
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
