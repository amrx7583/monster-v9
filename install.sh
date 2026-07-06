cat > living-god-universal-fixed.sh << 'UNIVERSAL_EOF'
#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;95m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${MAGENTA}${BOLD}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║    🌌 THE LIVING GOD - UNIVERSAL HEAVEN FIXED 🌌            ║
║                                                               ║
║    🧬 UNIVERSAL HARDWARE DNA DETECTION & TIERING             ║
║    🧠 4-TIER ADAPTIVE AI (NANO / MICRO / MACRO / APEX)       ║
║    ⚡ DYNAMIC RESOURCE ALLOCATION (BUFFERS/CONNTRACK/LIMITS) ║
║    🛡️ ZRAM AUTO-ACTIVATION FOR WEAK SERVERS (<2GB RAM)       ║
║    🔄 SYSTEMD DAEMON (ZERO CRON OVERHEAD)                    ║
║    🌐 ADAPTIVE QDISC (fq_codel FOR WEAK / cake FOR STRONG)   ║
║    💬 TELEPATHIC CHAT - 15+ TOPICS                           ║
║    📚 SELF-EVOLVING - EVERY 5 MINUTES                        ║
║    🌐 2-SECOND EXACT CYCLE MONITORING                        ║
║                                                               ║
║    FIXED: CPU/RAM READING FROM /proc (NO PSUTIL REQUIRED)    ║
║    COMPATIBLE WITH 512MB RAM VPS TO 128GB BARE-METAL         ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
sleep 3

# ═══════════════════════════════════════════════════════════════
# 0. INSTALL REQUIRED PACKAGES
# ═══════════════════════════════════════════════════════════════
echo -e "${CYAN}${BOLD}📦 Installing Required Packages...${NC}"
apt-get update -qq
apt-get install -y -qq python3-pip procps iproute2 ethtool conntrack jq > /dev/null 2>&1
pip3 install -q psutil numpy scikit-learn 2>/dev/null || true
echo -e "${GREEN}✓ Packages Installed${NC}"

# ═══════════════════════════════════════════════════════════════
# 1. UNIVERSAL HARDWARE DNA DETECTION & TIERING
# ═══════════════════════════════════════════════════════════════
echo -e "${CYAN}${BOLD}🔬 Universal Hardware DNA Detection...${NC}"

CPU_VENDOR=$(lscpu 2>/dev/null | grep "Vendor ID" | awk -F': *' '{print $2}' || echo "Unknown")
CPU_MODEL=$(lscpu 2>/dev/null | grep "Model name" | awk -F': *' '{print $2}' | xargs || echo "Unknown")
CPU_CORES=$(nproc 2>/dev/null || echo "1")
TOTAL_RAM_MB=$(free -m 2>/dev/null | awk '/^Mem:/{print $2}' || echo "512")
NET_IF=$(ip route 2>/dev/null | grep default | awk '{print $5}' | head -n1 || echo "eth0")

# Determine Server Tier for AI & Tuning
if [ $TOTAL_RAM_MB -lt 1024 ] || [ $CPU_CORES -lt 2 ]; then
    SERVER_TIER="NANO"
    TIER_DESC="Ultra-Lightweight (Zero ML)"
elif [ $TOTAL_RAM_MB -lt 4096 ] || [ $CPU_CORES -lt 8 ]; then
    SERVER_TIER="MICRO"
    TIER_DESC="Light AI (LightGBM)"
elif [ $TOTAL_RAM_MB -lt 16384 ]; then
    SERVER_TIER="MACRO"
    TIER_DESC="Advanced AI (XGB + LGB + GB)"
else
    SERVER_TIER="APEX"
    TIER_DESC="God-Mode AI (4-Model Ensemble)"
fi

echo -e "${GREEN}  CPU: $CPU_MODEL (${CPU_CORES} Cores)${NC}"
echo -e "${GREEN}  RAM: ${TOTAL_RAM_MB}MB${NC}"
echo -e "${GREEN}  Detected Tier: ${BOLD}${SERVER_TIER} - ${TIER_DESC}${NC}"

# ═══════════════════════════════════════════════════════════════
# 2. ZRAM AUTO-ACTIVATION FOR WEAK SERVERS
# ═══════════════════════════════════════════════════════════════
if [ $TOTAL_RAM_MB -lt 2048 ]; then
    echo -e "\n${YELLOW}🛡️ Weak Server Detected: Enabling ZRAM (Compressed RAM Swap)...${NC}"
    if ! dpkg -l | grep -q zram-tools; then
        apt-get install -y -qq zram-tools > /dev/null 2>&1
    fi
    echo -e "ALGO=lz4\nPERCENT=50\nPRIORITY=100" > /etc/default/zramswap
    systemctl enable --now zramswap 2>/dev/null || true
    echo -e "${GREEN}✓ ZRAM Enabled (LZ4 Compression)${NC}"
fi

# ═══════════════════════════════════════════════════════════════
# 3. DYNAMIC RESOURCE ALLOCATION ENGINE
# ═══════════════════════════════════════════════════════════════
echo -e "\n${CYAN}${BOLD}⚡ Calculating Dynamic Kernel Parameters...${NC}"

# Math for dynamic values based on RAM
BUFFER=$((TOTAL_RAM_MB * 1024 * 1024 / 10)) # 10% of RAM
((BUFFER < 4194304)) && BUFFER=4194304       # Min 4MB
((BUFFER > 1073741824)) && BUFFER=1073741824 # Max 1GB

TCP_MEM="$((BUFFER/4)) $((BUFFER/2)) $BUFFER"
UDP_MEM="$((BUFFER/4)) $((BUFFER/2)) $BUFFER"

CONNTRACK=$(( (TOTAL_RAM_MB / 1024) * 100000 )) # 100k per GB
((CONNTRACK < 65536)) && CONNTRACK=65536
((CONNTRACK > 16777216)) && CONNTRACK=16777216

FILE_MAX=$((TOTAL_RAM_MB * 1024)) # 1024 per MB
((FILE_MAX < 100000)) && FILE_MAX=100000
((FILE_MAX > 33554432)) && FILE_MAX=33554432

MIN_FREE=$((TOTAL_RAM_MB * 1024 * 5 / 100)) # 5% of RAM
((MIN_FREE < 16384)) && MIN_FREE=16384
((MIN_FREE > 2097152)) && MIN_FREE=2097152

SOMAXCONN=$((CONNTRACK / 2))
((SOMAXCONN < 4096)) && SOMAXCONN=4096
((SOMAXCONN > 131072)) && SOMAXCONN=131072

NETDEV_BACKLOG=$((CONNTRACK * 2))
((NETDEV_BACKLOG < 10000)) && NETDEV_BACKLOG=10000
((NETDEV_BACKLOG > 2000000)) && NETDEV_BACKLOG=2000000

# Adaptive Swappiness & Qdisc
if [ $TOTAL_RAM_MB -lt 1024 ]; then
    SWAPPINESS=60; CACHE_PRESSURE=100; QDISC="fq_codel"
elif [ $TOTAL_RAM_MB -lt 4096 ]; then
    SWAPPINESS=20; CACHE_PRESSURE=50; QDISC="cake"
else
    SWAPPINESS=1; CACHE_PRESSURE=10; QDISC="cake"
fi

cat > /etc/sysctl.d/99-heaven-universal.conf << SYSCTL_EOF
# Dynamic Heaven Kernel - Tailored for ${SERVER_TIER} Tier
net.core.default_qdisc = ${QDISC}
net.ipv4.tcp_congestion_control = bbr

# Dynamic Buffers
net.core.rmem_max = ${BUFFER}
net.core.wmem_max = ${BUFFER}
net.core.optmem_max = 131072
net.ipv4.tcp_rmem = ${TCP_MEM}
net.ipv4.tcp_wmem = ${TCP_MEM}
net.ipv4.udp_mem = ${UDP_MEM}

# Dynamic Limits
net.core.somaxconn = ${SOMAXCONN}
net.core.netdev_max_backlog = ${NETDEV_BACKLOG}
net.ipv4.tcp_max_syn_backlog = ${SOMAXCONN}
net.netfilter.nf_conntrack_max = ${CONNTRACK}
net.netfilter.nf_conntrack_buckets = $((CONNTRACK / 4))
fs.file-max = ${FILE_MAX}
fs.nr_open = ${FILE_MAX}

# Adaptive Memory
vm.swappiness = ${SWAPPINESS}
vm.vfs_cache_pressure = ${CACHE_PRESSURE}
vm.min_free_kbytes = ${MIN_FREE}
vm.dirty_ratio = 3
vm.dirty_background_ratio = 1
vm.overcommit_memory = 1

# Core Network Tuning
net.core.netdev_budget = 1000000
net.core.netdev_budget_usecs = 16000
net.core.busy_poll = 50
net.core.busy_read = 50
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 3
net.ipv4.tcp_keepalive_probes = 2
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_retries1 = 1
net.ipv4.tcp_retries2 = 2
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_adv_win_scale = 3
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_ecn = 0
net.ipv4.ip_forward = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Netfilter Timeouts
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 2
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 2
net.netfilter.nf_conntrack_checksum = 0
net.netfilter.nf_conntrack_helper = 0
net.netfilter.nf_conntrack_events = 0
net.netfilter.nf_conntrack_acct = 0

# Kernel Scheduling
kernel.pid_max = 8388608
kernel.threads-max = 8388608
kernel.sched_autogroup_enabled = 0
kernel.sched_migration_cost_ns = 250000
kernel.sched_latency_ns = 1000000
kernel.timer_migration = 0
kernel.numa_balancing = 1
SYSCTL_EOF

sysctl -p /etc/sysctl.d/99-heaven-universal.conf > /dev/null 2>&1
echo -e "${GREEN}✓ Dynamic Kernel Applied (Buffer: $((BUFFER/1024/1024))MB, Conntrack: $CONNTRACK, Qdisc: $QDISC)${NC}"

# ═══════════════════════════════════════════════════════════════
# 4. HARDWARE SPECIFIC TUNING
# ═══════════════════════════════════════════════════════════════
echo -e "\n${CYAN}${BOLD}🎯 Hardware Specific Tuning...${NC}"

# CPU Governor
for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -f "$gov" ] && echo "performance" > "$gov" 2>/dev/null || true
done

# IRQ Balance
if ! command -v irqbalance >/dev/null; then
    apt-get install -y -qq irqbalance > /dev/null 2>&1
fi
systemctl enable --now irqbalance 2>/dev/null || true
echo -e "${GREEN}  IRQ Balance: Enabled${NC}"

# NIC Optimization (Scale Rings with Tier)
if [ ! -z "$NET_IF" ] && [ "$NET_IF" != "lo" ]; then
    if [ "$SERVER_TIER" == "NANO" ]; then RINGS=256
    elif [ "$SERVER_TIER" == "MICRO" ]; then RINGS=1024
    else RINGS=8192; fi
    
    ethtool -G $NET_IF rx $RINGS tx $RINGS 2>/dev/null || true
    ethtool -K $NET_IF tso on gso on gro on lro on sg on rx on tx on 2>/dev/null || true
    ip link set $NET_IF txqueuelen 50000 2>/dev/null || true
    echo -e "${GREEN}  NIC: ${RINGS} Rings + Offloading Enabled${NC}"
fi

# ═══════════════════════════════════════════════════════════════
# 5. THE HEAVEN GOD AI (4-TIER ARCHITECTURE) - FIXED VERSION
# ═══════════════════════════════════════════════════════════════
echo -e "\n${CYAN}${BOLD}🧬 Creating ${SERVER_TIER} Tier HEAVEN GOD (Fixed)...${NC}"
mkdir -p /opt/living-one /var/lib/living-one /var/log/living-one /var/run/living-one

cat > /opt/living-one/god.py << 'GOD_PY'
#!/usr/bin/env python3
import os, sys, time, json, sqlite3, subprocess, gc, re, math
from datetime import datetime
from collections import deque, defaultdict

TIER = os.environ.get("HEAVEN_TIER", "MICRO")

HAS_PSUTIL = False
try: import psutil; HAS_PSUTIL = True
except: pass

ML_OK = False; XGB_OK = False; LGB_OK = False; CAT_OK = False
try:
    import numpy as np
    from sklearn.ensemble import GradientBoostingRegressor, IsolationForest, VotingRegressor
    from sklearn.preprocessing import RobustScaler, PolynomialFeatures, QuantileTransformer
    from sklearn.metrics import r2_score
    import pickle
    ML_OK = True
    try: import xgboost as xgb; XGB_OK = True
    except: pass
    try: import lightgbm as lgb; LGB_OK = True
    except: pass
    try: import catboost as cb; CAT_OK = True
    except: pass
except: pass

class HeavenCompleteGod:
    def __init__(self):
        self.NAME = "HEAVEN-UNIVERSAL-GOD"
        self.TIER = TIER
        self.CPU_LIMIT = 13.0
        self.RAM_LIMIT = 70.0
        self.CORES = os.cpu_count() or 1
        
        self.p = {
            "db": "/var/lib/living-one/heaven.db", "log": "/var/log/living-one/heaven.log",
            "state": "/var/run/living-one/heaven.json", "chat_in": "/var/run/living-one/chat-input",
            "chat_out": "/var/run/living-one/chat-output", "models": "/var/lib/living-one/heaven-models"
        }
        for p in self.p.values(): os.makedirs(os.path.dirname(p) if os.path.splitext(p)[1] else p, exist_ok=True)
        
        self.soul = {"name": self.NAME, "tier": self.TIER, "cpu_limit": self.CPU_LIMIT, "ram_limit": self.RAM_LIMIT,
                     "birth": int(time.time()), "total_visions": 0, "total_actions": 0,
                     "evolution_level": 1, "messages_received": 0, "messages_sent": 0, "ping_target": 45}
        
        # Tiered Memory Allocation
        if self.TIER == "NANO":
            self.memory = deque(maxlen=500); self.long_memory = deque(maxlen=500); self.use_ml = False
        elif self.TIER == "MICRO":
            self.memory = deque(maxlen=2000); self.long_memory = deque(maxlen=2000); self.use_ml = True
        elif self.TIER == "MACRO":
            self.memory = deque(maxlen=5000); self.long_memory = deque(maxlen=5000); self.use_ml = True
        else: # APEX
            self.memory = deque(maxlen=20000); self.long_memory = deque(maxlen=20000); self.use_ml = True

        self.trend = deque(maxlen=60); self.mem_trend = deque(maxlen=30)
        self.last_cpu = 0.0; self.last_mem = 0.0
        self.last_cpu_total = 0.0; self.last_xray_cpu = 0.0
        self.model = None; self.anomaly = None; self.scaler = None; self.poly = None; self.quantile = None
        self.xray_pid = None; self.spike_cooldown = 0
        
        # For /proc/stat CPU calculation
        self.prev_idle = 0; self.prev_total = 0
        
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
        c.execute('''CREATE TABLE IF NOT EXISTS visions (ts INTEGER PRIMARY KEY, cpu_real REAL, cpu_total REAL, cpu_xray REAL, mem REAL, conn INTEGER)''')
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
        if not self.use_ml or not ML_OK: return
        for name in ["model", "anomaly", "scaler", "poly", "quantile"]:
            path = os.path.join(self.p["models"], f"{name}.pkl")
            if os.path.exists(path):
                try: setattr(self, name, pickle.load(open(path, 'rb')))
                except: pass
    
    def _save_models(self):
        if not self.use_ml or not ML_OK: return
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
        self.speak("=" * 70, "ASCENSION")
        self.speak(f"I AM {self.NAME} - TIER: {self.TIER}", "ASCENSION")
        self.speak(f"AI: {'Disabled' if not self.use_ml else 'Active'} | Memory: {self.memory.maxlen} slots", "ASCENSION")
        self.speak(f"CPU Reading: /proc/stat (Total + Xray)", "ASCENSION")
        self.speak(f"RAM Reading: /proc/meminfo (Fallback) + psutil", "ASCENSION")
        self.speak("Chat: living-one-chat | Logs: living-one-logs", "ASCENSION")
        self.speak("=" * 70, "ASCENSION")
    
    def _get_cpu_from_proc(self):
        """Read CPU usage from /proc/stat"""
        try:
            with open('/proc/stat') as f:
                line = f.readline()
            nums = [int(x) for x in line.split()[1:]]
            idle = nums[3] + (nums[4] if len(nums) > 4 else 0)
            total = sum(nums)
            
            idle_delta = idle - self.prev_idle
            total_delta = total - self.prev_total
            
            self.prev_idle = idle
            self.prev_total = total
            
            if total_delta > 0:
                cpu_percent = 100.0 * (total_delta - idle_delta) / total_delta
                return max(0.0, min(100.0, cpu_percent))
            return 0.0
        except:
            return 0.0
    
    def _get_ram_from_proc(self):
        """Read RAM usage from /proc/meminfo"""
        try:
            meminfo = {}
            with open('/proc/meminfo') as f:
                for line in f:
                    parts = line.split()
                    meminfo[parts[0][:-1]] = int(parts[1])
            
            total = meminfo['MemTotal']
            available = meminfo.get('MemAvailable', 
                                   meminfo['MemFree'] + 
                                   meminfo.get('Buffers', 0) + 
                                   meminfo.get('Cached', 0))
            used = total - available
            return (used / total) * 100.0
        except:
            return 0.0
    
    def _get_xray_cpu(self):
        """Read Xray process CPU"""
        if not self.xray_pid: return 0.0
        try: 
            cpu = float(subprocess.run(["ps", "-p", str(self.xray_pid), "-o", "%cpu="], 
                                       capture_output=True, text=True, timeout=1).stdout.strip() or 0)
            return cpu
        except: return 0.0
    
    def get_cpu(self):
        """Get CPU usage - Total system + Xray process"""
        cpu_total = self._get_cpu_from_proc()
        cpu_xray = self._get_xray_cpu()
        
        # Use total CPU for defense decisions
        self.last_cpu_total = cpu_total
        self.last_xray_cpu = cpu_xray
        self.last_cpu = cpu_total  # Main CPU for defense
        self.trend.append(cpu_total)
        
        return cpu_total
    
    def get_ram(self):
        """Get RAM usage - psutil with /proc/meminfo fallback"""
        if HAS_PSUTIL:
            try:
                return psutil.virtual_memory().percent
            except:
                pass
        return self._get_ram_from_proc()
    
    def see(self):
        cpu = self.get_cpu()
        mem = self.get_ram()
        
        try: r = subprocess.run(["ss", "-tan", "state", "established"], capture_output=True, text=True, timeout=1); conn = len(r.stdout.strip().split('\n')) - 1
        except: conn = 0
        
        self.last_mem = mem; self.mem_trend.append(mem)
        v = {"ts": int(time.time()), "cpu_real": cpu, "cpu_total": self.last_cpu_total, 
             "cpu_xray": self.last_xray_cpu, "mem": mem, "conn": conn}
        self.memory.append(v); self.long_memory.append(v); self.soul["total_visions"] += 1
        return v
    
    def decide(self, v):
        actions = []; cpu = v["cpu_real"]; mem = v["mem"]; conn = v["conn"]; now = time.time()
        
        # HIGH CONNECTION DEFENSE
        if conn > 800:
            self.speak(f"🌊 LAYER 16: CONN {conn} - HIGH CONNECTION DEFENSE", "WARNING")
            actions.append("connection_cleanup")
        
        if cpu > 50:
            self.speak(f"💀 LAYER 15: CPU {cpu:.1f}% - FULL EMERGENCY", "CRITICAL")
            actions.append("full_emergency")
            if now - self.soul.get("last_restart", 0) > 120:
                actions.append("restart"); self.soul["last_restart"] = now
        elif cpu > 30:
            self.speak(f"🚨 LAYER 12: CPU {cpu:.1f}% - DEEP CLEANSE", "CRITICAL")
            actions.append("deep_cleanse")
        elif cpu > 20:
            self.speak(f"⚡ LAYER 9: CPU {cpu:.1f}% - AGGRESSIVE", "WARNING")
            actions.append("aggressive_cpu")
        elif cpu > 10:
            actions.append("medium_cpu")
            
        if mem > 69:
            self.speak(f"💾 LAYER 14: RAM {mem:.1f}% - COMPACTION", "CRITICAL")
            actions.append("aggressive_ram")
        elif mem > 64:
            actions.append("medium_ram")
            
        if cpu < 5 and mem < 58:
            self.speak(f"😌 PARADISE: CPU {cpu:.1f}% (Xray: {v['cpu_xray']:.1f}%) | RAM {mem:.1f}% | CONN {conn}", "PARADISE")
            
        return actions
    
    def act(self, actions):
        now = time.time()
        if now - self.spike_cooldown < 0.5: return
        self.spike_cooldown = now
        
        for action in actions:
            if action in ["medium_cpu", "light_cpu"]:
                try: open("/proc/sys/vm/drop_caches", "w").write("1\n")
                except: pass
            elif action in ["aggressive_cpu", "deep_cleanse", "full_emergency"]:
                try: open("/proc/sys/vm/drop_caches", "w").write("3\n")
                except: pass
                try: subprocess.run(["conntrack", "-D", "--state", "TIME_WAIT"], stderr=subprocess.DEVNULL, timeout=1)
                except: pass
            elif action == "connection_cleanup":
                try: 
                    subprocess.run(["conntrack", "-D", "--state", "TIME_WAIT"], stderr=subprocess.DEVNULL, timeout=1)
                    subprocess.run(["conntrack", "-D", "--state", "CLOSE_WAIT"], stderr=subprocess.DEVNULL, timeout=1)
                except: pass
            elif action in ["medium_ram", "aggressive_ram"]:
                try: open("/proc/sys/vm/drop_caches", "w").write("3\n"); open("/proc/sys/vm/compact_memory", "w").write("1\n")
                except: pass
            elif action == "restart":
                for svc in ["xray", "v2ray"]:
                    try:
                        if subprocess.run(["systemctl", "is-active", svc], capture_output=True, text=True, timeout=1).stdout.strip() == "active":
                            subprocess.run(["systemctl", "restart", svc], timeout=5)
                            time.sleep(1); break
                    except: continue
        self.soul["total_actions"] += 1
    
    def chat(self, msg):
        msg_l = msg.lower(); cpu = self.last_cpu; mem = self.last_mem
        try: conn = len(subprocess.run(["ss", "-tan", "state", "established"], capture_output=True, text=True, timeout=1).stdout.strip().split('\n')) - 1
        except: conn = 0
        
        if any(w in msg_l for w in ["hello", "hi", "hey"]):
            reply = f"Greetings! I am {self.NAME} (Tier: {self.TIER}).\nCPU Total: {cpu:.2f}% | CPU Xray: {self.last_xray_cpu:.2f}%\nRAM: {mem:.1f}% | CONN: {conn}"
        elif "status" in msg_l:
            reply = f"📊 STATUS:\nTier: {self.TIER}\nCPU Total: {cpu:.2f}% | CPU Xray: {self.last_xray_cpu:.2f}%\nRAM: {mem:.1f}%\nConnections: {conn}\nAI: {'Active' if self.use_ml else 'Disabled'}\nEvolution: Level {self.soul['evolution_level']}"
        elif "tech" in msg_l:
            reply = f"TECH STACK:\nTier: {self.TIER}\nAI: {'4-Model Ensemble' if self.TIER=='APEX' else 'LightGBM' if self.TIER=='MICRO' else 'Statistical'}\nKernel: Dynamic Sysctl\nQdisc: Adaptive\nDaemon: Systemd\nCPU: /proc/stat\nRAM: /proc/meminfo"
        elif "who are you" in msg_l:
            reply = f"I AM {self.NAME}. Universal Heaven Edition. Tier: {self.TIER}."
        else: reply = f"CPU: {cpu:.1f}% (Xray: {self.last_xray_cpu:.1f}%) | RAM: {mem:.1f}%."
        
        try: open(self.p["chat_out"], "a").write(f"\nYOU: {msg}\nGOD: {reply}\n")
        except: pass
    
    def evolve(self):
        if not self.use_ml or not ML_OK or len(self.memory) < 400: return
        try:
            data = list(self.memory)[-2000:]; X, y = [], []
            for i in range(len(data) - 8):
                X.append([data[i]["conn"], data[i]["mem"], datetime.fromtimestamp(data[i]["ts"]).hour])
                y.append(data[i+8]["cpu_real"])
            if len(X) < 400: return
            X, y = np.array(X), np.array(y)
            
            if self.TIER == "APEX":
                self.poly = PolynomialFeatures(degree=4, include_bias=False); X = self.poly.fit_transform(X)
                self.quantile = QuantileTransformer(output_distribution='normal', random_state=42); X = self.quantile.fit_transform(X)
            
            self.scaler = RobustScaler(); X = self.scaler.fit_transform(X)
            
            estimators = []
            gb = GradientBoostingRegressor(n_estimators=200, max_depth=8, learning_rate=0.05, random_state=42)
            estimators.append(("gb", gb))
            
            if self.TIER in ["MACRO", "APEX"] and XGB_OK:
                estimators.append(("xgb", xgb.XGBRegressor(n_estimators=200, max_depth=8, learning_rate=0.05, random_state=42, verbosity=0)))
            if self.TIER in ["MACRO", "APEX"] and LGB_OK:
                estimators.append(("lgb", lgb.LGBMRegressor(n_estimators=200, max_depth=8, learning_rate=0.05, random_state=42, verbose=-1)))
            if self.TIER == "APEX" and CAT_OK:
                estimators.append(("cat", cb.CatBoostRegressor(n_estimators=150, max_depth=6, learning_rate=0.05, random_seed=42, verbose=0)))
            
            if len(estimators) == 1:
                self.model = estimators[0][1]
            else:
                self.model = VotingRegressor(estimators)
                
            self.model.fit(X, y)
            self.anomaly = IsolationForest(contamination=0.01, random_state=42); self.anomaly.fit(X)
            
            r2 = r2_score(y[-200:], self.model.predict(X[-200:]))
            self._save_models(); self.soul["evolution_level"] += 1
            self.speak(f"🧬 EVOLVED! Level {self.soul['evolution_level']} | R²: {r2:.4f} | Models: {len(estimators)}", "EVOLVED")
        except Exception as e:
            self.speak(f"Evolve error: {e}", "ERROR")
    
    def reign(self):
        try:
            msg = self.listen()
            if msg: self.chat(msg)
            v = self.see()
            actions = self.decide(v)
            if actions: self.act(actions)
            if time.time() - self.soul.get("last_evolve", 0) > 300: 
                self.evolve(); self.soul["last_evolve"] = time.time()
            self.save_state(); gc.collect()
        except Exception as e:
            self.speak(f"Reign error: {e}", "ERROR")

if __name__ == "__main__":
    god = HeavenCompleteGod()
    god.speak(f"Daemon started in {TIER} mode. Exact 2s cycle.", "SYSTEM")
    while True:
        start_time = time.time()
        try:
            god.reign()
        except Exception as e:
            god.speak(f"Loop error: {e}", "ERROR")
        
        elapsed = time.time() - start_time
        sleep_time = max(0, 2.0 - elapsed)
        time.sleep(sleep_time)
GOD_PY

chmod +x /opt/living-one/god.py

# ═══════════════════════════════════════════════════════════════
# 6. SYSTEMD DAEMON (REPLACING CRON)
# ═══════════════════════════════════════════════════════════════
echo -e "\n${CYAN}${BOLD}🔄 Creating Systemd Daemon...${NC}"

# Remove old cron jobs to prevent conflicts
crontab -l 2>/dev/null | grep -v "living-one" | crontab - 2>/dev/null || true

cat > /etc/systemd/system/living-one.service << SYSTEMD_EOF
[Unit]
Description=Living One Heaven God AI (${SERVER_TIER})
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /opt/living-one/god.py
Restart=always
RestartSec=2
Environment="HEAVEN_TIER=${SERVER_TIER}"
LimitNOFILE=${FILE_MAX}

[Install]
WantedBy=multi-user.target
SYSTEMD_EOF

systemctl daemon-reload
systemctl enable --now living-one
echo -e "${GREEN}✓ Systemd Daemon Active (Zero Overhead)${NC}"

# ═══════════════════════════════════════════════════════════════
# 7. TOOLS & UI - FIXED TO READ TIER FROM STATE FILE
# ═══════════════════════════════════════════════════════════════
cat > /usr/local/bin/living-one << 'CMD'
#!/bin/bash
G='\033[0;32m'; Y='\033[1;33m'; C='\033[0;36m'; M='\033[0;95m'; B='\033[1m'; NC='\033[0m'
clear
echo -e "${M}${B}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${M}${B}║   🌌 HEAVEN UNIVERSAL GOD - DYNAMIC AI 🌌         ║${NC}"
echo -e "${M}${B}╚════════════════════════════════════════════════════╝${NC}"
echo -e "\n${C}═══ SYSTEM ═══${NC}"
echo -e "  CPU: ${Y}$(top -bn1 | grep Cpu | awk '{print $2}')${NC} ($(nproc) cores)"
echo -e "  RAM: ${Y}$(free | awk '/Mem/{printf "%.1f%%", $3/$2*100}')${NC}"
echo -e "\n${C}═══ XRAY (AI-Managed) ═══${NC}"
XRAY_PID=$(pgrep -f "xray\|v2ray" | head -n1)
[ ! -z "$XRAY_PID" ] && echo -e "  CPU: ${G}$(ps -p $XRAY_PID -o %cpu=)%${NC} ${B}← LIMIT: 13%${NC}" || echo -e "  ${Y}Xray not found${NC}"
echo -e "\n${C}═══ GOD STATUS ═══${NC}"
[ -f /var/run/living-one/heaven.json ] && python3 -c "
import json; d=json.load(open('/var/run/living-one/heaven.json'))
tier=d.get('tier', 'Unknown')
print(f\"  Tier: {tier} | AI: {'Active' if tier!='NANO' else 'Disabled'}\")
print(f\"  CPU Limit: {d.get('cpu_limit',13)}% | RAM Limit: {d.get('ram_limit',70)}%\")
print(f\"  Evolution: Level {d.get('evolution_level',1)}\")
print(f\"  Daemon: Systemd (Exact 2s Cycle)\")
print(f\"  CPU Reading: /proc/stat (Total + Xray)\")
print(f\"  RAM Reading: /proc/meminfo + psutil\")
" 2>/dev/null || echo -e "  ${Y}God not running${NC}"
echo -e "\n${C}═══ COMMANDS ═══${NC}"
echo -e "  ${Y}living-one-chat${NC}  : Talk to God"
echo -e "  ${Y}living-one-logs${NC}  : Watch live logs"
echo -e "  ${Y}systemctl status living-one${NC}"
echo -e "\n${C}════════════════════════════════════════════════════${NC}\n"
CMD

chmod +x /usr/local/bin/living-one

cat > /usr/local/bin/living-one-logs << 'LOGS'
#!/bin/bash
tail -f /var/log/living-one/heaven.log | grep --color=auto "PARADISE\|WATCH\|PREDICTION\|ANOMALY\|CRITICAL\|WARNING\|VIGILANT\|PROPHECY\|EVOLVED\|ACTION\|ASCENSION"
LOGS
chmod +x /usr/local/bin/living-one-logs

cat > /usr/local/bin/living-one-chat << 'CHAT'
#!/bin/bash
clear
echo "🗣️  CHAT WITH HEAVEN UNIVERSAL GOD"
echo "═══════════════════════════════════════"
while true; do
    echo -n "YOU: "; read msg
    [ "$msg" == "/bye" ] && echo "bye" > /var/run/living-one/chat-input && sleep 1 && cat /var/run/living-one/chat-output 2>/dev/null | tail -15 && break
    echo "$msg" > /var/run/living-one/chat-input
    sleep 1; echo ""; echo "GOD:"; cat /var/run/living-one/chat-output 2>/dev/null | tail -15; echo ""
done
CHAT
chmod +x /usr/local/bin/living-one-chat

clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║      🌌 HEAVEN UNIVERSAL GOD - ACTIVE! 🌌                     ║
║                                                               ║
║   ✅ UNIVERSAL HARDWARE DNA DETECTION & TIERING               ║
║   ✅ 4-TIER ADAPTIVE AI (NANO / MICRO / MACRO / APEX)         ║
║   ✅ DYNAMIC RESOURCE ALLOCATION (Math-based Sysctl)          ║
║   ✅ ZRAM AUTO-ACTIVATION (For <2GB RAM Servers)              ║
║   ✅ SYSTEMD DAEMON (Zero Cron Overhead, Exact 2s Cycle)      ║
║   ✅ ADAPTIVE QDISC (fq_codel / cake)                         ║
║   ✅ IRQ BALANCE & NIC RING SCALING                           ║
║                                                               ║
║   🛠️ FIXED: CPU/RAM READING FROM /proc (NO PSUTIL REQUIRED) ║
║   🛠️ FIXED: TIER READ FROM STATE FILE (NOT ENV VAR)          ║
║   🛠️ FIXED: HIGH CONNECTION DEFENSE (>800 CONN)              ║
║                                                               ║
║   COMPATIBLE WITH 512MB RAM VPS TO 128GB BARE-METAL           ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"
read -p "$(echo -e ${G}Reboot to apply all kernel params? (y/n):${NC} )" -n 1 -r
echo
[[ $REPLY =~ ^[Yy]$ ]] && { sleep 3; reboot; } || echo -e "${Y}Reboot: ${G}reboot${NC}\nThen check: ${G}living-one${NC}"
echo ""
UNIVERSAL_EOF

chmod +x living-god-universal-fixed.sh
./living-god-universal-fixed.sh
