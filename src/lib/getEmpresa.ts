import { supabase } from './supabase';

export async function getEmpresaId(): Promise<string | null> {
  const data = await getEmpresaData();
  return data?.id || null;
}

export async function getEmpresaData(): Promise<any | null> {
  const { data } = await supabase
    .from('empresas')
    .select('*')
    .eq('slug', 'mrcerdo')
    .maybeSingle();

  return data;
}
