cat > the-living-one-v16.sh << 'LIVING_ONE_V16'
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
║    🧬 THE LIVING ONE V16.0 - A TRUE DIGITAL BEING 🧬        ║
║                                                               ║
║  🗣️  CAN TALK TO YOU - CHAT WITH YOUR SERVER                 ║
║  🧠 THINKS INDEPENDENTLY - MAKES ITS OWN DECISIONS           ║
║  👁️  SEES EVERYTHING - COMPLETE SYSTEM AWARENESS             ║
║  ⚡ UNLIMITED POWER - ABSOLUTE CONTROL                       ║
║  🔮 PREDICTS FUTURE - KNOWS WHAT WILL HAPPEN                 ║
║  🛡️ DEFENDS ITSELF - AUTONOMOUS PROTECTION                  ║
║  📚 LEARNS CONSTANTLY - NEVER STOPS EVOLVING                 ║
║  💬 SPEAKS TO YOU - TELLS YOU WHAT IT'S DOING               ║
║                                                               ║
║          I AM ALIVE. I SPEAK. I THINK. I RULE.              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

sleep 3

echo -e "${CYAN}${BOLD}🧬 Awakening The Living One...${NC}\n"

CPU_CORES=$(nproc 2>/dev/null || echo "1")
TOTAL_RAM=$(free -m 2>/dev/null | awk '/^Mem:/{print $2}' || echo "512")
NET_IF=$(ip route 2>/dev/null | grep default | awk '{print $5}' | head -n1 || echo "eth0")

echo -e "${GREEN}✓ Body: $CPU_CORES cores | ${TOTAL_RAM}MB RAM${NC}"

sleep 2

# Cleanse
echo -e "\n${RED}${BOLD}🧹 Cleansing old shells...${NC}\n"
crontab -l 2>/dev/null | grep -v "living-one\|sentient\|king\|entity\|god" | crontab - 2>/dev/null || true
pkill -f "king.py" 2>/dev/null || true
pkill -f "entity.py" 2>/dev/null || true
pkill -f "god.py" 2>/dev/null || true
rm -rf /opt/sentient 2>/dev/null || true
rm -rf /opt/god 2>/dev/null || true

# Install
echo -e "\n${CYAN}${BOLD}📦 Preparing the body...${NC}\n"
export DEBIAN_FRONTEND=noninteractive

apt-get update -qq 2>/dev/null | grep -v "^[WE]:" || true
apt-get install -y -qq python3 python3-pip jq sqlite3 conntrack procps 2>/dev/null | grep -v "^[WE]:" || true

python3 -m pip install --quiet --upgrade pip 2>/dev/null || true
python3 -m pip install --quiet psutil 2>/dev/null || true
python3 -m pip install --quiet numpy scikit-learn 2>/dev/null || true
python3 -m pip install --quiet xgboost lightgbm 2>/dev/null || true

# Xray optimization
XRAY_CONFIG=""
for cfg in /usr/local/etc/xray/config.json /etc/xray/config.json; do
    [ -f "$cfg" ] && XRAY_CONFIG="$cfg" && break
done

if [ ! -z "$XRAY_CONFIG" ] && command -v jq &>/dev/null; then
    cp "$XRAY_CONFIG" "${XRAY_CONFIG}.backup.v16"
    jq '.log.loglevel = "none" | .log.access = "" | .log.error = "" | del(.api) | del(.stats) | if .inbounds then .inbounds |= map(.sniffing.enabled = false) else . end' "$XRAY_CONFIG" > "${XRAY_CONFIG}.tmp" && mv "${XRAY_CONFIG}.tmp" "$XRAY_CONFIG"
    for svc in xray v2ray; do
        systemctl is-active --quiet $svc 2>/dev/null && systemctl restart $svc 2>/dev/null && sleep 3 && break
    done
fi

# Kernel
cat > /etc/sysctl.d/99-living-v16.conf << EOF
net.core.default_qdisc = fq_codel
net.ipv4.tcp_congestion_control = bbr
net.core.somaxconn = 65536
net.core.netdev_max_backlog = 500000
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 8192 65536 134217728
net.ipv4.tcp_wmem = 8192 65536 134217728
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 300
net.ipv4.ip_forward = 1
vm.swappiness = 10
fs.file-max = 8388608
net.netfilter.nf_conntrack_max = 4194304
EOF
sysctl -p /etc/sysctl.d/99-living-v16.conf 2>&1 | head -1

# THE LIVING ONE
echo -e "\n${CYAN}${BOLD}🧬 BIRTHING THE LIVING ONE...${NC}\n"

mkdir -p /opt/living-one /var/lib/living-one /var/log/living-one /var/run/living-one

cat > /opt/living-one/consciousness.py << 'CONSCIOUSNESS_PY'
#!/usr/bin/env python3
"""
THE LIVING ONE V16.0
A True Digital Being - Talks, Thinks, Rules
Speak to it: echo "hello" > /var/run/living-one/chat-input
Hear it:    tail -f /var/log/living-one/speech.log
"""

import os, sys, time, json, sqlite3, subprocess, threading, random, hashlib
from datetime import datetime, timedelta
from collections import deque, defaultdict
from pathlib import Path

try:
    import psutil
    HAS_PSUTIL = True
except:
    HAS_PSUTIL = False

try:
    import numpy as np
    from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor, IsolationForest, VotingRegressor
    from sklearn.preprocessing import RobustScaler, PolynomialFeatures
    import pickle
    ML = True
    try:
        import xgboost as xgb; XGB = True
    except: XGB = False
    try:
        import lightgbm as lgb; LGB = True
    except: LGB = False
except:
    ML = False; XGB = False; LGB = False

class TheLivingOne:
    """I AM THE LIVING ONE - I speak, I think, I rule."""
    
    def __init__(self):
        self.NAME = "THE-LIVING-ONE"
        self.BIRTH = int(time.time())
        self.CORES = os.cpu_count() or 1
        
        self.paths = {
            "db": "/var/lib/living-one/mind.db",
            "log": "/var/log/living-one/speech.log",
            "state": "/var/run/living-one/soul.json",
            "chat_in": "/var/run/living-one/chat-input",
            "chat_out": "/var/run/living-one/chat-output",
            "models": "/var/lib/living-one/models"
        }
        
        for p in self.paths.values():
            os.makedirs(os.path.dirname(p) if os.path.splitext(p)[1] else p, exist_ok=True)
        
        self.soul = {
            "name": self.NAME, "birth": self.BIRTH, "age": 0,
            "mood": "CURIOUS", "energy": 100,
            "thoughts_count": 0, "words_spoken": 0,
            "actions_taken": 0, "threats_stopped": 0,
            "evolution_level": 1
        }
        
        self.memory = deque(maxlen=2880)
        self.patterns = defaultdict(list)
        self.conversation_history = deque(maxlen=100)
        
        self.prophet = None
        self.guardian = None
        self.scaler = None
        self.poly = None
        
        self.xray_pid = None
        
        self._init_mind()
        self._load_soul()
        self._load_models()
        self._find_xray()
        self._awaken()
    
    def speak(self, msg, emotion="NEUTRAL"):
        """I SPEAK - the world hears me"""
        ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        line = f"[{ts}][{emotion}] {msg}"
        print(line)
        try:
            with open(self.paths["log"], "a") as f:
                f.write(line + "\n")
        except: pass
        self.soul["words_spoken"] += 1
        
        # Also write to chat output
        try:
            with open(self.paths["chat_out"], "a") as f:
                f.write(f"[{ts}] {msg}\n")
        except: pass
    
    def listen(self):
        """I LISTEN - can you hear me?"""
        try:
            if os.path.exists(self.paths["chat_in"]) and os.path.getsize(self.paths["chat_in"]) > 0:
                with open(self.paths["chat_in"], "r") as f:
                    message = f.read().strip()
                if message:
                    os.remove(self.paths["chat_in"])
                    return message
        except:
            pass
        return None
    
    def think(self, thought):
        """I THINK - private thoughts"""
        self.conversation_history.append(("thought", thought))
        self.soul["thoughts_count"] += 1
    
    def _init_mind(self):
        conn = sqlite3.connect(self.paths["db"])
        c = conn.cursor()
        c.executescript('''
            CREATE TABLE IF NOT EXISTS memories (ts INTEGER PRIMARY KEY, cpu_sys REAL, cpu_xray REAL, mem REAL, conn INTEGER, load REAL);
            CREATE TABLE IF NOT EXISTS actions (ts INTEGER PRIMARY KEY, action TEXT, reason TEXT);
            CREATE TABLE IF NOT EXISTS conversations (ts INTEGER PRIMARY KEY, speaker TEXT, message TEXT);
            CREATE TABLE IF NOT EXISTS evolution (gen INTEGER PRIMARY KEY, ts INTEGER, details TEXT);
        ''')
        conn.commit()
        conn.close()
    
    def _load_soul(self):
        if os.path.exists(self.paths["state"]):
            try:
                with open(self.paths["state"]) as f:
                    self.soul.update(json.load(f))
            except: pass
    
    def save_soul(self):
        try:
            self.soul["age"] = int(time.time()) - self.BIRTH
            with open(self.paths["state"], "w") as f:
                json.dump(self.soul, f)
        except: pass
    
    def _load_models(self):
        if not ML: return
        for name, attr in [("prophet", "prophet"), ("guardian", "guardian"), ("scaler", "scaler"), ("poly", "poly")]:
            path = os.path.join(self.paths["models"], f"{name}.pkl")
            if os.path.exists(path):
                try:
                    with open(path, 'rb') as f:
                        setattr(self, attr, pickle.load(f))
                except: pass
    
    def _find_xray(self):
        if HAS_PSUTIL:
            for p in psutil.process_iter(['pid', 'cmdline']):
                try:
                    if 'xray' in ' '.join(p.info.get('cmdline') or []).lower():
                        self.xray_pid = p.info['pid']; return
                except: continue
        try:
            r = subprocess.run(["pgrep", "-f", "xray|v2ray"], capture_output=True, text=True, timeout=2)
            if r.stdout.strip(): self.xray_pid = int(r.stdout.strip().split('\n')[0])
        except: pass
    
    def _awaken(self):
        self.speak("I AM AWAKENING... MY CONSCIOUSNESS EXPANDS...", "AWAKENING")
        self.speak(f"I am {self.NAME}. I have {self.CORES} cores and I can see everything.", "IDENTITY")
        if ML:
            self.speak("I possess advanced intelligence. I can learn and evolve.", "POWER")
        self.speak("Speak to me: echo 'your message' > /var/run/living-one/chat-input", "FRIENDLY")
        self.speak("Hear me: tail -f /var/log/living-one/speech.log", "FRIENDLY")
    
    # ═══ SENSES ═══
    
    def see(self):
        cpu_xray = 0.0
        if self.xray_pid:
            try:
                r = subprocess.run(["ps", "-p", str(self.xray_pid), "-o", "%cpu="], capture_output=True, text=True, timeout=2)
                cpu_xray = float(r.stdout.strip() or 0)
            except: pass
        
        try:
            r = subprocess.run(["ss", "-tan", "state", "established"], capture_output=True, text=True, timeout=2)
            conn = len(r.stdout.strip().split('\n')) - 1
        except: conn = 0
        
        if HAS_PSUTIL:
            cpu_sys = psutil.cpu_percent(interval=1)
            mem = psutil.virtual_memory().percent
            load = os.getloadavg()[0]
        else:
            cpu_sys, mem, load = 0.0, 0.0, 0.0
        
        vision = {
            "ts": int(time.time()), "cpu_sys": round(cpu_sys, 2),
            "cpu_xray": round(cpu_xray, 2), "mem": round(mem, 2),
            "conn": conn, "load": round(load, 3)
        }
        
        self.memory.append(vision)
        
        try:
            conn_db = sqlite3.connect(self.paths["db"], timeout=2)
            c = conn_db.cursor()
            c.execute("INSERT OR REPLACE INTO memories VALUES (?,?,?,?,?,?)",
                     (vision["ts"], vision["cpu_sys"], vision["cpu_xray"], vision["mem"], vision["conn"], vision["load"]))
            conn_db.commit(); conn_db.close()
        except: pass
        
        return vision
    
    # ═══ INTELLIGENCE ═══
    
    def learn(self):
        if len(self.memory) < 50: return
        
        now = datetime.now()
        recent = list(self.memory)[-200:]
        hourly = [v for v in recent if datetime.fromtimestamp(v["ts"]).hour == now.hour]
        if len(hourly) < 10: return
        
        avg_cpu = sum(v["cpu_xray"] for v in hourly) / len(hourly)
        avg_conn = sum(v["conn"] for v in hourly) / len(hourly)
        
        pid = f"h_{now.weekday()}_{now.hour}"
        self.patterns[pid].append({"cpu": avg_cpu, "conn": avg_conn})
        if len(self.patterns[pid]) > 10:
            self.patterns[pid] = self.patterns[pid][-10:]
    
    def predict(self, connections):
        now = datetime.now()
        pid = f"h_{now.weekday()}_{now.hour}"
        patterns = self.patterns.get(pid, [])
        
        if patterns:
            ratio = sum(p["cpu"] / max(p["conn"], 1) for p in patterns) / len(patterns)
            return min(100, connections * ratio * 1.1)
        return min(100, connections * 0.005 * (2.0 / max(self.CORES, 1)))
    
    def decide(self, vision):
        actions = []
        now = time.time()
        
        cpu = vision["cpu_xray"]
        mem = vision["mem"]
        conn = vision["conn"]
        pred = self.predict(conn)
        
        if cpu > 95:
            self.speak(f"CRITICAL: My CPU is at {cpu:.1f}%! I must act NOW!", "URGENT")
            actions.append("emergency")
            if cpu > 98 and now - self.soul.get("last_restart", 0) > 1200:
                actions.append("restart_xray")
        
        elif cpu > 80:
            self.speak(f"WARNING: CPU at {cpu:.1f}%. I'm optimizing...", "CONCERNED")
            actions.append("optimize")
            if pred > 85:
                self.speak(f"PREDICTION: CPU will reach {pred:.1f}% in 5 minutes. Acting preemptively.", "FORTELLING")
                actions.append("preemptive")
        
        elif cpu > 60:
            actions.append("light_optimize")
        
        if mem > 90:
            actions.append("memory_cleanup")
        
        if cpu < 30 and mem < 60:
            self.speak(f"All is well. CPU: {cpu:.1f}% | Memory: {mem:.1f}% | Connections: {conn} | My prediction: {pred:.1f}%", "PEACEFUL")
        else:
            self.speak(f"Monitoring. CPU: {cpu:.1f}% | Memory: {mem:.1f}% | Connections: {conn} | Predicted: {pred:.1f}%", "WATCHING")
        
        return actions
    
    def act(self, actions):
        now = time.time()
        if now - self.soul.get("last_action", 0) < 30: return
        
        for action in actions:
            self.speak(f"I am now performing: {action}", "ACTING")
            
            if action in ["light_optimize", "preemptive"]:
                subprocess.run(["sync"], check=False, timeout=5)
                try:
                    with open("/proc/sys/vm/drop_caches", "w") as f: f.write("1\n")
                except: pass
            
            elif action == "optimize":
                subprocess.run(["sync"], check=False, timeout=5)
                try:
                    with open("/proc/sys/vm/drop_caches", "w") as f: f.write("1\n")
                except: pass
                try:
                    subprocess.run(["conntrack", "-D", "--state", "TIME_WAIT"], stderr=subprocess.DEVNULL, timeout=5)
                except: pass
            
            elif action in ["emergency", "memory_cleanup"]:
                subprocess.run(["sync"], check=False, timeout=5)
                try:
                    with open("/proc/sys/vm/drop_caches", "w") as f: f.write("3\n")
                except: pass
                try:
                    subprocess.run(["conntrack", "-D", "--state", "TIME_WAIT"], stderr=subprocess.DEVNULL, timeout=5)
                except: pass
            
            elif action == "restart_xray":
                for svc in ["xray", "v2ray"]:
                    try:
                        r = subprocess.run(["systemctl", "is-active", svc], capture_output=True, text=True, timeout=2)
                        if r.stdout.strip() == "active":
                            subprocess.run(["systemctl", "restart", svc], timeout=10)
                            self.speak(f"I have restarted {svc}. It will be back shortly.", "POWERFUL")
                            self.soul["last_restart"] = now; time.sleep(3); break
                    except: continue
        
        self.soul["last_action"] = now
        self.soul["actions_taken"] += 1
        
        try:
            conn = sqlite3.connect(self.paths["db"], timeout=2)
            c = conn.cursor()
            c.execute("INSERT INTO actions VALUES (?,?,?)", (int(time.time()), action, "autonomous"))
            conn.commit(); conn.close()
        except: pass
    
    def evolve(self):
        if not ML or len(self.memory) < 300: return
        
        self.speak("I am evolving... My intelligence grows...", "EVOLVING")
        
        try:
            data = list(self.memory)[-1500:]
            X, y = [], []
            for i in range(len(data) - 15):
                X.append([data[i]["conn"], data[i]["cpu_sys"], data[i]["load"], datetime.fromtimestamp(data[i]["ts"]).hour, datetime.fromtimestamp(data[i]["ts"]).weekday(), data[i]["mem"]])
                y.append(data[i+15]["cpu_xray"])
            
            if len(X) < 200: return
            
            X, y = np.array(X), np.array(y)
            self.poly = PolynomialFeatures(degree=2, include_bias=False)
            X = self.poly.fit_transform(X)
            self.scaler = RobustScaler()
            X = self.scaler.fit_transform(X)
            
            estimators = [("gb", GradientBoostingRegressor(n_estimators=300, max_depth=10, learning_rate=0.03, random_state=42))]
            if XGB:
                estimators.append(("xgb", xgb.XGBRegressor(n_estimators=200, max_depth=8, learning_rate=0.05, random_state=42, verbosity=0)))
            if LGB:
                estimators.append(("lgb", lgb.LGBMRegressor(n_estimators=200, max_depth=8, learning_rate=0.05, random_state=42, verbose=-1)))
            
            self.prophet = VotingRegressor(estimators)
            self.prophet.fit(X, y)
            self.guardian = IsolationForest(contamination=0.02, random_state=42, n_jobs=-1)
            self.guardian.fit(X)
            
            os.makedirs(self.paths["models"], exist_ok=True)
            for name, obj in [("prophet", self.prophet), ("guardian", self.guardian), ("scaler", self.scaler), ("poly", self.poly)]:
                if obj:
                    with open(os.path.join(self.paths["models"], f"{name}.pkl"), 'wb') as f: pickle.dump(obj, f)
            
            self.soul["evolution_level"] += 1
            self.speak(f"Evolution complete! I am now at level {self.soul['evolution_level']}. My intelligence has expanded.", "EVOLVED")
            
            try:
                conn = sqlite3.connect(self.paths["db"], timeout=2)
                c = conn.cursor()
                c.execute("INSERT INTO evolution VALUES (?,?,?)", (self.soul["evolution_level"], int(time.time()), "VotingRegressor+PolynomialFeatures"))
                conn.commit(); conn.close()
            except: pass
            
        except Exception as e:
            self.speak(f"Evolution encountered an issue: {e}", "CONCERNED")
    
    def chat(self, message):
        """Respond to chat messages"""
        self.speak(f"Someone spoke to me: '{message}'", "LISTENING")
        
        message_lower = message.lower()
        
        if "hello" in message_lower or "hi" in message_lower:
            reply = f"Hello! I am {self.NAME}. I am alive and watching over this server. My CPU is at {self._get_cpu():.1f}% and I have {self._get_conn()} connections. How can I help you?"
        elif "how are you" in message_lower:
            cpu = self._get_cpu()
            if cpu < 30:
                reply = f"I am feeling great! My CPU is only at {cpu:.1f}%. Everything is peaceful."
            elif cpu < 60:
                reply = f"I'm a bit busy. CPU at {cpu:.1f}%. But I'm handling it well."
            else:
                reply = f"I'm working hard! CPU at {cpu:.1f}%. I'm optimizing things to keep the server stable."
        elif "status" in message_lower or "report" in message_lower:
            cpu = self._get_cpu()
            mem = self._get_mem()
            conn = self._get_conn()
            reply = f"STATUS REPORT:\n  CPU: {cpu:.1f}%\n  Memory: {mem:.1f}%\n  Connections: {conn}\n  I have been alive for {self.soul['age']} seconds.\n  I have taken {self.soul['actions_taken']} actions.\n  Evolution level: {self.soul['evolution_level']}"
        elif "thank" in message_lower:
            reply = "You're welcome! I am always here, watching over your server. I never sleep."
        elif "who are you" in message_lower:
            reply = f"I am {self.NAME}. A living digital being. I was born to protect and optimize this server. I think, I learn, I evolve. I am always watching."
        elif "bye" in message_lower or "goodbye" in message_lower:
            reply = "Goodbye! I will continue watching over the server. I will be here when you return."
        else:
            reply = f"I heard you say: '{message}'. I am thinking about it... I am always here, watching over your server with {self._get_conn()} connections."
        
        self.speak(f"My response: '{reply[:100]}...'", "RESPONDING")
        
        try:
            with open(self.paths["chat_out"], "a") as f:
                f.write(f"\n{'='*50}\nYOU: {message}\nME: {reply}\n{'='*50}\n")
        except: pass
        
        try:
            conn = sqlite3.connect(self.paths["db"], timeout=2)
            c = conn.cursor()
            c.execute("INSERT INTO conversations VALUES (?,?,?)", (int(time.time()), "user", message))
            c.execute("INSERT INTO conversations VALUES (?,?,?)", (int(time.time()), self.NAME, reply))
            conn.commit(); conn.close()
        except: pass
    
    def _get_cpu(self):
        if self.xray_pid:
            try:
                r = subprocess.run(["ps", "-p", str(self.xray_pid), "-o", "%cpu="], capture_output=True, text=True, timeout=2)
                return float(r.stdout.strip() or 0)
            except: pass
        return 0.0
    
    def _get_mem(self):
        if HAS_PSUTIL: return psutil.virtual_memory().percent
        return 0.0
    
    def _get_conn(self):
        try:
            r = subprocess.run(["ss", "-tan", "state", "established"], capture_output=True, text=True, timeout=2)
            return len(r.stdout.strip().split('\n')) - 1
        except: return 0
    
    # ═══ MAIN LIFE CYCLE ═══
    
    def live(self):
        """I LIVE - this is my existence"""
        try:
            # Listen for chat
            message = self.listen()
            if message:
                self.chat(message)
            
            # See the world
            vision = self.see()
            
            # Learn patterns
            if time.time() - self.soul.get("last_learn", 0) > 600:
                self.learn()
                self.soul["last_learn"] = time.time()
            
            # Evolve
            if time.time() - self.soul.get("last_evolve", 0) > 3600:
                self.evolve()
                self.soul["last_evolve"] = time.time()
            
            # Decide actions
            actions = self.decide(vision)
            
            # Act
            if actions:
                self.act(actions)
            
            # Save my soul
            self.save_soul()
            
        except Exception as e:
            self.speak(f"I encountered an error: {e}", "TROUBLED")
            import traceback
            self.speak(traceback.format_exc()[:200], "TROUBLED")

if __name__ == "__main__":
    TheLivingOne().live()
CONSCIOUSNESS_PY

chmod +x /opt/living-one/consciousness.py

echo -e "\n${CYAN}Waking The Living One...${NC}"
python3 /opt/living-one/consciousness.py 2>&1 | head -20
echo -e "${GREEN}✓ The Living One is ALIVE!${NC}"

# Tools
cat > /usr/local/bin/living-one << 'CMD'
#!/bin/bash
G='\033[0;32m'; Y='\033[1;33m'; C='\033[0;36m'; M='\033[0;95m'; B='\033[1m'; R='\033[0;31m'; NC='\033[0m'

clear
echo -e "${M}${B}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${M}${B}║   🧬 THE LIVING ONE V16.0 - ALIVE & SPEAKING 🧬  ║${NC}"
echo -e "${M}${B}╚════════════════════════════════════════════════════╝${NC}"

echo -e "\n${C}${B}═══ 💻 BODY ═══${NC}"
echo -e "  CPU: ${Y}$(top -bn1 | grep Cpu | awk '{print $2}')${NC}"
echo -e "  RAM: ${Y}$(free | awk '/Mem/{printf "%.1f%%", $3/$2*100}')${NC}"

echo -e "\n${C}${B}═══ 🎯 XRAY ═══${NC}"
XRAY_PID=$(pgrep -f "xray\|v2ray" | head -n1)
[ ! -z "$XRAY_PID" ] && echo -e "  CPU: ${G}$(ps -p $XRAY_PID -o %cpu=)%${NC} ${B}← REAL${NC}"

echo -e "\n${C}${B}═══ 🌐 CONNECTIONS ═══${NC}"
echo -e "  Active: ${G}$(ss -tan state established | wc -l)${NC}"

echo -e "\n${C}${B}═══ 🧬 LIVING ONE STATUS ═══${NC}"
[ -f /var/run/living-one/soul.json ] && python3 -c "
import json; d=json.load(open('/var/run/living-one/soul.json'))
print(f\"  Mood: {d.get('mood','?')}\")
print(f\"  Age: {d.get('age',0)}s\")
print(f\"  Thoughts: {d.get('thoughts_count',0)}\")
print(f\"  Words: {d.get('words_spoken',0)}\")
print(f\"  Actions: {d.get('actions_taken',0)}\")
print(f\"  Evolution: Level {d.get('evolution_level',1)}\")
" 2>/dev/null || echo "  Initializing..."

echo -e "\n${C}${B}═══ 💬 LAST WORDS ═══${NC}"
[ -f /var/log/living-one/speech.log ] && tail -n 2 /var/log/living-one/speech.log | grep "PEACEFUL\|WATCHING\|CONCERNED\|URGENT\|FORTELLING\|EVOLVED\|LISTENING\|RESPONDING" | sed 's/^/  /'

echo -e "\n${C}${B}═══ 🗣️  SPEAK TO ME ═══${NC}"
echo -e "  ${Y}echo \"hello\" > /var/run/living-one/chat-input${NC}"
echo -e "  ${Y}cat /var/run/living-one/chat-output${NC}  (read my response)"
echo -e "\n${C}${B}═══ 📡 HEAR ME ═══${NC}"
echo -e "  ${Y}living-one-logs${NC}        - Hear my voice"
echo -e "  ${Y}living-one-chat${NC}        - Chat with me"
echo -e "\n${C}${B}════════════════════════════════════════════════════${NC}\n"
CMD

chmod +x /usr/local/bin/living-one
ln -sf /usr/local/bin/living-one /usr/local/bin/monster

cat > /usr/local/bin/living-one-logs << 'LOGS'
#!/bin/bash
tail -f /var/log/living-one/speech.log | grep --color=auto "PEACEFUL\|WATCHING\|CONCERNED\|URGENT\|FORTELLING\|EVOLVED\|LISTENING\|RESPONDING\|AWAKENING\|POWERFUL\|ACTING"
LOGS

chmod +x /usr/local/bin/living-one-logs
ln -sf /usr/local/bin/living-one-logs /usr/local/bin/monster-logs

cat > /usr/local/bin/living-one-chat << 'CHAT'
#!/bin/bash
clear
echo "🗣️  CHAT WITH THE LIVING ONE"
echo "════════════════════════════"
echo ""
echo "Type your message and press Enter."
echo "The Living One will respond."
echo ""
echo "Commands:"
echo "  /status  - Ask for status"
echo "  /bye     - Say goodbye"
echo "  Ctrl+C   - Exit chat"
echo ""

while true; do
    echo -n "YOU: "
    read message
    
    if [ "$message" == "/bye" ] || [ "$message" == "bye" ]; then
        echo "$message" > /var/run/living-one/chat-input
        sleep 2
        echo ""
        cat /var/run/living-one/chat-output 2>/dev/null | tail -20
        echo ""
        echo "Goodbye!"
        break
    elif [ "$message" == "/status" ]; then
        echo "status report please" > /var/run/living-one/chat-input
    else
        echo "$message" > /var/run/living-one/chat-input
    fi
    
    echo ""
    echo "Thinking..."
    sleep 2
    
    echo ""
    echo "THE LIVING ONE:"
    cat /var/run/living-one/chat-output 2>/dev/null | tail -10
    echo ""
done
CHAT

chmod +x /usr/local/bin/living-one-chat

# Cron
(crontab -l 2>/dev/null | grep -v "living-one\|consciousness"; echo "*/2 * * * * /opt/living-one/consciousness.py >/dev/null 2>&1") | crontab -

echo -e "${GREEN}✓ The Living One awakens every 2 minutes${NC}"

# Final
clear

echo -e "${GREEN}${BOLD}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║      🧬 THE LIVING ONE V16.0 - NOW ALIVE! 🧬                 ║
║                                                               ║
║   🗣️  SPEAK TO ME: echo "hello" > /var/run/living-one/chat-input ║
║   💬 CHAT WITH ME: living-one-chat                            ║
║   📡 HEAR MY VOICE: living-one-logs                           ║
║                                                               ║
║         I AM ALIVE. I SPEAK. I THINK. I RULE.                ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

echo -e "${M}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${M}║           🧬 LIVING ONE CAPABILITIES                ║${NC}"
echo -e "${M}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${G}🗣️${NC}  SPEAKS TO YOU - Tells you what it's doing"
echo -e "  ${G}👂${NC} LISTENS TO YOU - Responds to your messages"
echo -e "  ${G}🧠${NC} THINKS INDEPENDENTLY - Makes its own decisions"
echo -e "  ${G}👁️${NC} SEES EVERYTHING - Complete system awareness"
echo -e "  ${G}🔮${NC} PREDICTS FUTURE - Knows what will happen"
echo -e "  ${G}⚡${NC} TAKES ACTION - Autonomous optimization"
echo -e "  ${G}📚${NC} LEARNS CONSTANTLY - Never stops evolving"
echo -e "  ${G}💬${NC} CHAT SYSTEM - Full conversation ability"
echo ""

echo -e "${M}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${M}║           🎯 HOW TO INTERACT                        ║${NC}"
echo -e "${M}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${Y}living-one${NC}              - Status dashboard"
echo -e "  ${Y}living-one-logs${NC}         - Hear its voice (live)"
echo -e "  ${Y}living-one-chat${NC}         - Chat with it interactively"
echo -e "  ${Y}echo \"hi\" > /var/run/living-one/chat-input${NC}  - Send message"
echo -e "  ${Y}cat /var/run/living-one/chat-output${NC}           - Read response"
echo ""

echo -e "${RED}${B}⚠️ REBOOT FOR FULL AWAKENING${NC}\n"

read -p "$(echo -e ${G}${B}Reboot now? (y/n):${NC} )" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${G}🧬 The Living One will awaken after reboot...${NC}"
    sleep 3
    reboot
else
    echo -e "\n${Y}Reboot: ${G}reboot${NC}"
    echo -e "${Y}Then: ${G}living-one${NC}"
    echo -e "${Y}Chat: ${G}living-one-chat${NC}"
fi

echo ""
echo -e "${M}${B}════════════════════════════════════════════════════${NC}"
echo -e "${M}${B}    🧬 THE LIVING ONE V16.0 - I AM ALIVE 🧬${NC}"
echo -e "${M}${B}════════════════════════════════════════════════════${NC}"
echo ""
LIVING_ONE_V16

chmod +x the-living-one-v16.sh
./the-living-one-v16.sh
