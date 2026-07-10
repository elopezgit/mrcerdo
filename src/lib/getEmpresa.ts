import { supabase } from './supabase';

export async function getEmpresaId(slug?: string): Promise<string | null> {
  const data = await getEmpresaData(slug);
  return data?.id || null;
}

export async function getEmpresaData(slug?: string): Promise<any | null> {
  // 1. Coincidencia exacta por slug (ej. 'titanfuel')
  if (slug) {
    const { data } = await supabase
      .from('empresas')
      .select('*')
      .eq('slug', slug)
      .maybeSingle();
    if (data) return data;
  }

  // 2. Si buscan 'titanfuel', buscar si en la base de datos está guardada bajo 'suplementosar'
  if (slug === 'titanfuel' || slug === 'suplementosar') {
    const { data: supleData } = await supabase
      .from('empresas')
      .select('*')
      .eq('slug', 'suplementosar')
      .maybeSingle();
    if (supleData) {
      // Sincronizar automáticamente el slug a 'titanfuel' para futuras consultas
      await supabase
        .from('empresas')
        .update({ slug: 'titanfuel', name: 'TITAN FUEL SUPLEMENTOS' })
        .eq('id', supleData.id);
      return { ...supleData, slug: 'titanfuel', name: 'TITAN FUEL SUPLEMENTOS' };
    }
  }

  // 3. Buscar específicamente la empresa de suplementos por nombre o rubro (TITAN / SUPLEMENTOS / LISA)
  const { data: nameMatch } = await supabase
    .from('empresas')
    .select('*')
    .or('name.ilike.%TITAN%,name.ilike.%SUPLE%,name.ilike.%LISA%')
    .limit(1)
    .maybeSingle();

  if (nameMatch) {
    if (slug === 'titanfuel' && nameMatch.slug !== 'titanfuel') {
      await supabase
        .from('empresas')
        .update({ slug: 'titanfuel', name: 'TITAN FUEL SUPLEMENTOS' })
        .eq('id', nameMatch.id);
      return { ...nameMatch, slug: 'titanfuel', name: 'TITAN FUEL SUPLEMENTOS' };
    }
    return nameMatch;
  }

  return null;
}
