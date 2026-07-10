#!/usr/bin/env python3
"""
Script oficial de importación y generación de seed_suplementos.sql
A partir del catálogo PDF: infoBase/Suplement Facts.xlsx - Lisa Mayorista (1).pdf
"""
import fitz
import re
import os

def generate_seed():
    filename = r"c:\Users\EDC\Desktop\AndresPedidos\infoBase\Suplement Facts.xlsx - Lisa Mayorista (1).pdf"
    doc = fitz.open(filename)

    all_lines = []
    for page_num in range(len(doc)):
        page = doc[page_num]
        text = page.get_text()
        lines = [line.strip() for line in text.split('\n') if line.strip()]
        all_lines.extend([(page_num + 1, l) for l in lines])

    known_brands = [
        "STAR NUTRITION", "HOCH SPORT", "ENA SPORT", "GENERATION FIT",
        "NUTRILAB", "BODY ADVANCED", "VITAMIN WAY", "MERVICK",
        "XTRENGHT", "GOLD NUTRITION", "NATULIV"
    ]

    products = []
    current_brand = "STAR NUTRITION"

    i = 0
    while i < len(all_lines):
        pnum, line = all_lines[i]
        if line in ["PRODUCTO", "PRECIO", "PRODUCTO PRECIO", "PRECIO PRODUCTO"]:
            i += 1
            continue
        
        is_brand = False
        for b in known_brands:
            if line.upper() == b:
                current_brand = b
                is_brand = True
                break
        if is_brand:
            i += 1
            continue

        price_pattern = r'\$\s*([0-9\.\,]+)'
        match_same = re.search(price_pattern, line)
        if match_same:
            prod_name = line[:match_same.start()].strip()
            price_str = match_same.group(1)
            if prod_name:
                products.append({
                    "page": pnum,
                    "brand": current_brand,
                    "name": prod_name,
                    "price_raw": price_str
                })
            i += 1
            continue
        
        if i + 1 < len(all_lines):
            next_pnum, next_line = all_lines[i+1]
            match_next = re.fullmatch(r'\$\s*([0-9\.\,]+)', next_line)
            if match_next:
                products.append({
                    "page": pnum,
                    "brand": current_brand,
                    "name": line,
                    "price_raw": match_next.group(1)
                })
                i += 2
                continue
                
        i += 1

    print(f"Extracted {len(products)} products across {len(known_brands)} brands.")
    return products

if __name__ == '__main__':
    generate_seed()
