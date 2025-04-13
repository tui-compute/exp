#!/usr/bin/env python3
import argparse
import json
from jinja2 import Environment, FileSystemLoader

parser = argparse.ArgumentParser()
parser.add_argument('--config', required=True, help='Path to JSON config file')
parser.add_argument('--output', required=True, help='Path to output generated SV file')
args = parser.parse_args()

# Load config
with open(args.config) as f:
    config = json.load(f)

# Setup Jinja2 environment
env = Environment(loader=FileSystemLoader('templates'))
template = env.get_template('top_module.sv.j2')

# Render template with config
rendered = template.render(
    module_name=config['name'],
    pe_array=config.get('pe_array', [])
)

# Write to output
with open(args.output, 'w') as f:
    f.write(rendered)

print(f"[gen_top.py] Generated {args.output} using config {args.config}")

