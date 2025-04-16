#!/usr/bin/env python3
import yaml
import argparse
from jinja2 import Environment, FileSystemLoader

parser = argparse.ArgumentParser(description="Generate testbench from YAML config")
parser.add_argument('--config', required=True, help='Path to YAML config file')
parser.add_argument('--template', default='templates/tb_template.sv.j2', help='Path to Jinja2 template')
parser.add_argument('--output', required=True, help='Output testbench file')
args = parser.parse_args()

# Load YAML config
with open(args.config, 'r') as f:
    config = yaml.safe_load(f)

# Compute delay offsets for each expected output
latency = config.get("system_latency", 0)
input_data = config.get("input_data", [])
expected_output = config.get("expected_output", [])

# Pair expected values with the clock cycle they should appear on
timed_output = []
for i, value in enumerate(expected_output):
    cycle = i + latency
    timed_output.append({"cycle": cycle, "value": value})

config["timed_output"] = timed_output

# Set up Jinja environment
env = Environment(
    loader=FileSystemLoader('templates'),
    trim_blocks=True,
    lstrip_blocks=True
)
template = env.get_template(args.template.split('/')[-1])

# Render and write
with open(args.output, 'w') as f:
    f.write(template.render(config))

print(f"[gen_tb.py] Generated testbench at {args.output}")
