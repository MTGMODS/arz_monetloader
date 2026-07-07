import subprocess

if __name__ == "__main__":
    for config in ['arizona', 'rodina']:
        print(f"\n{'='*50}")
        print(f"[INFO] ⚡ STARTING BUILD FOR: {config}")
        print(f"{'='*50}\n")
        
        subprocess.run(["python", "build_launcher.py", config], check=True)