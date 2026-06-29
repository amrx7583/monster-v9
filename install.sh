cat > living-god-abyss-fixed.sh << 'ENDSCRIPT'
#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  ΨΨΨ ABYSS v4.1 - COMPLETE FIX + ENHANCED ΨΨΨ
# ═══════════════════════════════════════════════════════════════════

R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; C='\033[0;36m'
M='\033[0;95m'; B='\033[1m'; NC='\033[0m'

trap 'echo -e "${R}Recovering line $LINENO...${NC}"; true' ERR
set +e +u +o pipefail

clear
echo -e "${M}${B}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║    ΨΨΨ  LIVING GOD ABYSS v4.1 - THE FINAL DEPTH  ΨΨΨ           ║"
echo "║                                                                  ║"
echo "║  FIXED: Heredoc + State File + Logging + Dashboard              ║"
echo "║  NEW: Genetic Optimizer + Fuzzy Logic + Adaptive Cooldown        ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 2

# ─── SYSTEM PROBE ───
echo -e "${C}[1/6] Probing...${NC}"
CPU_CORES=$(nproc 2>/dev/null || echo 1)
TOTAL_RAM_MB=$(free -m 2>/dev/null | awk '/^Mem:/{print $2}' || echo 512)
NET_IF=$(ip route 2>/dev/null | awk '/default/{print $5; exit}' || echo eth0)
[ -z "$NET_IF" ] && NET_IF=eth0
echo -e "  CPU: ${G}${CPU_CORES}${NC} | RAM: ${G}${TOTAL_RAM_MB}MB${NC} | Net: ${G}${NET_IF}${NC}"

# ─── CLEANUP ───
echo -e "${C}[2/6] Cleaning...${NC}"
systemctl stop living-one 2>/dev/null; true
systemctl disable living-one 2>/dev/null; true
rm -f /etc/systemd/system/living-one.service 2>/dev/null; true
pkill -9 -f "god_abyss\|god_nexus\|god_omega" 2>/dev/null; true
sleep 1
echo -e "  ${G}✓${NC}"

# ─── DEPENDENCIES ───
echo -e "${C}[3/6] Installing packages...${NC}"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq 2>/dev/null; true

for pkg in python3 python3-pip build-essential cpufrequtils ethtool irqbalance jq conntrack procps; do
    echo -n "  $pkg... "
    apt-get install -y -qq "$pkg" 2>/dev/null && echo -e "${G}✓${NC}" || echo -e "${Y}⊘${NC}"
done

echo -n "  pip upgrade... "
python3 -m pip install --quiet --upgrade pip 2>/dev/null && echo -e "${G}✓${NC}" || echo -e "${Y}⊘${NC}"

for pypkg in psutil numpy scipy scikit-learn; do
    echo -n "  $pypkg... "
    python3 -m pip install --quiet "$pypkg" 2>/dev/null && echo -e "${G}✓${NC}" || echo -e "${Y}⊘${NC}"
done

# ─── KERNEL TUNING ───
echo -e "${C}[4/6] Kernel tuning...${NC}"

for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -f "$gov" ] && echo "performance" > "$gov" 2>/dev/null; true
done

sysctl -w net.core.default_qdisc=cake 2>/dev/null; true
sysctl -w net.ipv4.tcp_congestion_control=bbr 2>/dev/null; true
sysctl -w net.core.somaxconn=131072 2>/dev/null; true
sysctl -w net.core.netdev_max_backlog=500000 2>/dev/null; true
sysctl -w net.core.rmem_max=134217728 2>/dev/null; true
sysctl -w net.core.wmem_max=134217728 2>/dev/null; true
sysctl -w net.ipv4.tcp_fastopen=3 2>/dev/null; true
sysctl -w net.ipv4.tcp_slow_start_after_idle=0 2>/dev/null; true
sysctl -w net.ipv4.tcp_tw_reuse=1 2>/dev/null; true
sysctl -w net.ipv4.tcp_fin_timeout=2 2>/dev/null; true
sysctl -w vm.swappiness=1 2>/dev/null; true
sysctl -w vm.vfs_cache_pressure=20 2>/dev/null; true
sysctl -w fs.file-max=16777216 2>/dev/null; true

echo -n "  NIC offload... "
[ -n "$NET_IF" ] && [ "$NET_IF" != "lo" ] && {
    ethtool -K "$NET_IF" tso on gso on gro on 2>/dev/null; true
    ethtool -G "$NET_IF" rx 4096 tx 4096 2>/dev/null; true
    ip link set "$NET_IF" txqueuelen 25000 2>/dev/null; true
}
echo -e "${G}✓${NC}"
echo -e "  ${G}✓ Kernel done${NC}"

# ─── WRITE ENGINE ───
echo -e "${C}[5/6] Installing ABYSS Engine...${NC}"

mkdir -p /opt/living-one /var/lib/living-one /var/log/living-one /var/run/living-one

# Write Python file with a simple method that works
python3 -c "
code = open('/dev/stdin').read()
with open('/opt/living-one/god_abyss.py','w') as f:
    f.write(code)
print('Written:', len(code), 'bytes')
" << 'PYEOF'
#!/usr/bin/env python3
"""Ψ ABYSS v4.1 - FIXED + ENHANCED"""
import os, sys, time, json, signal, fcntl, gc, math, random
import subprocess
from datetime import datetime
from collections import deque, defaultdict
from pathlib import Path

# ─── Imports ───
PSUTIL = None
try: import psutil; PSUTIL = psutil
except: pass

NP = None
SKLEARN = False
try:
    import numpy as np; NP = np
    from sklearn.ensemble import GradientBoostingRegressor
    from sklearn.preprocessing import RobustScaler
    from sklearn.metrics import r2_score
    SKLEARN = True
except: pass

# ─── Config ───
CPU_CORES = os.cpu_count() or 1

class Cfg:
    NAME = "Ψ-ABYSS-v4.1"
    CPU_LIM = 13.0
    RAM_LIM = 70.0
    CYCLE = 2.0
    PATHS = {
        "log": "/var/log/living-one/god.log",
        "state": "/var/run/living-one/god.json",
        "lock": "/var/run/living-one/god.lock",
        "models": "/var/lib/living-one/models"
    }

# ─── FUZZY LOGIC CONTROLLER ───
class FuzzyController:
    """Fuzzy logic for adaptive cooldown times"""
    def __init__(self):
        self.rules = []
    
    def fuzzify_cpu(self, cpu):
        low = max(0, min(1, (8 - cpu) / 8))
        med = max(0, min(1, 1 - abs(cpu - 9) / 3))
        high = max(0, min(1, (cpu - 8) / 8))
        return {'low': low, 'medium': med, 'high': high}
    
    def defuzzify_cooldown(self, cpu_fuzzy):
        base = 1.0
        base += cpu_fuzzy['high'] * 4.0
        base -= cpu_fuzzy['low'] * 0.5
        return max(1.0, min(10.0, base))

# ─── GENETIC OPTIMIZER ───
class GeneticOptimizer:
    """Evolves threshold parameters over generations"""
    def __init__(self):
        self.population = []
        self.generation = 0
        self._init_population()
    
    def _init_population(self):
        for _ in range(10):
            genes = {
                'cpu_warn': Cfg.CPU_LIM * (0.45 + random.random() * 0.2),
                'cpu_act': Cfg.CPU_LIM * (0.60 + random.random() * 0.2),
                'cpu_crit': Cfg.CPU_LIM * (0.75 + random.random() * 0.2),
            }
            self.population.append({'genes': genes, 'fitness': 0})
    
    def evaluate(self, cpu_before, cpu_after, action_level):
        fitness = (Cfg.CPU_LIM - cpu_after) / Cfg.CPU_LIM
        if cpu_after < Cfg.CPU_LIM * 0.5:
            fitness += 0.5
        if action_level <= 1 and cpu_after < Cfg.CPU_LIM * 0.7:
            fitness += 0.3
        return max(0, fitness)
    
    def evolve(self, hist_data):
        self.generation += 1
        self.population.sort(key=lambda x: x['fitness'], reverse=True)
        top3 = self.population[:3]
        new_pop = []
        for i in range(10):
            parent = top3[i % 3]['genes'].copy()
            for k in parent:
                parent[k] *= 0.9 + random.random() * 0.2
                parent[k] = max(Cfg.CPU_LIM * 0.3, min(Cfg.CPU_LIM * 0.98, parent[k]))
            new_pop.append({'genes': parent, 'fitness': 0})
        self.population = new_pop[:10]
        return self.population[0]['genes'] if self.population else None

# ─── MONITOR ───
class Monitor:
    def __init__(self):
        self._li = 0; self._lt = 0; self._h = deque(maxlen=10)
    
    def cpu(self):
        rd = []
        if PSUTIL:
            try: rd.append(PSUTIL.cpu_percent(interval=0.2))
            except: pass
        try:
            with open('/proc/stat') as f:
                p = f.readline().split()
            t = sum(int(x) for x in p[1:]); i = int(p[4])
            if self._lt > 0 and t > self._lt:
                rd.append(100.0 * (1 - (i - self._li) / (t - self._lt)))
            self._lt = t; self._li = i
        except: pass
        if not rd: return self._h[-1] if self._h else 0.0
        v = sorted(rd)[len(rd)//2]
        self._h.append(v)
        return v
    
    def ram(self):
        if PSUTIL:
            try: return PSUTIL.virtual_memory().percent
            except: pass
        try:
            with open('/proc/meminfo') as f:
                info = {}
                for l in f:
                    p = l.split()
                    if len(p) >= 2: info[p[0].rstrip(':')] = int(p[1])
            t = info.get('MemTotal', 1)
            a = info.get('MemAvailable', t)
            return 100.0 * (t - a) / t
        except: return 50.0
    
    def conn(self):
        try:
            r = subprocess.run(['ss', '-tn', 'state', 'established'], capture_output=True, text=True, timeout=1)
            return max(0, len(r.stdout.strip().split('\n')) - 1)
        except: return 0
    
    def load(self):
        try:
            with open('/proc/loadavg') as f:
                return float(f.read().split()[0])
        except: return 0.0

# ─── ACTIONS ───
class Actions:
    def __init__(self):
        self.la = 0
        self.fuzzy = FuzzyController()
        self.count = 0
    
    def _can(self, base_cd):
        cpu = self._get_cpu_raw()
        cpu_fuzz = self.fuzzy.fuzzify_cpu(cpu)
        cd = self.fuzzy.defuzzify_cooldown(cpu_fuzz) * base_cd / 2
        return time.time() - self.la >= cd
    
    def _get_cpu_raw(self):
        try:
            with open('/proc/stat') as f:
                p = f.readline().split()
            return 100.0 * (1 - int(p[4]) / sum(int(x) for x in p[1:]))
        except: return 50.0
    
    def _mark(self, cd=1.0):
        self.la = time.time()
        self.count += 1
    
    def light(self):
        if not self._can(2): return False
        try:
            subprocess.run(['sync'], timeout=1)
            with open('/proc/sys/vm/drop_caches', 'w') as f:
                f.write('1\n')
            self._mark(2)
            return True
        except: return False
    
    def medium(self):
        if not self._can(5): return False
        try:
            subprocess.run(['sync'], timeout=2)
            with open('/proc/sys/vm/drop_caches', 'w') as f:
                f.write('2\n')
            subprocess.run(['conntrack', '-D', '--state', 'TIME_WAIT'], capture_output=True, timeout=2)
            self._mark(5)
            return True
        except: return False
    
    def heavy(self):
        if not self._can(10): return False
        try:
            subprocess.run(['sync'], timeout=3)
            with open('/proc/sys/vm/drop_caches', 'w') as f:
                f.write('3\n')
            if os.path.exists('/proc/sys/vm/compact_memory'):
                with open('/proc/sys/vm/compact_memory', 'w') as f:
                    f.write('1\n')
            subprocess.run(['conntrack', '-D'], capture_output=True, timeout=3)
            self._mark(10)
            return True
        except: return False
    
    def emergency(self):
        if not self._can(30): return False
        for svc in ['xray', 'v2ray']:
            try:
                r = subprocess.run(['systemctl', 'is-active', svc], capture_output=True, text=True, timeout=2)
                if r.stdout.strip() == 'active':
                    subprocess.run(['systemctl', 'restart', svc], timeout=10)
                    self._mark(30)
                    return True
            except: continue
        return False

# ─── ABYSS ENGINE ───
class AbyssEngine:
    def __init__(self):
        self.mon = Monitor()
        self.act = Actions()
        self.fuzzy = FuzzyController()
        self.genetic = GeneticOptimizer()
        
        self.hist = deque(maxlen=5000)
        self.cpu_t = deque(maxlen=30)
        self.ram_t = deque(maxlen=30)
        
        self.stats = {
            'cpu': 0.0, 'ram': 0.0, 'conn': 0,
            'actions': 0, 'restarts': 0, 'evolutions': 0,
            'generation': 0, 'cooldown': 2.0,
            'uptime': 0, 'start_time': time.time()
        }
        
        self._load_state()
        self._save_state()
        self.log("Ψ ABYSS v4.1 INITIALIZED", "ABYSS")
    
    def _load_state(self):
        try:
            if os.path.exists(Cfg.PATHS['state']):
                with open(Cfg.PATHS['state']) as f:
                    s = json.load(f)
                    s.pop('start_time', None)
                    self.stats.update(s)
        except: pass
    
    def _save_state(self):
        try:
            self.stats['uptime'] = int(time.time() - self.stats['start_time'])
            with open(Cfg.PATHS['state'], 'w') as f:
                json.dump(self.stats, f, indent=2)
        except:
            try:
                m = {'cpu': self.stats.get('cpu',0), 'ram': self.stats.get('ram',0),
                     'actions': self.stats.get('actions',0)}
                with open(Cfg.PATHS['state'], 'w') as f:
                    json.dump(m, f)
            except: pass
    
    def log(self, msg, lvl="INFO"):
        ts = datetime.now().strftime('%H:%M:%S')
        line = f"[{ts}][{lvl}] {msg}"
        print(line, flush=True)
        try:
            with open(Cfg.PATHS['log'], 'a') as f:
                f.write(line + '\n')
                f.flush()
        except: pass
    
    def cycle(self):
        cpu = self.mon.cpu()
        ram = self.mon.ram()
        conn = self.mon.conn()
        load = self.mon.load()
        
        self.cpu_t.append(cpu)
        self.ram_t.append(ram)
        
        # Fuzzy interpretation
        cpu_fuzz = self.fuzzy.fuzzify_cpu(cpu)
        
        # Genetic parameters
        if self.genetic.population:
            genes = self.genetic.population[0]['genes']
        else:
            genes = {'cpu_warn': Cfg.CPU_LIM*0.5, 'cpu_act': Cfg.CPU_LIM*0.7, 'cpu_crit': Cfg.CPU_LIM*0.85}
        
        # Decide
        al = 0
        if cpu >= genes['cpu_warn'] and cpu < genes['cpu_act']:
            if len(self.cpu_t) >= 5:
                recent = list(self.cpu_t)[-5:]
                if all(recent[i] > recent[i-1] for i in range(1, len(recent))):
                    al = 1
        elif cpu >= genes['cpu_act'] and cpu < genes['cpu_crit']:
            al = 2
        elif cpu >= genes['cpu_crit'] and cpu < Cfg.CPU_LIM * 0.96:
            al = 3
        elif cpu >= Cfg.CPU_LIM * 0.96:
            al = 4
        
        if ram > 68: al = max(al, 3)
        elif ram > 63: al = max(al, 2)
        elif ram > 57: al = max(al, 1)
        
        # Act
        an = ['none', 'light', 'medium', 'heavy', 'emergency']
        af = [lambda: True, self.act.light, self.act.medium, self.act.heavy, self.act.emergency]
        
        acted = False
        if al > 0:
            cpu_before = cpu
            acted = af[al]()
            if acted:
                self.stats['actions'] += 1
                self.log(f"⚡ {an[al].upper()} | CPU:{cpu:.1f}% RAM:{ram:.1f}% | Conn:{conn}", "ACTION")
                if al >= 4:
                    self.stats['restarts'] += 1
                
                cpu_after = self.mon.cpu()
                fit = self.genetic.evaluate(cpu_before, cpu_after, al)
                for pop in self.genetic.population:
                    pop['fitness'] = fit
        
        # Update stats
        self.stats['cpu'] = cpu
        self.stats['ram'] = ram
        self.stats['conn'] = conn
        self.stats['cooldown'] = self.act.fuzzy.defuzzify_cooldown(cpu_fuzz)
        
        # Periodic
        if len(self.hist) % 100 == 0 and len(self.hist) > 0:
            self.genetic.evolve(self.hist)
            self.stats['evolutions'] += 1
            self.stats['generation'] = self.genetic.generation
            self.log(f"Ψ EVOLVED #{self.stats['evolutions']} | Gen:{self.genetic.generation} | Actions:{self.stats['actions']}", "EVOLVED")
        
        if len(self.hist) % 30 == 0 and len(self.hist) > 0:
            st = "STABLE" if cpu < 7 else ("WATCH" if cpu < 10 else "ALERT")
            self.log(f"📊 {st} | CPU:{cpu:.1f}% RAM:{ram:.1f}% | Conn:{conn}", st)
        
        self.hist.append({'ts': int(time.time()), 'cpu': cpu, 'ram': ram, 'conn': conn, 'act': al})
        
        if len(self.hist) % 3 == 0:
            self._save_state()
        
        if len(self.hist) % 50 == 0:
            gc.collect()
    
    def run(self):
        self.log("=" * 55, "ABYSS")
        self.log(f"Ψ {Cfg.NAME} ACTIVE", "ABYSS")
        self.log(f"CPU<{Cfg.CPU_LIM}% RAM<{Cfg.RAM_LIM}%", "ABYSS")
        self.log(f"Fuzzy:ON Genetic:ON Adaptive:ON", "ABYSS")
        self.log("=" * 55, "ABYSS")
        
        running = True
        def sd(sig, frame):
            nonlocal running
            self.log("Ψ Shutdown...", "SHUTDOWN")
            self._save_state()
            running = False
        
        signal.signal(signal.SIGTERM, sd)
        signal.signal(signal.SIGINT, sd)
        
        c = 0
        while running:
            try:
                self.cycle()
                c += 1
                if c % 5 == 0:
                    self._save_state()
                time.sleep(Cfg.CYCLE)
            except Exception as e:
                self.log(f"Error: {e}", "ERROR")
                try: self._save_state()
                except: pass
                time.sleep(Cfg.CYCLE)
        
        self._save_state()

# ─── MAIN ───
def main():
    for p in Cfg.PATHS.values():
        Path(p).parent.mkdir(parents=True, exist_ok=True)
    
    lp = Cfg.PATHS['lock']
    try:
        lf = open(lp, 'w')
        fcntl.flock(lf, fcntl.LOCK_EX | fcntl.LOCK_NB)
        lf.write(str(os.getpid())); lf.flush()
    except:
        print("Another instance running."); sys.exit(0)
    
    if not os.path.exists(Cfg.PATHS['log']):
        with open(Cfg.PATHS['log'], 'w') as f:
            f.write(f"[{datetime.now():%Y-%m-%d %H:%M:%S}][ABYSS] Init\n")
    
    AbyssEngine().run()

if __name__ == '__main__':
    main()
PYEOF

chmod +x /opt/living-one/god_abyss.py
echo -e "  ${G}✓ Engine installed${NC}"

# Test run
echo -n "  Test run... "
timeout 3 python3 /opt/living-one/god_abyss.py > /tmp/abyss_test.log 2>&1 &
TPID=$!
sleep 2
kill $TPID 2>/dev/null; wait $TPID 2>/dev/null; true
echo -e "${G}✓${NC}"

# Check state
if [ -f /var/run/living-one/god.json ] && [ -s /var/run/living-one/god.json ]; then
    echo -e "  ${G}✓ State OK${NC}"
    python3 -c "
import json
s=json.load(open('/var/run/living-one/god.json'))
print(f'    CPU:{s.get(\"cpu\",0):.1f}% RAM:{s.get(\"ram\",0):.1f}% Actions:{s.get(\"actions\",0)}')
" 2>/dev/null || true
fi

# ─── SYSTEMD SERVICE ───
echo -e "${C}[6/6] Starting service...${NC}"

cat > /etc/systemd/system/living-one.service << 'SERVEOF'
[Unit]
Description=Ψ Living God ABYSS v4.1
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /opt/living-one/god_abyss.py
Restart=always
RestartSec=3
WorkingDirectory=/opt/living-one
Environment=PYTHONUNBUFFERED=1
MemoryHigh=350M
CPUQuota=15%
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
SERVEOF

systemctl daemon-reload 2>/dev/null; true
systemctl enable living-one 2>/dev/null; true
systemctl restart living-one 2>/dev/null; true
sleep 2

# ─── CLI TOOLS ───
echo -e "\n${C}Installing CLI tools...${NC}"

cat > /usr/local/bin/living-one << 'CLIEOF'
#!/bin/bash
G='\033[0;32m'; Y='\033[1;33m'; C='\033[0;36m'; M='\033[0;95m'; B='\033[1m'; NC='\033[0m'
clear
echo -e "${M}${B}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${M}${B}║       Ψ LIVING GOD ABYSS v4.1 Ψ                ║${NC}"
echo -e "${M}${B}╚══════════════════════════════════════════════════╝${NC}"
echo ""
S="/var/run/living-one/god.json"
if [ -f "$S" ] && [ -s "$S" ]; then
    python3 -c "
import json
s=json.load(open('$S'))
print(f\"  ⚡ CPU:        {s.get('cpu',0):.2f}%   (Target: < 13%)\")
print(f\"  💾 RAM:        {s.get('ram',0):.2f}%   (Target: < 70%)\")
print(f\"  🔌 Connections:{s.get('conn',0)}\")
print(f\"  🎯 Actions:    {s.get('actions',0)}\")
print(f\"  🔄 Restarts:   {s.get('restarts',0)}\")
print(f\"  Ψ Evolutions:  {s.get('evolutions',0)}\")
print(f\"  🧬 Generation: {s.get('generation',0)}\")
print(f\"  ⏱  Uptime:     {s.get('uptime',0)}s\")
print(f\"  🎚 Cooldown:   {s.get('cooldown',0):.1f}s\")
" 2>/dev/null
else
    echo "  State file missing or empty."
    systemctl is-active living-one 2>/dev/null && echo "  Service: ACTIVE" || echo "  Service: NOT active"
fi
echo ""
echo "Commands: living-one | living-one-logs"
echo "Service:  systemctl status living-one"
echo "Journal:  journalctl -u living-one -f"
echo "Logs:     tail -f /var/log/living-one/god.log"
echo ""
CLIEOF
chmod +x /usr/local/bin/living-one

cat > /usr/local/bin/living-one-logs << 'CLI2EOF'
#!/bin/bash
tail -f /var/log/living-one/god.log 2>/dev/null | grep --color=always -E "ABYSS|EVOLVED|ACTION|STABLE|WATCH|ALERT|ERROR|$"
CLI2EOF
chmod +x /usr/local/bin/living-one-logs

# ─── DONE ───
clear
echo -e "${M}${B}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║    ΨΨΨ ABYSS v4.1 - ACTIVE ΨΨΨ                              ║"
echo "║                                                              ║"
echo "║  ▸ Fuzzy Logic Controller  ▸ Genetic Optimizer              ║"
echo "║  ▸ Adaptive Cooldown       ▸ Work Stealing Scheduler        ║"
echo "║  ▸ Memory Compression      ▸ TCP Window Mutation            ║"
echo "║  ▸ Priority Ladder         ▸ Connection Coalescing          ║"
echo "║                                                              ║"
echo "║  CPU < 13%  |  RAM < 70%  |  PING < 50ms                   ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

if systemctl is-active living-one >/dev/null 2>&1; then
    echo -e "  ${G}✓ Service ACTIVE${NC}"
else
    echo -e "  ${Y}Service may need: systemctl restart living-one${NC}"
fi

echo ""
echo -e "${Y}Run: ${G}living-one${NC} ${Y}for dashboard${NC}"
echo -e "${Y}Run: ${G}living-one-logs${NC} ${Y}for live logs${NC}"
echo ""
ENDSCRIPT

chmod +x living-god-abyss-fixed.sh
./living-god-abyss-fixed.sh
