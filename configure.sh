#!/bin/bash
################################################################################
#
# Jungle4 Testnet - create config.ini from config.ini.example
# https://github.com/EOS-Jungle-Testnet/Node-Manual-Installation
#
# Asks for anything not given as a flag:
#   ./configure.sh
#   ./configure.sh --type full --p2p-address node.example.com
#   ./configure.sh --type bp --p2p-address 203.0.113.7 --bp-name mybpaccount1 --generate-keys
#
################################################################################
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/bin/bin"
TEMPLATE="$DIR/config.ini.example"
CONFIG="$DIR/config.ini"
KEYS="$DIR/keys.txt"

usage() {
	cat <<'EOF'
Usage: ./configure.sh [flags]   (asks for anything not given)

  --type full|bp            full node, or block producer
  --p2p-address HOST[:PORT] public address other nodes use to reach this node
                            (port 9876 if not given)
  --bp-name NAME            producer account (bp)
  --generate-keys           create the signing and BLS key pairs (bp);
                            they are also saved to keys.txt
  --signing-key PUB=KEY:PRIV            your own signing key pair (bp)
  --bls-key PUB_BLS_...=KEY:PVT_BLS_... your own finalizer key pair (bp)
  --force                   replace an existing config.ini (a backup is kept)
EOF
}

die() { echo "configure.sh: $*" >&2; exit 1; }
backup() { # copy a file to FILE.bak-<time>, never over an older backup
	local b="$1.bak-$(date +%Y%m%d-%H%M%S)" n=1
	while [ -e "$b" ]; do b="$1.bak-$(date +%Y%m%d-%H%M%S)-$n"; n=$((n + 1)); done
	cp -p "$1" "$b"
	chmod 600 "$b"   # config.ini and keys.txt can hold private keys
}
ask() { # variable, question, default
	local answer=""
	read -r -p "$2${3:+ [$3]}: " answer || true
	printf -v "$1" '%s' "${answer:-${3:-}}"
}
ask_secret() { # variable, question
	local answer=""
	read -r -s -p "$2: " answer || true
	echo >&2
	printf -v "$1" '%s' "$answer"
}

TYPE="" P2P="" BPNAME="" SIGN="" BLS="" POP="" GEN=0 FORCE=0
while [ $# -gt 0 ]; do
	case "$1" in
		--type)          TYPE="${2:?--type needs a value}"; shift 2 ;;
		--p2p-address)   P2P="${2:?--p2p-address needs a value}"; shift 2 ;;
		--bp-name)       BPNAME="${2:?--bp-name needs a value}"; shift 2 ;;
		--signing-key)   SIGN="${2:?--signing-key needs a value}"; shift 2 ;;
		--bls-key)       BLS="${2:?--bls-key needs a value}"; shift 2 ;;
		--generate-keys) GEN=1; shift ;;
		--force)         FORCE=1; shift ;;
		-h|--help)       usage; exit 0 ;;
		*)               usage >&2; die "unknown option: $1" ;;
	esac
done

[ -f "$TEMPLATE" ] || die "$TEMPLATE not found"
case "$DIR" in *[[:space:]]*) die "the node folder path has a space in it ($DIR); nodeos and keosd reject such paths, use a folder without spaces" ;; esac
[ ! -e "$CONFIG" ] || [ "$FORCE" = 1 ] || die "config.ini already exists; run with --force to replace it (a backup is kept)"

# node type
[ -n "$TYPE" ] || ask TYPE "Node type: full node or block producer (full/bp)" "full"
case "$TYPE" in full|bp) ;; *) die "--type must be full or bp, not '$TYPE'" ;; esac

# p2p-server-address
if [ -z "$P2P" ]; then
	guess=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i < NF; i++) if ($i == "src") print $(i + 1)}') || guess=""
	ask P2P "Public IP or hostname other nodes use to reach this node" "$guess"
fi
[ -n "$P2P" ] || die "the p2p address is required"
[[ "$P2P" == *:* && "$P2P" != \[*\] ]] || P2P="$P2P:9876"
[[ "$P2P" =~ ^([A-Za-z0-9.-]+|\[[0-9A-Fa-f:]+\]):[0-9]{1,5}$ ]] || die "not a HOST:PORT address: $P2P"
case "${P2P%:*}" in
	10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[01].*|127.*|100.6[4-9].*|100.[7-9][0-9].*|100.1[01][0-9].*|100.12[0-7].*)
		echo "warning: ${P2P%:*} is a private address; other nodes can't connect to it. Use your public IP or hostname." >&2 ;;
esac

if [ "$TYPE" = bp ]; then
	[ -n "$BPNAME" ] || ask BPNAME "Producer account name (12 symbols, a-z 1-5)"
	[[ "$BPNAME" =~ ^[a-z1-5.]{1,12}$ ]] || die "not a valid account name: '$BPNAME'"

	if [ "$GEN" = 0 ] && [ -z "$SIGN" ] && [ -z "$BLS" ]; then
		ask yn "Generate new signing and BLS keys? (y/n)" "y"
		case "$yn" in [Yy]*) GEN=1 ;; esac
	fi
	if [ "$GEN" = 1 ]; then
		[ -z "$SIGN$BLS" ] || die "use either --generate-keys or your own keys, not both"
		[ -x "$BIN/cleos" ] && [ -x "$BIN/spring-util" ] || die "cleos/spring-util not found in $BIN (see README, section 3)"
		k=$("$BIN/cleos" create key --to-console)
		b=$("$BIN/spring-util" bls create key --to-console)
		SIGN="$(awk '/Public key/ {print $3}' <<<"$k")=KEY:$(awk '/Private key/ {print $3}' <<<"$k")"
		BLS="$(awk -F': ' '/Public key/ {print $2}' <<<"$b")=KEY:$(awk -F': ' '/Private key/ {print $2}' <<<"$b")"
		POP=$(awk -F': ' '/Proof of Possession/ {print $2}' <<<"$b")
		[ ! -e "$KEYS" ] || backup "$KEYS"
		# mktemp creates the file 0600; renaming it replaces keys.txt whatever its old mode was
		ktmp=$(mktemp "$DIR/.keys.txt.XXXXXX")
		{ echo "# Jungle4 keys for $BPNAME, created by configure.sh on $(date -u +%FT%TZ). Keep a copy somewhere safe."
		  echo "# Signing key: the public key goes into regproducer."
		  echo "$k"
		  echo "# Finalizer (BLS) key: the public key and the Proof of Possession go into regfinkey."
		  echo "$b"; } > "$ktmp"
		chmod 600 "$ktmp"
		mv -f "$ktmp" "$KEYS"
	else
		[ -n "$SIGN" ] || ask_secret SIGN "Signing key pair (PUB=KEY:PRIV)"
		[ -n "$BLS" ] || ask_secret BLS "Finalizer key pair (PUB_BLS_...=KEY:PVT_BLS_...)"
	fi
	[[ "$SIGN" =~ ^(EOS|PUB_K1_)[1-9A-HJ-NP-Za-km-z]+=KEY:(5|PVT_K1_)[1-9A-HJ-NP-Za-km-z]+$ ]] || die "signing key must look like EOS...=KEY:5... (or PUB_K1_...=KEY:PVT_K1_...)"
	[[ "$BLS" =~ ^PUB_BLS_[A-Za-z0-9_-]+=KEY:PVT_BLS_[A-Za-z0-9_-]+$ ]] || die "BLS key must look like PUB_BLS_...=KEY:PVT_BLS_..."
fi

# write config.ini: a temp file in the same folder, renamed into place
TMP=$(mktemp "$DIR/.config.ini.XXXXXX")
trap 'rm -f "$TMP"' EXIT
TYPE="$TYPE" P2P="$P2P" BPNAME="$BPNAME" SIGN="$SIGN" BLS="$BLS" awk '
	{ match($0, /^[ \t]*/); indent = substr($0, 1, RLENGTH); line = substr($0, RLENGTH + 1) }
	line ~ /^p2p-server-address[ \t]*=/ { $0 = indent "p2p-server-address = " ENVIRON["P2P"] }
	line ~ /^(producer-name|signature-provider)[ \t]*=/ && ENVIRON["TYPE"] == "full" { $0 = indent "#" line }
	line ~ /^producer-name[ \t]*=/ && ENVIRON["TYPE"] == "bp" { $0 = indent "producer-name = " ENVIRON["BPNAME"] }
	line ~ /^signature-provider[ \t]*=[ \t]*YOUR_PUB_KEY_HERE/ && ENVIRON["TYPE"] == "bp" { $0 = indent "signature-provider = " ENVIRON["SIGN"] }
	line ~ /^signature-provider[ \t]*=[ \t]*YOUR_PUB_BLS_KEY_HERE/ && ENVIRON["TYPE"] == "bp" { $0 = indent "signature-provider = " ENVIRON["BLS"] }
	{ print }
' "$TEMPLATE" > "$TMP"
if [ "$TYPE" = bp ]; then chmod 600 "$TMP"; else chmod 644 "$TMP"; fi
[ ! -e "$CONFIG" ] || backup "$CONFIG"
mv -f "$TMP" "$CONFIG"
trap - EXIT

# chain-state-db-size-mb must fit in RAM
db=$(awk -F'=' '/^[ \t]*chain-state-db-size-mb[ \t]*=/ {gsub(/[ \t]/, "", $2); print $2}' "$CONFIG")
mem=$(awk '/^MemTotal:/ {print int($2 / 1024)}' /proc/meminfo 2>/dev/null || echo 0)
if [ -n "$db" ] && [ "$mem" -gt 0 ] && [ "$db" -gt "$mem" ]; then
	echo "warning: chain-state-db-size-mb = $db MB is more than this server's RAM ($mem MB); lower it in config.ini" >&2
fi

echo "config.ini written: $TYPE node, p2p-server-address = $P2P"
if [ "$TYPE" = bp ]; then
	echo "  producer-name: $BPNAME (config.ini is chmod 600: it holds your private keys)"
	echo "  signing public key (for regproducer): ${SIGN%%=*}"
	echo "  BLS public key (for regfinkey):       ${BLS%%=*}"
	[ -z "$POP" ] || echo "  BLS Proof of Possession (regfinkey):  $POP"
	[ "$GEN" = 0 ] || echo "  private keys saved to keys.txt (chmod 600) - back it up"
fi
echo "Next: ./Wallet/start_wallet.sh, then start from a snapshot (README, section 4)."
