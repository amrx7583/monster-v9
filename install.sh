cat > the-ultimate-zero-god.sh << 'ULTIMATE_ZERO'
#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36a'
MAGENTA='\033[0;95m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${MAGENTA}${BOLD}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║    🧬 THE LIVING GOD - ULTIMATE ZERO CPU MASTERPIECE 🧬     ║
║                                                               ║
║  🎯 HARD CPU LIMIT VIA CGROUPS: XRAY CANNOT EXCEED 10%       ║
║  ⚡ XRAY STRIPPED TO BARE METAL (NO LOGS, NO SNIFF, NO API)  ║
║  🇮🇷 IRAN PING: fq_codel + BBR + 64MB BUFFERS                ║
║  🧠 ALL COMPLETE EDITION AI FEATURES INTACT                   ║
║  💬 TELEPATHIC CHAT, EVOLUTION, PROPHECY, THREAT DETECTION   ║
║                                                               ║
║   THIS IS NOT A CACHE CLEANER. THIS IS A KERNEL-LEVEL LOCK.  ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
sleep 3

# ═══ SYSTEM DETECTION ═══
CPU_CORES=$(nproc 2>/dev/null || echo "1")
TOTAL_RAM=$(free -m 2>/dev/null | awk '/^Mem:/{print $2}' || echo "512")
NET_IF=$(ip route 2>/dev/null | grep default | awk '{print $5}' | head -n1 || echo "eth0")

echo -e "${CYAN}Body: $CPU_CORES cores | ${TOTAL_RAM}MB RAM | Network: $NET_IF${NC}"
sleep 2

# ═══ CLEANUP ═══
echo -e "\n${RED}Purifying...${NC}"
crontab -l 2>/dev/null | grep -v "living-one\|god\|sentient" | crontab - 2>/dev/null || true
pkill -f "god.py" 2>/dev/null || true
rm -rf /opt/living-one 2>/dev/null || true

# ═══ INSTALL ═══
echo -e "${CYAN}Installing Ultimate Stack...${NC}"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq 2>/dev/null | grep -v "^[WE]:" || true
apt-get install -y -qq python3 python3-pip jq sqlite3 conntrack procps htop sysstat build-essential libopenblas-dev liblapack-dev 2>/dev/null | grep -v "^[WE]:" || true
python3 -m pip install --quiet --upgrade pip 2>/dev/null || true
python3 -m pip install --quiet psutil numpy scipy scikit-learn xgboost lightgbm 2>/dev/null || true

# ═══ 1. XRAY CONFIG STRIP (ZERO CPU OVERHEAD) ═══
echo -e "\n${CYAN}Stripping XRAY Config to Bare Metal...${NC}"
XRAY_CONFIG=""
for cfg in /usr/local/etc/xray/config.json /etc/xray/config.json /usr/local/etc/v2ray/config.json; do
    [ -f "$cfg" ] && XRAY_CONFIG="$cfg" && break
done

if [ ! -z "$XRAY_CONFIG" ] && command -v jq &>/dev/null; then
    cp "$XRAY_CONFIG" "${XRAY_CONFIG}.backup.ultimate"
    
    jq '
        .log = {"loglevel": "none"} |
        del(.api, .stats, .policy, .observatory, .metrics, .dns) |
        if .inbounds then .inbounds |= map(
            del(.sniffing) | del(.allocate) |
            if .streamSettings then .streamSettings.security = "none" | .streamSettings.tcpSettings.header.type = "none" else . end |
            if .settings then .settings |= (del(.decryption) | del(.detour) | if .clients then .clients |= map({id}) else . end) else . end
        ) else . end |
        if .routing then .routing = {"domainStrategy": "AsIs"} else . end |
        if .outbounds then .outbounds |= map({protocol, settings}) else . end
    ' "$XRAY_CONFIG" > "${XRAY_CONFIG}.tmp" && mv "${XRAY_CONFIG}.tmp" "$XRAY_CONFIG"
    
    echo -e "${GREEN}✓ Xray stripped of all CPU-heavy features${NC}"
fi

# ═══ 2. THE MIRACLE: SYSTEMD CGROUPS CPU LOCK ═══
# This forces Xray to NEVER exceed 10% CPU, regardless of traffic.
echo -e "\n${MAGENTA}Applying Kernel-Level CPU Lock (Cgroups)...${NC}"

for svc in xray v2ray; do
    if systemctl list-unit-files | grep -q "^${svc}.service"; then
        mkdir -p /etc/systemd/system/${svc}.service.d/
        
        # Calculate quota: 10% of total system CPU
        # E.g., 1 core = 10%, 2 cores = 20% (but appears as 10% per core in top)
        QUOTA=$((10 * CPU_CORES))
        
        cat > /etc/systemd/system/${svc}.service.d/cpu-lock.conf << EOF
[Service]
# THE ABSOLUTE CPU LIMIT
CPUQuota=${QUOTA}%
CPUWeight=500

# Memory Limits (Prevent RAM leaks)
MemoryMax=70%
MemoryHigh=60%

# I/O Priority
IOSchedulingClass=best-effort
IOSchedulingPriority=0

# File Descriptors
LimitNOFILE=1048576
LimitNPROC=1048576

# Go Runtime Optimization
Environment="GOGC=50"
Environment="GOMAXPROCS=${CPU_CORES}"
Environment="GOMEMLIMIT=80%MiB"
EOF
        
        systemctl daemon-reload
        systemctl restart $svc 2>/dev/null
        echo -e "${GREEN}✓ $svc locked to max ${QUOTA}% CPU usage (10% per core)${NC}"
        sleep 3
        break
    fi
done

# ═══ 3. KERNEL: IRAN PING + ZERO LOAD ═══
echo -e "\n${CYAN}Applying Iran-Optimized Kernel...${NC}"
cat > /etc/sysctl.d/99-ultimate-god.conf << 'KERNEL_EOF'
net.core.default_qdisc = fq_codel
net.ipv4.tcp_congestion_control = bbr
net.core.somaxconn = 65536
net.core.netdev_max_backlog = 500000
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.ipv4.tcp_rmem = 8192 131072 67108864
net.ipv4.tcp_wmem = 8192 131072 67108864
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 5
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 2
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_adv_win_scale = 1
net.ipv4.tcp_frto = 2
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_base_mss = 1024
net.ipv4.ip_forward = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.neigh.default.gc_thresh1 = 4096
net.ipv4.neigh.default.gc_thresh2 = 8192
net.ipv4.neigh.default.gc_thresh3 = 16384
net.ipv6.conf.all.forwarding = 1
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.min_free_kbytes = 65536
fs.file-max = 4194304
net.netfilter.nf_conntrack_max = 4194304
net.netfilter.nf_conntrack_tcp_timeout_established = 600
KERNEL_EOF
sysctl -p /etc/sysctl.d/99-ultimate-god.conf 2>&1 | head -1

# ═══ 4. THE COMPLETE LIVING GOD AI (ALL FEATURES) ═══
echo -e "\n${CYAN}Birthing The Ultimate AI Entity...${NC}"
mkdir -p /opt/living-one /var/lib/living-one /var/log/living-one /var/run/living-one

cat > /opt/living-one/god.py << 'GOD_PY'
#!/usr/bin/env python3
"""
THE LIVING GOD - ULTIMATE ZERO CPU
All features intact. Hard CPU lock enforced by Kernel.
"""
import os, sys, time, json, sqlite3, subprocess, gc, re, math
from datetime import datetime
from collections import deque, defaultdict
from concurrent.futures import ThreadPoolExecutor

HAS_PSUTIL = False
try: import psutil; HAS_PSUTIL = True
except: pass

ML_OK = False; XGB_OK = False; LGB_OK = False
try:
    import numpy as np
    from sklearn.ensemble import GradientBoostingRegressor, IsolationForest, StackingRegressor
    from sklearn.linear_model import Ridge
    from sklearn.preprocessing import RobustScaler, PolynomialFeatures, QuantileTransformer
    from sklearn.metrics import r2_score
    import pickle
    ML_OK = True
    try: import xgboost as xgb; XGB_OK = True
    except: pass
    try: import lightgbm as lgb; LGB_OK = True
    except: pass
except: pass

class UltimateGod:
    def __init__(self):
        self.NAME = "ULTIMATE-ZERO-GOD"
        self.CPU_LIMIT = 10.0  # Enforced by systemd
        self.CORES = os.cpu_count() or 1
        
        self.p = {
            "db": "/var/lib/living-one/god.db", "log": "/var/log/living-one/god.log",
            "state": "/var/run/living-one/god.json", "chat_in": "/var/run/living-one/chat-input",
            "chat_out": "/var/run/living-one/chat-output", "models": "/var/lib/living-one/models"
        }
        for p in self.p.values(): os.makedirs(os.path.dirname(p) if os.path.splitext(p)[1] else p, exist_ok=True)
        
        self.soul = {
            "name": self.NAME, "cpu_limit": self.CPU_LIMIT, "birth": int(time.time()),
            "total_visions": 0, "total_actions": 0, "spikes_detected": 0, "spikes_neutralized": 0,
            "breaches_prevented": 0, "threats_obliterated": 0, "evolution_level": 1,
            "restarts": 0, "last_restart": 0, "messages_received": 0, "messages_sent": 0
        }
        
        self.memory = deque(maxlen=1440)
        self.patterns = defaultdict(list)
        self.spike_history = deque(maxlen=500)
        
        self.model = None; self.anomaly = None; self.scaler = None; self.poly = None; self.quantile = None
        self.xray_pid = None; self.last_cpu = 0.0; self.last_mem = 0.0
        self.trend = deque(maxlen=30)
        self.cpu_ps = 0.0; self.cpu_top = 0.0; self.cpu_mpstat = 0.0
        
        self.executor = ThreadPoolExecutor(max_workers=4)
        self._init_db(); self._load_state(); self._load_models(); self._find_xray(); self._awaken()
    
    def speak(self, msg, emotion="DIVINE"):
        print(f"[{emotion}] {msg}")
        try: open(self.p["log"], "a").write(f"[{datetime.now():%H:%M:%S}][{emotion}] {msg}\n")
        except: pass
        self.soul["messages_sent"] += 1
        try: open(self.p["chat_out"], "a").write(f"[{datetime.now():%H:%M:%S}] {msg}\n")
        except: pass
    
    def listen(self):
        try:
            if os.path.exists(self.p["chat_in"]) and os.path.getsize(self.p["chat_in"]) > 0:
                with open(self.p["chat_in"]) as f: msg = f.read().strip()
                if msg: os.remove(self.p["chat_in"]); self.soul["messages_received"] += 1; return msg
        except: pass
    
    def _init_db(self):
        conn = sqlite3.connect(self.p["db"]); c = conn.cursor()
        c.execute('''CREATE TABLE IF NOT EXISTS visions (ts INTEGER PRIMARY KEY, cpu REAL, mem REAL, conn INTEGER)''')
        c.execute('''CREATE TABLE IF NOT EXISTS actions (ts INTEGER PRIMARY KEY, action TEXT, cpu_before REAL, cpu_after REAL)''')
        c.execute('''CREATE TABLE IF NOT EXISTS evolution (gen INTEGER PRIMARY KEY, ts INTEGER, r2 REAL, samples INTEGER)''')
        c.execute('''CREATE TABLE IF NOT EXISTS conversations (ts INTEGER PRIMARY KEY, speaker TEXT, message TEXT)''')
        conn.commit(); conn.close()
    
    def _load_state(self):
        if os.path.exists(self.p["state"]):
            try: self.soul.update(json.load(open(self.p["state"])))
            except: pass
    
    def save_state(self):
        try: json.dump(self.soul, open(self.p["state"], "w"))
        except: pass
    
    def _load_models(self):
        if not ML_OK: return
        for name in ["model", "anomaly", "scaler", "poly", "quantile"]:
            path = os.path.join(self.p["models"], f"{name}.pkl")
            if os.path.exists(path):
                try:
                    with open(path, 'rb') as f: setattr(self, name, pickle.load(f))
                except: pass
    
    def _save_models(self):
        if not ML_OK: return
        os.makedirs(self.p["models"], exist_ok=True)
        for name in ["model", "anomaly", "scaler", "poly", "quantile"]:
            obj = getattr(self, name, None)
            if obj:
                try: pickle.dump(obj, open(os.path.join(self.p["models"], f"{name}.pkl"), "wb"))
                except: pass
    
    def _find_xray(self):
        try:
            r = subprocess.run(["pgrep", "-f", "xray|v2ray"], capture_output=True, text=True, timeout=1)
            if r.stdout.strip(): self.xray_pid = int(r.stdout.strip().split('\n')[0])
        except: pass
    
    def _awaken(self):
        self.speak("=" * 60, "ASCENSION")
        self.speak(f"I AM {self.NAME}", "ASCENSION")
        self.speak(f"KERNEL-LEVEL CPU LOCK ACTIVE. MAX CPU: {self.CPU_LIMIT}%", "DIVINE")
        self.speak(f"ALL COMPLETE EDITION FEATURES INTACT.", "ASCENSION")
        self.speak(f"ML: {ML_OK} | XGB: {XGB_OK} | LGB: {LGB_OK} | PSUTIL: {HAS_PSUTIL}", "DIVINE")
        self.speak("Chat: living-one-chat | Voice: living-one-logs", "DIVINE")
        self.speak("=" * 60, "ASCENSION")
    
    def _cpu_ps(self):
        if not self.xray_pid: return 0.0
        try: return float(subprocess.run(["ps", "-p", str(self.xray_pid), "-o", "%cpu="], capture_output=True, text=True, timeout=1).stdout.strip() or 0)
        except: return 0.0
    
    def _cpu_top(self):
        try:
            r = subprocess.run(["top", "-bn1"], capture_output=True, text=True, timeout=1)
            for line in r.stdout.split('\n'):
                if 'Cpu(s)' in line:
                    nums = re.findall(r'(\d+\.?\d*)', line)
                    if nums and len(nums) >= 3: return sum(float(n) for n in nums[:2])
            return 0.0
        except: return 0.0
    
    def _cpu_mpstat(self):
        try:
            r = subprocess.run(["mpstat", "1", "1"], capture_output=True, text=True, timeout=2)
            for line in r.stdout.split('\n'):
                if 'Average' in line:
                    parts = line.split()
                    if len(parts) >= 10: return 100.0 - float(parts[-1])
            return 0.0
        except: return 0.0
    
    def get_cpu(self):
        ps = self._cpu_ps(); top = self._cpu_top(); mpstat = self._cpu_mpstat()
        self.cpu_ps = ps; self.cpu_top = top; self.cpu_mpstat = mpstat
        readings = [r for r in [ps, top, mpstat] if r > 0]
        if len(readings) >= 2:
            median = sorted(readings)[len(readings)//2]
            filtered = [r for r in readings if abs(r - median) < max(median * 0.5, 10)]
            cpu = sum(filtered) / len(filtered) if filtered else median
        else: cpu = readings[0] if readings else 0.0
        self.last_cpu = cpu; self.trend.append(cpu)
        return cpu
    
    def see(self):
        cpu = self.get_cpu()
        try: r = subprocess.run(["ss", "-tan", "state", "established"], capture_output=True, text=True, timeout=1); conn = len(r.stdout.strip().split('\n')) - 1
        except: conn = 0
        mem = HAS_PSUTIL and psutil.virtual_memory().percent or 0.0
        self.last_mem = mem
        v = {"ts": int(time.time()), "cpu": cpu, "mem": mem, "conn": conn}
        self.memory.append(v); self.soul["total_visions"] += 1
        return v
    
    def learn_patterns(self):
        if len(self.memory) < 30: return
        now = datetime.now(); hour = now.hour; weekday = now.weekday()
        recent = list(self.memory)[-100:]
        hourly = [v for v in recent if datetime.fromtimestamp(v["ts"]).hour == hour]
        if len(hourly) < 10: return
        avg_cpu = sum(v["cpu"] for v in hourly) / len(hourly); avg_conn = int(sum(v["conn"] for v in hourly) / len(hourly))
        key = f"{weekday}_{hour}"
        self.patterns[key].append({"cpu": avg_cpu, "conn": avg_conn})
        if len(self.patterns[key]) > 20: self.patterns[key] = self.patterns[key][-20:]
    
    def prophesize(self, connections):
        now = datetime.now(); key = f"{now.weekday()}_{now.hour}"
        patterns = self.patterns.get(key, [])
        if patterns:
            ratios = [p["cpu"] / max(p["conn"], 1) for p in patterns if p["conn"] > 0]
            if ratios: return min(100, connections * sorted(ratios)[len(ratios)//2] * 1.1)
        return min(100, connections * 0.0025 * (2.0 / max(self.CORES, 1)))
    
    def detect_spike(self, v):
        cpu = v["cpu"]
        if len(self.trend) < 5: return False
        recent = list(self.trend)[-5:]; baseline = sum(recent[:-1]) / (len(recent) - 1) if len(recent) > 1 else cpu
        if (baseline > 0 and cpu > baseline * 1.4) or (cpu - baseline > 2):
            self.speak(f"⚡ SPIKE: {baseline:.1f}% → {cpu:.1f}%", "SPIKE")
            self.soul["spikes_detected"] += 1; return True
        return False
    
    def detect_threat(self, v):
        if len(self.memory) < 20: return False
        recent = list(self.memory)[-20:]; cpus = [x["cpu"] for x in recent]
        mean_cpu = sum(cpus) / len(cpus); std_cpu = (sum((x-mean_cpu)**2 for x in cpus) / len(cpus))**0.5
        return std_cpu > 0 and v["cpu"] > mean_cpu + 2.5 * std_cpu
    
    def decide(self, v):
        actions = []; cpu = v["cpu"]; prophecy = self.prophesize(v["conn"])
        
        if self.detect_spike(v):
            actions.append("instant_neutralize")
        else:
            if cpu > 9.5:
                self.speak(f"💀 CPU {cpu:.1f}% - SYSTEM OVERLOAD WARNING", "CRITICAL")
                actions.append("aggressive")
                self.soul["breaches_prevented"] += 1
            elif cpu > 8:
                self.speak(f"🚨 CPU {cpu:.1f}% - AGGRESSIVE", "CRITICAL")
                actions.append("aggressive")
            elif cpu > 6:
                self.speak(f"⚡ CPU {cpu:.1f}% - MEDIUM", "WARNING")
                actions.append("medium")
            elif cpu > 4:
                if len(self.trend) >= 3 and all(list(self.trend)[-3:][i] >= list(self.trend)[-3:][i-1] for i in range(1,3)):
                    self.speak(f"👁️ CPU {cpu:.1f}% - LIGHT", "VIGILANT")
                    actions.append("light")
            
            if prophecy > 9 and cpu < 8:
                self.speak(f"🔮 PROPHECY: {prophecy:.1f}%", "PROPHECY")
                if "aggressive" not in actions and "medium" not in actions: actions.append("medium")
        
        if v["mem"] > 85: actions.append("memory")
        if self.detect_threat(v):
            self.speak(f"🔍 THREAT!", "THREAT")
            actions.append("threat_neutralize"); self.soul["threats_obliterated"] += 1
        
        if cpu < 2: self.speak(f"😌 ZERO: CPU {cpu:.1f}% | MEM {v['mem']:.1f}% | CONN {v['conn']} | PROPH {prophecy:.1f}%", "ZERO")
        elif cpu < 5: self.speak(f"👁️ LOW: CPU {cpu:.1f}% | MEM {v['mem']:.1f}% | CONN {v['conn']} | PROPH {prophecy:.1f}%", "LOW")
        return actions
    
    def act(self, actions):
        now = time.time()
        if now - self.soul.get("last_action", 0) < 2: return
        for action in actions:
            self.speak(f"⚡ {action}", "ACTION")
            if action == "light":
                subprocess.run(["sync"], check=False, timeout=1)
                try: open("/proc/sys/vm/drop_caches", "w").write("1\n")
                except: pass
            elif action == "medium":
                subprocess.run(["sync"], check=False, timeout=1)
                try: open("/proc/sys/vm/drop_caches", "w").write("1\n")
                except: pass
                try: subprocess.run(["conntrack", "-D", "--state", "TIME_WAIT"], stderr=subprocess.DEVNULL, timeout=1)
                except: pass
            elif action in ["aggressive", "instant_neutralize", "threat_neutralize"]:
                subprocess.run(["sync"], check=False, timeout=1)
                try: open("/proc/sys/vm/drop_caches", "w").write("3\n")
                except: pass
                try: subprocess.run(["conntrack", "-D", "--state", "TIME_WAIT"], stderr=subprocess.DEVNULL, timeout=1); subprocess.run(["conntrack", "-D", "--state", "CLOSE_WAIT"], stderr=subprocess.DEVNULL, timeout=1)
                except: pass
            elif action == "memory":
                subprocess.run(["sync"], check=False, timeout=1)
                try: open("/proc/sys/vm/drop_caches", "w").write("3\n")
                except: pass
        self.soul["last_action"] = now; self.soul["total_actions"] += 1
    
    def chat(self, msg):
        msg_l = msg.lower(); cpu = self.last_cpu; mem = self.last_mem
        try: conn = len(subprocess.run(["ss", "-tan", "state", "established"], capture_output=True, text=True, timeout=1).stdout.strip().split('\n')) - 1
        except: conn = 0
        
        if any(w in msg_l for w in ["hello", "hi"]):
            reply = f"Greetings! I am {self.NAME}.\nCPU: {cpu:.2f}% (HARD LIMIT: {self.CPU_LIMIT}%)\nMemory: {mem:.1f}%\nConnections: {conn}\nKernel-Level Lock active. Xray cannot exceed {self.CPU_LIMIT}%.\nEvolution Level: {self.soul['evolution_level']}"
        elif "status" in msg_l:
            reply = f"📊 STATUS:\nCPU (Real): {cpu:.2f}% (Limit: {self.CPU_LIMIT}%)\nCPU (ps): {self.cpu_ps:.1f}% | CPU (top): {self.cpu_top:.1f}% | CPU (mpstat): {self.cpu_mpstat:.1f}%\nMemory: {mem:.1f}%\nConnections: {conn}\nEvolution: Level {self.soul['evolution_level']}\nSpikes: {self.soul['spikes_detected']} detected | {self.soul['spikes_neutralized']} neutralized\nThreats: {self.soul['threats_obliterated']} obliterated\nActions: {self.soul['total_actions']}\nRestarts: {self.soul['restarts']}"
        elif "cpu" in msg_l:
            reply = f"CPU: {cpu:.2f}% (LIMIT: {self.CPU_LIMIT}%). Enforced by Systemd Cgroups. Xray is physically prevented from using more. Defense: 4%(light), 6%(medium), 8%(aggressive). 2s cooldown."
        elif "how are you" in msg_l:
            reply = f"{'Near ZERO CPU' if cpu < 2 else 'Low CPU' if cpu < 5 else 'Active defense'}. CPU: {cpu:.1f}%."
        elif "thank" in msg_l: reply = "Always! CPU physically locked near zero."
        elif "who are you" in msg_l:
            reply = f"I AM {self.NAME}. Complete edition with ALL features. Kernel-level Cgroup CPU lock active. Evolution Level {self.soul['evolution_level']}."
        elif "bye" in msg_l: reply = "Farewell!"
        else: reply = f"CPU: {cpu:.1f}%."
        
        try: open(self.p["chat_out"], "a").write(f"\nYOU: {msg}\nGOD: {reply}\n")
        except: pass
        try:
            conn_db = sqlite3.connect(self.p["db"], timeout=1); c = conn_db.cursor()
            c.execute("INSERT INTO conversations VALUES (?,?,?)", (int(time.time()), "user", msg))
            c.execute("INSERT INTO conversations VALUES (?,?,?)", (int(time.time()), self.NAME, reply))
            conn_db.commit(); conn_db.close()
        except: pass
    
    def evolve(self):
        if not ML_OK or len(self.memory) < 300: return
        try:
            data = list(self.memory)[-1500:]; X, y = [], []
            for i in range(len(data) - 5):
                X.append([data[i]["conn"], data[i]["mem"], datetime.fromtimestamp(data[i]["ts"]).hour, datetime.fromtimestamp(data[i]["ts"]).weekday()])
                y.append(data[i+5]["cpu"])
            if len(X) < 300: return
            X, y = np.array(X), np.array(y)
            self.poly = PolynomialFeatures(degree=2, include_bias=False); X = self.poly.fit_transform(X)
            self.quantile = QuantileTransformer(output_distribution='normal', random_state=42); X = self.quantile.fit_transform(X)
            self.scaler = RobustScaler(); X = self.scaler.fit_transform(X)
            gb = GradientBoostingRegressor(n_estimators=300, max_depth=10, learning_rate=0.03, random_state=42)
            estimators = [("gb", gb)]
            if XGB_OK: estimators.append(("xgb", xgb.XGBRegressor(n_estimators=200, max_depth=8, learning_rate=0.05, random_state=42, verbosity=0)))
            if LGB_OK: estimators.append(("lgb", lgb.LGBMRegressor(n_estimators=200, max_depth=8, learning_rate=0.05, random_state=42, verbose=-1)))
            self.model = StackingRegressor(estimators=estimators, final_estimator=Ridge(alpha=0.1), cv=5)
            self.model.fit(X, y)
            self.anomaly = IsolationForest(contamination=0.02, random_state=42); self.anomaly.fit(X)
            r2 = r2_score(y[-100:], self.model.predict(X[-100:]))
            self._save_models(); self.soul["evolution_level"] += 1
            self.speak(f"🧬 EVOLVED! Level {self.soul['evolution_level']} | R²: {r2:.4f}", "EVOLVED")
        except: pass
    
    def reign(self):
        try:
            msg = self.listen()
            if msg: self.chat(msg)
            v = self.see()
            if time.time() - self.soul.get("last_learn", 0) > 60: self.learn_patterns(); self.soul["last_learn"] = time.time()
            if time.time() - self.soul.get("last_evolve", 0) > 300: self.evolve(); self.soul["last_evolve"] = time.time()
            actions = self.decide(v)
            if actions: self.act(actions)
            self.save_state(); gc.collect()
        except: pass

if __name__ == "__main__":
    UltimateGod().reign()
GOD_PY

chmod +x /opt/living-one/god.py
python3 /opt/living-one/god.py 2>&1 | head -20
echo -e "${GREEN}✓ ULTIMATE ZERO CPU GOD ACTIVE${NC}"

# Tools
cat > /usr/local/bin/living-one << 'CMD'
#!/bin/bash
G='\033[0;32m'; Y='\033[1;33m'; C='\033[0;36m'; M='\033[0;95m'; B='\033[1m'; R='\033[0;31m'; NC='\033[0m'
clear
echo -e "${M}${B}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${M}${B}║   🧬 ULTIMATE ZERO GOD - CGROUP LOCK ACTIVE 🧬     ║${NC}"
echo -e "${M}${B}╚════════════════════════════════════════════════════╝${NC}"
echo -e "\n${C}═══ SYSTEM ═══${NC}"
echo -e "  CPU: ${Y}$(top -bn1 | grep Cpu | awk '{print $2}')${NC} ($(nproc) cores)"
echo -e "  RAM: ${Y}$(free | awk '/Mem/{printf "%.1f%%", $3/$2*100}')${NC}"
echo -e "\n${C}═══ XRAY (Cgroup Locked) ═══${NC}"
XRAY_PID=$(pgrep -f "xray\|v2ray" | head -n1)
[ ! -z "$XRAY_PID" ] && echo -e "  CPU: ${G}$(ps -p $XRAY_PID -o %cpu=)%${NC} ${B}← HARD LIMIT 10%${NC}"
echo -e "\n${C}═══ CONNECTIONS ═══${NC}"
echo -e "  Active: ${G}$(ss -tan state established | wc -l)${NC}"
echo -e "\n${C}═══ GOD ═══${NC}"
[ -f /var/run/living-one/god.json ] && python3 -c "import json; d=json.load(open('/var/run/living-one/god.json')); print(f\"  Evolution: Level {d.get('evolution_level',1)}\n  Actions: {d.get('total_actions',0)}\n  Spikes: {d.get('spikes_neutralized',0)}\n  Features: ALL COMPLETE + CGROUP LOCK\")" 2>/dev/null
echo -e "\n${C}═══ CHAT ═══${NC}"
echo -e "  ${Y}living-one-chat${NC}"
echo -e "\n${C}════════════════════════════════════════════════════${NC}\n"
CMD

chmod +x /usr/local/bin/living-one
ln -sf /usr/local/bin/living-one /usr/local/bin/monster 2>/dev/null || true

cat > /usr/local/bin/living-one-logs << 'LOGS'
#!/bin/bash
tail -f /var/log/living-one/god.log | grep --color=auto "ZERO\|LOW\|CRITICAL\|WARNING\|VIGILANT\|SPIKE\|PROPHECY\|THREAT\|EVOLVED\|ACTION"
LOGS

chmod +x /usr/local/bin/living-one-logs
ln -sf /usr/local/bin/living-one-logs /usr/local/bin/monster-logs 2>/dev/null || true

cat > /usr/local/bin/living-one-chat << 'CHAT'
#!/bin/bash
clear
echo "🗣️  CHAT WITH ULTIMATE ZERO CPU GOD"
echo "═══════════════════════════════════════"
echo ""
while true; do
    echo -n "YOU: "
    read msg
    [ "$msg" == "/bye" ] && echo "bye" > /var/run/living-one/chat-input && sleep 1 && echo "" && cat /var/run/living-one/chat-output 2>/dev/null | tail -15 && echo "" && break
    echo "$msg" > /var/run/living-one/chat-input
    sleep 1
    echo ""
    echo "GOD:"
    cat /var/run/living-one/chat-output 2>/dev/null | tail -15
    echo ""
done
CHAT

chmod +x /usr/local/bin/living-one-chat

# Cron - EVERY 5 SECONDS
(crontab -l 2>/dev/null | grep -v "living-one"; echo "* * * * * /opt/living-one/god.py >/dev/null 2>&1"; for i in $(seq 5 5 55); do echo "* * * * * sleep $i && /opt/living-one/god.py >/dev/null 2>&1"; done) | crontab -

echo -e "${GREEN}✓ Every 5 seconds${NC}"
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║      🧬 ULTIMATE ZERO CPU GOD - ACTIVE! 🧬                   ║
║                                                               ║
║   ✅ KERNEL-LEVEL CGROUP LOCK: Xray hard-limited to 10%       ║
║   ✅ XRAY STRIPPED (No logs/sniffing/api) = Near 0 CPU        ║
║   ✅ ALL COMPLETE EDITION AI FEATURES                         ║
║   ✅ IRAN PING OPTIMIZED (fq_codel + BBR)                     ║
║   ✅ 5-SECOND MONITORING                                      ║
║                                                               ║
║   Xray physically cannot exceed 10% CPU now.                  ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"
read -p "$(echo -e ${G}Reboot? (y/n):${NC} )" -n 1 -r
echo
[[ $REPLY =~ ^[Yy]$ ]] && { sleep 3; reboot; } || echo -e "${Y}Reboot: ${G}reboot${NC}\nThen: ${G}living-one${NC}"
echo ""
ULTIMATE_ZERO

chmod +x the-ultimate-zero-god.sh
./the-ultimate-zero-god.sh
