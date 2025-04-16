#!/usr/bin/env python3
import argparse
import yaml
from jinja2 import Environment, FileSystemLoader

# Parse arguments
parser = argparse.ArgumentParser(description="Generate a top module from YAML config using Jinja2")
parser.add_argument('--config', required=True, help='YAML config file')
parser.add_argument('--template', default='templates/top_template.sv.j2', help='Path to Jinja2 template')
parser.add_argument('--output', required=True, help='Output SV file')
args = parser.parse_args()

# Load config
with open(args.config, 'r') as f:
    config = yaml.safe_load(f)

# Set up Jinja2 environment
env = Environment(
    loader=FileSystemLoader('templates'),
    trim_blocks=True,
    lstrip_blocks=True
)
template = env.get_template(args.template.split('/')[-1])

# Render template with config data
rendered_sv = template.render(config)

# Write to output file
with open(args.output, 'w') as out_file:
    out_file.write(rendered_sv)

print(f"Generated: {args.output} from {args.config}")
