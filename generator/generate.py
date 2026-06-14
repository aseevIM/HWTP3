#генератор по шаблону, вставил свои колоночки в columns

import csv
import random
import os
import sys

NUM_ROWS = 100

COLUMNS = ["product_id", "product_name", "category", "price", "in_stock"]

def generate_row():
    categories = ["Electronics", "Clothing", "Books", "Toys"]
    products = {
        "Electronics": ["Laptop", "Phone", "Tablet"],
        "Clothing": ["T-shirt", "Jeans", "Jacket"],
        "Books": ["Novel", "Textbook", "Dictionary"],
        "Toys": ["Lego", "Doll", "Car"]
    }
    
    category = random.choice(categories)
    product_name = random.choice(products[category])
    
    return {
        "product_id": random.randint(1, 10000),
        "product_name": product_name,
        "category": category,
        "price": round(random.uniform(10.0, 1000.0), 2),
        "in_stock": random.choice(["yes", "no"])
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)

print(f"Generated {NUM_ROWS} rows to {OUTPUT_FILE}")
