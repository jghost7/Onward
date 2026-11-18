"""Read Questie's Forever database (QuestieDB "baked" mode) offline.

QuestieDB (GPL-3.0) stores every quest/NPC/object row as base64 CBOR in its TOC metadata:
  ## X-Quest-<id>-S: <scalar row>        ## X-Quest-<id>-<field>: <table field>
  ## X-Quest-IDS: <zlib'd CBOR id list>  values starting "~N~" are split into <key>-1..N.
Field numbers come from QuestieDB/src/meta/<entity>Meta.lua.
"""
import base64
import pathlib
import re
import struct
import zlib

FOREVER = pathlib.Path(r"X:\World of Warcraft\_forever_\Interface\AddOns")
TOC = FOREVER / "QuestieDB" / "QuestieDB_Forever.toc"

QUEST = {"name": 1, "startedBy": 2, "finishedBy": 3, "requiredLevel": 4, "questLevel": 5,
         "requiredRaces": 6, "requiredClasses": 7, "objectivesText": 8, "triggerEnd": 9,
         "objectives": 10, "sourceItemId": 11, "preQuestGroup": 12, "preQuestSingle": 13,
         "childQuests": 14, "inGroupWith": 15, "exclusiveTo": 16, "zoneOrSort": 17, "requiredSkill": 18,
         "nextQuestInChain": 22, "questFlags": 23, "specialFlags": 24, "parentQuest": 25,
         "breadcrumbForQuestId": 27, "breadcrumbs": 28, "extraObjectives": 29,
         "requiredMaxLevel": 32}
NPC = {"name": 1, "minLevel": 4, "maxLevel": 5, "rank": 6, "spawns": 7, "zoneID": 9,
       "questStarts": 10, "questEnds": 11, "friendlyToFaction": 13, "subName": 14, "npcFlags": 15}
OBJECT = {"name": 1, "questStarts": 2, "questEnds": 3, "spawns": 4, "zoneID": 5}


# ---------------------------------------------------------------- CBOR (subset WoW emits)
def _cbor(buf, i):
    ib = buf[i]
    major, info = ib >> 5, ib & 31
    i += 1

    def arg(info, i):
        if info < 24:
            return info, i
        n = {24: 1, 25: 2, 26: 4, 27: 8}[info]
        return int.from_bytes(buf[i:i + n], "big"), i + n

    if major == 7:
        if info == 20: return False, i
        if info == 21: return True, i
        if info in (22, 23): return None, i
        if info == 25:
            h = int.from_bytes(buf[i:i + 2], "big")
            return _half(h), i + 2
        if info == 26: return struct.unpack(">f", buf[i:i + 4])[0], i + 4
        if info == 27: return struct.unpack(">d", buf[i:i + 8])[0], i + 8
        raise ValueError(f"cbor simple {info}")
    n, i = arg(info, i)
    if major == 0: return n, i
    if major == 1: return -1 - n, i
    if major == 2: return bytes(buf[i:i + n]), i + n
    if major == 3: return buf[i:i + n].decode("utf-8", "replace"), i + n
    if major == 4:
        out = []
        for _ in range(n):
            v, i = _cbor(buf, i)
            out.append(v)
        return out, i
    if major == 5:
        out = {}
        for _ in range(n):
            k, i = _cbor(buf, i)
            v, i = _cbor(buf, i)
            out[k] = v
        return out, i
    if major == 6:  # tag: ignore, return content
        return _cbor(buf, i)
    raise ValueError(f"cbor major {major}")


def _half(h):
    s, e, f = (h >> 15) & 1, (h >> 10) & 31, h & 1023
    v = (f / 1024) * 2 ** -14 if e == 0 else float("inf") if e == 31 else (1 + f / 1024) * 2 ** (e - 15)
    return -v if s else v


def cbor(data):
    return _cbor(data, 0)[0]


def lua_list(v):
    """CBOR arrays come back as lists; Lua sparse arrays as {int: v} maps. Normalize to a list."""
    if v is None:
        return []
    if isinstance(v, list):
        return v
    if isinstance(v, dict) and all(isinstance(k, int) for k in v):
        return [v[k] for k in sorted(v)]
    return [v]


# ---------------------------------------------------------------- store
class QuestieDB:
    def __init__(self, toc=TOC):
        self.meta = {}
        pat = re.compile(r"^## (X-[^:]+):\s?(.*)$")
        with open(toc, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                m = pat.match(line.rstrip("\r\n"))
                if m:
                    self.meta[m.group(1)] = m.group(2)
        self._cache = {}

    def stored(self, key):
        v = self.meta.get(key)
        if v is None:
            return None
        m = re.fullmatch(r"~(\d+)~", v)
        if m:
            v = "".join(self.meta[f"{key}-{i}"] for i in range(1, int(m.group(1)) + 1))
        return v

    def ids(self, prefix):
        raw = base64.b64decode(self.stored(f"X-{prefix}IDS"))
        for wbits in (15, -15, 31):
            try:
                return cbor(zlib.decompress(raw, wbits))
            except zlib.error:
                continue
        raise ValueError("cannot decompress id list")

    def row(self, prefix, id_):
        key = (prefix, id_)
        if key not in self._cache:
            s = self.stored(f"X-{prefix}{id_}-S")
            self._cache[key] = cbor(base64.b64decode(s)) if s else None
        return self._cache[key]

    def field(self, prefix, id_, idx):
        row = self.row(prefix, id_)
        if row is None:
            return None
        if isinstance(row, dict) and idx in row:
            return row[idx]
        if isinstance(row, list) and idx - 1 < len(row) and row[idx - 1] is not None:
            return row[idx - 1]
        s = self.stored(f"X-{prefix}{id_}-{idx}")
        return cbor(base64.b64decode(s)) if s else None

    def quest(self, q, name):
        return self.field("Quest-", q, QUEST[name])

    def npc(self, n, name):
        return self.field("Npc-", n, NPC[name])

    def obj(self, o, name):
        return self.field("Object-", o, OBJECT[name])


def map_names():
    """uiMapId -> zone name, from the comments in QuestieDB's Forever zone file."""
    text = (FOREVER / "QuestieDB" / "support" / "Forever" / "Zones" / "uiMapIdToAreaId.lua").read_text(encoding="utf-8")
    return {int(m): n.strip() for m, _, n in re.findall(r"\[(\d+)\]\s*=\s*(\d+),\s*--\s*(.+)", text)}


FLIGHT_MASTER = 8      # classic npcFlags bit (Forever uses the classic table: Thor = 11 = gossip|questgiver|flight)


INNKEEPER = 128        # classic npcFlags bit (Innkeeper Shay = 135 = gossip|questgiver|vendor|innkeeper)


FLIGHT_TITLES = ("Wind Rider Master", "Gryphon Master", "Hippogryph Master", "Bat Handler", "Flight Master")


def flight_masters(db, a2m, faction_letter, flag=FLIGHT_MASTER):
    """{uiMapId: [((x, y), name), ...]} for flight masters (or, with flag=INNKEEPER, innkeepers)
    friendly to 'A' or 'H'."""
    out = {}
    for n in db.ids("Npc-"):
        flags = db.field("Npc-", n, NPC["npcFlags"]) or 0
        if not flags & flag:
            # Forever's own flight masters (Riverglades, Mount Hyjal) lack the flag in Questie's
            # data: know them by their title instead
            sub = db.npc(n, "subName") if flag == FLIGHT_MASTER else None
            sub = sub.decode("utf-8", "replace") if isinstance(sub, bytes) else sub
            if sub not in FLIGHT_TITLES:
                continue
        friendly = db.npc(n, "friendlyToFaction")
        friendly = friendly.decode() if isinstance(friendly, bytes) else (friendly or "AH")
        if faction_letter not in friendly:
            continue
        spawns = db.npc(n, "spawns")
        if isinstance(spawns, list):
            spawns = {i + 1: v for i, v in enumerate(spawns) if v}
        name = db.npc(n, "name")
        name = name.decode("utf-8", "replace") if isinstance(name, bytes) else name
        for area, lst in (spawns or {}).items():
            m = a2m.get(area)
            for c in lua_list(lst):
                c = lua_list(c)
                if m and len(c) >= 2 and c[0] is not None and c[0] >= 0:
                    out.setdefault(m, []).append(((float(c[0]), float(c[1])), name))
    return out


def area_to_uimap():
    """areaId -> uiMapId from QuestieDB's Forever zone support file."""
    text = (FOREVER / "QuestieDB" / "support" / "Forever" / "Zones" / "areaIdToUiMapId.lua").read_text(encoding="utf-8")
    return {int(a): int(m) for a, m in re.findall(r"\[(\d+)\]\s*=\s*(\d+)", text)}
