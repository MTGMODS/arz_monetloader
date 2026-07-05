import subprocess

CONFIGS = ['arizona', 'rodina']

if __name__ == "__main__":
    for config in CONFIGS:
        print(f"\n{'='*50}")
        print(f"[INFO] ⚡ STARTING BUILD FOR: {config}")
        print(f"{'='*50}\n")
        
        subprocess.run(["python", "build_launcher.py", config], check=True)