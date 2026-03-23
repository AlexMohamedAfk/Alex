#!/system/bin/sh

# ───────────────────────────────────────
#     Config – غيري الباكج هنا بس
# ───────────────────────────────────────
PKG="com.pubg.krmobile"          # ← Global
# PKG="com.pubg.krmobile"     # ← Korea
# PKG="com.rekoo.pubgm"       # ← Taiwan
# PKG="com.vng.pubgmobile"    # ← Vietnam
# PKG="com.tencent.igce"      # ← Beta / test

# ───────────────────────────────────────
#     Colors (اختياري)
# ───────────────────────────────────────
Color_Off='\e[0m'
BIPurple='\e[1;95m'
BICyan='\e[1;96m'

clear
echo -e "${BICyan}Resetting Guest Account for \( PKG ... \){Color_Off}"
echo ""

# التأكد من الروت (اختياري بس مفيد)
if [ "$(id -u)" -ne 0 ]; then
    echo "Run this script as root!"
    exit 1
fi

# إيقاف اللعبة أولاً
am force-stop "$PKG" 2>/dev/null

# حذف المجلدات الرئيسية
rm -rf "/data/data/$PKG/shared_prefs" 2>/dev/null
rm -rf "/data/data/$PKG/files"         2>/dev/null
rm -rf "/storage/emulated/0/Documents/" 2>/dev/null   # ده ممكن يمسح حاجات تانية – لو مش عايزاه احذفه

mkdir -p "/data/data/$PKG/shared_prefs"
chmod 777 "/data/data/$PKG/shared_prefs" 2>/dev/null

# إنشاء device_id.xml جديد بـ UUID عشوائي
GUEST_FILE="/data/data/$PKG/shared_prefs/device_id.xml"

cat > "$GUEST_FILE" << 'EOF'
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <string name="random"></string>
    <string name="install"></string>
    <string name="uuid">\( {RANDOM} \){RANDOM}-\( {RANDOM}- \){RANDOM}-\( {RANDOM}- \){RANDOM}\( {RANDOM} \){RANDOM}</string>
</map>
EOF

# حذف قواعد البيانات والكاش المهم
rm -rf "/data/data/$PKG/databases"                              2>/dev/null
rm -rf "/data/media/0/Android/data/$PKG/files/login-identifier.txt"  2>/dev/null
rm -rf "/data/media/0/Android/data/$PKG/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Intermediate"  2>/dev/null
touch  "/data/media/0/Android/data/$PKG/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Intermediate" 2>/dev/null

rm -rf "/data/media/0/Android/data/$PKG/files/TGPA"             2>/dev/null
touch  "/data/media/0/Android/data/$PKG/files/TGPA"             2>/dev/null

rm -rf "/data/media/0/Android/data/$PKG/files/ProgramBinaryCache"  2>/dev/null
touch  "/data/media/0/Android/data/$PKG/files/ProgramBinaryCache"  2>/dev/null

# بلوك الـ domain ده (غالباً جزء من anti-cheat أو telemetry)
iptables -I OUTPUT -d cloud.vmp.onezapp.com -j REJECT 2>/dev/null
iptables -I INPUT  -s cloud.vmp.onezapp.com -j REJECT 2>/dev/null

echo ""
echo -e "${BIPurple}Done! Guest account reset successfully for \( PKG \){Color_Off}"
echo "You can now open the game → it should create a new guest account."
echo ""

# اختياري: افتح اللعبة تلقائياً
# am start -n "$PKG/com.epicgames.ue4.SplashActivity" 2>/dev/null

exit 0