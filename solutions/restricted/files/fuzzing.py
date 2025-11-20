import requests
import sys
import json
import os

url = "http://restricted.rogue-sentinels.io:64375/calculate"
checkpoint_file = "fuzzing_checkpoint.json"

# Load checkpoint if exists
start_x, start_y, start_z = 0, 0, 0
if os.path.exists(checkpoint_file):
    with open(checkpoint_file, 'r') as f:
        checkpoint = json.load(f)
        start_x, start_y, start_z = checkpoint['x'], checkpoint['y'], checkpoint['z']
        print(f"[*] Resuming from checkpoint: x={start_x}, y={start_y}, z={start_z}")

print("[*] Starting exhaustive fuzzing")
tested = 0

try:
    for x in range(start_x, 1000000):
        for y in range(start_y if x == start_x else 0, 1000000):
            for z in range(start_z if x == start_x and y == start_y else 0, 1000000):
                tested += 1
                
                if tested % 10000 == 0:
                    print(f"[*] Tested: {tested:,} - Current: x={x}, y={y}, z={z}")
                    # Save checkpoint
                    with open(checkpoint_file, 'w') as f:
                        json.dump({'x': x, 'y': y, 'z': z}, f)
                
                try:
                    response = requests.post(url, data={"x": x, "y": y, "z": z}, timeout=5)
                    
                    if response.status_code != 200:
                        print()
                        print("=" * 70)
                        print(f"[!!!] FOUND! x={x}, y={y}, z={z}")
                        print(f"[!!!] Status: {response.status_code}")
                        print(f"[!!!] Response: {response.text}")
                        print("=" * 70)
                        sys.exit(0)
                        
                except Exception as e:
                    continue

except KeyboardInterrupt:
    print(f"\n[*] Interrupted at x={x}, y={y}, z={z}")
    sys.exit(1)